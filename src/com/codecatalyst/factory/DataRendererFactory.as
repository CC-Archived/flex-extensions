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

package com.codecatalyst.factory
{
	import com.codecatalyst.data.Property;
	import com.codecatalyst.util.EventDispatcherUtil;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.IDataRenderer;
	import mx.events.FlexEvent;
	
	public class DataRendererFactory extends ClassFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Event listeners to apply when generating instances of the generator Class, if the generator is an IEventDispatcher.
		 */
		public var eventListeners:Object = null;
		
		/**
		 * Hashmap of property key / value pairs evaluated and applied to resulting instances during each data change/assignment.
		 */
		public var runtimeProperties:Object = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function DataRendererFactory( generator:Class, parameters:Array = null, properties:Object = null, eventListeners:Object = null, runtimeProperties:Object = null )
		{
			super( generator, parameters, properties );
			
			this.eventListeners = eventListeners;
			this.runtimeProperties = runtimeProperties;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public override function newInstance():*
		{
			var instance:Object = super.newInstance();
			
			// Add event listeners (if applicable).
			
			if ( instance is IEventDispatcher )
				EventDispatcherUtil.addEventListeners( instance as IEventDispatcher, eventListeners, false, 0, true );
			
			// Add FlexEvent.DATA_CHANGE handler
			
			if ( instance is IEventDispatcher )
				( instance as IEventDispatcher ).addEventListener( FlexEvent.DATA_CHANGE, renderer_dataChangeHandler, false, 0, true );
			
			return instance;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Handle FlexEvent.DATA_CHANGE.
		 */
		protected function renderer_dataChangeHandler( event:FlexEvent ):void
		{
			var renderer:IDataRenderer = IDataRenderer( event.target );
			
			applyRuntimeProperties( renderer, runtimeProperties );
		}
		
		/**
		 * Evaluate and apply the specified runtime properties to the specified object instance.
		 */
		protected static function applyRuntimeProperties( instance:Object, runtimeProperties:Object ):void
		{
			for ( var targetPropertyPath:String in runtimeProperties )
			{
				var targetProperty:Property = new Property( targetPropertyPath );
				
				targetProperty.setValue( instance, evaluateRuntimeValue( instance, runtimeProperties[ targetPropertyPath ] ) );
			}
		}
		
		/**
		 * Evaluate the specified value - which may be a (nested 'dot notation') property path, callback or just a standalone value.
		 */
		protected static function evaluateRuntimeValue( instance:Object, value:* ):*
		{
			if ( value is String )
			{
				var valueProperty:Property = new Property( value as String );
				if ( valueProperty.exists( instance ) )
				{
					return valueProperty.getValue( instance );
				}
				else
				{
					return value;
				}
			}
			else if ( value is Function )
			{
				var callback:Function = value as Function;
				
				return callback( IDataRenderer( instance ).data );
			}
			else
			{
				return value;
			}
		}
	}
}