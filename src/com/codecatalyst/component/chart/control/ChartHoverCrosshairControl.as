package com.codecatalyst.component.chart.control
{
	import com.codecatalyst.util.GraphicsUtil;
	
	import flash.geom.Point;
	
	import mx.graphics.IStroke;
	import mx.graphics.Stroke;

	/**
	 * Direction.
	 */
	[Style(name="direction", type="String", enumeration="horizontal,vertical,both", inherit="no")]
	
	/**
	 * Stroke.
	 */
	[Style(name="stroke", type="mx.graphics.IStroke", inherit="no")]
	
	/**
	 * Dash pattern (optional).
	 */
	[Style(name="pattern", type="Array", arrayType="Number")]
	
	public class ChartHoverCrosshairControl extends ChartHoverControl
	{
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ChartHoverCrosshairControl()
		{
			super();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Draw a hover indicator at the specified point.
		 */
		override protected function drawHoverIndicatorForPoint( point:Point ):void
		{
			var direction:String = getStyle( "direction" ) as String || "both";
			var stroke:IStroke = getStyle( "stroke" ) as IStroke || new Stroke( 0x000000, 1.0 );
			var pattern:Array  = getStyle( "pattern" ) as Array;
			
			switch ( direction )
			{
				case "horizontal":
					drawLine( new Point( 0, point.y ), new Point( width, point.y ), stroke, pattern );
					break;

				case "vertical":
					drawLine( new Point( point.x, 0 ), new Point( point.x, height ), stroke, pattern );
					break;

				case "both":
					drawLine( new Point( point.x, 0 ), new Point( point.x, height ), stroke, pattern );
					drawLine( new Point( 0, point.y ), new Point( width, point.y ), stroke, pattern );
					break;
			}
		}
		
		/**
		 * Draw a line between the specified starting and ending Points.
		 */
		protected function drawLine( start:Point, end:Point, stroke:IStroke, pattern:Array ):void
		{
			GraphicsUtil.drawPolyLine( graphics, [ start, end ], stroke, pattern );
		}
	}
}