/*
Copyright (c) 2006 Adobe Systems Incorporated

Permission is hereby granted, free of charge, to any person
obtaining a copy of this software and associated documentation
files (the "Software"), to deal in the Software without
restriction, including without limitation the rights to use,
copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the
Software is furnished to do so, subject to the following
conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.
*/
package qs.charts
{
	import mx.core.IDataRenderer;
	import mx.graphics.IStroke;
	import mx.skins.ProgrammaticSkin;
	import mx.charts.series.items.LineSeriesSegment;
	
	import qs.utils.GraphicsUtils;
	
	public class DashedLineRenderer extends ProgrammaticSkin implements IDataRenderer
	{
		public function DashedLineRenderer() 
		{
			super();
		}
		
		private var _lineSegment:LineSeriesSegment;
		private var _pattern:Array = [15];
		
		public function set pattern(value:Array):void
		{
			_pattern = value;
			invalidateDisplayList();
		}
		public function get pattern():Array
		{ 
			return _pattern;
		}
		
		public function get data():Object
		{
			return _lineSegment;
		}
		
		public function set data(value:Object):void
		{
			_lineSegment = LineSeriesSegment(value);
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var stroke:IStroke = getStyle("lineStroke");		
			
			graphics.clear();
			GraphicsUtils.drawDashedPolyLine(graphics, stroke, _pattern, _lineSegment.items.slice(_lineSegment.start, _lineSegment.end+1));
		}
	}
}