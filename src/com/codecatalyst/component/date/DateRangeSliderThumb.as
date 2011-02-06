////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2009 CodeCatalyst, LLC - http://www.codecatalyst.com/
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

package com.codecatalyst.component.date
{
	import com.codecatalyst.data.DateRange;
	import com.codecatalyst.util.NumberUtil;
	import com.codecatalyst.util.StyleUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.controls.Button;
	import mx.controls.ButtonPhase;
	import mx.core.mx_internal;
	import mx.managers.CursorManagerPriority;
	
	use namespace mx_internal;
	
	/**
	 * Handle width.
	 */
	[Style(name="handleWidth", type="Number", inherit="no")]
	
	/**
	 * Handle width.
	 */
	[Style(name="handleHeight", type="Number", inherit="no")]
	
	/**
	 * Grip position.
	 */
	[Style(name="gripPosition", type="String", enumeration="top,bottom", inherit="no")]
	
	/**
	 *  Handle skin.
	 */
	[Style(name="handleSkin", type="Class", inherit="no", states="up, over, down, disabled, selectedUp, selectedOver, selectedDown, selectedDisabled")]
	
	/**
	 * 'Pan' mouse down cursor.
	 */
	[Style(name="panMouseDownCursor", type="Class", inherit="no")]
	
	/**
	 * 'Pan' mouse down cursor offset.
	 */
	[Style(name="panMouseDownCursorOffset", type="Point", inherit="no")]
	
	/**
	 * 'Pan' mouse down cursor.
	 */
	[Style(name="panMouseUpCursor", type="Class", inherit="no")]
	
	/**
	 * 'Pan' mouse down cursor offset.
	 */
	[Style(name="panMouseUpCursorOffset", type="Point", inherit="no")]
	
	/**
	 * 'Resize' mouse down cursor.
	 */
	[Style(name="resizeMouseDownCursor", type="Class", inherit="no")]
	
	/**
	 * 'Resize' mouse down cursor offset.
	 */
	[Style(name="resizeMouseDownCursorOffset", type="Point", inherit="no")]
	
	/**
	 * 'Resize' mouse up cursor.
	 */
	[Style(name="resizeMouseUpCursor", type="Class", inherit="no")]
	
	/**
	 * 'Resize' mouse up cursor offset.
	 */
	[Style(name="resizeMouseUpCursorOffset", type="Point", inherit="no")]
	
	[ExcludeClass]
	public class DateRangeSliderThumb extends Button
	{
		// ========================================
		// Protected constants
		// ========================================
		
		/**
		 * Resize direction: left.
		 */
		protected static const RESIZE_DIRECTION_LEFT:String = "left";
		
		/**
		 * Resize direction: right.
		 */
		protected static const RESIZE_DIRECTION_RIGHT:String = "right";
		
		// ========================================
		// Protected properties
		// ========================================	
		
		/**
		 * Backing variable for <code>dateRange</code> property.
		 * 
		 * @see #dateRange
		 */
		protected var _dateRange:DateRange = null;
		
		/**
		 * Backing variable for <code>isDraggable</code> property.
		 * 
		 * @see #isDraggable
		 */
		protected var _isDraggable:Boolean = true;
		
		/**
		 * Left handle.
		 */
		protected var leftHandle:Button = null;
		
		/**
		 * Right handle.
		 */
		protected var rightHandle:Button = null;
		
		/**
		 * Handle width.
		 */
		protected var handleWidth:Number = DateRangeSlider.DEFAULT_HANDLE_WIDTH;
		
		/**
		 * Handle height.
		 */
		protected var handleHeight:Number = DateRangeSlider.DEFAULT_HANDLE_HEIGHT;
		
		/**
		 * Previous drag coordinate.
		 */
		protected var dragPrevious:Point = null;
		
		/**
		 * Drag DateRange.
		 */
		protected var dragDateRange:DateRange = null;
		
		/**
		 * Resize direction.
		 * 
		 * @see #RESIZE_DIRECTION_LEFT
		 * @see #RESIZE_DIRECTION_RIGHT
		 */
		protected var resizeDirection:String = null;
		
		/**
		 * 'Pan' mouse down cursor.
		 */
		protected var panMouseDownCursor:Class = DateRangeSlider.DEFAULT_PAN_MOUSE_DOWN_CURSOR;
		
		/**
		 * 'Pan' mouse down cursor offset.
		 */
		protected var panMouseDownCursorOffset:Point = DateRangeSlider.DEFAULT_PAN_MOUSE_DOWN_CURSOR_OFFSET;
		
		/**
		 * 'Pan' mouse up cursor.
		 */
		protected var panMouseUpCursor:Class = DateRangeSlider.DEFAULT_PAN_MOUSE_UP_CURSOR;
		
		/**
		 * 'Pan' mouse up cursor offset.
		 */
		protected var panMouseUpCursorOffset:Point = DateRangeSlider.DEFAULT_PAN_MOUSE_UP_CURSOR_OFFSET;
		
		/**
		 * 'Resize' mouse down cursor.
		 */
		protected var resizeMouseDownCursor:Class = DateRangeSlider.DEFAULT_RESIZE_CURSOR;
		
		/**
		 * 'Resize' mouse down cursor offset.
		 */
		protected var resizeMouseDownCursorOffset:Point = DateRangeSlider.DEFAULT_RESIZE_CURSOR_OFFSET;
		
		/**
		 * 'Resize' mouse up cursor.
		 */
		protected var resizeMouseUpCursor:Class = DateRangeSlider.DEFAULT_RESIZE_CURSOR;
		
		/**
		 * 'Resize' mouse up cursor offset.
		 */
		protected var resizeMouseUpCursorOffset:Point = DateRangeSlider.DEFAULT_RESIZE_CURSOR_OFFSET;
		
		/**
		 * Current cursor identifier.
		 */
		protected var cursorId:int = -1;
		
		// ========================================
		// Public properties
		// ========================================	
		
		/**
		 * Parent DateRangeSlider.
		 */
		protected var dateRangeSlider:DateRangeSlider;
		
		[Bindable( "dateRangeChanged" )]
		/**
		 * DateRange.
		 */
		public function get dateRange():DateRange
		{
			return _dateRange;
		}
		
		public function set dateRange( value:DateRange ):void
		{
			_dateRange = value;
			
			dispatchEvent( new Event( "dateRangeChanged" ) );
		}
		
		[Bindable( "isDraggableChanged" )]
		/**
		 * Specifies whether this range thumb is draggable.
		 */
		public function get isDraggable():Boolean
		{
			return _isDraggable;
		}
		
		public function set isDraggable( value:Boolean ):void
		{
			if ( _isDraggable != value )
			{
				_isDraggable = value;
				
				leftHandle.visible = _isDraggable;
				rightHandle.visible = _isDraggable;
				
				changeSkins();
				invalidateDisplayList();
				
				dispatchEvent( new Event( "isDraggableChanged" ) );
			}
		}
		
		/**
		 * Pan callback method.
		 */
		public var panCallback:Function = null;
		
		/**
		 * Resize callback method.
		 */
		public var resizeCallback:Function = null;
		
		// ========================================
		// Constructor
		// ========================================	
		
		/**
		 * Constructor.
		 */
		public function DateRangeSliderThumb( dateRangeSlider:DateRangeSlider, panCallback:Function, resizeCallback:Function )
		{
			super();
			
			styleName = dateRangeSlider;
			
			this.dateRangeSlider = dateRangeSlider;
			this.panCallback = panCallback;
			this.resizeCallback = resizeCallback;
			
			leftHandle = new Button();
			leftHandle.data = DateRangeSliderThumb.RESIZE_DIRECTION_LEFT;
			rightHandle = new Button();
			rightHandle.data = DateRangeSliderThumb.RESIZE_DIRECTION_RIGHT;	
			
			addEventListener( Event.ADDED,   thumb_addedHandler   );
			addEventListener( Event.REMOVED, thumb_removedHandler );
		}
		
		// ========================================
		// Public methods
		// ========================================	
		
		/**
		 * @inheritDoc
		 */
		override public function styleChanged( styleProp:String ):void
		{
			super.styleChanged( styleProp );
			
			var allStyles:Boolean = ( ( styleProp == null ) || ( styleProp == "styleName" ) );
			
			// Thumb skin.
			
			if ( ( allStyles == true ) || ( styleProp == "thumbSkin" ) )
			{
				setButtonSkin( this, ( getStyle( "thumbSkin" ) as Class ) );
			}
			
			// Handle skin.
			
			if ( ( allStyles == true ) || ( styleProp == "handleSkin" ) )
			{
				setButtonSkin( leftHandle,  ( getStyle( "handleSkin" ) as Class ) );
				setButtonSkin( rightHandle, ( getStyle( "handleSkin" ) as Class ) );
			}
			
			// Handle width and height.
			
			if ( ( allStyles == true ) || ( styleProp == "handleWidth" ) )
			{
				handleWidth  = NumberUtil.sanitizeNumber( getStyle( "handleWidth" ), DateRangeSlider.DEFAULT_HANDLE_WIDTH );				

				invalidateDisplayList();
			}
			if ( ( allStyles == true ) || ( styleProp == "handleHeight" ) )
			{
				handleHeight = NumberUtil.sanitizeNumber( getStyle( "handleHeight" ), DateRangeSlider.DEFAULT_HANDLE_HEIGHT );
				
				invalidateDisplayList();
			}
			
			// 'Pan' mouse cursors.
			
			if ( ( allStyles == true ) || ( styleProp == "panMouseDownCursor" ) ) 
			{
				panMouseDownCursor = getStyle( "panMouseDownCursor" ) || DateRangeSlider.DEFAULT_PAN_MOUSE_DOWN_CURSOR;
			}
			if ( ( allStyles == true ) || ( styleProp == "panMouseDownCursorOffset" ) )
			{
				panMouseDownCursorOffset = StyleUtil.parsePoint( getStyle( "panMouseDownCursorOffset" ) ) || DateRangeSlider.DEFAULT_PAN_MOUSE_DOWN_CURSOR_OFFSET;
			}
			if ( ( allStyles == true ) || ( styleProp == "panMouseUpCursor" ) ) 
			{
				panMouseUpCursor = getStyle( "panMouseUpCursor" ) || DateRangeSlider.DEFAULT_PAN_MOUSE_UP_CURSOR;
			}
			if ( ( allStyles == true ) || ( styleProp == "panMouseUpCursorOffset" ) )
			{
				panMouseUpCursorOffset = StyleUtil.parsePoint( getStyle( "panMouseUpCursorOffset" ) ) || DateRangeSlider.DEFAULT_PAN_MOUSE_UP_CURSOR_OFFSET;
			}
			
			// 'Resize' mouse cursors.
			
			if ( ( allStyles == true ) || ( styleProp == "resizeMouseDownCursor" ) ) 
			{
				resizeMouseDownCursor = getStyle( "resizeMouseDownCursor" ) || DateRangeSlider.DEFAULT_RESIZE_CURSOR;
			}
			if ( ( allStyles == true ) || ( styleProp == "resizeMouseDownCursorOffset" ) )
			{
				resizeMouseDownCursorOffset = StyleUtil.parsePoint( getStyle( "resizeMouseDownCursorOffset" ) ) || DateRangeSlider.DEFAULT_RESIZE_CURSOR_OFFSET;
			}
			if ( ( allStyles == true ) || ( styleProp == "resizeMouseUpCursor" ) ) 
			{
				resizeMouseUpCursor = getStyle( "resizeMouseUpCursor" ) || DateRangeSlider.DEFAULT_RESIZE_CURSOR;
			}
			if ( ( allStyles == true ) || ( styleProp == "resizeMouseUpCursorOffset" ) )
			{
				resizeMouseUpCursorOffset = StyleUtil.parsePoint( getStyle( "resizeMouseUpCursorOffset" ) ) || DateRangeSlider.DEFAULT_RESIZE_CURSOR_OFFSET;
			}
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
			
			addEventListener( MouseEvent.MOUSE_DOWN, thumb_mouseDownHandler );
			addEventListener( MouseEvent.MOUSE_OVER, thumb_mouseOverHandler );
			addEventListener( MouseEvent.MOUSE_OUT,  thumb_mouseOutHandler  );
			
			leftHandle.addEventListener( MouseEvent.MOUSE_DOWN, handle_mouseDownHandler );
			leftHandle.addEventListener( MouseEvent.MOUSE_OVER, handle_mouseOverHandler );
			leftHandle.addEventListener( MouseEvent.MOUSE_OUT,  handle_mouseOutHandler  );
			
			rightHandle.addEventListener( MouseEvent.MOUSE_DOWN, handle_mouseDownHandler );
			rightHandle.addEventListener( MouseEvent.MOUSE_OVER, handle_mouseOverHandler );
			rightHandle.addEventListener( MouseEvent.MOUSE_OUT,  handle_mouseOutHandler  );
		}
		
		/**
		 * Handle Event.ADDED.
		 */
		protected function thumb_addedHandler( event:Event ):void
		{
			if ( event.target == this )
			{
				owner.addChild( leftHandle  );
				owner.addChild( rightHandle );
			}
		}
		
		/**
		 * Handle Event.REMOVED.
		 */
		protected function thumb_removedHandler( event:Event ):void
		{
			if ( event.target == this )
			{
				owner.removeChild( leftHandle  );
				owner.removeChild( rightHandle );
			}
		}
		
		/**
		 * Set the specified skin class as the skin for the specified Button.
		 */
		protected function setButtonSkin( button:Button, skinClass:Class ):void
		{
			// Ensure Button styles are not applied instead (they have precedence).
			
			button.setStyle( "upSkin",               null );
			button.setStyle( "overSkin",             null );
			button.setStyle( "downSkin",             null );
			button.setStyle( "disabledSkin",         null );
			button.setStyle( "selectedUpSkin",       null );
			button.setStyle( "selectedOverSkin",     null );
			button.setStyle( "selectedDownSkin",     null );
			button.setStyle( "selectedDisabledSkin", null );
			
			// Apply skin class.
			
			button.setStyle( "skin", skinClass );
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			positionHandles();
		}
		
		/**
		 * Position the handles for this thumb.
		 */
		protected function positionHandles():void
		{
			var frame:Rectangle = new Rectangle( x, y, unscaledWidth, unscaledHeight );
			
			leftHandle.setActualSize( handleWidth, handleHeight );
			leftHandle.move( frame.left  - ( leftHandle.width   / 2 ), ( frame.height / 2 ) - ( leftHandle.height  / 2 ) );
			
			rightHandle.setActualSize( handleWidth, handleHeight );
			rightHandle.move( frame.right - ( rightHandle.width / 2 ), ( frame.height / 2 ) - ( rightHandle.height / 2 ) );			
		}
		
		/**
		 * Create a bounded DateRange, constrained by the current start time and end time.
		 */
		protected function createBoundedRange( dateRange:DateRange, resizeDirection:String = null ):DateRange
		{
			var boundedDateRange:DateRange = dateRangeSlider.selectableDateRange.createBoundedDateRange( dateRange );
			
			if ( ( resizeDirection == DateRangeSliderThumb.RESIZE_DIRECTION_LEFT  ) && ( boundedDateRange.startTime > boundedDateRange.endTime  ) )
				boundedDateRange.startTime = boundedDateRange.endTime;
			
			if ( ( resizeDirection == DateRangeSliderThumb.RESIZE_DIRECTION_RIGHT ) && ( boundedDateRange.endTime   < boundedDateRange.startTime ) )
				boundedDateRange.endTime = boundedDateRange.startTime;
			
			return boundedDateRange;
		}	
		
		/**
		 * Pan relative to the specified starting and ending coordinates (in component coordinate space).
		 */
		protected function pan( dragStart:Point, dragEnd:Point, complete:Boolean = false ):void
		{
			var deltaX:Number = dragStart.x - dragEnd.x;
			var deltaTime:Number = deltaX * ( dateRangeSlider.selectableDateRange.duration / dateRangeSlider.width );
			
			dragDateRange = new DateRange( dragDateRange.startTime - deltaTime, dragDateRange.endTime - deltaTime );
			
			dateRange = createBoundedRange( dragDateRange );
			
			panCallback( this, complete );
		}
		
		/**
		 * Resize relative the specified starting and ending coordinates (in component coordinate space).
		 */
		protected function resize( dragStart:Point, dragEnd:Point, complete:Boolean = false ):void
		{
			var deltaX:Number = dragStart.x - dragEnd.x;
			var deltaTime:Number = deltaX * ( dateRangeSlider.selectableDateRange.duration / dateRangeSlider.width );
			
			if ( resizeDirection == DateRangeSliderThumb.RESIZE_DIRECTION_LEFT )
			{
				dragDateRange = new DateRange( dragDateRange.startTime - deltaTime, dragDateRange.endTime );
			}
			else // ( resizeDirection == DateRangeSliderThumb.RESIZE_DIRECTION_RIGHT )
			{
				dragDateRange = new DateRange( dragDateRange.startTime, dragDateRange.endTime - deltaTime );
			}
			
			dateRange = createBoundedRange( dragDateRange, resizeDirection );
			
			resizeCallback( this, complete );
		}
		
		/**
		 * Show the specified mouse cursor.
		 */
		protected function showCursor( cursorClass:Class, cursorOffset:Point ):void
		{
			hideCursor();
			
			cursorOffset ||= new Point( 0, 0 );
			
			cursorId = cursorManager.setCursor( cursorClass, CursorManagerPriority.MEDIUM, cursorOffset.x, cursorOffset.y );
		}
		
		/**
		 * Remove the currently assigned mouse cursor (if applicable).
		 */
		protected function hideCursor():void
		{
			if ( cursorId != -1 )
			{
				cursorManager.removeCursor( cursorId );
				cursorId = -1;
			}
		}
		
		/**
		 * Handle MouseEvent.MOUSE_DOWN.
		 */
		protected function thumb_mouseDownHandler( event:MouseEvent ):void
		{
			if ( !isDraggable )
				return;
			
			// Drag operation initiated
			
			dateRangeSlider.isDragging = true;
			
			// Store the current coordinate for the first delta calculation
			
			dragPrevious = new Point( dateRangeSlider.mouseX, dateRangeSlider.mouseY );
			
			// Store the current range
			
			dragDateRange = dateRange.clone();
			
			// Show the 'Pan' mouse down cursor
			
			showCursor( panMouseDownCursor, panMouseDownCursorOffset );
			
			// Toggle the corresponding handles to their OVER state
			
			leftHandle.phase  = ButtonPhase.OVER;
			rightHandle.phase = ButtonPhase.OVER;
			
			// Add MouseEvent.MOUSE_MOVE and MouseEvent.MOUSE_UP event listeners
			
			systemManager.addEventListener( MouseEvent.MOUSE_MOVE, pan_mouseMoveHandler );
			systemManager.addEventListener( MouseEvent.MOUSE_UP, pan_mouseUpHandler );
		}
		
		/**
		 * Handle thumb MouseEvent.MOUSE_OVER.
		 */
		protected function thumb_mouseOverHandler( event:MouseEvent ):void
		{
			if ( !isDraggable )
				return;
			
			if ( !dateRangeSlider.isDragging )
			{
				// Show the 'Pan' mouse up cursor
				
				showCursor( panMouseUpCursor, panMouseUpCursorOffset );
				
				// Toggle the corresponding handles to their OVER state
				
				leftHandle.phase  = ButtonPhase.OVER;
				rightHandle.phase = ButtonPhase.OVER;
			}
		}
		
		/**
		 * Handle thumb MouseEvent.MOUSE_OUT.
		 */
		protected function thumb_mouseOutHandler( event:MouseEvent ):void
		{
			if ( !isDraggable )
				return;
			
			if ( !dateRangeSlider.isDragging )
			{
				// Hide the 'Pan' mouse cursor
				
				hideCursor();
				
				// Toggle the corresponding handles to their OVER state
				
				leftHandle.phase  = ButtonPhase.UP;
				rightHandle.phase = ButtonPhase.UP;
			}		
		}
		
		/**
		 * Handle handle MouseEvent.MOUSE_OVER.
		 */
		protected function handle_mouseOverHandler( event:MouseEvent ):void
		{
			if ( !isDraggable )
				return;
			
			if ( !dateRangeSlider.isDragging )
			{
				// Show the 'Resize' mouse cursor
				
				showCursor( resizeMouseUpCursor, resizeMouseUpCursorOffset );
			}
		}
		
		/**
		 * Handle handle MouseEvent.MOUSE_OUT.
		 */
		protected function handle_mouseOutHandler( event:MouseEvent ):void
		{
			if ( !isDraggable )
				return;
			
			if ( !dateRangeSlider.isDragging )
			{
				// Hide the 'Resize' mouse cursor
				
				hideCursor();
			}		
		}
		
		/**
		 * Handle range handle MouseEvent.MOUSE_DOWN.
		 */
		protected function handle_mouseDownHandler( event:MouseEvent ):void
		{
			if ( !isDraggable )
				return;
			
			// Drag operation initiated
			
			dateRangeSlider.isDragging = true;	
			
			// Determine the resize direction
			
			resizeDirection = event.target.data;
			
			// Store the current coordinate for the first delta calculation
			
			dragPrevious = new Point( dateRangeSlider.mouseX, dateRangeSlider.mouseY );
			
			// Store the current range
			
			dragDateRange = dateRange.clone();
			
			// Show the 'Resize' mouse cursor
			
			showCursor( resizeMouseDownCursor, resizeMouseDownCursorOffset );
			
			// Add MouseEvent.MOUSE_MOVE and MouseEvent.MOUSE_UP event listeners
			
			systemManager.addEventListener( MouseEvent.MOUSE_MOVE, resize_mouseMoveHandler );
			systemManager.addEventListener( MouseEvent.MOUSE_UP, resize_mouseUpHandler );
		}		
		
		/**
		 * Handle 'pan' operation MouseEvent.MOUSE_DOWN.
		 */
		protected function pan_mouseMoveHandler( event:MouseEvent ):void
		{
			var dragCurrent:Point = new Point( dateRangeSlider.mouseX, dateRangeSlider.mouseY );
			
			// Pan relative to previous and current coordinates
			
			pan( dragPrevious, dragCurrent );
			
			// Store the current coordinate for the next delta calculation
			
			dragPrevious = dragCurrent;
			
			// Toggle the corresponding handles to their OVER state.
			
			leftHandle.phase  = ButtonPhase.OVER;
			rightHandle.phase = ButtonPhase.OVER;
		}
		
		/**
		 * Handle 'pan' operation MouseEvent.MOUSE_UP.
		 */
		protected function pan_mouseUpHandler( event:MouseEvent ):void
		{
			var dragCurrent:Point = new Point( dateRangeSlider.mouseX, dateRangeSlider.mouseY );
			
			// Pan relative to previous and current coordinates
			
			pan( dragPrevious, dragCurrent, true );
			
			// Drag operation completed
			
			dateRangeSlider.isDragging = false;
			
			// Clear stored coordinate.
			
			dragPrevious = null;
			
			// Clear stored range.
			
			dragDateRange = null;
			
			// Toggle the corresponding handles back to their UP state.
			
			if ( !hitTestPoint( event.stageX, event.stageY ) )
			{
				// Hide the 'Pan' mouse cursor
				
				hideCursor();
				
				leftHandle.phase  = ButtonPhase.UP;
				rightHandle.phase = ButtonPhase.UP;
			}
			else
			{
				// Show the 'Pan' mouse up cursor.
				
				showCursor( panMouseUpCursor, panMouseUpCursorOffset );
			}
			
			// Remove MouseEvent.MOUSE_MOVE and MouseEvent.MOUSE_UP event listeners
			
			systemManager.removeEventListener( MouseEvent.MOUSE_MOVE, pan_mouseMoveHandler );
			systemManager.removeEventListener( MouseEvent.MOUSE_UP, pan_mouseUpHandler );
		}
		
		/**
		 * Handle 'resize' operation MouseEvent.MOUSE_DOWN.
		 */
		protected function resize_mouseMoveHandler( event:MouseEvent ):void
		{
			var dragCurrent:Point = new Point( dateRangeSlider.mouseX, dateRangeSlider.mouseY );
			
			// Resize relative to previous and current coordinates
			
			resize( dragPrevious, dragCurrent );
			
			// Store the current coordinate for the next delta calculation
			
			dragPrevious = dragCurrent;
		}
		
		/**
		 * Handle 'resize' operation MouseEvent.MOUSE_UP.
		 */
		protected function resize_mouseUpHandler( event:MouseEvent ):void
		{
			var dragCurrent:Point = new Point( dateRangeSlider.mouseX, dateRangeSlider.mouseY );
			
			// Resize relative to previous and current coordinates
			
			resize( dragPrevious, dragCurrent, true );
			
			// Drag operation completed
			
			dateRangeSlider.isDragging = false;
			
			// Clear stored coordinate.
			
			dragPrevious = null;
			
			// Clear stored range.
			
			dragDateRange = null;
			
			// Hide the 'Resize' mouse cursor
			
			hideCursor();
			
			// Remove MouseEvent.MOUSE_MOVE and MouseEvent.MOUSE_UP event listeners
			
			systemManager.removeEventListener( MouseEvent.MOUSE_MOVE, resize_mouseMoveHandler );
			systemManager.removeEventListener( MouseEvent.MOUSE_UP, resize_mouseUpHandler );
		}
	}
}