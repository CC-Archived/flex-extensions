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
	import com.codecatalyst.util.RectangleUtil;
	import com.codecatalyst.util.StyleUtil;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.graphics.SolidColor;
	import mx.graphics.Stroke;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	/**
	 * Fill.
	 */
	[Style(name="fill", type="mx.graphics.IFill", inherit="no")]
	
	/**
	 * Stroke.
	 */
	[Style(name="stroke", type="mx.graphics.IStroke", inherit="no")]
	
	/**
	 * Dispatched when the user clicks to zoom in to a chart coordinate.
	 */
	[Event(name="zoomIn", type="com.codecatalyst.component.chart.control.ChartZoomEvent")]
	
	/**
	 * Dispatched when the user drags a rectangular selection to zoom in to a region of the chart.
	 */
	[Event(name="zoomToRectangle", type="com.codecatalyst.component.chart.control.ChartZoomEvent")]
	
	public class ChartZoomInControl extends AbstractChartControl
	{
		// ========================================
		// Protected constants
		// ========================================
		
		[Embed(source="/asset/image/cursor/zoom-in.png")]
		/**
		 * Default 'Zoom In' cursor.
		 */
		protected static const DEFAULT_ZOOM_IN_CURSOR:Class;
		
		/**
		 * Default 'Zoom Out' cursor offset.
		 */
		protected static const DEFAULT_ZOOM_IN_CURSOR_OFFSET:Point = new Point( -11, -11 );
		
		// ========================================
		// Static initializers
		// ========================================
		
		/**
		 * Static initializer for default CSS styles.
		 */
		protected static var stylesInitialized:Boolean = initializeStyles();
		
		protected static function initializeStyles():Boolean
		{
			var declaration:CSSStyleDeclaration = StyleUtil.getStyleDeclaration( "ChartZoomInControl" );
			
			declaration.defaultFactory = 
				function ():void
				{
					this.mouseDownCursor 		= DEFAULT_ZOOM_IN_CURSOR;
					this.mouseDownCursorOffset 	= DEFAULT_ZOOM_IN_CURSOR_OFFSET;
					this.rollOverCursor  		= DEFAULT_ZOOM_IN_CURSOR;
					this.rollOverCursorOffset 	= DEFAULT_ZOOM_IN_CURSOR_OFFSET;
				};
			
			StyleUtil.setStyleDeclaration( "ChartZoomInControl", declaration, false );
			
			return true;
		}
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Indicates whether this control is currently performing a zoom operation.
		 */
		protected var isZooming:Boolean = false;
		
		/**
		 * Starting mouse coordinate during a zoom operation.
		 */
		protected var zoomStart:Point;
		
		/**
		 * Current mouse coordinate during a zoom operation.
		 */
		protected var zoomCurrent:Point;
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Indicates whether to allow zooming the X axis.
		 */
		public var allowZoomX:Boolean = true;;
		
		/**
		 * Indicates whether to allow zooming the Y axis.
		 */
		public var allowZoomY:Boolean = true;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ChartZoomInControl()
		{
			super();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if ( ( isZooming == true ) && ( zoomCurrent != null ) )
			{
				var fill:IFill     = getStyle( "fill" )   as IFill   || new SolidColor( 0x999999, 0.5 );
				var stroke:IStroke = getStyle( "stroke" ) as IStroke || new Stroke( 0x000000, 1.0, 0.0, true );
				
				var rectangle:Rectangle = calculateCurrentZoomRectangle();
				
				CONFIG::FLEX3 {
					stroke.apply( graphics );
					fill.begin( graphics, rectangle );
				}
				CONFIG::FLEX4 {
					stroke.apply( graphics, null, null );
					fill.begin( graphics, rectangle, null );
				}
				
				graphics.drawRect( rectangle.x, rectangle.y, rectangle.width, rectangle.height );
				fill.end( graphics );
			}
		}
		
		/**
		 * Calculate the current zoom rectangle (in component coordinates).
		 */
		protected function calculateCurrentZoomRectangle():Rectangle
		{
			var rectangle:Rectangle =
				new Rectangle(
					( allowZoomX ) ? zoomStart.x : 0,
					( allowZoomY ) ? zoomStart.y : 0,
					( allowZoomX ) ? zoomCurrent.x - zoomStart.x : width,
					( allowZoomY ) ? zoomCurrent.y - zoomStart.y : height
				);
			
			return RectangleUtil.normalize( rectangle );
		}
		
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
				
				// Store the starting coordinate
				
				zoomStart = new Point( mouseX, mouseY );
			}
		}
		
		/**
		 * Handle MouseEvent.MOUSE_MOVE.
		 */
		override protected function mouseMoveHandler( event:MouseEvent ):void
		{
			super.mouseMoveHandler( event );
			
			// Store the current coordinate
			
			zoomCurrent = new Point( mouseX, mouseY );
			
			// Mark the display as dirty
			
			invalidateDisplayList();
		}
		
		/**
		 * Handle MouseEvent.MOUSE_UP.
		 */
		override protected function mouseUpHandler( event:MouseEvent ):void
		{
			super.mouseUpHandler( event );
			
			if ( zoomCurrent != null )
			{
				// Zoom to the current zoom rectangle
				
				zoomTo( calculateCurrentZoomRectangle() );
			}
			else
			{
				// Calculate zoom origin coordinate (in component coordinates)
				
				var zoomOrigin:Point = new Point( this.mouseX, this.mouseY );
				
				// Zoom to the calculated origin coordinate
				
				zoomIn( zoomOrigin );
			}
			
			// Clear the stored coordinates
			
			zoomStart = null;
			zoomCurrent = null;
			
			// Zoom operation completed
			
			isZooming = false;
			
			// Mark the display as dirty
			
			invalidateDisplayList();
		}
		
		/**
		 * Zoom to the specified rectangle (in component coordinate space).
		 */
		protected function zoomTo( rectangle:Rectangle ):void
		{
			// Convert component coordinates to chart data coordinates
			
			var dataForTopLeft:Array = localToData( rectangle.topLeft );
			var dataForBottomRight:Array = localToData( rectangle.bottomRight );
			
			var chartRectangle:Rectangle = new Rectangle();
			
			chartRectangle.topLeft = new Point( dataForTopLeft[ 0 ], dataForTopLeft[ 1 ] );
			chartRectangle.bottomRight = new Point( dataForBottomRight[ 0 ], dataForBottomRight[ 1 ] );
			
			// Create, populate and dispatch a ChartZoomEvent.ZOOM_TO_RECTANGLE event
			
			var chartZoomEvent:ChartZoomEvent = new ChartZoomEvent( ChartZoomEvent.ZOOM_TO_RECTANGLE );
			
			chartZoomEvent.rectangle = chartRectangle;
			
			dispatchEvent( chartZoomEvent );			
		}
		
		/**
		 * Zoom in relative to the specified origin coordinate (in component coordinate space).
		 */
		protected function zoomIn( origin:Point ):void
		{
			// Convert component coordinates to chart data coordinates
			
			var dataForOrigin:Array = localToData( origin );
			
			var chartOrigin:Point = new Point( dataForOrigin[ 0 ], dataForOrigin[ 1 ] );
			
			// Create, populate and dispatch a ChartZoomEvent.ZOOM_IN event
			
			var chartZoomEvent:ChartZoomEvent = new ChartZoomEvent( ChartZoomEvent.ZOOM_IN );
			
			chartZoomEvent.origin = chartOrigin;
			
			dispatchEvent( chartZoomEvent );				
		}
	}
}