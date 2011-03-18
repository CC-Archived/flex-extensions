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

package com.codecatalyst.component.chart.control
{
	import flash.events.Event;
	import flash.geom.Point;
	
	public class ChartHoverEvent extends Event
	{
		// ========================================
		// Public constants
		// ========================================
		
		/**
		 * Hover.
		 * 
		 * @see #x
		 * @see #y
		 */
		public static const HOVER:String = "hover";
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * X value.
		 */
		public var x:*;
		
		/**
		 * Y value.
		 */
		public var y:*;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ChartHoverEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
		{
			super( type, bubbles, cancelable );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Duplicates an instance of the event to support re-dispatching.
		 */
		override public function clone():Event
		{
			var event:ChartHoverEvent = new ChartHoverEvent( type, bubbles, cancelable );
			
			event.x = x;
			event.y = y;
			
			return event;
		}		
	}
}