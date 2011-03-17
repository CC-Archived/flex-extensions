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
	import com.codecatalyst.util.DateUtil;
	
	public class SampleSet extends TemporalData
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>samplingInterval</code> property.
		 * 
		 * @see #samplingInterval
		 */
		protected var _samplingInterval:TimeInterval = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Time interval between samples in this sample set, in milliseconds.
		 */
		public function get samplingInterval():TimeInterval
		{
			return _samplingInterval;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function SampleSet( samples:Array, samplingInterval:TimeInterval, dateFieldName:String = "date", isSorted:Boolean = false )
		{
			super( samples, dateFieldName, isSorted );
			
			_samplingInterval = samplingInterval.clone();
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Create a new SampleSet containing the subset of samples available for the specified date range.
		 */
		override public function createSubset( targetDateRange:DateRange ):TemporalData
		{
			return new SampleSet( createDataSubset( targetDateRange ), samplingInterval, dateFieldName, true );
		}
	}
}