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
	import com.codecatalyst.util.DictionaryUtil;
	import com.codecatalyst.util.PropertyUtil;
	
	import flash.utils.Dictionary;

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
		 * Backing variable for <code>dateFieldName</code> property.
		 * 
		 * @see #dateFieldName
		 */
		protected var _dateFieldName:String = null;
		
		/**
		 * Backing variable for <code>dateRange</code> property.
		 * 
		 * @see #dateRange
		 */
		protected var _dateRange:DateRange = null;
		
		/**
		 * Lazily instantiated Dictionary of <code>data</code> items, keyed by <code>data</code> item <code>dateFieldName</code> Date time values.
		 */
		protected var dataItemsByDateTime:Dictionary = null;
		
		/**
		 * Lazily instantiated Dictionary of <code>data</code> item <code>dateFieldName</code> Date time values, keyed by <code>data</code> item.
		 */
		protected var dateTimesByDataItem:Dictionary = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable("dataChanged")]
		/**
		 * Data.
		 */
		public function get data():Array
		{
			return _data;
		}
		
		[Bindable("dateFieldNameChanged")]
		/**
		 * Date field name.
		 * 
		 * @default "date"
		 */
		public function get dateFieldName():String
		{
			return _dateFieldName;
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
		public function TemporalData( data:Array, dateFieldName:String = "date", isSorted:Boolean = false )
		{
			super();
			
			_data = ArrayUtil.clone( data );
			_dateFieldName = dateFieldName;
			
			// Sort, if necessary.
			
			if ( !isSorted )
			{
				_data.sort( function ( sampleA:Object, sampleB:Object ):* {
					return DateUtil.compare( sampleA, sampleB, dateFieldName );
				});
			}
			
			// Calculate the date range.
			
			_dateRange = DateUtil.range( data, dateFieldName, true );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Create a new TemporalData containing the subset of data available for the specified date range.
		 */
		public function createSubset( targetDateRange:DateRange ):TemporalData
		{
			return new TemporalData( createDataSubset( targetDateRange ), dateFieldName, true );
		}
		
		/**
		 * Get the data items that occurs on the specified Date, or null if unavailable.
		 */
		public function getDataItemsByDate( date:Date ):Array
		{
			if ( dateRange.contains( date.time ) )
			{
				return lookupDataItemsByDateTime( date.time );
			}
			
			return [];
		}
		
		/**
		 * Get the data item(s) that occur nearest to the specified Date.
		 */
		public function getNearestDataItemsByDate( date:Date ):Array
		{
			// TODO: Since the data is sorted, refactor as a 'divide and conquer' style algorithm and reuse in a refactored createDataSubset() implementation.
			
			if ( dateRange.contains( date.time ) )
			{
				var exactMatches:Array = getDataItemsByDate( date );
				if ( exactMatches != null )
					return exactMatches;
				
				var closestDataItems:Array = [];
				var closestDataItemDateTimeOffset:* = null;
				
				data.forEach( function ( item:Object, index:int, array:Array ):void {
					var dataItemDateTime:Number = lookupDateTimeByDataItem( item );
					var dataItemDateTimeOffset:Number = date.time - dataItemDateTime;
					
					if ( closestDataItemDateTimeOffset != null )
					{
						if ( Math.abs( dataItemDateTimeOffset ) < Math.abs( closestDataItemDateTimeOffset ) )
						{
							closestDataItems = new Array();
							closestDataItems.push( item );
							
							closestDataItemDateTimeOffset = dataItemDateTimeOffset;
						}
						else if ( dataItemDateTimeOffset == closestDataItemDateTimeOffset )
						{
							closestDataItems.push( item );
						}
					}
					else
					{
						closestDataItems = new Array();
						closestDataItems.push( item );
						
						closestDataItemDateTimeOffset = dataItemDateTimeOffset;
					}
				});
				
				return closestDataItems;
			}
			
			return [];
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Create an Array containing the subset of data available for the specified date range.
		 */
		protected function createDataSubset( targetDateRange:DateRange ):Array
		{
			if ( dateRange.intersects( targetDateRange ) )
			{
				var subset:Array = 
					data.filter( function ( item:Object, index:int, array:Array ):Boolean {
						return targetDateRange.contains( lookupDateTimeByDataItem( item ) );
					});
				
				return subset;
			}
			
			return [];			
		}
		
		/**
		 * Uses a Dictionary index to return the Date time for the specified data item.
		 */
		protected function lookupDateTimeByDataItem( item:Object ):Number
		{		
			// Index lazily.
			
			if ( dateTimesByDataItem == null )
				indexData();
			
			return dateTimesByDataItem[ item ];
		}
		
		/**
		 * Uses a Dictionary index to return the corresponding data items for the specified Date time.
		 */
		protected function lookupDataItemsByDateTime( dateTime:Number ):Array
		{
			// Index lazily.
			
			if ( dataItemsByDateTime == null )
				indexData();
			
			return dataItemsByDateTime[ dateTime ];
		}
		
		/**
		 * Creates a fast lookup table of data items by date item Date time, and data item Date times by data item.
		 */
		protected function indexData():void
		{
			dataItemsByDateTime = new Dictionary();
			dateTimesByDataItem = new Dictionary();
			
			_data.forEach( function ( item:Object, index:int, array:Array ):void {
				var itemDateTime:Number = getDateTimeForDataItem( item )
				
				dataItemsByDateTime[ itemDateTime ] ||= new Array();
				dataItemsByDateTime[ itemDateTime ].push( item );
				
				dateTimesByDataItem[ item ] = itemDateTime;
			});
		}
		
		/**
		 * @private
		 * 
		 * Temporary Date instance - used to eliminate unnecessary Date instantiation during Date related calculations.
		 */
		protected static var _temporaryDate:Date = new Date();
		
		/**
		 * Get the Date time for the specified sample.
		 */
		protected function getDateTimeForDataItem( sample:Object ):Number
		{
			var value:* = PropertyUtil.getObjectPropertyValue( sample, dateFieldName );
			
			if ( value is Date )
				_temporaryDate.time = value.time;
			else if ( value is Number )
				_temporaryDate.time = value;
			else
				_temporaryDate.time = Date.parse( value );
			
			return _temporaryDate.time;
		}
	}
}