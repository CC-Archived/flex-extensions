////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010 CodeCatalyst, LLC - http://www.codecatalyst.com/
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
	import flash.geom.Rectangle;
	
	public class ChartZoomEvent extends Event
	{
		// ========================================
		// Public constants
		// ========================================
		
		/**
		 * Zoom in.
		 * 
		 * @see #point
		 */
		public static const ZOOM_IN:String = "zoomIn";
		
		/**
		 * Zoom out.
		 * 
		 * @see #point
		 */
		public static const ZOOM_OUT:String = "zoomOut";
		
		/**
		 * Zoom to a rectangle.
		 * 
		 * @see #rectangle
		 */
		public static const ZOOM_TO_RECTANGLE:String = "zoomToRectangle";
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Zoom origin point.
		 */
		public var origin:Point = null;
		
		/**
		 * Zoom rectangle.
		 */
		public var rectangle:Rectangle = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ChartZoomEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false )
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
			var event:ChartZoomEvent = new ChartZoomEvent( type, bubbles, cancelable );
			
			event.origin = origin;
			event.rectangle = rectangle;
			
			return event;
		}		
	}
}