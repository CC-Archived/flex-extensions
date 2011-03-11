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
	public class FrequencyBin
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>range</code> property.
		 * 
		 * @see #range
		 */
		protected var _range:NumericRange;
		
		/**
		 * Backing variable for <code>frequency</code> property.
		 * 
		 * @see #frequency
		 */
		protected var _frequency:Number;
		
		/**
		 * Backing variable for <code>percentage</code> property.
		 * 
		 * @see #percentage
		 */
		protected var _percentage:Number;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable("maximumChanged")]
		/**
		 * Sample range.
		 */
		public function get range():NumericRange
		{
			return _range;
		}
		
		[Bindable("frequencyChanged")]
		/**
		 * Sample frequency for <code>range</code>.
		 */
		public function get frequency():Number
		{
			return _frequency;
		}
		
		/**
		 * Sample frequency percentage.
		 */
		public function get percentage():Number
		{
			return _percentage;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function FrequencyBin( range:NumericRange, frequency:Number, percentage:Number )
		{
			super();
			
			_range = range;
			_frequency = frequency;
			_percentage = percentage;
		}
	}
}