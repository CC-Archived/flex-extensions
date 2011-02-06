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
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.filters.ColorMatrixFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	public class BitmapDataUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Create a grayscale version of the specified BitmapData.
		 */
		public static function grayscale( bitmapData:BitmapData ):BitmapData
		{
			var rLum:Number = 0.3086;
			var gLum:Number = 0.6094;
			var bLum:Number = 0.082; 
			
			var matrix:Array = 
				[ 
					rLum, gLum, bLum, 0,    0,
					rLum, gLum, bLum, 0,    0,
					rLum, gLum, bLum, 0,    0,
					0,    0,    0,    1,    0 
				];
			 
			var bitmapBounds:Rectangle = new Rectangle( 0, 0, bitmapData.width, bitmapData.height );
			var filter:ColorMatrixFilter = new ColorMatrixFilter( matrix );

			bitmapData.applyFilter( bitmapData, bitmapBounds, new Point( 0, 0 ), filter );
			
			return bitmapData;
		}
		
		/**
		 * Tint the specified BitmapData with the specified color.
		 */
		public static function tint( bitmapData:BitmapData, color:uint ):BitmapData
		{
			var r:int = ( ( color >> 16 ) & 0xFF );
			var g:int = ( ( color >> 8 )  & 0xFF );
			var b:int = ( ( color )       & 0xFF );
			
			var bitmapBounds:Rectangle = new Rectangle( 0, 0, bitmapData.width, bitmapData.height );
			var colorTransform:ColorTransform = new ColorTransform( 1.0, 1.0, 1.0, 1.0, r, g, b );
			
			bitmapData.colorTransform( bitmapBounds, colorTransform );
			
			return bitmapData;
		}
		
		// TODO: lighten( percentage ), darken( percentage ).
	}
}