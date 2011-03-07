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
	import com.codecatalyst.data.Property;
	import com.codecatalyst.util.EventDispatcherUtil;
	import com.codecatalyst.util.PropertyUtil;
	import com.codecatalyst.util.StyleUtil;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.IDataRenderer;
	import mx.events.FlexEvent;
	import mx.styles.IStyleClient;
	
	
	/**
	 * This Factory supports creation of instances ARE IStyleClient instances that will be used as itemRenderers in DataGrids and Lists.
	 * Both initialization and runtime properties and styles may be specified. Runtime settings may be evaluated and assigned based on "data" 
	 * values for each instance.
	 * 
	 * @see com.codecatalyst.factory.DataRendererFactory 
	 * 
	 * @example
	 * 
	 * 
	 * <mx:DataGrid width="100%" height="100%" >
	 *   <mx:DataGridColumn 
	 *		width="100"
	 *		headerText="Result"
	 *		sortable="false">
	 * 
	 *		<mx:itemRenderer>
	 * 		  
	 * 			<!-- Notice, here we do not use the  Component wrapper "trick" -->
	 * 
	 *		  <fe:StyleableRendererFactory
	 * 				generator="{ USFlagSprite }"
	 * 				properties="{ { 
	 * 								horizontalCenter	: 0, 					// This is a style
	 * 								y 					: this.height/2
	 * 							} }"
	 * 				eventListeners="{ { mouseDown : function (e:MouseEvent):void {
	 * 													var render : USFlagSprite = event.target as USFlagSprit;
	 * 													    render.alpha = 0.2;
	 * 												}, 
	 * 									mouseOver : function (e:MouseEvent):void {
	 * 													// some other custom code here...
	 * 													// Notice the "this" is scoped to the DataGrid...
	 * 												} 
	 * 								   } }"
	 * 				runtimeProperties="{ { visible : function (data:Object):Boolean {
	 * 													return (data && data.citizenship == "USA");
	 * 												 },
	 * 									   toolTip : function (data:Object):String {
	 * 													return data ? "Resident of " + data.state : "";
	 * 												 }
 	 * 								   } }" 
	 * 				runtimeStyles="{ {  
	 * 									
	 * 								} }"
	 * 				xmlns:fe="http://www.codecatalyst.com/2011/flex-extensions" />
	 *		</mx:itemRenderer>
	 * 
	 *	 </mx:DataGridColumn>
	 * </mx:DataGrid>
	 *  
	 *  
	 * @author Thomas Burleson
	 * @author John Yanarella
	 * 
	 * 
	 */
	
	public class StyleableRendererFactory extends StyleableFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Hashmap of style key / value pairs evaluated and applied to resulting instances during each data change/assignment.
		 */
		public var runtimeStyles:Object = null;
		
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
		public function StyleableRendererFactory(  generator		 :Object = null, 
												   parameters		 :Array  = null, 
												   properties		 :Object = null, 
												   eventListeners	 :Object = null, 
												   styles			 :Object = null,  
												   runtimeProperties :Object = null, 
												   runtimeStyles	 :Object = null )
		{
			super( generator, parameters, properties, eventListeners, styles );

			this.runtimeProperties 	= runtimeProperties;
			this.runtimeStyles 		= runtimeStyles;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public override function newInstance():*
		{
			// Create instance with applied construction properties and styles and eventlisteners
			
			var instance:Object = super.newInstance();
			
			// Add event listeners (if applicable).
			
			if ( instance is IEventDispatcher ) {

				// Add FlexEvent.DATA_CHANGE handler to apply runtime properties 
			
				(instance as IEventDispatcher).addEventListener( FlexEvent.DATA_CHANGE, renderer_dataChangeHandler, false, 0, true );
			}
			
			return instance;
		}
		
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