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
	import com.codecatalyst.data.FrequencyBin;
	import com.codecatalyst.data.NumericRange;
	
	import flash.utils.Dictionary;
	
	public class StatisticUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		[ArrayElementType("com.codecatalyst.data.FrequencyBin")]
		/**
		 * Given a set of items (and optional value field) and NumericRange(s), returns a frequency distribution as an Array of Bins.
		 */
		public static function frequency( items:*, valueFieldName:String = null, valueRanges:Array = null ):Array
		{
			if ( valueRanges == null )
				valueRanges = range( items, valueFieldName ).partition();
			
			var valueFrequencyByValueRange:Dictionary = calculateValueFrequencyByValueRanges( items, valueFieldName, valueRanges );
			
			var bins:Array = new Array();
			
			for each ( var valueRange:NumericRange in valueRanges )
			{
				bins.push( new FrequencyBin( valueRange, valueFrequencyByValueRange[ valueRange ] ) );
			}
			
			return bins;
		}
		
		/**
		 * Calculates the mean for the specified value field for an iterable set of items (Array, ArrayCollection, Proxy, etc.).
		 */
		public static function mean( items:*, valueFieldName:String = null ):Number
		{
			return ( sum( items, valueFieldName ) / items.length );
		}
		
		/**
		 * Calculate the range (min and max) for the specified value field for an iterable set of items (Array, ArrayCollection, Proxy, etc.).
		 */
		public static function range( items:*, valueFieldName:String = null ):NumericRange
		{
			var minValue:Number = Number.NaN;
			var maxValue:Number = Number.NaN;
			
			for each ( var item:Object in items )
			{
				var value:Number = getValue( item, valueFieldName );
				
				if ( !isNaN( value ) )
				{
					minValue = ( !isNaN( minValue ) ) ? Math.min( minValue, value ) : value;
					maxValue = ( !isNaN( maxValue ) ) ? Math.max( maxValue, value ) : value;
				}
			}
			
			return new NumericRange( minValue, maxValue );
		}
		
		/**
		 * Calculates the standard deviation for the specified value field for an iterable set of items (Array, ArrayCollection, Proxy, etc.).
		 */
		public static function standardDeviation( items:*, valueFieldName:String = null ):Number
		{
			return Math.sqrt( variance( items, valueFieldName ) );
		}
		
		/**
		 * Calculate the sum for the specified value field for an iterable set of items (Array, ArrayCollection, Proxy, etc.).
		 */
		public static function sum( items:*, valueFieldName:String = null ):Number
		{
			var sum:Number = 0;
			
			for each ( var item:Object in items )
			{
				var value:Number = getValue( item, valueFieldName );
				
				sum += value;
			}
			
			return sum;
		}
		
		/**
		 * Calculates the variance for the specified value field for an iterable set of items (Array, ArrayCollection, Proxy, etc.).
		 */
		public static function variance( items:*, valueFieldName:String = null ):Number
		{
			var meanValue:Number = mean( items, valueFieldName );
			
			var sumOfSquaredDifferences:Number = 0;
			for each ( var item:Object in items )
			{
				var value:Number = getValue( item, valueFieldName );
				
				var difference:Number = value - meanValue;
				
				sumOfSquaredDifferences += ( difference * difference );
			}
			
			return sumOfSquaredDifferences / items.length;
		}
		
		// ========================================
		// Protected methods
		// ========================================	
				
		/**
		 * Calculates the value frequency distribution for the specified value field in the specified items among the specified value ranges.
		 */
		protected static function calculateValueFrequencyByValueRanges( items:*, valueFieldName:String, valueRanges:Array ):Dictionary
		{
			var valueFrequencyByValueRange:Dictionary = new Dictionary();
			
			for each ( var item:Object in items )
			{
				var value:Number = getValue( item, valueFieldName );
				
				for each ( var valueRange:NumericRange in valueRanges )
				{
					if ( valueRange.contains( value ) )
					{
						valueFrequencyByValueRange[ valueRange ] ||= 0;
						valueFrequencyByValueRange[ valueRange ] += 1;
					}
				}
			}
			
			return valueFrequencyByValueRange;
		}
		
		/**
		 * Get a Number value for the specified item and value field name.
		 */
		protected static function getValue( item:Object, valueFieldName:String ):Number
		{
			if ( valueFieldName != null )
			{
				if ( item is XML )
					return Number( ( item as XML ).attribute( valueFieldName ) );
				
				return Number( PropertyUtil.getObjectPropertyValue( item, valueFieldName ) );
			}
			else
			{
				return Number( item );
			}
			
			return Number.NaN;
		}
	}
}