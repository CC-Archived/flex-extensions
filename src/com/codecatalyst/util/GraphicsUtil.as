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

package com.codecatalyst.util
{
	import flash.display.Graphics;
	
	import mx.graphics.IStroke;
	
	import qs.utils.GraphicsUtils;

	public class GraphicsUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Draw lines connecting the specified iterable set (Array, IList, etc.) of coordinates (Point, etc.) with the specified stroke and dash pattern (optional).
		 */
		public static function drawPolyLine( graphics:Graphics, coordinates:*, stroke:IStroke, pattern:Array = null ):void
		{
			if ( pattern != null )
			{
				GraphicsUtils.drawDashedPolyLine( graphics, stroke, pattern, coordinates );
			}
			else
			{
				if ( coordinates.length == 0 )
					return;

				stroke.apply( graphics );
				
				var coordinate:Object = coordinates[ 0 ];
				graphics.moveTo( coordinate.x, coordinate.y );
				for ( var coordinateIndex:int = 1; coordinateIndex < coordinates.length; coordinateIndex++ )
				{
					coordinate = coordinates[ coordinateIndex ];
					graphics.lineTo( coordinate.x, coordinate.y );
				}	
			}
		}
	}
}