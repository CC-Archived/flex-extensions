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

package com.codecatalyst.component.chart
{
	import mx.charts.AxisRenderer;
	import mx.charts.LinearAxis;
	import mx.charts.chartClasses.CartesianChart;
	
	public class DynamicChart extends CartesianChart
	{
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function DynamicChart()
		{
			super();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 *  @inheritDoc
		 */
		override protected function commitProperties():void
		{
			// Workaround for bug in CartesianChart where the deprecated <code>horizontalAxisRenderer</code> and <code>verticalAxisRenderer</code>
			// properties are internally populated by CartesianChart and are not cleared when <code>horizontalAxisRenderers</code> or <code>verticalAxisRenderers</code>
			// are later dynamically populated.
			
			if ( ( horizontalAxisRenderers.length == 0 ) && ( horizontalAxisRenderer == null ) )
			{
				horizontalAxisRenderers = [ createTemporaryAxisRenderer() ];
			}
			
			if ( ( verticalAxisRenderers.length == 0 ) && ( verticalAxisRenderer == null ) )
			{
				verticalAxisRenderers = [ createTemporaryAxisRenderer() ];
			}
			
			super.commitProperties();
		}
		
		/**
		 * Create a temporary AxisRenderer.
		 */
		protected function createTemporaryAxisRenderer():AxisRenderer
		{
			var axisRenderer:AxisRenderer = new AxisRenderer();
			
			axisRenderer.axis = new LinearAxis();
			
			return axisRenderer;
		}
	}
}