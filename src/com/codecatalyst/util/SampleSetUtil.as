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

package com.codecatalyst.util
{
	import com.codecatalyst.data.DateRange;
	import com.codecatalyst.data.SampleSet;
	import com.codecatalyst.data.TemporalData;

	public class SampleSetUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Collates an Array of SampleSet(s) with potentially differing sampling interval(s) into a new TemporalData instance containing the best available samples (i.e. lowest sampling interval).
		 */
		public static function collate( sampleSets:Array ):TemporalData
		{
			// Collate the sorted sample sets.
			
			var collatedSamples:Array = new Array();
			var collatedSampleDateRange:DateRange = unionSampleSetDateRanges( sampleSets );
			
			var remainingDateRange:DateRange = collatedSampleDateRange.clone();
			while ( remainingDateRange.startTime < collatedSampleDateRange.endTime )
			{
				// Get the current sample set.
				
				var currentSampleSet:SampleSet = getNextSampleSet( sampleSets, remainingDateRange, currentSampleSet );
				if ( currentSampleSet == null )
					break;
				
				// Get the next sample set.
				
				var nextSampleSet:SampleSet = getNextSampleSet( sampleSets, remainingDateRange, currentSampleSet );
				
				// Calculate the relevant date range, based on the remaining date range and current and next sample set date ranges.
				
				var relevantEndTime:Number = currentSampleSet.sampleDateRange.endTime;
				if ( ( nextSampleSet != null ) && ( nextSampleSet.samplingInterval <= currentSampleSet.samplingInterval ) )
					relevantEndTime = Math.min( relevantEndTime, nextSampleSet.sampleDateRange.startTime - 1 );
				
				var relevantSampleDateRange:DateRange = new DateRange( remainingDateRange.startTime, relevantEndTime );
				
				// Concatenate the subset of samples from the current sample set for relevant date range.
				
				collatedSamples = collatedSamples.concat( currentSampleSet.createSubset( relevantSampleDateRange ).samples );
				
				// Update remaining date range.
				
				remainingDateRange.startTime = relevantSampleDateRange.endTime + 1;
			}		
			
			// Create and return a new TemporalData instance populated with the collated sample data.
			
			return new TemporalData( collatedSamples, collatedSampleDateRange );
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Union the sample DateRange(s) for the specified SampleSet(s).
		 */
		protected static function unionSampleSetDateRanges( sampleSets:Array ):DateRange
		{
			var result:DateRange = null;
			
			for each ( var sampleSet:SampleSet in sampleSets )
			{
				if ( result == null )
				{
					result = sampleSet.sampleDateRange.clone();
				}
				else
				{
					result.startTime = Math.min( result.startTime, sampleSet.sampleDateRange.startTime );
					result.endTime   = Math.max( result.endTime,   sampleSet.sampleDateRange.endTime );
				}	
			}
			
			return result;
		}
		
		/**
		 * Get the next lowest interval sample set given an Array of SampleSets, a date range constraint and the current sample set (if applicable).
		 */
		protected static function getNextSampleSet( sampleSets:Array, dateRange:DateRange, currentSampleSet:SampleSet ):SampleSet
		{
			// Filter the sample sets down to those that intersect the specified date range constraint (excluding the current sample set).
			
			var constrainedSampleSets:Array = 
				sampleSets.filter(
					function ( sampleSet:SampleSet, index:int, array:Array ):Boolean
					{
						if ( sampleSet != currentSampleSet )
							return sampleSet.sampleDateRange.intersects( dateRange );
						
						return false;
					}
				);
			
			// Sort the date range constrained sample sets by start time and sampling interval (lowest to highest).
			
			constrainedSampleSets.sort(
				function ( a:SampleSet, b:SampleSet ):int
				{
					var startTimeComparison:int = NumberUtil.compare( a.sampleDateRange.startTime, b.sampleDateRange.startTime );
					
					if ( startTimeComparison == 0 )
						return NumberUtil.compare( a.samplingInterval, b.samplingInterval );
					
					return startTimeComparison;
				}
			);
			
			// Initial case - no current sample set - return the first sample set among the sorted date range constrained sample sets.
			
			if ( currentSampleSet == null )
				return ( constrainedSampleSets.length > 0 ) ? constrainedSampleSets[ 0 ] as SampleSet : null;
			
			// Otherwise, find the next sample set among the sorted date range constrained sample sets, if applicable.
			
			if ( constrainedSampleSets.length > 1 )
			{
				// If available, return the first occurring, lowest interval sample set among the the sorted date range constrained sample sets that intersects the current sample set and has a lower sampling interval than the current sample set.
				
					// 1. Filter the sorted date range constrained sample sets down to those that intersect the current sample set's date range and have a lower sampling interval.
					
					var intersectingLowerSamplingIntervalConstrainedSampleSets:Array = 
						constrainedSampleSets.filter(
							function ( sampleSet:SampleSet, index:int, array:Array ):Boolean
							{
								if ( sampleSet != currentSampleSet )
									return ( sampleSet.sampleDateRange.intersects( currentSampleSet.sampleDateRange ) && ( sampleSet.samplingInterval < currentSampleSet.samplingInterval ) );
								
								return false;
							}
						);
					
					// 2. Sort the intersecting lower sampling interval date range constrained sample sets by start time and sampling interval (lowest to highest).
					
					intersectingLowerSamplingIntervalConstrainedSampleSets.sort(
						function ( a:SampleSet, b:SampleSet ):int
						{
							var startTimeComparison:int = NumberUtil.compare( a.sampleDateRange.startTime, b.sampleDateRange.startTime );
							
							if ( startTimeComparison == 0 )
								return NumberUtil.compare( a.samplingInterval, b.samplingInterval );
							
							return startTimeComparison;
						}
					);
					
					// 3. Return the first occurring, lowest sampling interval sample set among the sorted intersecting lower sampling interval date range constrained sample sets, if applicable.
					
					if ( intersectingLowerSamplingIntervalConstrainedSampleSets.length > 0 )
						return intersectingLowerSamplingIntervalConstrainedSampleSets[ 0 ] as SampleSet;

				// If available, return the first occurring, lowest sampling interval sample set among the sorted date range constrained sample sets that follows or extend past the current sample set.
				
					// 1. Filter the sorted date range constrained sample sets down to those that follow after or extend past the current sample set's date range.
					
					var followingConstrainedSampleSets:Array = 
						constrainedSampleSets.filter(
							function ( sampleSet:SampleSet, index:int, array:Array ):Boolean
							{
								if ( sampleSet != currentSampleSet )
									return ( sampleSet.sampleDateRange.endTime > currentSampleSet.sampleDateRange.endTime );
								
								return false;
							}
						);
					
					// 2. Sort the following date range constrained sample sets by start time (relative to the current sample set's end time) and sampling interval (lowest to highest).
					
					followingConstrainedSampleSets.sort(
						function ( a:SampleSet, b:SampleSet ):int
						{
							var startTimeComparison:int = 
							NumberUtil.compare( 
								Math.max( a.sampleDateRange.startTime, currentSampleSet.sampleDateRange.endTime ),
								Math.max( b.sampleDateRange.startTime, currentSampleSet.sampleDateRange.endTime )
							);
							
							if ( startTimeComparison == 0 )
								return NumberUtil.compare( a.samplingInterval, b.samplingInterval );
							
							return startTimeComparison;
						}
					);
					
					// 3. Return the first occurring (relative to the current sample set's end time), lowest sampling interval sample set among the sorted following date range constrained sample sets, if applicable.
					
					if ( followingConstrainedSampleSets.length > 0 )
						return followingConstrainedSampleSets[ 0 ] as SampleSet;
			}
			
			return null;
		}
	}
}