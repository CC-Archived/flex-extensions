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
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.core.IInvalidating;
	import mx.events.PropertyChangeEvent;
	import com.codecatalyst.util.PropertyUtil;
	
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
			
			if ( ! ChangeWatcher.canWatch( source, propertyName ) )
				throw new Error( "The specified property is not [Bindable]." );
			
			watcher = ChangeWatcher.watch( source, [ propertyName ], changeEventHandler );
			
			reset();
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
			{
				var currentValue:* = PropertyUtil.getObjectPropertyValue( source, propertyName );
				
				// Method signature required == function ( target:IEventDispatcher, property:String, previousVal:*, newVal:* ):void 
				
				callback( source, propertyName, previousValue, currentValue );
			}
		}
		
		/**
		 * Reset this invalidated tracked property.
		 */
		public function reset():void
		{
			_invalidated = false;
			
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
	}
}