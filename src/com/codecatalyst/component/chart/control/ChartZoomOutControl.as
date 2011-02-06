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
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	/**
	 * Dispatched when the user clicks to zoom out from a chart coordinate.
	 */
	[Event(name="zoomOut", type="com.codecatalyst.component.chart.control.ChartZoomEvent")]
	
	public class ChartZoomOutControl extends AbstractChartControl
	{
		// ========================================
		// Protected constants
		// ========================================
		
		[Embed(source="/asset/image/cursor/zoom-out.png")]
		/**
		 * Default 'Zoom Out' cursor.
		 */
		protected static const DEFAULT_ZOOM_OUT_CURSOR:Class;
		
		/**
		 * Default 'Zoom Out' cursor offset.
		 */
		protected static const DEFAULT_ZOOM_OUT_CURSOR_OFFSET:Point = new Point( -11, -11 );
		
		// ========================================
		// Static initializers
		// ========================================
		
		/**
		 * Static initializer for default CSS styles.
		 */
		protected static var stylesInitialized:Boolean = initializeStyles();
		
		protected static function initializeStyles():Boolean
		{
			var declaration:CSSStyleDeclaration = StyleManager.getStyleDeclaration( "ChartZoomOutControl" ) || new CSSStyleDeclaration();
			
			declaration.defaultFactory = 
				function ():void
				{
					this.mouseDownCursor 		= DEFAULT_ZOOM_OUT_CURSOR;
					this.mouseDownCursorOffset 	= DEFAULT_ZOOM_OUT_CURSOR_OFFSET;
					this.rollOverCursor  		= DEFAULT_ZOOM_OUT_CURSOR;
					this.rollOverCursorOffset 	= DEFAULT_ZOOM_OUT_CURSOR_OFFSET;
				};
			
			StyleManager.setStyleDeclaration( "ChartZoomOutControl", declaration, false );
			
			return true;
		}
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Indicates whether this control is currently performing a zoom operation.
		 */
		protected var isZooming:Boolean = false;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ChartZoomOutControl()
		{
			super();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Handle MouseEvent.MOUSE_DOWN.
		 */
		override protected function mouseDownHandler( event:MouseEvent ):void
		{
			super.mouseDownHandler( event );
			
			if ( enabled )
			{
				// Zoom operation initiated
				
				isZooming = true;
			}
		}
		
		/**
		 * Handle MouseEvent.MOUSE_UP.
		 */
		override protected function mouseUpHandler( event:MouseEvent ):void
		{
			super.mouseUpHandler( event );
			
			// Calculate zoom origin coordinate (in component coordinates)
			
			var zoomOrigin:Point = new Point( this.mouseX, this.mouseY );
			
			// Zoom to the calculated origin coordinate
			
			zoomOut( zoomOrigin );
			
			// Zoom operation completed
			
			isZooming = false;
		}
		
		/**
		 * Zoom out relative to the specified origin coordinate (in component coordinate space).
		 */
		protected function zoomOut( origin:Point ):void
		{
			// Convert component coordinates to chart data coordinates
			
			var dataForOrigin:Array = localToData( origin );
			var chartOrigin:Point = new Point( dataForOrigin[ 0 ], dataForOrigin[ 1 ] );
			
			// Create, populate and dispatch a ChartZoomEvent.ZOOM_OUT event
			
			var chartZoomEvent:ChartZoomEvent = new ChartZoomEvent( ChartZoomEvent.ZOOM_OUT );
			
			chartZoomEvent.origin = chartOrigin;
			
			dispatchEvent( chartZoomEvent );			
		}
	}
}