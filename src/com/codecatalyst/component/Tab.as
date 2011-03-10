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