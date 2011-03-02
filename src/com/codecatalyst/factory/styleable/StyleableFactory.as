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
	import com.codecatalyst.util.EventDispatcherUtil;
	import com.codecatalyst.util.PropertyUtil;
	import com.codecatalyst.util.StyleUtil;
	
	import flash.events.IEventDispatcher;
	
	import mx.styles.IStyleClient;
	import com.codecatalyst.factory.ClassFactory;

	/**
	 * UIComponentFactory adds to the ClassFactory the ability to configure 1 or more
	 * style settings to each instance. Note that this configuration is performed only one time; during the construction process.
	 * This class also allows developers to include or mix style settings in the 'properties' object; this 
	 * feature dramatically reduces the developers need to remember if any specific option is a 'style' or a 'property'.
	 *
	 * NOTE: This factory can still be used in Grids and Lists, but the runtime changes will not be detected.
	 *       Flex has a significant bug regarding assigning styles for containers renderers in grids; developers are advised
	 *       to use BoxItemRenderer (or subclasses) to resolve this issue!
	 *  
	 * @see StyleableRendererFactory
	 * @see com.codecatalyst.component.renderer.BoxItemRenderer
	 * 
	 * @example
	 * <fe:UIComponentFactory
	 * 			id="factory
	 * 			generator="{ BoxItemRenderer }"
	 * 			styles="{ { 
	 * 							backgroundAlpha : 0.5, 
	 * 							backgroundColor : 0x990000 
	 * 					} }" 
	 * 			properties="{ { 
	 * 							percentWidth    : 100, 
	 * 							percentHeight   : 100, 
	 * 							includeInLayout : this.showDetails, 
	 * 							verticalCenter  : 0, 						// This is a style
	 * 							styleName       : 'shadowBox'  
	 * 			} }"
	 * 			eventListeners="{ { mouseDown 	: function (e:MouseEvent):void {
	 * 												var render : Canvas = event.target as BoxItemRenderer;
	 * 												    render.alpha = 0.2;
	 * 											  }, 
	 * 								mouseOver 	: function (e:MouseEvent):void {
	 * 												// some other custom code here...
	 *													// Notice the "this" is scoped to the DataGrid...
	 * 											  } 
	 *  						   } }"
	 * 			xmlns:fe="http://www.codecatalyst.com/2011/flex-extensions" />
	 *  
	 * 
	 * 
	 * @author Thomas Burleson
	 * @author John Yanarella
	 * 
	 * 
	 */

	public class StyleableFactory extends ClassFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		
		/**
		 * Styles applied when generating instances of the generator Class.
		 */
		public var styles:Object = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function StyleableFactory( generator			:Object = null, 
										  parameters		:Array  = null, 
										  properties		:Object = null, 
										  eventListeners	:Object = null,
										  styles			:Object = null )
		{
			super( generator, parameters, properties, eventListeners );
			
			this.styles         = styles;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public override function newInstance():*
		{
			// Create instance [and apply properties]
			
			var instance:Object = super.newInstance();
			
			// Apply styles.
			
			return StyleUtil.applyStyles( IStyleClient( instance ), styles );
		}
		

		/**
		 * Override method to apply the static property values to the new instance.
		 * If the specified property does not exist, then cache in the "styles" object 
		 * for use after applyProperties() finishes.
		 * 
		 * NOTE: this override allows the properties object to contain style specifications
		 *       so styles and properties can be easily mixed in one initializaiton object
		 *  
		 * @param instance 	New object instance from the IFactory::newInstance() request
		 * @return Object 	instance initialized with "property" values;
		 * 
		 */
		protected override function applyProperties(instance:Object):* {
			try 
			{
				// Iterate all property pairs and assign 
				// NOTE: we specify "true" to allow the 'properties' container to mix properties and style pairs
				
				PropertyUtil.applyProperties(instance, properties, true);
			} 
			catch ( error:ReferenceError ) 
			{
				trace(error.message);	
			}
			
			
			return instance;	
		}		
	}
}