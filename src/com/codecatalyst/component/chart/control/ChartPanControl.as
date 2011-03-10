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
	import com.codecatalyst.util.StyleUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	/**
	 * Dispatched when the user clicks and drags to pan by a chart coordinate offset.
	 */
	[Event(name="pan", type="com.codecatalyst.component.chart.control.ChartPanEvent")]
	
	public class ChartPanControl extends AbstractChartControl
	{
		// ========================================
		// Protected constants
		// ========================================
		
		[Embed(source="/asset/image/cursor/grab.png")]
		/**
		 * Default 'Pan' cursor.
		 */
		protected static const DEFAULT_PAN_CURSOR:Class;
		
		/**
		 * Default 'Pan' cursor offset.
		 */
		protected static const DEFAULT_PAN_CURSOR_OFFSET:Point = new Point( -11, -11 );
		
		[Embed(source="/asset/image/cursor/grabbing.png")]
		/**
		 * Default 'Panning' cursor.
		 */
		protected static const DEFAULT_PANNING_CURSOR:Class;
		
		/**
		 * Default 'Panning' cursor offset.
		 */
		protected static const DEFAULT_PANNING_CURSOR_OFFSET:Point = new Point( -11, -11 );
		
		// ========================================
		// Static initializers
		// ========================================
		
		/**
		 * Static initializer for default CSS styles.
		 */
		protected static var stylesInitialized:Boolean = initializeStyles();
		
		protected static function initializeStyles():Boolean
		{
			var declaration:CSSStyleDeclaration = StyleUtil.getStyleDeclaration( "ChartPanControl" );
			
			declaration.defaultFactory = 
				function ():void
				{
					this.mouseDownCursor        = DEFAULT_PANNING_CURSOR;
					this.mouseDownCursorOffset  = DEFAULT_PANNING_CURSOR_OFFSET;
					this.rollOverCursor         = DEFAULT_PAN_CURSOR;
					this.rollOverCursorOffset   = DEFAULT_PAN_CURSOR_OFFSET;
				};
			
			StyleUtil.setStyleDeclaration( "ChartPanControl", declaration, false );
			
			return true;
		}
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Indicates whether this control is currently performing a drag operation.
		 */
		protected var isDragging:Boolean = false;
		
		/**
		 * Previous drag coordinate.
		 */
		protected var dragPrevious:Point = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ChartPanControl()
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
				// Drag operation initiated
				
				isDragging = true;
				
				// Store the current coordinate for the first delta calculation
				
				dragPrevious = new Point( mouseX, mouseY );
			}
		}
		
		/**
		 * Handle MouseEvent.MOUSE_MOVE.
		 */
		override protected function mouseMoveHandler( event:MouseEvent ):void
		{
			super.mouseMoveHandler( event );
			
			var dragCurrent:Point = new Point( mouseX, mouseY );
			
			// Pan relative to previous and current coordinates
			
			pan( dragPrevious, dragCurrent );
			
			// Store the current coordinate for the next delta calculation
			
			dragPrevious = dragCurrent;
		}
		
		/**
		 * Handle MouseEvent.MOUSE_UP.
		 */
		override protected function mouseUpHandler( event:MouseEvent ):void
		{
			super.mouseUpHandler( event );
			
			var dragCurrent:Point = new Point( mouseX, mouseY );
			
			// Pan relative to previous and current coordinates
			
			pan( dragPrevious, dragCurrent, true );
			
			// Drag operation completed
			
			isDragging = false;
		}
		
		/**
		 * Pan relative to the specified starting and ending coordinates (in component coordinate space).
		 */
		protected function pan( dragStart:Point, dragEnd:Point, complete:Boolean = false ):void
		{
			// Convert component coordinates to chart data coordinates
			
			var dataForDragStart:Array = localToData( dragStart );
			var dataForDragEnd:Array = localToData( dragEnd );
			
			var chartDragStart:Point = new Point( dataForDragStart[ 0 ], dataForDragStart[ 1 ] );
			var chartDragEnd:Point = new Point( dataForDragEnd[ 0 ], dataForDragEnd[ 1 ] );
			
			// Calculate the x and y deltas (in component coordinates)
			
			var xAxisDelta:Number = chartDragStart.x - chartDragEnd.x;
			var yAxisDelta:Number = chartDragStart.y - chartDragEnd.y;
			
			// Create, populate and dispatch a ChartPanEvent.PAN event
			
			var chartPanEvent:ChartPanEvent = new ChartPanEvent( ChartPanEvent.PAN );
			
			chartPanEvent.xAxisDelta = xAxisDelta;
			chartPanEvent.yAxisDelta = yAxisDelta;
			chartPanEvent.complete = complete;
			
			dispatchEvent( chartPanEvent );		
		}
	}
}