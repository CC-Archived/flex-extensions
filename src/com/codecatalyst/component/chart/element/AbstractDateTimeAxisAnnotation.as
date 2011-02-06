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
	import mx.charts.DateTimeAxis;
	import mx.charts.chartClasses.CartesianChart;
	import mx.charts.chartClasses.CartesianDataCanvas;
	
	public class AbstractDateTimeAxisAnnotation extends CartesianDataCanvas
	{
		// ========================================
		// Protected constants
		// ========================================
		
		/**
		 * Vertical direction.
		 */
		protected static const VERTICAL:String = "vertical";
		
		/**
		 * Horizontal direction.
		 */
		protected static const HORIZONTAL:String = "horizontal";
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * DateTimeAxis associated with the <code>chart</code>, if applicable.
		 */
		protected var dateTimeAxis:DateTimeAxis = null;
		
		/**
		 * Direction of the DateTimeAxis (<code>HORIZONTAL</code> or <code>VERTICAL</code>).
		 */
		protected var dateTimeAxisDirection:String = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function AbstractDateTimeAxisAnnotation()
		{
			super();
			
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			dateTimeAxis = getDateTimeAxis();
			dateTimeAxisDirection = getDateTimeAxisDirection();
		}
		
		/**
		 * Returns the DateTimeAxis, or <code>null</code> if the parent chart does not have a DateTimeAxis.
		 */
		protected function getDateTimeAxis():DateTimeAxis
		{
			if ( horizontalAxis is DateTimeAxis )
				return horizontalAxis as DateTimeAxis;
			
			if ( verticalAxis is DateTimeAxis )
				return verticalAxis as DateTimeAxis;
			
			if ( chart is CartesianChart )
			{
				var cartesianChart:CartesianChart = chart as CartesianChart;
				
				if ( cartesianChart.horizontalAxis is DateTimeAxis )
					return cartesianChart.horizontalAxis as DateTimeAxis;
				
				if ( cartesianChart.verticalAxis is DateTimeAxis )
					return cartesianChart.verticalAxis as DateTimeAxis;
			}
			
			return null;
		}
		
		/**
		 * Returns the DateTimeAxis direction (<code>HORIZONTAL</code> or <code>VERTICAL</code>), or <code>null</code> if the parent chart does not have a DateTimeAxis.
		 */
		protected function getDateTimeAxisDirection():String
		{
			if ( horizontalAxis is DateTimeAxis )
				return HORIZONTAL;
			
			if ( verticalAxis is DateTimeAxis )
				return VERTICAL;
			
			if ( chart is CartesianChart )
			{
				var cartesianChart:CartesianChart = chart as CartesianChart;
				
				if ( cartesianChart.horizontalAxis is DateTimeAxis )
					return HORIZONTAL;
				
				if ( cartesianChart.verticalAxis is DateTimeAxis )
					return VERTICAL;
			}
			
			return null;
		}
	}
}