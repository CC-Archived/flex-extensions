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
	
	import mx.charts.chartClasses.CartesianDataCanvas;
	import mx.managers.CursorManager;
	import mx.managers.CursorManagerPriority;
	
	/**
	 * 'Mouse Down' cursor.
	 */
	[Style(name="mouseDownCursor", type="Class", inherit="no")]
	
	/**
	 * 'Mouse Down' cursor offset.
	 */
	[Style(name="mouseDownCursorOffset", type="Point", inherit="no")]
	
	/**
	 * 'Roll Over' cursor.
	 */
	[Style(name="rollOverCursor", type="Class", inherit="no")]
	
	/**
	 * 'Roll Over' cursor offset.
	 */
	[Style(name="rollOverCursorOffset", type="Point", inherit="no")]
	
	public class AbstractChartControl extends CartesianDataCanvas
	{
		// ========================================
		// Protected constants
		// ========================================
		
		/**
		 * Default mouse down cursor offset.
		 */
		protected static const DEFAULT_MOUSE_DOWN_CURSOR_OFFSET:Point = new Point( 0, 0 );
		
		/**
		 * Default roll over cursor offset.
		 */
		protected static const DEFAULT_ROLL_OVER_CURSOR_OFFSET:Point = new Point( 0, 0 );
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * 'Mouse Down' cursor.
		 */
		protected var mouseDownCursor:Class = null;
		
		/**
		 * 'Mouse Down' cursor offset.
		 */
		protected var mouseDownCursorOffset:Point = DEFAULT_MOUSE_DOWN_CURSOR_OFFSET;
		
		/**
		 * 'Roll Over' cursor.
		 */
		protected var rollOverCursor:Class = null;
		
		/**
		 * 'Roll Over' cursor offset.
		 */
		protected var rollOverCursorOffset:Point = DEFAULT_ROLL_OVER_CURSOR_OFFSET;
		
		/**
		 * 'Mouse Down' cursor identifier.
		 */
		protected var mouseDownCursorId:int = -1;
		
		/**
		 * 'Roll Over' cursor identifier.
		 */
		protected var rollOverCursorId:int = -1;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function AbstractChartControl()
		{
			super();
			
			this.percentWidth = 100;
			this.percentHeight = 100;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			// Add MouseEvent.MOUSE_DOWN, MouseEvent.ROLL_OVER, MouseEvent.ROLL_OUT event listeners.
			
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true );			
			addEventListener( MouseEvent.ROLL_OVER,  rollOverHandler,  false, 0, true );
			addEventListener( MouseEvent.ROLL_OUT,   rollOutHandler,   false, 0, true );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );
			
			var allStyles:Boolean = ( ( styleProp == null ) || ( styleProp == "styleName" ) );
			
			// 'Mouse Down' cursor.
			
			if ( ( allStyles == true ) || ( styleProp == "mouseDownCursor" ) ) 
			{
				mouseDownCursor = getStyle( "mouseDownCursor" );
			}
			if ( ( allStyles == true ) || ( styleProp == "mouseDownCursorOffset" ) )
			{
				mouseDownCursorOffset = StyleUtil.parsePoint( getStyle( "mouseDownCursorOffset" ) ) || DEFAULT_MOUSE_DOWN_CURSOR_OFFSET;
			}
			
			// 'Roll Over' cursor.
			
			if ( ( allStyles == true ) || ( styleProp == "rollOverCursor" ) ) 
			{
				rollOverCursor = getStyle( "rollOverCursor" );
			}
			if ( ( allStyles == true ) || ( styleProp == "rollOverCursorOffset" ) )
			{
				rollOverCursorOffset = StyleUtil.parsePoint( getStyle( "rollOverCursorOffset" ) ) || DEFAULT_ROLL_OVER_CURSOR_OFFSET;
			}
		}
		
		/**
		 * Handle MouseEvent.MOUSE_DOWN.
		 */
		protected function mouseDownHandler( event:MouseEvent ):void
		{
			// Show the 'Mouse Down' cursor.
			
			if ( mouseDownCursor != null )
				mouseDownCursorId = CursorManager.setCursor( mouseDownCursor, CursorManagerPriority.HIGH, mouseDownCursorOffset.x, mouseDownCursorOffset.y );
			
			// Add MouseEvent.MOUSE_MOVE and MouseEvent.MOUSE_UP event listeners
			
			systemManager.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true );
			systemManager.addEventListener( MouseEvent.MOUSE_UP,   mouseUpHandler,   false, 0, true );
		}
		
		/**
		 * Handle MouseEvent.MOUSE_MOVE.
		 */
		protected function mouseMoveHandler( event:MouseEvent ):void
		{
			// Override in subclasses.
		}
		
		/**
		 * Handle MouseEvent.MOUSE_UP.
		 */
		protected function mouseUpHandler( event:MouseEvent ):void
		{
			// Hide the 'Mouse Down' cursor.
			
			if ( mouseDownCursorId != -1 )
				CursorManager.removeCursor( mouseDownCursorId );
			
			// Remove MouseEvent.MOUSE_MOVE and MouseEvent.MOUSE_UP event listeners
			
			systemManager.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
			systemManager.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
		}
		
		/**
		 * Handle MouseEvent.ROLL_OVER.
		 */
		protected function rollOverHandler( event:MouseEvent ):void
		{
			// Show the 'Roll Over' cursor.
			
			if ( rollOverCursor != null )
				rollOverCursorId = CursorManager.setCursor( rollOverCursor, CursorManagerPriority.MEDIUM, rollOverCursorOffset.x, rollOverCursorOffset.y );
		}
		
		/**
		 * Handle MouseEvent.ROLL_OUT.
		 */
		protected function rollOutHandler( event:MouseEvent ):void
		{
			// Hide the 'Roll Over' cursor.
			
			if ( rollOverCursorId != -1 )
				CursorManager.removeCursor( rollOverCursorId );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			graphics.clear();
			
			if ( enabled )
			{
				// Draw an invisible fill to create a hitbox for mouse handlers.
				
				graphics.beginFill( 0, 0 );
				graphics.drawRect( 0, 0, unscaledWidth, unscaledHeight );
				graphics.endFill();
			}
		}
	}
}