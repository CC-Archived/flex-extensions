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

package com.codecatalyst.component.chart.element
{
	import com.codecatalyst.util.GraphicsUtil;
	
	import flash.geom.Point;
	
	import mx.charts.ChartItem;
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
	
	public class LinearTrendLine extends AbstractCartesianSeriesAnnotation
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>pattern</code> property.
		 * 
		 * @see #pattern
		 */
		protected var _pattern:Array = null;
		
		/**
		 * Slope.
		 */
		protected var slope:Number = NaN;
		
		/**
		 * Y intercept.
		 */
		protected var yIntercept:Number = NaN;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function LinearTrendLine()
		{
			super();
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
			
			var stroke:IStroke = getStyle( "stroke" )  as IStroke || new Stroke( 0xffffff, 1.0 );
			var pattern:Array  = getStyle( "pattern" ) as Array;
			
			graphics.clear();

			if ( chartItems.length > 0 )
			{
				calculateSlopeAndYIntercept();
				
				if ( !isNaN( slope ) && !isNaN( yIntercept ) )
				{
					var firstItem:ChartItem = chartItems[ 0 ];
					var lastItem:ChartItem  = chartItems[ chartItems.length - 1 ];
					
					var point1:Point = createLocalTrendPointForChartItem( firstItem );
					var point2:Point = createLocalTrendPointForChartItem( lastItem );
					
					GraphicsUtil.drawPolyLine( graphics, [ point1, point2 ], stroke, pattern );
				}
			}
		}
		
		/**
		 * Creates a Point along the trend line, in local coordinates, given a ChartItem.
		 */
		protected function createLocalTrendPointForChartItem( chartItem:ChartItem ):Point
		{
			var point:Point = dataToLocal( chartItem.item[ xField ], chartItem.item[ yField ] );
			
			// y = mx + b
			point.y = ( slope * point.x ) + yIntercept;
			
			return point;
		}
		
		/**
		 * Calculate the slope and y intercept for the <code>series</code>.
		 */
		protected function calculateSlopeAndYIntercept():void
		{
			var numberOfItems:Number = chartItems.length;
			
			if ( numberOfItems > 0 )
			{
				// Precalculate the various summations used in the equations below.
				
				var sumOfAllXTimesY:Number = 0;
				var sumOfAllX:Number = 0;
				var sumOfAllY:Number = 0;
				var sumOfAllSquaredX:Number = 0;
				for each ( var chartItem:ChartItem in chartItems )
				{
					var point:Point = dataToLocal( chartItem.item[ xField ], chartItem.item[ yField ] );
					
					sumOfAllXTimesY += point.x * point.y;
					sumOfAllX += point.x;
					sumOfAllY += point.y;
					sumOfAllSquaredX += point.x * point.x;
				}
				
				// Calculate 'a', the number of items times the sum of all x-values multiplied by their corresponding y-values:
				//   a = n * ( (x[0] * y[0]) + (x[1] * y[1]) + ... )
				var numOfItemsTimesSumOfAll:Number = numberOfItems * sumOfAllXTimesY;
				
				// Calculate 'b', the sum of all x-values times the sum of all y-values:
				//   b = ( y[0] + y[1] + ... ) * ( x[0] + x[1] + ... )
				var sumOfAllXTimeSumOfAllY:Number = sumOfAllX * sumOfAllY;
				
				// Calculate 'c', the number of items times the sum of all squared x-values:
				//   c = n * ( x[0]^2 + x[1]^2 + ... )
				var numOfAllItemsTimesSumOfAllSquaredX:Number = numberOfItems * sumOfAllSquaredX;
				
				// Calculate 'd', the squared sum of all x-values:
				//   d = ( x[0] + x[1] + ... )^2
				var squaredSumOfAllX:Number = sumOfAllX * sumOfAllX;
				
				// Calculate the slope 'm':
				//   m = ( a - b ) / ( c- d )
				slope = ( numOfItemsTimesSumOfAll - sumOfAllXTimeSumOfAllY ) / ( numOfAllItemsTimesSumOfAllSquaredX - squaredSumOfAllX );
				
				// Calculate the y-intercept 'b':
				//   b = ( ( y[0] + y[1] + ... ) - ( m * ( x[0] + x[1] + ... ) ) / n
				yIntercept = (sumOfAllY - ( slope * sumOfAllX ) ) / numberOfItems;
			}
			else
			{
				slope = NaN;
				yIntercept = NaN;
			}
		}
	}
}