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
	import com.codecatalyst.util.PropertyUtil;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.core.IInvalidating;
	import mx.events.PropertyChangeEvent;
	import mx.utils.DescribeTypeCache;
	
	
	[ExcludeClass]
	public class InvalidationTrackedProperty
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>invalidated</code> property.
		 * 
		 * @see #invalidated
		 */
		protected var _invalidated:Boolean = false;
		
		/**
		 * Backing variable for <code>previousValue</code> property.
		 * 
		 * @see #previousValue
		 */
		protected var _previousValue:* = null;
		
		/**
		 * Source instance (containing this property).
		 */
		protected var source:IEventDispatcher = null;
		
		/**
		 * Property name.
		 */
		protected var propertyName:String = null;
		
		/**
		 * Change watcher.
		 */
		protected var watcher:ChangeWatcher;
		
		/**
		 * Invalidation flags.
		 * 
		 * @see com.codecatalyst.util.InvalidationFlags
		 */
		protected var invalidationFlags:uint = InvalidationFlags.NONE;
		
		/**
		 * Invalidation callback (optional).
		 */
		protected var callback:Function;
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Indicates whether this tracked property has been invalidated.
		 */
		public function get invalidated():Boolean
		{
			return _invalidated;
		}
		
		/**
		 * Previous value for this property, if it is currently invalidated.
		 */
		public function get previousValue():*
		{
			return _previousValue;
		}
		
		/**
		 * Support to defer `reset()` when callbacks on non-IInvalidating are used.
		 * Set to `false` to allow "throttled" callbacks to used; @see InvalidationTracker::applyThrottler()
		 */
		public var autoReset : Boolean = true;

		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function InvalidationTrackedProperty( source:IEventDispatcher, propertyName:String, invalidationFlags:uint, callback:Function = null )
		{
			super();
			
			this.source            = source;
			this.propertyName      = propertyName;
			this.invalidationFlags = invalidationFlags;
			this.callback          = callback;
			
			attachWatcher(source, propertyName);
			
			reset();
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		
		/**
		 * Properties with [Invalidate()] attached must have a [Bindable] also attached so property changes
		 * can be detected and invalidation auto-initiated. Custom databinding events can also use [Bindable('xxxx')]
		 * notations where the change event not a `propertyChange` event. (note `xxxx` is a placeholder for the custom event type).
		 *      
		 * 
		 * Custom databinding events must be manually/programmatically dispatched. Therefore, when used with [Invalidate()]
		 * custom databindings require manual invalidation.
		 * e.g.
		 * 
		 *       Bindable(event="selectedChanged")]
		 *       [Invalidate("properties")]
		 *       
		 *       // Which button is selected in the StatusFilter toggleButton bar
		 *       // 
		 *       // NOTE: unable to use [Invalidate(...)] here since we are using
		 *       //  a custom databinding event name `change`
		 *          
		 *       public function get selected():StatusFilterEnum
		 *       {
		 *       	return _selected;
		 *       }
		 *       public function set selected(value:StatusFilterEnum):void
		 *       {
		 *       	if (_selected != value)
		 *       	{
		 *       		_selected 		 = value;
		 *       		
		 *       		// Defer change response until commitProperties
		 *       		
		 *       		// propertyTracker.invalidate("selected");
		 *       	}
		 *       }
		 * 
		 * @param source
		 * @param propertyName
		 * 
		 */		
		public function attachWatcher(source:IEventDispatcher, propertyName:String):void 
		{
			if ( ChangeWatcher.canWatch( source, propertyName ) )
			{
				watcher = ChangeWatcher.watch( source, [ propertyName ], changeEventHandler );
			} 
			
			if ( watcher == null) 
			{
				if ( !hasCustomEvent )  
				{
					throw new Error( "The specified property '" + propertyName + "' is not [Bindable]" );
				}
				
				var msg : String  = "Warning: The specified property '" + propertyName + "' uses a custom databinding [Bindable('" + customBinding + "')]";
				
					msg += "\r";
					msg += "Custom databindings must be manually [programmatically] invalidated with the InvalidationTracker!"
				
				trace ( msg );
			}
		}
		
		/**
		 * Does this property have a custom databinding event name ?
		 * e.g  [Bindable(event="<custom name>")]
		 *  
		 * @return Boolean false if [Bindable] 
		 * 
		 */
		protected function get hasCustomEvent():Boolean
		{
			// Use internal, previously cached flag if available
			
			return ( _customEventName || customBinding );
			
		}

		/**
		 * Parse the custom event type used for databinding notifications; if present.
		 * e.g  [Bindable(event="<custom name>")]
		 * 
		 * @return String null if no custom event type 
		 */		
		protected function get customBinding():String 
		{
			var description	:XML 	 = DescribeTypeCache.describeType( source ).typeDescription;
			var list		:XMLList = description..metadata.(@name == 'Bindable');
			
			// Parse the type description for the property's [Bindable] information
			
			for each ( var item:XML in list )
			{
				var property    :XML    = item.parent();
				var propertyName:String = property.@name;
				
				if (propertyName == this.propertyName )
				{
					var bindable	:XML 	 = property.metadata.(@name == "Bindable")[0];
					
					_customEventName = MetadataUtil.getMetadataAttribute( bindable, "event", true ); 
					break;
				}
			}
			
			_customEventName =  _customEventName == "" 				  ? null :
								_customEventName == "propertyChange"  ? null : _customEventName;
			
			return _customEventName;
		}
		
		/**
		 * Invalidate this tracked property and automatically execute the IInvalidating methods for the specified InvalidationFlags (if applicable).
		 */
		public function invalidate():void
		{
			if ( _invalidated == false ) 
			{
				_invalidated = true;
				
				if ( source is IInvalidating )
				{
					var invalidating:IInvalidating = source as IInvalidating;
					
					if ( invalidationFlags & InvalidationFlags.DISPLAY_LIST )
					{
						invalidating.invalidateDisplayList();
					}
					
					if ( invalidationFlags & InvalidationFlags.PROPERTIES )
					{
						invalidating.invalidateProperties();
					}
					
					if ( invalidationFlags & InvalidationFlags.SIZE )
					{
						invalidating.invalidateSize();
					}
				}
			}
				
			if ( callback != null )
			{
				var currentValue:* = PropertyUtil.getObjectPropertyValue( source, propertyName );
				
				if ( callback.length == 3 )
					callback( propertyName, previousValue, currentValue );
				else
					callback();
				
				if ( !(source is IInvalidating) && autoReset ) 
				{
					reset();
				}
			}
			
		}
		
		/**
		 * Reset this invalidated tracked property.
		 */
		public function reset():void
		{			
			_invalidated   = false;			
			_previousValue = PropertyUtil.getObjectPropertyValue( source, propertyName );
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Handle the change event.
		 */
		protected function changeEventHandler( event:Event ):void
		{
			if ( event is PropertyChangeEvent )
			{
				if ( ( event as PropertyChangeEvent ).property == propertyName )
				{
					invalidate();
				}
			}
			else
			{
				invalidate();
			}
		}
		
		private var _customEventName : String;

		
	}
}