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

package com.codecatalyst.component.chart.element
{
	import com.codecatalyst.data.TimeInterval;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;

	[DefaultProperty("interval")]
	public class DateTimeGridLineSet extends EventDispatcher
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>interval</code> property.
		 * 
		 * @see #interval
		 */
		protected var _interval:TimeInterval = null;
		
		/**
		 * Backing variable for <code>maximumTimeSpan</code> property.
		 * 
		 * @see #maximumTimeSpan
		 */
		protected var _maximumTimeSpan:Number = NaN;
		
		/**
		 * Backing variable for <code>strokeFilterFunction</code> property. 
		 */
		protected var _strokeFilterFunction:Function = null;
		
		/**
		 * Backing variable for <code>fillFilterFunction</code> property. 
		 */
		protected var _fillFilterFunction:Function = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable("intervalChanged")]
		/**
		 * Time interval associated with this grid line set.
		 */
		public function get interval():TimeInterval
		{
			return _interval;
		}
		
		public function set interval( value:TimeInterval ):void
		{
			if ( _interval != value )
			{
				_interval = value;
				
				dispatchEvent( new Event( "intervalChanged" ) );
			}
		}
		
		[Bindable("maximumTimeSpanChanged")]
		/**
		 * Maximum time span threshold, in milliseconds.
		 */
		public function get maximumTimeSpan():Number			
		{
			return _maximumTimeSpan
		}
		
		public function set maximumTimeSpan( value:Number ):void
		{
			if ( _maximumTimeSpan != value )
			{
				_maximumTimeSpan = value;
				
				dispatchEvent( new Event( "maximumTimeSpanChanged" ) );
			}
		}
		
		[Bindable("strokeFilterFunctionChanged")]
		/**
		 * Stroke filter function (optional).
		 */
		public function get strokeFilterFunction():Function
		{
			return _strokeFilterFunction;
		}
		
		public function set strokeFilterFunction( value:Function ):void
		{
			if ( _strokeFilterFunction != value )
			{
				_strokeFilterFunction = value;
				
				dispatchEvent( new Event( "strokeFilterFunctionChanged" ) );
			}
		}
		
		[Bindable("fillFilterFunctionChanged")]
		/**
		 * Fill filter function (optional).
		 */
		public function get fillFilterFunction():Function
		{
			return _fillFilterFunction;
		}
		
		public function set fillFilterFunction( value:Function ):void
		{
			if ( _fillFilterFunction != value )
			{
				_fillFilterFunction = value;
				
				dispatchEvent( new Event( "fillFilterFunctionChanged" ) );
			}
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function DateTimeGridLineSet( interval:TimeInterval = null, maximumTimeSpan:Number = NaN, strokeFilterFunction:Function = null, fillFilterFunction:Function = null )
		{
			super();
			
			this.interval             = interval;
			this.maximumTimeSpan      = maximumTimeSpan;
			this.strokeFilterFunction = strokeFilterFunction;
			this.fillFilterFunction   = fillFilterFunction;
		}
	}
}