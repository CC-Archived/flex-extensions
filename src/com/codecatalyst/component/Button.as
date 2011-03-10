package com.codecatalyst.component
{
	import mx.controls.Button;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	/**
	 * Extends the standard Flex Halo Button control to support additional styles.
	 */
	public class Button extends mx.controls.Button
	{
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function Button()
		{
			super();
		}
		
		// ========================================
		// mx_internal methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override mx_internal function viewSkinForPhase( tempSkinName:String, stateName:String ):void
		{
			super.viewSkinForPhase( tempSkinName, stateName );
			
			if ( selected )
			{
				textField.setColor( getStyle( "textSelectedColor" ) );
			}
		}
	}
}