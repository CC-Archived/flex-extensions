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

package com.codecatalyst.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class DateRange extends EventDispatcher
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>startTime</code property.
		 */
		protected var _startTime:Number = NaN;
		
		/**
		 * Backing variable for <code>startDate</code> property.
		 */
		protected var _startDate:Date;
		
		/**
		 * Backing variable for <code>endTime</code property.
		 */
		protected var _endTime:Number = NaN;
		
		/**
		 * Backing variable for <code>endDate</code> property.
		 */
		protected var _endDate:Date;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable( "startDateChanged" )]
		/**
		 * Starting date for range, expressed in milliseconds since epoch.
		 * 
		 * @see #startDate
		 */
		public function get startTime():Number
		{
			return _startTime;
		}
		
		public function set startTime( value:Number ):void
		{
			if ( _startTime != value )
			{
				_startTime = value;
				_startDate = isNaN( value ) ? null : new Date( value );
				
				dispatchEvent( new Event( "startDateChanged" ) );
			}
		}
		
		[Bindable("startDateChanged")]
		/**
		 * Start date.
		 */
		public function get startDate():Date
		{
			return _startDate;
		}
		
		[Bindable( "endDateChanged" )]
		/**
		 * Ending date for range, expressed in milliseconds since epoch.
		 * 
		 * @see #endDate
		 */
		public function get endTime():Number
		{
			return _endTime;
		}
		
		public function set endTime( value:Number ):void
		{
			if ( _endTime != value )
			{
				_endTime = value;
				_endDate = isNaN( value ) ? null : new Date( value );
				
				dispatchEvent( new Event( "endDateChanged" ) );
			}
		}
		
		[Bindable("endDateChanged")]
		/**
		 * End date.
		 */
		public function get endDate():Date
		{
			return _endDate;
		}
		
		[Bindable("startDateChanged")]
		[Bindable("endDateChanged")]
		/**
		 * Duration between the current start date and end date, in millseconds.
		 */
		public function get duration():Number
		{
			return endTime - startTime;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function DateRange( startTime:Number = NaN, endTime:Number = NaN )
		{
			super();
			
			this.startTime = startTime;
			this.endTime   = endTime;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Creates a clone of this DateRange.
		 */
		public function clone():DateRange
		{
			return new DateRange( startTime, endTime );
		}
		
		/**
		 * Returns a Boolean indicating whether specified time occurs between the current start time and end time.
		 */
		public function contains( time:Number ):Boolean
		{
			if ( ! isNaN( time ) )
				return ( ( time >= startTime ) && ( time <= endTime ) );
			
			return false;
		}
		
		/**
		 * Given a Date time, creates a Date time bounded by the current start time and end time.
		 */
		public function createBoundedDateTime( time:Number ):Number
		{
			return calculateBoundedTime( time );
		}
		
		/**
		 * Given a DateRange, creates a corresponding DateRange bounded by the current start time and end time.
		 */
		public function createBoundedDateRange( dateRange:DateRange ):DateRange
		{
			var boundedDateRange:DateRange = new DateRange();
			
			boundedDateRange.startTime = calculateBoundedTime( dateRange.startTime );
			boundedDateRange.endTime   = calculateBoundedTime( dateRange.endTime );
			
			return boundedDateRange;
		}
		
		/**
		 * Returns a Boolean indicating whether the specified DateRange intersects with the current start time and end time.
		 */
		public function intersects( dateRange:DateRange ):Boolean
		{
			if ( dateRange != null )
				return ( ( dateRange.startTime <= endTime ) && ( dateRange.endTime >= startTime ) );
			
			return false;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Calculate a bounded time, constrained by the current start time and end time.
		 */
		protected function calculateBoundedTime( time:Number ):Number
		{
			return Math.max( Math.min( time, endTime ), startTime );
		}
	}
}