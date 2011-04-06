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
	import mx.controls.Text;
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
	 * Extends the standard Flex 3 Halo Text component to support new styles for specifying
	 * hyperlink color and decoration (including normal, active and hover states) for htmlText.
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
	public class Text extends mx.controls.Text
	{
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function Text()
		{
			super();
		}

		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override protected function createInFontContext( classObj:Class ):Object
		{
			// Replace requests for UITextField with LinkifyTextField.
			
			if ( classObj == mx.core.UITextField )
				classObj = com.codecatalyst.component.text.UITextField;
			
			return super.createInFontContext( classObj );
		}
	}
}