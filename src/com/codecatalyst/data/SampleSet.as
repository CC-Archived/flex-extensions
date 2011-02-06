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
	
	import flash.sampler.Sample;

	public class SampleSet
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>samples</code> property.
		 * 
		 * @see #samples
		 */
		protected var _samples:Array = null;
		
		/**
		 * Backing variable for <code>samplingInterval</code> property.
		 * 
		 * @see #samplingInterval
		 */
		protected var _samplingInterval:Number = NaN;
		
		/**
		 * Backing variable for <code>sampleDateRange</code> property.
		 * 
		 * @see #sampleDateRange
		 */
		protected var _sampleDateRange:DateRange = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		[ArrayElementType("Object")]
		/**
		 * Samples.
		 */
		public function get samples():Array
		{
			return _samples;
		}
		
		/**
		 * Time interval between samples in this sample set, in milliseconds.
		 */
		public function get samplingInterval():Number
		{
			return _samplingInterval;
		}
		
		/**
		 * Date range of the samples in this sample set.
		 */
		public function get sampleDateRange():DateRange
		{
			return _sampleDateRange;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function SampleSet( samples:Array, samplingInterval:Number, startTime:Number )
		{
			super();
			
			_samples          = ArrayUtil.clone( samples );
			_samplingInterval = samplingInterval;
			_sampleDateRange  = new DateRange( startTime, startTime + ( samples.length - 1 * samplingInterval ) );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Create a new SampleSet containing the subset of samples available for the specified date range.
		 */
		public function createSubset( dateRange:DateRange ):SampleSet
		{
			if ( sampleDateRange.intersects( dateRange ) )
			{
				var boundedDateRange:DateRange = createBoundedAndAlignedDateRange( dateRange );
				
				var startIndex:int = calculateBoundedIndexForTime( boundedDateRange.startTime );
				var endIndex:int   = calculateBoundedIndexForTime( boundedDateRange.endTime );
				
				if ( endIndex - startIndex >= 0 )
					return new SampleSet( samples.slice( startIndex, endIndex + 1 ), samplingInterval, boundedDateRange.startTime );
				else
					return null;
			}
			
			return null;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Creates a new DateRange based on the specified DateRange and bound and aligned to this SampleSet's DateRange and sampling interval.
		 */
		protected function createBoundedAndAlignedDateRange( dateRange:DateRange ):DateRange
		{
			var boundedTargetDateRange:DateRange = sampleDateRange.createBoundedDateRange( dateRange );
			
			boundedTargetDateRange.startTime = Math.ceil(  boundedTargetDateRange.startTime / samplingInterval ) * samplingInterval;
			boundedTargetDateRange.endTime   = Math.floor( boundedTargetDateRange.endTime   / samplingInterval ) * samplingInterval;

			return boundedTargetDateRange;
		}

		/**
		 * Caculuates a bounded sample Array index for the specified time.
		 */		
		protected function calculateBoundedIndexForTime( time:Number ):int
		{
			var calculatedIndex:int = Math.floor( ( time - sampleDateRange.startTime ) / samplingInterval );
			
			return Math.min( Math.max( calculatedIndex, 0 ), samples.length - 1 );
		}
	}
}