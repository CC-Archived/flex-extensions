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

package com.codecatalyst.factory.styleable
{
	import com.codecatalyst.util.PropertyUtil;
	import com.codecatalyst.util.StyleUtil;
	
	import flash.events.IEventDispatcher;
	
	import mx.events.FlexEvent;
	import mx.styles.IStyleClient;
	
	/**
	 * StyleableRendererFactory is used to generate IDataRenderer instances for use with Lists, Grids and Populators where the developer needs
	 * to customize settings on each renderer instance based on current values its assigned "data" object.
	 * 
	 * StyleableRendererFactory introduces support for runtime data-driven properties and styles, which update in response to to runtime changes of the backing 'data' object.
	 * 
	 * StyleableRendererFactory is similar to DataRendererFactory, but adds support for styles and runtime styles.
	 * StyleableRendererFactory extends StyleableFactory, adding support for runtime styles.
	 * 
	 * @see com.codecatalyst.factory.DataRendererFactory
	 * @see com.codecatalyst.factory.StyleableFactory
	 * 
	 * NOTE: Flex has a significant bug that causes it to ignore custom styles for containers renderers in Halo lists (ex. DataGrid, List, etc.).
	 * Developers are advised to use BoxItemRenderer or CanvasItemRenderer to ensure custom styles are not cleared by the list component.
	 *  
	 * @see com.codecatalyst.component.renderer.BoxItemRenderer
	 * @see com.codecatalyst.component.renderer.CanvasItemRenderer
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
	 *             <fe:StyleableRendererFactory
	 *                 generator="{ USFlagSprite }"
	 *                 properties="{ { 
	 *                                   horizontalCenter: 0, 		// This is a style
	 *                                   y: this.height/2
	 * 		    					} }"
	 *                 eventListeners="{ { 
	 *                                       mouseDown: function (e:MouseEvent):void {
	 *                                                      var render:USFlagSprite = event.target as USFlagSprite;
	 *                                                      render.alpha = 0.2;
	 *                                       }, 
	 *                                       mouseOver: function (e:MouseEvent):void {
	 *                                                      // NOTE: "this" is scoped to the DataGrid, negating the need to reference outerDocument
	 *                                                      // handler logic goes here...
	 * 						    						} 
	 *                                 } }"
	 *                 runtimeProperties="{ { 
	 *                                      label: 'data.label',
	 *                                          visible: function (data:Object):Boolean {
	 *                                                       return (data && data.citizenship == "USA");
	 *                                                   },
	 *                                          toolTip: function (data:Object):String {
	 *                                                       return data ? "Resident of " + data.state : "";
	 *                                                   }
 	 *                                    } }" 
	 *                 runtimeStyles="{ {  
	 * 		    						    backgroundColor: "data.color"	
	 *                                } }"
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
	public class StyleableRendererFactory extends StyleableFactory
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
		
		/**
		 * Runtime styles to evaluate and apply to generated instances in response to each <code>data</code> change.
		 * 
		 * Hashmap of style key / value pairs.
		 */
		public var runtimeStyles:Object = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function StyleableRendererFactory( generator:Object = null, parameters:Array  = null, properties:Object = null, eventListeners:Object = null, styles:Object = null, runtimeProperties:Object = null, runtimeStyles:Object = null )
		{
			super( generator, parameters, properties, eventListeners, styles );

			this.runtimeProperties = runtimeProperties;
			this.runtimeStyles     = runtimeStyles;
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
			PropertyUtil.applyProperties( event.target, runtimeProperties, true, true );
			StyleUtil.applyStyles(event.target as IStyleClient, runtimeStyles, true);
		}
	}
}