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
		
		/**
		 * Brings the specified DisplayObject forward in z-order within the specified DisplayObjectContainer.
		 */
		public static function bringForward( container:DisplayObjectContainer, displayObject:DisplayObject ):void
		{
			var childIndex:int = container.getChildIndex( displayObject );
			var targetIndex:int = ( childIndex < container.numChildren - 1 ) ? childIndex++ : childIndex;
			
			container.setChildIndex( displayObject, targetIndex );
		}
		
		/**
		 * Brings the specified DisplayObject to the front in z-order within the specified DisplayObjectContainer.
		 */
		public static function bringToFront( container:DisplayObjectContainer, displayObject:DisplayObject ):void
		{
			var lastIndex:int = container.numChildren - 1;
			
			container.setChildIndex( displayObject, lastIndex );
		}
		
		/**
		 * Sends the specified DisplayObject backward in z-order within the specified DisplayObjectContainer.
		 */
		public static function sendBackward( container:DisplayObjectContainer, displayObject:DisplayObject ):void
		{
			var childIndex:int = container.getChildIndex( displayObject );
			var targetIndex:int = ( childIndex > 0 ) ? childIndex-- : childIndex;
			
			container.setChildIndex( displayObject, targetIndex );
		}
		
		/**
		 * Sends the specified DisplayObject to the back in z-order within the specified DisplayObjectContainer.
		 */
		public static function sendToBack( container:DisplayObjectContainer, displayObject:DisplayObject ):void
		{
			var firstIndex:int = 0;
			
			container.setChildIndex( displayObject, firstIndex );
		}
	}
}