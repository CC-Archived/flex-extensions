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
	import flash.geom.Point;
	
	import mx.styles.IStyleClient;
	
	public class StyleUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Applies the specified styles to the specified style client.
		 */
		public static function applyStyles( styleClient:IStyleClient, styles:Object ):void
		{
			for ( var style:String in styles )
			{
				styleClient.setStyle( style, styles[ style ] );
			}
		}
		
		/**
		 * Parses a style value into a Point.
		 */
		public static function parsePoint( value:Object ):Point
		{
			if ( value is Point )
				return value as Point;
			
			// TODO: Verify.
			if ( ( value is Array ) && ( value.length == 2 ) )
				return new Point( value[ 0 ], value[ 1 ] );
			
			return null;
		}
		
		// TODO: 
		//   parseRectangle( value:Object ):Rectangle
		//   parseFill( value:Object ):IFill
		//   parseStroke( value:Object ):IStroke
	}
}