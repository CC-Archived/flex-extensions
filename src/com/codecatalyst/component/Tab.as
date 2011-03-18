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

package com.codecatalyst.component
{
	import com.codecatalyst.util.NumberUtil;
	
	import mx.controls.ButtonPhase;
	import mx.controls.tabBarClasses.Tab;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	/**
	 *  Text color of the label as the user moves the mouse pointer over the button while the button is selected.
	 *  
	 *  @default textRollOverColor
	 */
	[Style(name="textSelectedRollOverColor", type="uint", format="Color", inherit="yes")]
	
	/**
	 * Vertical offset of the label while the tab is selected.
	 */
	[Style(name="selectedLabelVerticalOffset", type="Number", format="Length", inherit="no")]
	
	/**
	 * Extends the standard Halo Tab component to add support for additional styles.
	 */
	public class Tab extends mx.controls.tabBarClasses.Tab
	{
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function Tab()
		{
			super();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override mx_internal function layoutContents( unscaledWidth:Number, unscaledHeight:Number, offset:Boolean ):void
		{
			super.layoutContents(unscaledWidth, unscaledHeight, offset);
			
			if ( selected )
			{
				var selectedLabelVerticalOffset:Number = NumberUtil.sanitizeNumber( getStyle( "selectedLabelVerticalOffset" ), 0 ) - 1;
				
				textField.y += selectedLabelVerticalOffset;
				
				if (currentIcon != null )
					currentIcon.y += selectedLabelVerticalOffset;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override mx_internal function viewSkinForPhase( tempSkinName:String, stateName:String ):void
		{
			super.viewSkinForPhase( tempSkinName, stateName );
			
			if ( enabled && selected )
			{
				if ( phase == ButtonPhase.OVER )
				{
					var labelColor:Number = ( textField.getStyle( "textSelectedRollOverColor" ) != null ) ? textField.getStyle( "textSelectedRollOverColor" ) : textField.getStyle( "textRollOverColor" );		
					textField.setColor( labelColor );
				}
			}
		}
	}
}