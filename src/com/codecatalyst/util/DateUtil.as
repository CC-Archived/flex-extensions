////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008 CodeCatalyst, LLC - http://www.codecatalyst.com/
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
	import com.codecatalyst.data.DateRange;
	
	import mx.formatters.DateFormatter;
	
	public class DateUtil
	{
		// ========================================
		// Public constants
		// ========================================
		
		/**
		 * Time expressed as milliseconds.
		 */
		public static const MILLISECOND:Number 	= 1;
		public static const SECOND:Number 		= MILLISECOND * 1000;
		public static const MINUTE:Number 		= SECOND * 60;
		public static const HOUR:Number 		= MINUTE * 60;
		public static const DAY:Number 			= HOUR * 24;
		public static const WEEK:Number 		= DAY * 7;
		public static const MONTH:Number 		= DAY * 30; 				// NOTE: Imprecise.
		public static const QUARTER:Number		= MONTH * 3; 				// NOTE: Imprecise.
		public static const YEAR:Number   		= DAY * 365; 				// NOTE: Imprecise.
		
		/**
		 * Days of the week.
		 */
		public static const SUNDAY:Number 		= 0;
		public static const MONDAY:Number 		= 1;
		public static const TUESDAY:Number 		= 2;
		public static const WEDNESDAY:Number 	= 3;
		public static const THURSDAY:Number 	= 4;
		public static const FRIDAY:Number 		= 5;
		public static const SATURDAY:Number 	= 6;
		
		[ArrayElementType("String")]
		/**
		 * Month names (localized).
		 */
		public static function get MONTH_NAMES():Array
		{
			if ( _MONTH_NAMES == null )
			{
				_MONTH_NAMES = new Array();
				
				var dateFormatter:DateFormatter = new DateFormatter();
				dateFormatter.formatString = "MMMM";
				
				var date:Date = new Date( 2011, 0, 1 );
				for ( var month:int = 0; month < 12; month++ )
				{
					date.month = month;
					
					_MONTH_NAMES.push( dateFormatter.format( date ) );
				}
			}
			
			return _MONTH_NAMES;
		}
		
		// ========================================
		// Protected constants
		// ========================================
		
		/**
		 * @private
		 * 
		 * Backing variable for <code>MONTH_NAMES</code>.
		 * 
		 * @see #MONTH_NAMES
		 */
		protected static var _MONTH_NAMES:Array = null;
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Comparator function for two Dates.
		 */
		public static function compare( a:*, b:*, dateFieldName:String = null ):int
		{
			var dateA:Date = getDate( a, dateFieldName );
			var dateB:Date = getDate( b, dateFieldName );
			
			return NumberUtil.compare( dateA.time, dateB.time );
		}
		
		/**
		 * Calculates the duration in milliseconds between two dates.
		 */
		public static function duration( start:*, end:*, dateFieldName:String = null ):Number
		{
			var startDate:Date = getDate( start, dateFieldName );
			var endDate:Date = getDate( end, dateFieldName );
			
			return ( endDate.getTime() - startDate.getTime() );
		}
		
		/**
		 * Returns the minimum (i.e. earlier) date of the two specified dates.
		 */
		public static function min( a:*, b:*, dateFieldName:String = null ):Date
		{
			var dateA:Date = getDate( a, dateFieldName );
			var dateB:Date = getDate( b, dateFieldName );
			
			return ( dateA.getTime() <= dateB.getTime() ) ? dateA : dateB;
		}
		
		/**
		 * Returns the maximum (i.e. later) date of the two specified dates.
		 */
		public static function max( a:*, b:*, dateFieldName:String = null ):Date
		{
			var dateA:Date = getDate( a, dateFieldName );
			var dateB:Date = getDate( b, dateFieldName );
			
			return ( dateA.getTime() >= dateB.getTime() ) ? dateA : dateB;
		}
		
		/**
		 * Calculate the DateRange (min and max) for the specified Date field for an iterable set of items (Array, ArrayCollection, Proxy, etc.).
		 */
		public static function range( items:*, dateFieldName:String = null, isSorted:Boolean = false ):DateRange
		{
			var minDate:Date = null;
			var maxDate:Date = null;

			if ( isSorted )
			{
				minDate = getDate( IterableUtil.getFirstItem( items ), dateFieldName );
				maxDate = getDate( IterableUtil.getLastItem( items ), dateFieldName );
			}
			else
			{
				for each ( var item:Object in items )
				{
					var date:Date = getDate( item, dateFieldName );
					
					if ( date != null )
					{
						minDate = ( minDate != null ) ? min( minDate, date ) : date;
						maxDate = ( maxDate != null ) ? max( maxDate, date ) : date;
					}
				}
			}
			
			return new DateRange( 
				( minDate != null ) ? minDate.time : null, 
				( maxDate != null ) ? maxDate.time : null 
			);
		}
		
		/**
		 * Returns the 'floor' for the specified date - i.e. rounded down relative to the specified time unit.
		 */
		public static function floor( date:Date, unit:Number ):Date
		{
			var result:Date = new Date( date.time );
			
			switch ( unit )
			{
				case YEAR:
					result.month = 0;
					result.date = 1;
					result.hours = 0;
					result.minutes = 0;
					result.seconds = 0;
					result.milliseconds = 0;
					break;
				
				case QUARTER:
					result.month = calculateStartingMonthForQuarter( calculateQuarterForMonth( result.month ) );
					result.date = 1;
					result.hours = 0;
					result.minutes = 0;
					result.seconds = 0;
					result.milliseconds = 0;
					break;
				
				case MONTH:
					result.date = 1;
					result.hours = 0;
					result.minutes = 0;
					result.seconds = 0;
					result.milliseconds = 0;
					break;
				
				case DAY:
					result.hours = 0;
					result.minutes = 0;	
					result.seconds = 0;
					result.milliseconds = 0;
					break;
				
				case HOUR:
					result.minutes = 0;
					result.seconds = 0;
					result.milliseconds = 0;
					break;
				
				case MINUTE:
					result.seconds = 0;
					result.milliseconds = 0;
					break;
				
				case SECOND:
					result.milliseconds = 0;
					break;
				
				default:
					throw new Error( "Unsupported unit specified." );
			}
			
			return result;
		}
		
		/**
		 * Returns the 'ceiling' for the specified date - i.e. rounded up relative to the specified time unit.
		 */
		public static function ceil( date:Date, unit:Number ):Date
		{
			var result:Date = floor( date, unit );
			
			// NOTE: This logic assumes Date's implementation properly handles overflow values.
			
			switch ( unit )
			{
				case YEAR:
					result.fullYear += 1;
					break;
				
				case QUARTER:
					result.month = calculateStartingMonthForQuarter( calculateQuarterForMonth( result.month ) + 1 );
					break;
				
				case MONTH:
					result.month += 1;
					break;
				
				case DAY:
					result.date += 1;
					break;
				
				case HOUR:
					result.hours += 1;
					break;
				
				case MINUTE:
					result.minutes += 1;
					break;
				
				case SECOND:
					result.seconds += 1;
					break;
				
				default:
					throw new Error( "Unsupported unit specified." );
			}
			
			return result;
		}
		
		/**
		 * Calculates the corresponding quarter for the specified month.
		 */
		public static function calculateQuarterForMonth( month:int ):int
		{
			return Math.ceil( ( month + 1 ) / 3 );
		}
		
		/**
		 * Calculates the corresponding starting month for the specified quarter.
		 */
		public static function calculateStartingMonthForQuarter( quarter:int ):int
		{
			return ( quarter - 1 ) * 3;
		}
		
		/**
		 * Returns the occurance of the day for the specified Date within the current month.
		 */
		public static function occurranceOfDayInMonth( date:Date ):int
		{
			var occurrance:int = 1;
			
			var previousWeek:Date = new Date( date.getTime() - WEEK );
			while ( previousWeek.month == date.month )
			{
				previousWeek.setTime( previousWeek.getTime() - WEEK );
				
				occurrance++;
			}
			
			return occurrance;
		}
		
		/**
		 * Returns a Boolean indicating whether the specified Date is the last occurance of the day within the current month.
		 */
		public static function isLastOccuranceOfDayInMonth( date:Date ):Boolean
		{
			var nextWeek:Date = new Date( date.getTime() + WEEK );
			
			return ( nextWeek.month != date.month );
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Get a Date for the specified item and value field name.
		 */
		protected static function getDate( item:Object, dateFieldName:String ):Date
		{
			if ( ( dateFieldName != null )  && ( item != null ) )
			{
				return PropertyUtil.getObjectPropertyValue( item, dateFieldName ) as Date;
			}
			else
			{
				return item as Date;
			}
			
			return null;
		}
	}
}