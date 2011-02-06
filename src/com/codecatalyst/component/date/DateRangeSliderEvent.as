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

package com.codecatalyst.component.date
{
	import com.codecatalyst.data.DateRange;
	
	import flash.events.Event;
	
	public class DateRangeSliderEvent extends Event
	{
		// ========================================
		// Public constants
		// ========================================
		
		/**
		 * Notifies listeners that the DateRange was panned.
		 * 
		 * @see #dateRange
		 * @see #index
		 * @see #complete
		 */
		public static const DATE_RANGE_PANNED:String = "dateRangePanned";
		
		/**
		 * Notifies listeners that the DateRange was resized.
		 * 
		 * @see #dateRange
		 * @see #index
		 * @see #complete
		 */
		public static const DATE_RANGE_RESIZED:String = "dateRangeResized";
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * DateRange.
		 */
		public var dateRange:DateRange = null;

		/**
		 * DateRange index.
		 */
		public var index:int = 0;
		
		/**
		 * Indicates whether the user interaction is 'complete'.
		 */
		public var complete:Boolean = false;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function DateRangeSliderEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Duplicates an instance of the event to support re-dispatching.
		 */
		override public function clone():Event
		{
			var event:DateRangeSliderEvent = new DateRangeSliderEvent( type, bubbles, cancelable );
			
			event.dateRange = dateRange;
			event.index = index;
			event.complete = complete;
			
			return event;
		}		
	}
}