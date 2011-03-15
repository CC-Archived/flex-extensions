package qs.charts
{
	import mx.charts.renderers.AreaRenderer;
	import mx.graphics.IStroke;
	
	import qs.utils.GraphicsUtils;
	
	public class DashedAreaRenderer extends AreaRenderer
	{
		/**
		 * Backing variable for <code>pattern</code> property.
		 * 
		 * @see #pattern
		 */
		protected var _pattern:Array = [ 15 ];
		
		/**
		 * Constructor.
		 */
		public function DashedAreaRenderer()
		{
			super();
		}
		
		/**
		 * Dash pattern.
		 */
		public function set pattern( value:Array ):void
		{
			_pattern = value;
			
			invalidateDisplayList();
		}
		public function get pattern():Array
		{ 
			return _pattern;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function getStyle( styleProp:String ):*
		{
			if ( styleProp == "areaStroke" )
				return null;
			
			return super.getStyle( styleProp );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			var stroke:IStroke = super.getStyle( "areaStroke" );
			
			var boundary:Array = data.filteredCache;
			if (boundary.length == 0)
				return;
			
			GraphicsUtils.drawDashedPolyLine( graphics, stroke, pattern, boundary );
		}
	}
}