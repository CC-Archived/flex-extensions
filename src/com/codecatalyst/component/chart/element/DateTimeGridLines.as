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
	import com.codecatalyst.data.DateRange;
	import com.codecatalyst.data.TimeInterval;
	import com.codecatalyst.util.ArrayUtil;
	import com.codecatalyst.util.DateUtil;
	import com.codecatalyst.util.GraphicsUtil;
	import com.codecatalyst.util.NumberUtil;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.charts.chartClasses.ChartState;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	
	/**
	 * Fill.
	 */
	[Style(name="fill", type="mx.graphics.IFill", inherit="no")]
	
	/**
	 * Stroke.
	 */
	[Style(name="stroke", type="mx.graphics.IStroke", inherit="no")]
	
	/**
	 * Dash pattern.
	 */
	[Style(name="pattern", type="Array", arrayType="Number")]
	
	[DefaultProperty("sets")]
	public class DateTimeGridLines extends AbstractDateTimeAxisAnnotation
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>sets</code> property.
		 * 
		 * @see #sets
		 */
		protected var _sets:Array = null;
		
		/**
		 * Sorted <code>sets</code>.
		 * 
		 * @see #sets
		 */
		protected var sortedSets:Array = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		[ArrayElementType("com.codecatalyst.component.chart.element.DateTimeGridLineSet")]
		[Bindable("setsChanged")]
		/**
		 * Array of DateTimeGridLineSet(s).
		 */
		public function get sets():Array
		{
			return _sets;
		}
		
		public function set sets( value:Array ):void
		{
			if ( _sets != value )
			{
				_sets = value;
				
				if ( _sets != null )
				{
					// Clone the Array of DateTimeGridLineSet(s) and sort the resulting Array by duration.
					
					sortedSets = ArrayUtil.clone( _sets )
					
					sortedSets = sortedSets.sort(
						function ( a:DateTimeGridLineSet, b:DateTimeGridLineSet ):int
						{
							return NumberUtil.compare( a.maximumTimeSpan, b.maximumTimeSpan );
						}
					);
				}
				
				dispatchEvent( new Event( "setsChanged" ) );
			}
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function DateTimeGridLines()
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
			
			var fill:IFill     = getStyle( "fill" )    as IFill;
			var stroke:IStroke = getStyle( "stroke" )  as IStroke;
			var pattern:Array  = getStyle( "pattern" ) as Array;
			
			graphics.clear();
			
			if ( dateTimeAxis != null )
			{
				// Calculate the duration
				
				var duration:Number = DateUtil.duration( dateTimeAxis.minimum, dateTimeAxis.maximum );
				
				// Get the appropriate set for the calculated duration
				
				var gridLineSet:DateTimeGridLineSet = getAppropriateDateTimeGridLineSetForDuration( duration );
				
				if ( gridLineSet != null )
				{
					// Get the starting and ending date relative to the the time interval's relative unit
					
					var dateRange:DateRange = 
						new DateRange(
							calculateRelativeStartingDate( dateTimeAxis.minimum, gridLineSet.interval ).time,
							calculateRelativeEndingDate( dateTimeAxis.maximum, gridLineSet.interval ).time
						);
					
					var date:Date = null;
					var rectangle:Rectangle = null;

					// Draw fills (if applicable)

					if ( fill != null )
					{
						gridLineSet.interval.iterate(
							dateRange,
							function ( date:Date ):void
							{
								if ( ( gridLineSet.fillFilterFunction == null ) || ( gridLineSet.fillFilterFunction( date ) == true ) )
								{
									var rectangle:Rectangle = calculateGridLineRectangleForDate( date, gridLineSet.interval );
									
									CONFIG::FLEX3 {	fill.begin( graphics, rectangle );				}
									CONFIG::FLEX4 {	fill.begin( graphics, rectangle, null );		}
									
									graphics.drawRect( rectangle.x, rectangle.y, rectangle.width, rectangle.height );
									fill.end( graphics );
								}
							}
						);					
					}
					
					// Draw strokes (if applicable )
					
					if ( stroke != null )
					{
						gridLineSet.interval.iterate(
							dateRange,
							function ( date:Date ):void
							{
								if ( ( gridLineSet.strokeFilterFunction == null ) || ( gridLineSet.strokeFilterFunction( date ) == true ) )
								{
									GraphicsUtil.drawPolyLine( 
										graphics, 
										calculateGridLinePointsForRectangle( 
											calculateGridLineRectangleForDate( date, gridLineSet.interval )
										), 
										stroke, 
										pattern
									);
								}
							}
						);					
					}
				}
			}
		}
		
		/**
		 * Get the appropriate DateTimeGridLineSet for the calculated duration.
		 */
		protected function getAppropriateDateTimeGridLineSetForDuration( duration:Number ):DateTimeGridLineSet
		{
			// Return the first grid line set among the sorted sets where the duration does not exceed the set's maximum time span threshold.
			
			for each ( var gridLineSet:DateTimeGridLineSet in sortedSets )
			{
				if ( isNaN( gridLineSet.maximumTimeSpan ) || ( gridLineSet.maximumTimeSpan >= duration ) )
					return gridLineSet;
			}
			
			return null;
		}
		
		/**
		 * Calculate the starting occurrence Date for the specified Date, relative to the specified repeating time interval.
		 */
		public function calculateRelativeStartingDate( date:Date, interval:TimeInterval ):Date
		{
			var result:Date = DateUtil.floor( date, interval.relativeUnit );
			
			var incrementedDate:Date = interval.incrementDate( result );
			while ( incrementedDate.time < date.time )
			{
				result = incrementedDate;
				
				incrementedDate = interval.incrementDate( result );
			}
			
			return result;
		}
		
		/**
		 * Calculate the ending occurrence Date for the specified Date, relative to the specified repeating time interval.
		 */
		public function calculateRelativeEndingDate( date:Date, interval:TimeInterval ):Date
		{
			var result:Date = DateUtil.ceil( date, interval.relativeUnit );
			
			var decrementedDate:Date = interval.incrementDate( result );
			while ( decrementedDate.time > date.time )
			{
				result = decrementedDate;
				
				decrementedDate = interval.decrementDate( result );
			}
			
			return result;
		}
		
		/**
		 * Calculates a grid line Rectangle in local coordinates for the specified date and time interval.
		 */
		protected function calculateGridLineRectangleForDate( date:Date, interval:TimeInterval ):Rectangle
		{
			var rectangle:Rectangle = null;
			
			if ( dateTimeAxisDirection == HORIZONTAL )
			{
				rectangle = new Rectangle();

				rectangle.top    = 0;
				rectangle.left   = dataToLocal( date ).x;
				rectangle.bottom = unscaledHeight;
				rectangle.right  = dataToLocal( interval.incrementDate( date ) ).x;
			}
			else if ( dateTimeAxisDirection == VERTICAL )
			{
				rectangle = new Rectangle();
				
				rectangle.top    = dataToLocal( null, date ).y;
				rectangle.left   = 0;
				rectangle.bottom = dataToLocal( null, interval.incrementDate( date ) ).y;
				rectangle.right  = unscaledWidth;
			}
			
			return rectangle;
		}
		
		/**
		 * Calculates grid line segment Points based on the date time axis direction and the specified Rectangle.
		 * 
		 * @see #calculateGridLineRectangleForDate()
		 */
		protected function calculateGridLinePointsForRectangle( rectangle:Rectangle ):Array
		{
			if ( dateTimeAxisDirection == HORIZONTAL )
			{
				return [ new Point( rectangle.left, rectangle.top ), new Point( rectangle.left, rectangle.bottom ) ];
			}
			else if ( dateTimeAxisDirection == VERTICAL )
			{
				return [ new Point( rectangle.left, rectangle.top ), new Point( rectangle.right, rectangle.top ) ];
			}
			
			return [];
		}
	}
}
