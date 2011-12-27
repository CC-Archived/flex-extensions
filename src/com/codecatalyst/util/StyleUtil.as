////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2009 CodeCatalyst, LLC - http://www.codecatalyst.com/
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

package com.codecatalyst.util
{
	import com.codecatalyst.util.PropertyUtil;
	
	import flash.geom.Point;
	
	import mx.core.IFlexModuleFactory;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.IStyleClient;
	import mx.styles.StyleManager;

	
	public class StyleUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Gets the CSSStyleDeclaration object that stores the rules for the specified CSS selector.
		 * 
		 * Normalizes the changes between Flex 3.x and Flex 4.x - specify the full path to the component class for both.
		 * 
		 * @see mx.styles.IStyleManager#getStyleDeclaration()
		 * @see mx.styles.IStyleManager2#getStyleDeclaration()
		 */
		public static function getStyleDeclaration( style:String, module:IFlexModuleFactory = null ):CSSStyleDeclaration
		{
			var result : CSSStyleDeclaration = null;
			
			CONFIG::FLEX3 {
				var expression:RegExp = /^(.*)\.([^.]+)$/;
				var match:Object = expression.exec( style );
				
				var className:String = ( match ) ? match[ 1 ] as String : style;
				
				result = StyleManager.getStyleDeclaration( className ); 
			}
			CONFIG::FLEX4 {
				result = StyleManager.getStyleManager( module ).getStyleDeclaration( style );
			}
			
			return result; 
		}
		
		/**
		 * Sets the CSSStyleDeclaration object that stores the rules for the specified CSS selector.
		 * 
		 * @see mx.styles.IStyleManager#setStyleDeclaration()
		 * @see mx.styles.IStyleManager2#setStyleDeclaration()
		 */
		public static function setStyleDeclaration( style:String, declaration:CSSStyleDeclaration, update:Boolean = false, module:IFlexModuleFactory = null ):void
		{
			CONFIG::FLEX3 {
				StyleManager.setStyleDeclaration( style, declaration, update ); 
			}
			CONFIG::FLEX4 {
				StyleManager.getStyleManager( module ).setStyleDeclaration( style, declaration, update ); 
			}
		}
		
		/**
		 * Applies the specified styles to the specified style client.
		 */
		/**
		 * Apply the specified style key / value pairs to the specified object instance.
		 * 
		 * @param instance          Target object instance.
		 * @param properties        Style key / value pairs.
		 * @param evaluate          Indicates whether to evaluate the values against the instance.
		 */
		public static function applyStyles( styleClient:IStyleClient, styles:Object, evaluate:Boolean = false, callbackField:String = null ):void
		{
			if ( styles == null ) return;
			
			if ( styleClient != null ) 
			{
				for ( var key:String in styles )
				{
					var value:* = styles[ key ];
					
					if ( evaluate )
					{
						value = RuntimeEvaluationUtil.evaluate( styleClient, value, callbackField );
					}
					
					styleClient.setStyle( key, value );
				}
			}
		}
		
		/**
		 * Parses a style value into a Point.
		 */
		public static function parsePoint( value:Object ):Point
		{
			if ( value is Point )
				return value as Point;
			
			// TODO: Verify.
			if ( ( value is Array ) && ( value.length == 2 ) )
				return new Point( value[ 0 ], value[ 1 ] );
			
			return null;
		}
		
		// TODO: 
		//   parseRectangle( value:Object ):Rectangle
		//   parseFill( value:Object ):IFill
		//   parseStroke( value:Object ):IStroke
	}
}