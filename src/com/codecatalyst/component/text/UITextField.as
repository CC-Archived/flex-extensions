////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010 CodeCatalyst, LLC - http://www.codecatalyst.com/
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

package com.codecatalyst.component.text
{
	import flash.text.StyleSheet;
	
	import mx.core.UITextField;

	/**
	 *  Specifies whether links in htmlText are underlined.
	 *  Possible values are <code>"none"</code>, and <code>"underline"</code>.
	 * 
	 *  @default "none"
	 */
	[Style(name="linkDecoration", type="String", enumeration="none,underline", inherit="yes")]
	
	/**
	 * Color to use for links in htmlText.
	 */
	[Style(name="linkColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Specifies whether links in htmlText are underlined when hovered over.
	 *  Possible values are <code>"none"</code>, and <code>"underline"</code>.
	 * 
	 *  @default "none"
	 */
	[Style(name="hoverLinkDecoration", type="String", enumeration="none,underline", inherit="yes")]
	
	/**
	 * Color to use for links in htmlText when hovered over.
	 */
	[Style(name="hoverLinkColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 *  Specifies whether links in htmlText are underlined when active
	 *  Possible values are <code>"none"</code>, and <code>"underline"</code>.
	 * 
	 *  @default "none"
	 */
	[Style(name="activeLinkDecoration", type="String", enumeration="none,underline", inherit="yes")]
	
	/**
	 * Color to use for links in htmlText when active.
	 */
	[Style(name="activeLinkColor", type="uint", format="Color", inherit="yes")]

	/**
	 * Extends the standard Flex 3 Halo UITextField component to support new styles for specifying 
	 * hyperlink color and decoration (including support for active and hover state) for htmlText.
	 * 
	 * @example CSS sample
	 * 
	 * <listing version="3.0">
	 * .hoverLinkText {
	 *     linkDecoration: none;
	 *     linkColor: #336699;
	 *     hoverLinkDecoration: "underline";
	 *     hoverLinkColor: #336699; 
	 *     activeLinkDecoration: "underline";
	 *     activeLinkColor: #0000FF;
	 *  }
	 * </listing> 
	 * 
  	 * @author John Yanarella
	 */
	public class UITextField extends mx.core.UITextField
	{
		// ========================================
		// Protecteed properties
		// ========================================	
		
		/**
		 * Indicates whether a link-related Flex CSS style has changed.
		 */
		protected var linkStyleChanged:Boolean;
		
		// ========================================
		// Public properties
		// ========================================	
		
		/**
		 * @inheritDoc
		 */
		override public function set htmlText( value:String ):void
		{
			updateTextField( value, styleSheet );
		}
		
		// ========================================
		// Constructor
		// ========================================		
		
		/**
		 * Constructor.
		 */
		public function UITextField()
		{
			super();
		}

		// ========================================
		// Public methods
		// ========================================	
		
		/**
		 * @inheritDoc
		 */
		override public function styleChanged(styleProp:String):void
		{
			super.styleChanged( styleProp );

			var allStyles:Boolean = ( ( styleProp == null ) || ( styleProp == "styleName" ) );
			if ( allStyles ) 
			{
				linkStyleChanged = true;
			}
			else
			{
				switch ( styleProp )
				{
					case "linkDecoration":
					case "linkColor":
					case "hoverLinkDecoration":
					case "hoverLinkColor":
					case "activeLinkDecoration":
					case "activeLinkColor":
						
						linkStyleChanged = true;
						break;
				}
			}
			
			if ( linkStyleChanged )
			{
				if ( styleSheet == null ) 
					styleSheet = new StyleSheet();
				
				updateStyleSheetFromCSS( styleSheet );
				
				updateTextField( htmlText, styleSheet );
					
				linkStyleChanged = false;
			}
		}
		
		// ========================================
		// Protected methods
		// ========================================	

		/**
		 * Updates the TextField <code>htmlText</code> and <code>styleSheet</code>.
		 * 
		 * @param htmlText Text to be display in the TextField, including basic HTML markup.
		 * @param styleSheet TextField StyleSheet to apply.
		 */
		protected function updateTextField( htmlText:String, styleSheet:StyleSheet ):void
		{
			// NOTE: TextField's TextFormat and StyleSheet do not play nicely together.
			// The following logic ensures TextFormat and StyleSheet are applied in an acceptable order.
			// Otherwise strange things happen - especially when used within item renderers.
			
			super.styleSheet = null;
			super.htmlText = htmlText;
			
			if ( styleSheet != null )
			{
				super.styleSheet = styleSheet;
				super.htmlText = htmlText;		// NOTE: Intentionally calling the super.htmlText setter again.			
			}
		}

		/**
		 * Update the specified TextField StyleSheet based on the current Flex CSS styles.
		 */
		protected function updateStyleSheetFromCSS( styleSheet:StyleSheet ):void
		{
			applyStyle( styleSheet, "a:link",   createStyle( "linkDecoration", 		"linkColor" ) );
			applyStyle( styleSheet, "a:hover",  createStyle( "hoverLinkDecoration", "hoverLinkColor" ) );
			applyStyle( styleSheet, "a:active", createStyle( "activeLinkDecoration","activeLinkColor" ) );
		}

		/**
		 * Utility method to safely create a style object suitable for a flash.text.Stylesheet from named Flex styles.
		 */
		protected function createStyle( decorationStyleName:String, colorStyleName:String ):Object
		{
			var style:Object = new Object();
			
			var styleFound:Boolean = false;
			
			if ( getStyle( decorationStyleName ) )
			{
				style.textDecoration = getStyle( decorationStyleName );
				
				styleFound = true;
			}
			if ( getStyle( colorStyleName ) )
			{
				style.color = "#" + rgbToHex( getStyle( colorStyleName ) );
				
				styleFound = true;
			}
			
			return ( styleFound ) ? style : null;
		}
		
		/**
		 * Utility method to safely add a style object by name to a flash.text.Stylesheet.
		 */
		protected function applyStyle( styleSheet:StyleSheet, styleName:String, styleObject:Object ):void
		{
			if ( styleObject != null )
				styleSheet.setStyle( styleName, styleObject );
		}

		/**
		 * Utility method to convert an rgb uint value to a hex String representation.
		 */
		protected function rgbToHex( value:uint ):String
		{
			var str:String = value.toString( 16 ).toUpperCase();
			str = String( "000000" + str ).substr( -6 );
			
			return str;
		}
	}
}