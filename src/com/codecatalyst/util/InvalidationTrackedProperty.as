package com.codecatalyst.util
{
	import com.codecatalyst.util.InvalidationFlags;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.core.IInvalidating;
	import mx.events.PropertyChangeEvent;
	
	[ExcludeClass]
	public class InvalidationTrackedProperty
	{
		// ========================================
		// Protected constants
		// ========================================
		
		/**
		 * Priority for event listeners.
		 */
		protected static var PRIORITY:int = int.MAX_VALUE;
		
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
		 * Source instance (containing this property).
		 */
		protected var source:IEventDispatcher = null;
		
		/**
		 * Property name.
		 */
		protected var propertyName:String = null;
		
		/**
		 * Change event type.
		 */
		protected var changeEventType:String = null;
		
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
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function InvalidationTrackedProperty( source:IEventDispatcher, propertyName:String, changeEventType:String, invalidationFlags:uint, callback:Function = null )
		{
			super();
			
			this.source            = source;
			this.propertyName      = propertyName;
			this.changeEventType   = changeEventType;
			this.invalidationFlags = invalidationFlags;
			this.callback          = callback;
			
			source.addEventListener( changeEventType, changeEventHandler, false, PRIORITY, true );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Invalidate this tracked property and automatically execute the IInvalidating methods for the specified InvalidationFlags (if applicable).
		 */
		public function invalidate():void
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
			
			if ( callback != null )
				callback( propertyName );
		}
		
		/**
		 * Reset this invalidated tracked property.
		 */
		public function reset():void
		{
			_invalidated = false;
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
	}
}