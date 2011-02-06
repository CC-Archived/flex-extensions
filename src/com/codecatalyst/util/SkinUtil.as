////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008 CodeCatalyst, LLC - http://www.codecatalyst.com/
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
	
	import mx.core.IFlexDisplayObject;
	import mx.core.IInvalidating;
	import mx.core.IProgrammaticSkin;
	import mx.managers.ILayoutManagerClient;
	import mx.styles.ISimpleStyleClient;

	public class SkinUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Creates an instance of the specified skin class.
		 */
		public static function create( skinClass:Class, styleName:Object ):DisplayObject
		{
			if ( skinClass != null )
			{
				var skin:DisplayObject = new skinClass() as DisplayObject;
				
				if ( skin is IInvalidating )
				{
					( skin as IInvalidating ).validateNow();
				}
				else if ( skin is IProgrammaticSkin )
				{
					( skin as IProgrammaticSkin ).validateDisplayList();
				}
				
				if ( skin is ISimpleStyleClient )
				{
					( skin as ISimpleStyleClient ).styleName = styleName;
				}
				
				return skin;
			}
			
			return null;
		}
		
		/**
		 * Simulate layout by the LayoutManager for the specified skin instance.
		 */
		public static function layout( skin:DisplayObject, owner:DisplayObject ):void
		{
			if ( ( skin is ILayoutManagerClient ) && ( owner is ILayoutManagerClient ) )
			{
				( skin as ILayoutManagerClient ).nestLevel   = ( owner as ILayoutManagerClient ).nestLevel + 1;
				( skin as ILayoutManagerClient ).initialized = true;
			}
		}
		
		/**
		 * Position the specified skin instance.
		 */
		public static function resize( skin:DisplayObject, width:Number, height:Number ):void
		{
			if ( skin is IFlexDisplayObject )
			{
				( skin as IFlexDisplayObject ).setActualSize( width, height );
			}
			else
			{
				skin.width  = width;
				skin.height = height;
			}
		}
		
		/**
		 * Validate the specified skin instance immediately.
		 */
		public static function validate( skin:DisplayObject ):void
		{
			if ( skin is IInvalidating )
			{
				( skin as IInvalidating ).validateNow();
			}
			else if ( skin is IProgrammaticSkin )
			{
				( skin as IProgrammaticSkin ).validateDisplayList();
			}
		}
	}
}