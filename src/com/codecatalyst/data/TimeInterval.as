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

package com.codecatalyst.data
{
	import com.codecatalyst.util.DateUtil;
	import com.codecatalyst.util.NumberUtil;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class TimeInterval extends EventDispatcher
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>unit</code> property.
		 * 
		 * @see #unit
		 */
		protected var _unit:Number = NaN;
		
		/**
		 * Backing variable for <code>count</code> property.
		 * 
		 * @see #count
		 */
		protected var _count:int = 1;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable("unitChanged")]
		/**
		 * Unit of time, expressed in milliseconds.
		 * 
		 * @see com.codecatalyst.util.DateUtil
		 */
		public function get unit():Number
		{
			return _unit;
		}
		
		public function set unit( value:Number ):void
		{
			if ( _unit != value )
			{
				_unit = value;
				
				dispatchEvent( new Event( "unitChanged" ) );
			}
		}
		
		[Bindable("countChanged")]
		/**
		 * Count of the specified <code>unit</code>.
		 * 
		 * @see #unit
		 */
		public function get count():int
		{
			return _count;
		}
		
		public function set count( value:int ):void
		{
			if ( _count != value )
			{
				_count = value;
				
				dispatchEvent( new Event( "countChanged" ) );
			}
		}
		
		[Bindable("unitChanged")]
		/**
		 * Relative unit of time, expressed in milliseconds.
		 */
		public function get relativeUnit():Number
		{
			return DateUtil.relativeUnit( unit );
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function TimeInterval( unit:Number = NaN, count:int = 1 ):void
		{
			super();
			
			this.unit  = unit;
			this.count = count;		
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Creates a clone of this TimeInterval.
		 */
		public function clone():TimeInterval
		{
			return new TimeInterval( unit, count );
		}
		
		/**
		 * Comparison function.
		 */
		public function compare( value:TimeInterval ):int
		{
			return NumberUtil.compare( unit * count, value.unit * value.count );
		}
		
		/**
		 * Iterate through the specified DateRange by incrementing by this TimeInterval and executing the specified Function for each Date increment.
		 */
		public function iterate( dateRange:DateRange, func:Function ):void
		{
			var date:Date = new Date( dateRange.startTime );
			
			while ( date.time < dateRange.endTime )
			{
				func( date );
				
				date = incrementDate( date );
			}
		}
		
		/**
		 * Returns a new Date representing the specified Date incremented by this time interval.
		 * 
		 * NOTE: This implements special case logic for inexact time units, such as months and years.
		 */
		public function incrementDate( date:Date ):Date
		{
			var incrementedDate:Date = new Date( date.time );
			
			switch ( unit )
			{
				case DateUtil.SECOND:
				case DateUtil.MINUTE:
				case DateUtil.HOUR:
				case DateUtil.DAY:
					incrementedDate.time += ( unit * count );
					return incrementedDate;
					
				case DateUtil.MONTH:
					incrementedDate.month += count;
					return incrementedDate;
					
				case DateUtil.QUARTER:
					incrementedDate.month += ( 3  * count );
					return incrementedDate;
					
				case DateUtil.YEAR:
					incrementedDate.fullYear += count;
					return incrementedDate;
					
				default:
					throw new Error( "Unsupported time unit specified." );
			}
		}
		
		/**
		 * Returns a new Date representing the specified Date decremented by this time interval.
		 * 
		 * NOTE: This implements special case logic for inexact time units, such as months and years.
		 */
		public function decrementDate( date:Date ):Date
		{
			var decrementedDate:Date = new Date( date.time );
			
			switch ( unit )
			{
				case DateUtil.SECOND:
				case DateUtil.MINUTE:
				case DateUtil.HOUR:
				case DateUtil.DAY:
					decrementedDate.time -= ( unit * count );
					return decrementedDate;
					
				case DateUtil.MONTH:
					decrementedDate.month -= count;
					return decrementedDate;
					
				case DateUtil.QUARTER:
					decrementedDate.month -= ( 3 * count );
					return decrementedDate;
					
				case DateUtil.YEAR:
					decrementedDate.fullYear -= count;
					return decrementedDate;
					
				default:
					throw new Error( "Unsupported time unit specified." );
			}
		}
	}
}