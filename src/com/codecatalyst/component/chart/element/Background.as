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
	import flash.geom.Rectangle;
	
	import mx.charts.chartClasses.ChartElement;
	import mx.graphics.IFill;
	import mx.graphics.IStroke;
	import mx.graphics.SolidColor;
	import mx.graphics.Stroke;
	
	/**
	 * Background fill.
	 */
	[Style(name="backgroundFill", type="mx.graphics.IFill", inherit="no")]
	
	/**
	 * Border stroke.
	 */
	[Style(name="borderStroke", type="mx.graphics.IStroke", inherit="no")]
	
	public class Background extends ChartElement
	{
		// ========================================
		// Constructor
		// ========================================	
		
		/**
		 * Constructor.
		 */
		public function Background()
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
			
			if ( chart == null )
				return;
			
			// NOTE: ChartBase and CartesianChart incorrectly mask backgroundElements, so we just blow away the mask in the parent 'holder' component.
			parent.mask = null;
			
			var backgroundFill:IFill = getStyle( "backgroundFill" ) as IFill   || new SolidColor( 0xffffff, 1.0 );
			var borderStroke:IStroke = getStyle( "borderStroke" )   as IStroke || new Stroke( 0x000000, 1.0 );
			
			var borderRectangle:Rectangle = new Rectangle( -1, -1, unscaledWidth + 1, unscaledHeight + 1 );
			
			graphics.clear();
			
			CONFIG::FLEX3 {
				borderStroke.apply( graphics );
				backgroundFill.begin( graphics, borderRectangle );
			}
			CONFIG::FLEX4 {
				borderStroke.apply( graphics, null, null );
				backgroundFill.begin( graphics, borderRectangle, null );
			}
			
			graphics.drawRect( borderRectangle.x, borderRectangle.y, borderRectangle.width, borderRectangle.height );
			backgroundFill.end( graphics );
		}
	}
}