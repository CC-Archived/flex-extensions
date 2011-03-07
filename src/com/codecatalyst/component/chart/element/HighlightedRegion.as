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

package com.codecatalyst.component.chart.element
{
	import com.codecatalyst.util.NumberUtil;
	import com.codecatalyst.util.RectangleUtil;
	
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.charts.chartClasses.CartesianDataCanvas;
	import mx.charts.chartClasses.ChartState;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.graphics.SolidColor;
	import mx.graphics.Stroke;
	
	/**
	 * Fill.
	 */
	[Style(name="fill", type="mx.graphics.IFill", inherit="no")]
	
	/**
	 * Stroke.
	 */
	[Style(name="stroke", type="mx.graphics.IStroke", inherit="no")]
	
	public class HighlightedRegion extends CartesianDataCanvas
	{
		// ========================================
		// Protected properties
		// ========================================	
		
		/**
		 * Backing variable for <code>minimumX</code> property.
		 * 
		 * @see #minimumX
		 */
		protected var _minimumX:*;
		
		/**
		 * Backing variable for <code>maximumX</code> property.
		 * 
		 * @see #maximumX
		 */
		protected var _maximumX:*;
		
		/**
		 * Backing variable for <code>minimumY</code> property.
		 * 
		 * @see #minimumY
		 */
		protected var _minimumY:*;
		
		/**
		 * Backing variable for <code>maximumY</code> property.
		 * 
		 * @see #maximumY
		 */
		protected var _maximumY:*;
		
		// ========================================
		// Public properties
		// ========================================	
		
		[Bindable("minimumXChanged")]
		/**
		 * Minimum X value, in data coordinates.
		 */
		public function get minimumX():*
		{
			return _minimumX;
		}
		
		public function set minimumX( value:* ):void
		{
			if ( _minimumX != value )
			{
				_minimumX = value;
				
				invalidateDisplayList();
				
				dispatchEvent( new Event( "minimumXChanged" ) );
			}
		}
		
		[Bindable("maximumXChanged")]
		/**
		 * Maximum X value, in data coordinates.
		 */
		public function get maximumX():*
		{
			return _maximumX;
		}
		
		public function set maximumX( value:* ):void
		{
			if ( _maximumX != value )
			{
				_maximumX = value;
				
				invalidateDisplayList();
				
				dispatchEvent( new Event( "maximumXChanged" ) );
			}
		}
		
		[Bindable("minimumYChanged")]
		/**
		 * Minimum Y value, in data coordinates.
		 */
		public function get minimumY():*
		{
			return _minimumY;
		}
		
		public function set minimumY( value:* ):void
		{
			if ( _minimumY != value )
			{
				_minimumY = value;
				
				invalidateDisplayList();
				
				dispatchEvent( new Event( "minimumYChanged" ) );
			}
		}
		
		[Bindable("maximumYChanged")]
		/**
		 * Maximum Y value, in data coordinates.
		 */
		public function get maximumY():*
		{
			return _maximumY;
		}
		
		public function set maximumY( value:* ):void
		{
			if ( _maximumY != value )
			{
				_maximumY = value;
				
				invalidateDisplayList();
				
				dispatchEvent( new Event( "maximumYChanged" ) );
			}
		}
		
		// ========================================
		// Constructor
		// ========================================	
		
		/**
		 * Constructor.
		 */
		public function HighlightedRegion()
		{
			super();
			
			percentWidth = 100;
			percentHeight = 100;
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
			
			if ( ( chart == null ) || ( chart.chartState == ChartState.PREPARING_TO_HIDE_DATA ) || ( chart.chartState == ChartState.HIDING_DATA ) )
				return;
			
			var fill:IFill     = getStyle( "fill" )   as IFill   || new SolidColor( 0xffffff, 1.0 );
			var stroke:IStroke = getStyle( "stroke" ) as IStroke || new Stroke( 0xffffff, 1.0 );
			
			graphics.clear();
			
			var rectangle:Rectangle = createLocalRectangleForDataRegion();
			var boundaryRectangle:Rectangle = new Rectangle( 0, 0, unscaledWidth, unscaledHeight );
			var boundedRectangle:Rectangle = rectangle.intersection( boundaryRectangle );
			
			CONFIG::FLEX3 {
				stroke.apply( graphics );
				fill.begin( graphics, boundedRectangle );
			}
			CONFIG::FLEX4 {
				stroke.apply( graphics, null, null );
				fill.begin( graphics, boundedRectangle, null );
			}
			
			graphics.drawRect( boundedRectangle.x, boundedRectangle.y, boundedRectangle.width, boundedRectangle.height );
			fill.end( graphics );
		}
		
		/**
		 * Creates a Rectangle in local coordinates based on the current data region.
		 * 
		 * @see minimumX
		 * @see minimumY
		 * @see maximumX
		 * @see maximumY
		 */
		protected function createLocalRectangleForDataRegion():Rectangle
		{
			var minimum:Point = dataToLocal( minimumX, minimumY );
			var maximum:Point = dataToLocal( maximumX, maximumY );
			
			var rectangle:Rectangle = new Rectangle();
			
			rectangle.top    = NumberUtil.sanitizeNumber( maximum.y, 0 );
			rectangle.left   = NumberUtil.sanitizeNumber( minimum.x, 0 );
			rectangle.bottom = NumberUtil.sanitizeNumber( minimum.y, height );
			rectangle.right  = NumberUtil.sanitizeNumber( maximum.x, width );
			
			return rectangle;
		}
	}
}