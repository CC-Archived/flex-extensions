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
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	/**
	 * Extends the standard Halo TabBar component to add support for overlapping tabs.
	 */
	public class OverlappingTabBar extends TabBar
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Child DisplayObjects, in their original order.
		 */
		protected var children:Array;
		
		/**
		 * Child DisplayObject original indices, keyed by instance.
		 */
		protected var childIndicesByInstance:Dictionary;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function OverlappingTabBar()
		{
			super();
			
			children = new Array();
			childIndicesByInstance = new Dictionary( true );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override public function addChild( child:DisplayObject ):DisplayObject
		{
			return addChildAt( child, numChildren );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function addChildAt( child:DisplayObject, index:int ):DisplayObject
		{
			super.addChildAt( child, index );
			
			children.splice( index, 0, child );
			childIndicesByInstance[ child ] = index;
			
			refresh();
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getChildAt( index:int ):DisplayObject
		{
			return children[ index ];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getChildIndex( child:DisplayObject ):int
		{
			return childIndicesByInstance[ child ];
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChild( child:DisplayObject ):DisplayObject
		{
			return removeChildAt( getChildIndex( child ) );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function removeChildAt( index:int ):DisplayObject
		{
			var child:DisplayObject = super.removeChild( getChildAt( index ) );
			
			children.splice( index, 1 );
			childIndicesByInstance[ child ] = null;
			
			refresh();
			
			return child;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function setChildIndex( child:DisplayObject, newIndex:int ):void
		{
			// NOTE: Unnecessary - index change applied in call to refresh().
			// super.setChildIndex( child, newIndex );
			
			var previousIndex:int = getChildIndex( child );
			
			children.splice( previousIndex, 1 );
			children.splice( newIndex, 0, child );
			
			var childCount:int = children.length;
			for ( var childIndex:int = previousIndex; childIndex < childCount; childIndex++ )
			{
				var child:DisplayObject = children[ childIndex ];
				
				childIndicesByInstance[ child ] = childIndex;
			}
			
			refresh();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override protected function hiliteSelectedNavItem( index:int ):void
		{
			super.hiliteSelectedNavItem( index );
			
			refresh();
		}
		
		/**
		 * Arrange in reverse z-order from the original indices and then bring the selected item to the front.
		 */
		protected function refresh():void
		{
			var highestDepth:int = numChildren - 1;
			
			var childCount:int = children.length;
			for ( var childIndex:int = 0; childIndex < childCount; childIndex++ )
			{
				super.setChildIndex( children[ childIndex ], highestDepth - childIndex );
			}
			
			if ( selectedIndex != -1 )
			{
				super.setChildIndex( children[ selectedIndex ], highestDepth );
			}
		}
	}
}