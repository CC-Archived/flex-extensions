package com.codecatalyst.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class DisplayObjectContainerUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		[ArrayElementType("flash.display.DisplayObject")]
		/**
		 * Returns an Array of the specified DisplayObjectContainer's children.
		 */
		public static function children( container:DisplayObjectContainer ):Array
		{
			var children:Array = new Array();
			
			var numChildren:int = container.numChildren;
			for ( var childIndex:int = 0; childIndex < numChildren; childIndex++ )
			{
				var child:DisplayObject = container.getChildAt( childIndex );
				
				children.push( child );
			}
			
			return children;
		}
	}
}