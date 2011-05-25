////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011 CodeCatalyst, LLC - http://www.codecatalyst.com/
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.	
////////////////////////////////////////////////////////////////////////////////

package com.codecatalyst.util.invalidation
{
	import com.codecatalyst.util.MetadataUtil;
	
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.events.FlexEvent;
	import mx.utils.DescribeTypeCache;
	import mx.utils.StringUtil;
	
	/**
	 * Implements support for [Invalidate("displaylist,properties,size")] metadata on [Bindable] 
	 * public properties as an alternative to the common pattern of writing custom get / set method pairs 
	 * w/ backing variable and changed flags.
	 */
	public class InvalidationTracker
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Source instance.
		 */
		protected var source:IEventDispatcher = null;
		
		/**
		 * Dictionary of InvalidationTrackedProperty(s), keyed by property name.
		 */
		protected var trackedProperties:Dictionary = new Dictionary();
		
		/**
		 * Notification function useful for tracking changes properties.
		 * 
		 * <p>This callback is especially useful if <code>[Invalidate]</code> is used on non-<code>IInvalidating</code>
		 * classes. Such classes do NOT have a mx validation lifecycle. So this callback allows "immediate" 
		 * notifications for any property changes to the instance to be dispatched.
		 * 
		 * <pre>
		 *    function ( target:IEventDispatcher, property:String, previousVal:*, newVal:* ) : void
		 * </pre>
		 * 
		 * (optional).
		 * 
		 * @default NULL 
		 */
		protected var callback:Function = null;
				
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function InvalidationTracker( source:IEventDispatcher, callback:Function = null )
		{
			super();
			
			this.source   = source;
			this.callback = callback;
			
			setup();
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Track the specified property by name, change event type with the specified invalidation flags.
		 * 
		 * @param identifier A parameter name String or Array of parameter name Strings.
		 * @param changeEventType The event type dispatched to indicate the property changed.
		 * @param invalidationFlags The InvalidationFlags corresponding to the IInvalidating methods to automatically initiate.
		 * @param callback An optional callback triggered whenever this property changes.
		 */
		public function track( identifier:*, invalidationFlags:uint, callback:Function = null ):void
		{
			execute( _track, identifier, true, arguments.slice( 1 ) );
		}
		
		/**
		 * Invalidate the specified property by name.
		 * 
		 * @param identifier A parameter name String or Array of parameter name Strings.
		 */
		public function invalidate( identifier:* ):void
		{
			execute( _invalidate, identifier );
		}
		
		/**
		 * Returns a Boolean indicating whether (any of) the specified tracked property(s) have been invalidated.
		 * 
		 * NOTE: If no parameter name identifier is specified, returns a Boolean indicating whether any tracked property has been invalidated.
		 * 
		 * @param identifier A parameter name String or Array of parameter name Strings.
		 */
		public function invalidated( identifier:* = null ):Boolean
		{
			if ( identifier == null )
			{
				for each ( var trackedProperty:InvalidationTrackedProperty in trackedProperties )
				{
					if ( trackedProperty.invalidated )
						return true;
				}
				
				return false;
			}
			
			return execute( _invalidated, identifier, false );
		}
		
		/**
		 * Returns the previous value for the specified tracked property, if that property is currently invalidated.
		 */
		public function previousValue( identifier:String ):*
		{
			return _previousValue( identifier );
		}
		
		/**
		 * Resets the specified invalidated tracked property(s).
		 * 
		 * @param identifier A parameter name String or Array of parameter name Strings.
		 */
		public function reset( identifier:* ):void
		{
			execute( _reset, identifier );
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Setup.
		 */
		protected function setup():void
		{
			processInvalidateAnnotations();
			
			source.addEventListener( FlexEvent.UPDATE_COMPLETE, updateCompleteHandler, false, 0, true );
		}
		
		/**
		 * Executes the specified method for the specified identifer(s), with optional additional parameters.
		 * 
		 * @param method The method to execute.
		 * @param identifier A parameter name String or Array of parameter name Strings.
		 * @param every A Boolean indicating whether to iterate using Array.every() or Array.some().
		 * @param additionalParameters Optional additional parameters to supply when calling the specified method.
		 * 
		 * @return The aggregated return value.
		 */
		protected function execute( method:Function, identifier:*, every:Boolean = true, additionalParameters:Array = null ):*
		{
			if ( identifier is Array )
			{
				var iterator:Function = ( every ) ? identifier.every : identifier.some;
				
				return iterator( 
					function ( item:*, index:int, array:Array ):*
					{
						return execute( method, item, every, additionalParameters );
					}
				);
			}
			else if ( identifier is String )
			{
				var parameters:Array = [ identifier ];
				if ( additionalParameters != null )
					parameters = parameters.concat( additionalParameters );
				
				return method.apply( null, parameters );
			}
			else
			{
				throw new Error( "Unsupported property identifier specified." );
			}
		}
		
		/**
		 * Process any [Invalidate] annotations in the specified <code>source</code>.
		 */
		protected function processInvalidateAnnotations():void
		{
			var description:XML = DescribeTypeCache.describeType( source ).typeDescription;
			
			var list:XMLList = description..metadata.(@name == 'Invalidate');
			for each ( var item:XML in list )
			{
				// Parse the type description.
				
				var property:XML = item.parent();
				var invalidateMetadata:XML = property.metadata.(@name == "Invalidate")[0];
				var invalidateMetadataOptions:String = MetadataUtil.getMetadataAttribute( invalidateMetadata, "phase", true ); 
				
				// Determine the property name and invalidation flags.
				
				var propertyName:String = property.@name;
				var invalidationFlags:uint = InvalidationFlags.NONE;
				
				invalidateMetadataOptions
					.split(",")
					.map( function ( item:String, index:int, array:Array ):uint { 
						switch( StringUtil.trim( item ) )
						{
							case "displaylist":  return InvalidationFlags.DISPLAY_LIST;
							case "size":         return InvalidationFlags.SIZE;
							case "properties":   return InvalidationFlags.PROPERTIES;
							default:             throw new Error( "Unsupported invalidation option specified." );
						}
					})
					.forEach( function ( invalidationFlag:uint, index:int, array:Array ):void { 
						invalidationFlags = invalidationFlags | invalidationFlag;
					});
				
				// NOTE: If no phases are explicitly specified, default to all phases.
					
				if ( invalidateMetadataOptions.length == 0 )
					invalidationFlags = InvalidationFlags.DISPLAY_LIST | InvalidationFlags.SIZE | InvalidationFlags.PROPERTIES;
					
				// Track the specified property name with the specified invalidation flags.
				
				_track( propertyName, invalidationFlags );
			}
		}
		
		/**
		 * Gets the tracked property by name.
		 */
		protected function getTrackedPropertyByName( propertyName:String ):InvalidationTrackedProperty
		{
			var trackedProperty:InvalidationTrackedProperty = trackedProperties[ propertyName ] as InvalidationTrackedProperty;
			
			if ( trackedProperty == null )
				throw new Error( "The specified property is not being tracked: " + propertyName );
			
			return trackedProperty;
		}
		
		/**
		 * Track the specified property by name, change event type with the specified invalidation flags.
		 */
		protected function _track( propertyName:String, invalidationFlags:uint, callback:Function = null ):void
		{
			trackedProperties[ propertyName ] = new InvalidationTrackedProperty( source, propertyName, invalidationFlags, callback || this.callback );
		}
		
		/**
		 * Invalidate the specified property by name.
		 */
		protected function _invalidate( propertyName:String ):void
		{
			getTrackedPropertyByName( propertyName ).invalidate();
		}
		
		/**
		 * Returns a Boolean indicating whether the specified tracked property has been invalidated. 
		 */
		protected function _invalidated( propertyName:String ):Boolean
		{
			return getTrackedPropertyByName( propertyName ).invalidated;
		}
		
		/**
		 * Returns the previous value for the specified tracked property, if that property is currently invalidated.
		 */
		protected function _previousValue( propertyName:String ):*
		{
			return getTrackedPropertyByName( propertyName ).previousValue;
		}
		
		/**
		 * Resets the specified invalidated tracked property.
		 */
		protected function _reset( propertyName:String ):void
		{
			getTrackedPropertyByName( propertyName ).reset();
		}
		
		/**
		 * Handle FlexEvent.UPDATE_COMPLETE.
		 */
		protected function updateCompleteHandler( event:FlexEvent ):void
		{
			for each ( var trackedProperty:InvalidationTrackedProperty in trackedProperties )
			{
				trackedProperty.reset();
			}
		}
	}
}