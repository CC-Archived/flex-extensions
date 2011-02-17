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
	import com.codecatalyst.util.StyleUtil;
	
	import mx.core.IDataRenderer;
	import mx.events.FlexEvent;
	import mx.styles.IStyleClient;
	
	public class ItemRendererFactory extends DataRendererFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Styles applied when generating instances of the generator Class.
		 */
		public var styles:Object = null;
		
		/**
		 * Hashmap of style key / value pairs evaluated and applied to resulting instances during each data change/assignment.
		 */
		public var runtimeStyles:Object = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ItemRendererFactory( generator:Class = null, parameters:Array = null, properties:Object = null, styles:Object = null,  eventListeners:Object = null, runtimeProperties:Object = null, runtimeStyles:Object = null )
		{
			super( generator, parameters, properties, eventListeners, runtimeProperties );
			
			this.styles = styles;
			this.runtimeStyles = runtimeStyles;
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
			
			// Apply styles (if applicable).
			
			if ( instance is IStyleClient )
				StyleUtil.applyStyles( instance as IStyleClient, styles );
			
			return instance;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Handle FlexEvent.DATA_CHANGE.
		 */
		override protected function renderer_dataChangeHandler( event:FlexEvent ):void
		{
			super.renderer_dataChangeHandler( event );
			
			var renderer:IDataRenderer = IDataRenderer( event.target );
			
			if ( renderer is IStyleClient )
				applyRuntimeStyles( renderer as IStyleClient, runtimeStyles );
		}
		
		/**
		 * Evaluate and apply the specified runtime properties to the specified object instance.
		 */
		override protected function applyRuntimeProperties( instance:Object, runtimeProperties:Object ):void
		{
			for ( var targetPropertyPath:String in runtimeProperties )
			{
				var targetProperty:Property = new Property( targetPropertyPath );
				
				if ( targetProperty.exists( instance ) )
				{
					targetProperty.setValue( instance, evaluateRuntimeValue( instance, runtimeProperties[ targetPropertyPath ] ) );
				}
				else if ( instance is IStyleClient )
				{
					( instance as IStyleClient ).setStyle( targetPropertyPath, evaluateRuntimeValue( instance, runtimeProperties[ targetPropertyPath ] ) );
				}
				else
				{
					throw new Error( "Specified property does not exist." );
				}
			}
		}
		
		/**
		 * Evaluate and apply the specified runtime styles to the specified IStyleClient.
		 */
		protected function applyRuntimeStyles( styleClient:IStyleClient, runtimeStyles:Object ):void
		{
			for ( var targetStyle:String in runtimeStyles )
			{
				styleClient.setStyle( targetStyle, evaluateRuntimeValue( styleClient, runtimeStyles[ targetStyle ] ) );
			}
		}
	}
}