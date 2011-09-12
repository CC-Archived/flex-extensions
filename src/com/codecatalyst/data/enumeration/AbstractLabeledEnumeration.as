package com.codecatalyst.data.enumeration
{
	[Bindable]
	/**
	 * An abstract implementation of an enumerated type where each element has an immutable <code>id</code> and <code>displayLabel</code> property.
	 */
	public class AbstractLabeledEnumeration extends AbstractEnumeration
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Display label.
		 */
		public function get displayLabel():String
		{
			return _displayLabel;
		}
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Backing variable for <code>displayLabel</code>.
		 */
		protected var _displayLabel:String = null;

		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function AbstractLabeledEnumeration( id:String, displayLabel:String )
		{
			super( id );
			
			_displayLabel = displayLabel;
		}
	}
}