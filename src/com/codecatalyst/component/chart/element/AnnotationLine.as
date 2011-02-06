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

package com.codecatalyst.component.chart.element
{
	import com.codecatalyst.util.GraphicsUtil;
	import com.codecatalyst.util.NumberUtil;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.charts.chartClasses.CartesianDataCanvas;
	import mx.charts.chartClasses.ChartState;
	import mx.graphics.IStroke;
	import mx.graphics.Stroke;
	
	/**
	 * Stroke.
	 */
	[Style(name="stroke", type="mx.graphics.IStroke", inherit="no")]
	
	/**
	 * Dash pattern (optional).
	 */
	[Style(name="pattern", type="Array", arrayType="Number")]
	
	public class AnnotationLine extends CartesianDataCanvas
	{
		// ========================================
		// Protected properties
		// ========================================	
		
		/**
		 * Backing variable for <code>x1</code> property.
		 * 
		 * @see #x1
		 */
		protected var _x1:*;
		
		/**
		 * Backing variable for <code>y1</code> property.
		 * 
		 * @see #y1
		 */
		protected var _y1:*;
		
		/**
		 * Backing variable for <code>x2</code> property.
		 * 
		 * @see x2
		 */
		protected var _x2:*;
		
		/**
		 * Backing variable for <code>y2</code> property.
		 * 
		 * @see y2
		 */
		protected var _y2:*;
		
		// ========================================
		// Public properties
		// ========================================	
		
		[Bindable("x1Changed")]
		/**
		 * Starting x1 value, in data coordinates.
		 * 
		 * @see y1
		 */
		public function get x1():*
		{
			return _x1;
		}
		
		public function set x1( value:* ):void
		{
			if ( _x1 != value )
			{
				_x1 = value;
				
				invalidateDisplayList();
				
				dispatchEvent( new Event( "x1Changed" ) );
			}
		}
		
		[Bindable("y1Changed")]
		/**
		 * Starting y1 value, in data coordinates.
		 * 
		 * @see x1
		 */
		public function get y1():*
		{
			return _y1;
		}
		
		public function set y1( value:* ):void
		{
			if ( _y1 != value )
			{
				_y1 = value;
				
				invalidateDisplayList();
				
				dispatchEvent( new Event( "y1Changed" ) );
			}
		}
		
		[Bindable("x2Changed")]
		/**
		 * Ending x value, in data coordinates.
		 * 
		 * @see y2
		 */
		public function get x2():*
		{
			return _x2;
		}
		
		public function set x2( value:* ):void
		{
			if ( _x2 != value )
			{
				_x2 = value;
				
				invalidateDisplayList();
				
				dispatchEvent( new Event( "x2Changed" ) );
			}
		}
		
		[Bindable("y2Changed")]
		/**
		 * Ending y value, in data coordinates.
		 * 
		 * @see x2
		 */
		public function get y2():*
		{
			return _y2;
		}
		
		public function set y2( value:* ):void
		{
			if ( _y2 != value )
			{
				_y2 = value;
				
				invalidateDisplayList();
				
				dispatchEvent( new Event( "y2Changed" ) );
			}
		}
		
		// ========================================
		// Constructor
		// ========================================	
		
		/**
		 * Constructor.
		 */
		public function AnnotationLine()
		{
			super();
			
			percentWidth = 100;
			percentHeight = 100;
		}
		
		// ========================================
		// Protected methods
		// ========================================	
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if ( ( chart == null ) || ( chart.chartState == ChartState.PREPARING_TO_HIDE_DATA ) || ( chart.chartState == ChartState.HIDING_DATA ) )
				return;
			
			var stroke:IStroke = getStyle( "stroke" ) as IStroke || new Stroke( 0xffffff, 1.0 );
			var pattern:Array  = getStyle( "pattern" ) as Array;
			
			graphics.clear();
			
			GraphicsUtil.drawPolyLine( graphics, calculateLinePoints(), stroke, pattern );
		}
		
		/**
		 * Calculate the line Point(s) in local coordinates for the specified data coordinates.
		 */
		protected function calculateLinePoints():Array
		{
			var point1:Point = dataToLocal( x1, y1 );
			var point2:Point = dataToLocal( x2, y2 );
			
			var startPoint:Point = 
				new Point(
					NumberUtil.sanitizeNumber( point1.x, 0 ),
					NumberUtil.sanitizeNumber( point1.y, 0 )
				);
			var endPoint:Point =
				new Point(
					NumberUtil.sanitizeNumber( point2.x, NumberUtil.sanitizeNumber( point1.x, width  ) ),
					NumberUtil.sanitizeNumber( point2.y, NumberUtil.sanitizeNumber( point1.y, height ) )
				);
			
			return [ startPoint, endPoint ];
		}
	}
}