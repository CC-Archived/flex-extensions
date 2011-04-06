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
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class RectangleUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Returns a Boolean value indicating whether the specified Rectangle is valid.
		 */
		public static function isValid( rectangle:Rectangle ):Boolean
		{
			if ( ( rectangle == null ) || isNaN( rectangle.width ) || isNaN( rectangle.height ) )
				return false;
			
			return true;
		}
		
		/**
		 * Returns a new normalized Rectangle based on the specified Rectangle.
		 * 
		 * Any Rectangle with negative width or height becomes a Rectangle with positive width or height that extends to the upper-left of the original Rectangle.
		 */
		public static function normalize( rectangle:Rectangle ):Rectangle
		{
			var normalizedRectangle:Rectangle = rectangle.clone();
			
			if ( normalizedRectangle.width < 0 )
			{
				normalizedRectangle.x     = normalizedRectangle.x + normalizedRectangle.width;
				normalizedRectangle.width = normalizedRectangle.width * -1;
			}
			
			if ( normalizedRectangle.height < 0 )
			{
				normalizedRectangle.y      = normalizedRectangle.y + normalizedRectangle.height;
				normalizedRectangle.height = normalizedRectangle.height * -1;
			}
			
			return normalizedRectangle;
		}
		
		/**
		 * Returns a new Rectangle translated by the specified x and y coordinates.
		 */
		public static function translate( rectangle:Rectangle, x:Number, y:Number ):Rectangle
		{
			var translatedRectangle:Rectangle = rectangle.clone();
			
			translatedRectangle.offset( x, y );
			
			return translatedRectangle;
		}
		
		/**
		 * Returns the center Point of the specified Rectangle.
		 */
		public static function center( rectangle:Rectangle ):Point
		{
			return new Point( ( rectangle.left + rectangle.right ) / 2.0, ( rectangle.top + rectangle.bottom ) / 2.0 );
		}
	}
}