package com.codecatalyst.util
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	
	import mx.core.IInvalidating;
	import mx.core.IUIComponent;
	import mx.utils.DescribeTypeCache;
	import mx.utils.StringUtil;
	
	/**
	 * Implements support for [Track(invalidate="displaylist,properties,size")] metadata on [Bindable] public properties as an alternative to the common pattern of writing custom get / set method pairs w/ backing variable and changed flags.
	 */
	public class InvalidationTracker
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Source.
		 */
		protected var source:IEventDispatcher = null;
		
		/**
		 * Dictionary of InvalidationTrackedProperty(s), keyed by property name.
		 */
		protected var trackedProperties:Dictionary = new Dictionary();
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function InvalidationTracker( source:IEventDispatcher )
		{
			super();
			
			this.source = source;
			
			processTrackAnnotations();
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
		public function track( identifier:*, changeEventType:String, invalidationFlags:uint, callback:Function = null ):void
		{
			execute( _track, identifier, arguments.slice( 1 ) );
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
		 * Returns a Boolean indicating whether the specified tracked property(s) have been invalidated.
		 * 
		 * @param identifier A parameter name String or Array of parameter name Strings.
		 */
		public function invalidated( identifier:* ):Boolean
		{
			return execute( _invalidated, identifier );
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
		 * Executes the specified method for the specified identifer(s), with optional additional parameters.
		 * 
		 * @param method The method to execute.
		 * @param identifier A parameter name String or Array of parameter name Strings.
		 * @param additionalParameters Optional additional parameters to supply when calling the specified method.
		 * 
		 * @return The aggregated return value.
		 */
		protected function execute( method:Function, identifier:*, additionalParameters:Array = null ):*
		{
			if ( identifier is Array )
			{
				return identifier.every( 
					function ( item:*, index:int, array:Array ):*
					{
						return execute( method, item, additionalParameters );
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
		 * Process any [Track] annotations in the specified <code>source</code>.
		 */
		protected function processTrackAnnotations():void
		{
			var description:XML = DescribeTypeCache.describeType( source ).typeDescription;
		
			var list:XMLList = description.accessor.metadata.(@name == 'Track');
			
			for each ( var item:XML in list )
			{
				var accessor:XML = item.parent();
				
				var bindableMetdata:XML = accessor.metadata.(@name == 'Bindable')[ 0 ];
				var trackMetadata:XML = accessor.metadata.(@name == 'Track')[ 0 ];
				
				var propertyName:String = accessor.@name;
				var changeEventType:String = bindableMetdata.arg.(@key == 'event').@value;
				
				var invalidationFlags:uint = InvalidationFlags.NONE;
				( trackMetadata.arg.(@key == 'invalidate').@value ).split(",").map( 
					function (item:String, index:int, array:Array):uint
					{ 
						switch( StringUtil.trim( item ) )
						{
							case "displaylist":
								return InvalidationFlags.DISPLAY_LIST;
							case "size":
								return InvalidationFlags.SIZE;
							case "properties":
								return InvalidationFlags.PROPERTIES;
							case "none":
								return InvalidationFlags.NONE;
							default:
								throw new Error( "Unsupported invalidation option specified." );
						}
					}
				).forEach(
					function (invalidationFlag:uint, index:int, array:Array):void
					{ 
						invalidationFlags = invalidationFlags | invalidationFlag;
					}
				);
				
				_track( propertyName, changeEventType, invalidationFlags );
			}
		}
		
		/**
		 * Gets the tracked property by name.
		 */
		protected function getTrackedPropertyByName( propertyName:String ):InvalidationTrackedProperty
		{
			var trackedProperty:InvalidationTrackedProperty = trackedProperties[ propertyName ] as InvalidationTrackedProperty;
			
			if ( trackedProperty == null )
				throw new Error( "The specified property is not being tracked." );
			
			return trackedProperty;
		}
		
		/**
		 * Track the specified property by name, change event type with the specified invalidation flags.
		 */
		protected function _track( propertyName:String, changeEventType:String, invalidationFlags:uint, callback:Function = null ):void
		{
			trackedProperties[ propertyName ] = new InvalidationTrackedProperty( source, propertyName, changeEventType, invalidationFlags, callback );
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
		 * Resets the specified invalidated tracked property.
		 */
		protected function _reset( propertyName:String ):void
		{
			getTrackedPropertyByName( propertyName ).reset();
		}
	}
}