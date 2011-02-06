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
	import com.codecatalyst.util.ArrayUtil;

	public class TemporalData
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>data</code> property.
		 * 
		 * @see #data
		 */
		protected var _data:Array = null;
		
		/**
		 * Backing variable for <code>dateRange</code> property.
		 * 
		 * @see #dateRange
		 */
		protected var _dateRange:DateRange = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable("dataChanged")]
		/**
		 * Data.
		 */
		public function get data():Array
		{
			return data;
		}
		
		[Bindable("dateRangeChanged")]
		/**
		 * Date range for data.
		 */
		public function get dateRange():DateRange
		{
			return _dateRange;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function TemporalData( data:Array, dateRange:DateRange )
		{
			super();
			
			_data      = ArrayUtil.clone( data );
			_dateRange = dateRange.clone();
		}
	}
}