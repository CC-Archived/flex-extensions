package com.codecatalyst.data.enumeration
{
	[Bindable]
	/**
	 * An abstract implementation of an enumerated type where each element has an immutable <code>id</code> property.
	 */
	public class AbstractEnumeration
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Unique identifier.
		 */
		public function get id():String
		{
			return _id;
		}
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>id</code>.
		 */
		protected var _id:String = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function AbstractEnumeration( id:String )
		{
			super();
			
			_id = id;
		}
	}
}