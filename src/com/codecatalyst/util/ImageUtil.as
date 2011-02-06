////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2009 CodeCatalyst, LLC - http://www.codecatalyst.com/
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
	import flash.display.Bitmap;

	public class ImageUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Return the specified image source converted to grayscale.
		 */
		public static function grayscale( source:Object ):Bitmap
		{
			var bitmap:Bitmap = createBitmap( source );
			
			BitmapDataUtil.grayscale( bitmap.bitmapData );
			
			return bitmap;
		}
		
		/**
		 * Return the specified image source tinted with the specified color.
		 */
		public static function tint( source:Object, color:uint ):Bitmap
		{
			var bitmap:Bitmap = createBitmap( source );
			
			BitmapDataUtil.tint( bitmap.bitmapData, color );
			
			return bitmap;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Create a Bitmap instance from the specified source.
		 */
		protected static function createBitmap( source:Object ):Bitmap
		{
			if ( source is Class )
			{
				return new source() as Bitmap;
			}
			else if ( source is Bitmap )
			{
				return source as Bitmap;
			}
			else
			{
				throw new Error( "Unsuported source specified." );
			}
		}
	}
}