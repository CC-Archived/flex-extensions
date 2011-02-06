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
	import flash.events.Event;
	
	import mx.charts.chartClasses.CartesianDataCanvas;
	import mx.charts.chartClasses.Series;
	import mx.events.FlexEvent;
	
	public class AbstractCartesianSeriesAnnotation extends CartesianDataCanvas
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>series<code> property.
		 * 
		 * @see #series
		 */
		protected var _series:Series;
		
		[ArrayElementType("mx.chart.ChartItem")]
		/**
		 * ChartItems for <code>series</code>.
		 */
		protected function get chartItems():Array
		{
			if ( ( series != null ) && ( series.items != null ) )
				return series.items;
			
			return [];
		}
		
		/**
		 * ChartItem item x value field.
		 */
		protected function get xField():String
		{
			try
			{
				return series[ "xField" ];
			}
			catch ( error:Error )
			{
				throw new Error( "Unsupported Series type." );
			}
			
			return null;
		}
		
		/**
		 * ChartItem item y value field.
		 */
		protected function get yField():String
		{
			try
			{
				return series[ "yField" ];
			}
			catch ( error:Error )
			{
				throw new Error( "Unsupported Series type." );
			}
			
			return null;
		}
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable("seriesChanged")]
		/**
		 * Series.
		 */
		public function get series():Series
		{
			return _series;
		}
		
		public function set series( value:Series ):void
		{
			if ( _series != value )
			{
				if ( _series != null )
					_series.addEventListener( FlexEvent.UPDATE_COMPLETE, series_updateCompleteHandler );
				
				_series = value;
				
				if ( _series != null )
					_series.addEventListener( FlexEvent.UPDATE_COMPLETE, series_updateCompleteHandler, false, 0, true );
				
				dispatchEvent( new Event( "seriesChanged" ) );
			}
		}
		
		// ========================================
		// Constructor
		// ========================================	
		
		/**
		 * Constructor
		 */
		public function AbstractCartesianSeriesAnnotation()
		{
			super();
			
			percentWidth = 100;
			percentHeight = 100;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Handle FlexEvent.UPDATE_COMPLETE.
		 */
		protected function series_updateCompleteHandler( event:FlexEvent ):void
		{
			invalidateDisplayList();
		}
	}
}