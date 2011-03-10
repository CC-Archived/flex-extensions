package com.codecatalyst.component
{
	import mx.controls.TabBar;
	import mx.core.ClassFactory;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	/**
	 * Extends the standard Halo TabBar to replace the standard Tab navigation item with a custom subclass.
	 * 
	 * @see com.codecatalyst.component.Tab
	 */
	public class TabBar extends mx.controls.TabBar
	{
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function TabBar()
		{
			super();
			
			navItemFactory = new ClassFactory( Tab );
		}
	}
}