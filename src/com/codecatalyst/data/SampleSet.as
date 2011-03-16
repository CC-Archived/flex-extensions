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
		protected var _samplingInterval:TimeInterval = null;
		
		/**
		 * Backing variable for <code>sampleDateFieldName</code> property.
		 * 
		 * @see #sampleDateFieldName
		 */
		protected var _sampleDateFieldName:String = null;
		
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
		public function get samplingInterval():TimeInterval
		{
			return _samplingInterval;
		}
		
		/**
		 * Sample date field name.
		 * 
		 * @default "date"
		 */
		public function get sampleDateFieldName():String
		{
			return _sampleDateFieldName;
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
		public function SampleSet( samples:Array, samplingInterval:TimeInterval, sampleDateFieldName:String = "date" )
		{
			super();
			
			_samples             = ArrayUtil.clone( samples );
			_samplingInterval    = samplingInterval.clone();
			_sampleDateFieldName = sampleDateFieldName;
			_sampleDateRange     = DateUtil.range( samples, sampleDateFieldName );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Create a new SampleSet containing the subset of samples available for the specified date range.
		 */
		public function createSubset( targetDateRange:DateRange ):SampleSet
		{
			if ( sampleDateRange.intersects( targetDateRange ) )
			{
				var dateProperty:Property = new Property( sampleDateFieldName );
				
				var date:Date = new Date();
				
				var subsetSamples:Array = 
					samples.filter( function ( sample:Object, index:int, array:Array ):Boolean {
						var value:* = dateProperty.getValue( sample );
						
						if ( value is Date )
							date.time = value.time;
						else if ( value is Number )
							date.time = value;
						else
							date.time = Date.parse( value );
							
						return targetDateRange.contains( date.time );
					});
				
				return new SampleSet( subsetSamples, samplingInterval, sampleDateFieldName );
			}
			
			return new SampleSet( [], samplingInterval, sampleDateFieldName );
		}
	}
}