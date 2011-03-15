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

package com.codecatalyst.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	public class NumericRange extends EventDispatcher
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>minimum</code property.
		 * 
		 * @see #minimum
		 */
		protected var _minimum:Number = NaN;
		
		/**
		 * Backing variable for <code>maximum</code> property.
		 * 
		 * @see #maximum
		 */
		protected var _maximum:Number = NaN;
		
		// ========================================
		// Public properties
		// ========================================

		[Bindable("minimumChanged")]
		/**
		 * The minimum value for this numeric range.
		 */
		public function get minimum():Number
		{
			return _minimum;
		}
		
		public function set minimum( value:Number ):void
		{
			if ( _minimum != value )
			{
				_minimum = value;
				
				dispatchEvent( new Event( "minimumChanged" ) );
			}
		}
		
		[Bindable("maximumChanged")]
		/**
		 * The maximum value for this numeric range.
		 */
		public function get maximum():Number
		{
			return _maximum;
		}
		
		public function set maximum( value:Number ):void
		{
			if ( _maximum != value )
			{
				_maximum = value;
				
				dispatchEvent( new Event( "maximumChanged" ) );
			}
		}
		
		[Bindable("minimumChanged")]
		[Bindable("maximumChanged")]
		/**
		 * The range between the minimum value and maximum value for this numeric range.
		 */
		public function get range():Number
		{
			return maximum - minimum;
		}

		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function NumericRange( minimum:Number = NaN, maximum:Number = NaN )
		{
			super();
			
			_minimum = minimum;
			_maximum = maximum;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Returns a Boolean indicating whether the specified value falls within this NumericRange.
		 */
		public function contains( value:Number ):Boolean
		{
			return ( ( value >= minimum ) && ( value <= maximum ) );
		}
		
		[ArrayElementType("com.codecatalyst.data.NumericRange")]
		/**
		 * Partitions this NumericRange equally into the specified count of NumericRange(s).
		 */
		public function partition( count:int = -1 ):Array
		{
			var numericRanges:Array = new Array();
			
			if ( count < 0 )
				count = Math.sqrt( range );
			
			var partitionSize:Number = range / count;
			
			for ( var partitionIndex:int = 0; partitionIndex < count; partitionIndex++ )
			{
				var numericRange:NumericRange = new NumericRange( ( partitionIndex * partitionSize ) + minimum, ( ( partitionIndex + 1 ) * partitionSize ) + minimum );
				
				numericRanges.push( numericRange );
			}
			
			return numericRanges;
		}
	}
}