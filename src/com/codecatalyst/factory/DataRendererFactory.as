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
	import com.codecatalyst.util.PropertyUtil;
	
	import flash.events.IEventDispatcher;
	
	import mx.events.FlexEvent;
	
	/**
	 * DataRendererFactory is used to generate IDataRenderer instances for use with Lists, Grids and Populators where the developer needs
	 * to customize settings on each renderer instance based on current values its assigned "data" object.
	 * 
	 * DataRendererFactory introduces the support for runtime data-driven properties, which update in response to to runtime changes of the backing 'data' object.
	 * 
	 * StyleableRendererFactory extends DataRendererFactory, adding support for styles and runtime styles.
	 * 
	 * @see StyleableRendererFactory 
	 * 
	 * @example
	 * <mx:DataGrid width="100%" height="100%" >
	 *     <mx:DataGridColumn 
	 *         width="100"
	 *         headerText="Result"
	 *         sortable="false">
	 * 
	 *         <mx:itemRenderer>
	 * 
	 *             <!-- NOTE: Here we use the factory as an alternative to <mx:Component>. -->
	 * 
	 *             <fe:DataRendererFactory
	 *                 generator="{ USFlagSprite }"
	 *                 properties="{ { 
	 *                                   x: this.width/2, 
	 *                                   y: this.height/2 
	 *                             } }"
	 *                 eventListeners="{ { 
	 *                                       mouseDown: function ( event:MouseEvent ):void {
	 *                                                      var render : USFlagSprite = event.target as USFlagSprite;
	 *                                                      render.alpha = 0.2;
	 *                                                  }, 
	 *                                       mouseOver: function ( event:MouseEvent ):void {
	 *                                                      // NOTE: "this" is scoped to the DataGrid, negating the need to reference outerDocument
	 *                                                      // handler logic goes here...
	 *                                                  } 
	 *                                 } }"
	 *                 runtimeProperties="{ {
	 *                                          label: 'data.label',
	 *                                          visible: function ( data:Object ):Boolean {
	 *                                                       return ( data.citizenship == 'USA' );
	 *                                          } 
 	 *                                    } }" 
	 *                 xmlns:fe="http://www.codecatalyst.com/2011/flex-extensions" />
	 * 
	 *         </mx:itemRenderer>
	 * 
	 *     </mx:DataGridColumn>
	 * </mx:DataGrid>
	 * 
	 * @author Thomas Burleson
	 * @author John Yanarella
	 */
	public class DataRendererFactory extends ClassFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Runtime properties to evaluate and assign to generated instances in response to each <code>data</code> change.
		 * 
		 * Hashmap of property key / value pairs.
		 * 
		 * NOTE: Property chains are supported via 'dot notation' and resolved for each new instance.
		 */
		public var runtimeProperties:Object = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function DataRendererFactory( generator:Object = null, parameters:Array  = null, properties:Object = null, eventListeners:Object = null, runtimeProperties:Object = null )
		{
			super( generator, parameters, properties, eventListeners );
			
			this.runtimeProperties = runtimeProperties;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override public function newInstance():*
		{
			// Create instance (and apply properties and event listeners)
			
			var instance:Object = super.newInstance();
			
			// Add event listeners (if applicable).
			
			if ( instance is IEventDispatcher )
			{
				// Add FlexEvent.DATA_CHANGE handler to apply runtime properties 
				
				( instance as IEventDispatcher ).addEventListener( FlexEvent.DATA_CHANGE, renderer_dataChangeHandler, false, 0, true );
			}
			
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
			PropertyUtil.applyProperties( event.target, runtimeProperties, false, true, "data" );
		}
	}
}