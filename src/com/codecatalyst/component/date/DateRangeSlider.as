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
	import asset.skin.slider.BackgroundSkin;
	import asset.skin.slider.HandleSkin;
	import asset.skin.slider.ThumbSkin;

	import com.codecatalyst.data.DateRange;
	import com.codecatalyst.factory.ClassFactory;
	import com.codecatalyst.util.ArrayUtil;
	import com.codecatalyst.util.BitmapDataUtil;
	import com.codecatalyst.util.FactoryPool;
	import com.codecatalyst.util.RectangleUtil;
	import com.codecatalyst.util.SkinUtil;
	import com.codecatalyst.util.StyleUtil;

	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	import mx.core.UIComponent;
	import mx.core.mx_internal;
	import mx.events.FlexEvent;
	import mx.graphics.IFill;
	import mx.graphics.ImageSnapshot;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;

	use namespace mx_internal;

	/**
	 * Background skin.
	 */
	[Style(name="backgroundSkin", type="Class", inherit="no")]

	/**
	 * Thumb skin.
	 */
	[Style(name="thumbSkin", type="Class", inherit="no", states="up, over, down, disabled, selectedUp, selectedOver, selectedDown, selectedDisabled")]

	/**
	 * Thumb background fill.
	 */
	[Style(name="thumbBackgroundFill", type="mx.graphics.IFill", inherit="no")]

	/**
	 * Handle skin.
	 */
	[Style(name="handleSkin", type="Class", inherit="no", states="up, over, down, disabled, selectedUp, selectedOver, selectedDown, selectedDisabled")]

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
	 * Indicates whether overlapping grips should automatically alternate between top and bottom positions.
	 */
	[Style(name="alternateOverlappingGripPositions", type="Boolean", inherit="no")]

	/**
	 * 'Pan' mouse down cursor.
	 */
	[Style(name="panMouseDownCursor", type="Class", inherit="no")]

	/**
	 * 'Pan' mouse down cursor.
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

	/**
	 * Dispatched when a selected DateRange is panned.
	 */
	[Event(name="dateRangePanned", type="com.codecatalyst.component.date.DateRangeSliderEvent")]

	/**
	 * Dispatched when a selected DateRange is resized.
	 */
	[Event(name="dateRangeResized", type="com.codecatalyst.component.date.DateRangeSliderEvent")]

	public class DateRangeSlider extends UIComponent
	{
		// ========================================
		// Internal constants
		// ========================================

		[Embed(source="/asset/image/cursor/grabbing.png")]
		/**
		 * Default 'pan' mouse down cursor icon.
		 */
		internal static const DEFAULT_PAN_MOUSE_DOWN_CURSOR:Class;

		/**
		 * Default 'pan' mouse down cursor offset.
		 */
		internal static const DEFAULT_PAN_MOUSE_DOWN_CURSOR_OFFSET:Point = new Point( -11, -11 );

		[Embed(source="/asset/image/cursor/grab.png")]
		/**
		 * Default 'pan' mouse up cursor icon.
		 */
		internal static const DEFAULT_PAN_MOUSE_UP_CURSOR:Class;

		/**
		 * Default 'pan' mouse up cursor offset.
		 */
		internal static const DEFAULT_PAN_MOUSE_UP_CURSOR_OFFSET:Point = new Point( -11, -11 );

		[Embed(source="/asset/image/cursor/resize-column.png")]
		/**
		 * Default 'resize' cursor icon.
		 */
		internal static const DEFAULT_RESIZE_CURSOR:Class;

		/**
		 * Default 'resize' cursor offset.
		 */
		internal static const DEFAULT_RESIZE_CURSOR_OFFSET:Point = new Point( -11, -11 );

		/**
		 * Default handle width.
		 */
		internal static const DEFAULT_HANDLE_WIDTH:Number = 15;

		/**
		 * Default handle height.
		 */
		internal static const DEFAULT_HANDLE_HEIGHT:Number = 15;

		// ========================================
		// Static initializers
		// ========================================

		/**
		 * Static initializer for default CSS styles.
		 */
		protected static var stylesInitialized:Boolean = initializeStyles();

		protected static function initializeStyles():Boolean
		{
			var declaration:CSSStyleDeclaration = StyleUtil.getStyleDeclaration( "com.codecatalyst.component.date.DateRangeSlider" ) || new CSSStyleDeclaration();

			declaration.defaultFactory =
				function ():void
				{
					this.backgroundSkin                     = BackgroundSkin;
					this.thumbSkin                          = ThumbSkin;
					this.handleSkin                         = HandleSkin;
					this.handleWidth                        = DEFAULT_HANDLE_WIDTH;
					this.handleHeight                       = DEFAULT_HANDLE_HEIGHT;
					this.gripPosition                       = "bottom";
					this.alternateOverlappingGripPositions  = true;
					this.panMouseDownCursor                 = DEFAULT_PAN_MOUSE_DOWN_CURSOR;
					this.panMouseDownCursorOffset           = DEFAULT_PAN_MOUSE_DOWN_CURSOR_OFFSET;
					this.panMouseUpCursor                   = DEFAULT_PAN_MOUSE_UP_CURSOR;
					this.panMouseUpCursorOffset             = DEFAULT_PAN_MOUSE_UP_CURSOR_OFFSET;
					this.resizeMouseDownCursor              = DEFAULT_RESIZE_CURSOR;
					this.resizeMouseDownCursorOffset        = DEFAULT_RESIZE_CURSOR_OFFSET;
					this.resizeMouseUpCursor                = DEFAULT_RESIZE_CURSOR;
					this.resizeMouseUpCursorOffset          = DEFAULT_RESIZE_CURSOR_OFFSET;
				};

			StyleUtil.setStyleDeclaration( "com.codecatalyst.component.date.DateRangeSlider", declaration, false );

			return true;
		}

		// ========================================
		// Protected properties
		// ========================================

		/**
		 * Backing variable for <code>content</code> property.
		 *
		 * @see #content
		 */
		protected var _content:DisplayObject = null;

		/**
		 * Indicates whether the <code>content</code> property has been invalidated.
		 */
		protected var contentChanged:Boolean = false;

		[ArrayElementType("com.codecatalyst.data.DateRange")]
		/**
		 * Backing variable for <code>selectedDateRanges</code> property.
		 *
		 * @see #selectedDateRanges
		 */
		protected var _selectedDateRanges:Array = null;

		/**
		 * Indicates whether the <code>selectedDateRange</code> or <code>selectedDateRanges</code> property has been invalidated.
		 */
		protected var selectedDateRangesChanged:Boolean;

		/**
		 * Backing variable for <code>selectableDateRange</code> property.
		 *
		 * @see #selectableDateRange
		 */
		protected var _selectableDateRange:DateRange = null;

		/**
		 * Indicates whether the <code>selectableDateRange</code> property has been invalidated.
		 */
		protected var selectableDateRangeChanged:Boolean = false;

		/**
		 * Backing variable for <code>bitmapDataModifier</code> property.
		 *
		 * @see #bitmapDataModifier
		 */
		protected var _bitmapDataModifier:Function = BitmapDataUtil.grayscale;

		/**
		 * Indicates whether the <code>bitmapDataModifier</code> property has been invalidated.
		 */
		protected var bitmapDataModifierChanged:Boolean = false;

		/**
		 * Grip position.
		 */
		protected var gripPosition:String = "top";

		/**
		* Indicates whether overlapping grips should automatically alternate between top and bottom positions.
		*/
		protected var alternateOverlappingGripPositions:Boolean = true;

		/**
		 * Container for background elements.
		 */
		protected var background:Sprite = null;

		/**
		 * Container for foreground elements.
		 */
		protected var foreground:Sprite = null;

		/**
		 * Background skin.
		 */
		protected var backgroundSkin:DisplayObject = null;

		/**
		 * Indicates whether the content has been updated.
		 */
		protected var contentUpdated:Boolean = false;

		/**
		 * BitmapData capture of the content.
		 */
		protected var contentBitmapData:BitmapData = null;

		/**
		 * Modified BitmapData capture of the content (for background).
		 */
		protected var modifiedContentBitmapData:BitmapData = null;

		/**
		 * DateRangeSliderThumb factory.
		 */
		protected var thumbPool:FactoryPool;

		[ArrayElementType("com.codecatalyst.component.date.DateRangeSliderThumb")]
		/**
		 * DateRangeSliderThumb(s) for the specified selectedDateRange / selectedDateRange(s).
		 */
		protected var thumbs:Array = [];

		// ========================================
		// Internal properties
		// ========================================

		/**
		 * Indicates whether this control is currently performing a drag operation.
		 */
		internal var isDragging:Boolean = false;

		// ========================================
		// Public properties
		// ========================================

		[Bindable( "contentChanged" )]
		/**
		 * Content.
		 */
		public function get content():DisplayObject
		{
			return _content;
		}

		public function set content( value:DisplayObject ):void
		{
			if ( _content != value )
			{
				if ( _content != null )
				{
					removeChild( _content );

					_content.removeEventListener( FlexEvent.UPDATE_COMPLETE, content_updateCompleteHandler );
				}

				_content = value;

				contentChanged = true;
				invalidateProperties();

				if ( _content != null )
				{
					addChildAt( _content, 0 );

					_content.addEventListener( FlexEvent.UPDATE_COMPLETE, content_updateCompleteHandler, false, 0, true );
				}

				dispatchEvent( new Event( "contentChanged" ) );
			}
		}

		[Bindable( "selectedDateRangesChanged" )]
		/**
		 * DateRange of selected Dates.
		 */
		public function get selectedDateRange():DateRange
		{
			try
			{
				return selectedDateRanges[ 0 ] as DateRange;
			}
			catch ( error:Error )
			{
				// NOTE: Intentionally ignored.
			}

			return null;
		}

		public function set selectedDateRange( value:DateRange ):void
		{
			if ( selectedDateRange != value )
			{
				_selectedDateRanges = [ value ];

				selectedDateRangesChanged = true;
				invalidateProperties();

				dispatchEvent( new Event( "selectedDateRangesChanged" ) );
			}
		}

		[ArrayElementType("com.codecatalyst.data.DateRange")]
		[Bindable("selectedDateRangesChanged")]
		/**
		 * Array of DateRange(s) of selected Dates.
		 */
		public function get selectedDateRanges():Array
		{
			return _selectedDateRanges;
		}

		public function set selectedDateRanges( value:Array ):void
		{
			if ( _selectedDateRanges != value )
			{
				_selectedDateRanges = value;

				selectedDateRangesChanged = true;
				invalidateProperties();

				dispatchEvent( new Event( "selectedDateRangesChanged" ) );
			}
		}

		[Bindable("selectableDateRangeChanged")]
		/**
		 * DateRange of selectable Dates.
		 */
		public function get selectableDateRange():DateRange
		{
			return _selectableDateRange;
		}

		public function set selectableDateRange( value:DateRange ):void
		{
			if ( _selectableDateRange != value )
			{
				_selectableDateRange = value;

				selectableDateRangeChanged = true;
				invalidateProperties();

				dispatchEvent( new Event( "selectableDateRangeChanged" ) );
			}
		}

		[Bindable("bitmapDataModifierChanged")]
		public function get bitmapDataModifier():Function
		{
			return _bitmapDataModifier;
		}

		public function set bitmapDataModifier( value:Function ):void
		{
			if ( _bitmapDataModifier != value )
			{
				_bitmapDataModifier = value;

				bitmapDataModifierChanged = true;
				invalidateProperties();

				dispatchEvent( new Event( "bitmapDataModifierChanged" ) );
			}
		}

		// ========================================
		// Constructor
		// ========================================

		/**
		 * Constructor.
		 */
		public function DateRangeSlider()
		{
			super();

			thumbPool = new FactoryPool( new ClassFactory( DateRangeSliderThumb, [ this, onPanThumb, onResizeThumb ] ) );

			background = new Sprite();
			foreground = new Sprite();
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

			// Background skin.

			if ( ( allStyles == true ) || ( styleProp == "backgroundSkin" ) )
			{
				loadBackgroundSkin( getStyle( "backgroundSkin" ) as Class );

				invalidateDisplayList();
			}

			// Grip position.

			if ( ( allStyles == true ) || ( styleProp == "gripPosition" ) )
			{
				gripPosition = getStyle( "gripPosition" );

				invalidateDisplayList();
			}

			// Alternate overlapping grip positions.

			if ( ( allStyles == true ) || ( styleProp == "alternateOverlappingGripPositions" ) )
			{
				alternateOverlappingGripPositions = getStyle( "alternateOverlappingGripPositions" );

				invalidateDisplayList();
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

			// Add the foreground and background containers.

			addChild( background );
			addChild( foreground );

			// Populate with thumbs.

			populateThumbs();
		}

		/**
		 * Populate this slider with DateRangeSliderThumb(s) for the current selectedDateRanges.
		 */
		protected function populateThumbs():void
		{
			// Remove any existing thumb(s).

			removeThumbs();

			// Add thumb(s).

			addThumbs();
		}

		[ArrayElementType("com.codecatalyst.component.date.DateRangeSliderThumb")]
		/**
		 * Add DateRangeSliderThumb(s) for the current selectedDateRanges.
		 */
		protected function addThumbs():void
		{
			for each ( var dateRange:DateRange in selectedDateRanges )
			{
				var thumb:DateRangeSliderThumb = thumbPool.acquireInstance();
				thumb.dateRange = dateRange;

				addChild( thumb );

				thumbs.push( thumb );
			}
		}

		/**
		 * Remove all child DateRangeSliderThumb(s).
		 */
		protected function removeThumbs():void
		{
			for ( var childIndex:int = 0; childIndex < numChildren; childIndex++ )
			{
				var child:DisplayObject = getChildAt( childIndex );
				if ( child is DateRangeSliderThumb )
				{
					var thumb:DateRangeSliderThumb = child as DateRangeSliderThumb;

					removeChildAt( childIndex );

					thumbPool.releaseInstance( thumb );

					childIndex--;
				}
			}

			thumbs = [];
		}

		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();

			if ( contentChanged )
			{
				contentUpdated = true;
			}

			if ( selectedDateRangesChanged )
			{
				populateThumbs();
			}

			if ( contentChanged || selectedDateRangesChanged || selectableDateRangeChanged )
			{
				invalidateDisplayList();

				contentChanged = false;
				selectedDateRangesChanged = false;
				selectableDateRangeChanged = false;
			}
		}

		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );

			var bounds:Rectangle = new Rectangle( 0, 0, unscaledWidth, unscaledHeight );

			// Draw and position the content.

			if ( content != null )
			{
				content.visible = true;

				SkinUtil.resize( content, unscaledWidth, unscaledHeight );
				SkinUtil.validate( content );
			}

			if ( contentUpdated )
			{
				captureContent();

				contentUpdated = false;
			}

			if ( content != null )
			{
				content.visible = false;
			}

			// Draw and position background elements.

			background.graphics.clear();

			if ( backgroundSkin != null )
			{
				SkinUtil.resize( backgroundSkin, unscaledWidth, unscaledHeight );
				SkinUtil.validate( backgroundSkin );
			}

			// Draw and position foreground elements.

			foreground.graphics.clear();

			// Draw (modified) content bitmap data.

			drawBitmapData(
				foreground.graphics,
				( modifiedContentBitmapData != null ) ? modifiedContentBitmapData : contentBitmapData,
				bounds
			);

			// Draw thumbs.

			for each ( var thumb:DateRangeSliderThumb in thumbs )
			{
				updateThumb( thumb );
			}

			updateThumbGrips();
		}

		/**
		 * Update the specified DateRangeSliderThumb by sizing and positioning it to match the associated DateRange.
		 */
		protected function updateThumb( thumb:DateRangeSliderThumb ):void
		{
			thumb.visible = ( ( thumb.dateRange != null ) && ( selectableDateRange != null ) );

			if ( thumb.visible )
			{
				var thumbRectangle:Rectangle = calculateThumbRectangle( thumb.dateRange, unscaledWidth, unscaledHeight );

				if ( RectangleUtil.isValid( thumbRectangle ) )
				{
					var thumbBackgroundFill:IFill = getStyle( "thumbBackgroundFill" );

					drawBitmapData( foreground.graphics, contentBitmapData, thumbRectangle, thumbBackgroundFill );

					thumb.setActualSize( thumbRectangle.width, thumbRectangle.height );
					thumb.move( thumbRectangle.x, thumbRectangle.y );

					thumb.invalidateDisplayList();
				}
			}
		}

		/**
		 * Update the DateRangeSliderThumb grips to stagger the grip position (top vs. bottom) for overlapping DateRangeSliderThumbs.
		 */
		protected function updateThumbGrips():void
		{
			if ( alternateOverlappingGripPositions )
			{
				var thumbsByX:Array = ArrayUtil.clone( thumbs );
				thumbsByX.sortOn( "x", Array.NUMERIC );

				var thumbCount:int = thumbsByX.length;
				var preceedingThumbOverlapped:Boolean = false;
				var overlappingThumbIndex:int = 0;
				for ( var thumbIndex:int = 0; thumbIndex < thumbCount; thumbIndex++ )
				{
					var sortedThumb:DateRangeSliderThumb = thumbsByX[ thumbIndex ] as DateRangeSliderThumb;

					if ( ! sortedThumb.visible )
						continue;

					// Determine if this thumb overlaps a subsequent thumb.

					var thumbOverlapsSubsequentThumb:Boolean = false;
					for ( var subsequentThumbIndex:int = thumbIndex + 1; subsequentThumbIndex < thumbCount; subsequentThumbIndex++ )
					{
						var subsequentThumb:DateRangeSliderThumb = thumbsByX[ subsequentThumbIndex ] as DateRangeSliderThumb;

						if ( ! subsequentThumb.visible )
							continue;

						if ( sortedThumb.dateRange.intersects( subsequentThumb.dateRange ) )
							thumbOverlapsSubsequentThumb = true;
					}

					// If so, increment the overlapping thumb index, otherwise reset it.

					if ( preceedingThumbOverlapped )
						overlappingThumbIndex++;
					else
						overlappingThumbIndex = 0;

					// Set the grip position by alternating based on the overlapping thumb index.

					var gripPositions:Array = ( gripPosition == "top" ) ? [ "top", "bottom" ] : [ "bottom", "top" ];

					sortedThumb.setStyle( "gripPosition", ( overlappingThumbIndex % 2 ) ? gripPositions[ 1 ] : gripPositions[ 0 ] );

					preceedingThumbOverlapped = thumbOverlapsSubsequentThumb;
				}
			}
			else
			{
				for each ( var thumb:DateRangeSliderThumb in thumbs )
				{
					thumb.setStyle( "gripPosition", gripPosition );
				}
			}
		}

		/**
		 * Calculate the thumb Rectangle, given the specified DateRange and component width and height.
		 */
		protected function calculateThumbRectangle( dateRange:DateRange, width:Number, height:Number ):Rectangle
		{
			var boundedDateRange:DateRange = selectableDateRange.createBoundedDateRange( dateRange );

			var rectangle:Rectangle = new Rectangle();

			rectangle.left   = ( ( boundedDateRange.startTime - selectableDateRange.startTime ) / selectableDateRange.duration ) * width;
			rectangle.right  = ( ( boundedDateRange.endTime   - selectableDateRange.startTime ) / selectableDateRange.duration ) * width;

			rectangle.height = height;

			return rectangle;
		}

		/**
		 * Load the background skin.
		 */
		protected function loadBackgroundSkin( skinClass:Class ):void
		{
			if ( backgroundSkin != null )
				background.removeChild( backgroundSkin as DisplayObject );

			backgroundSkin = SkinUtil.create( skinClass, this );

			if ( backgroundSkin != null )
			{
				background.addChild( backgroundSkin as DisplayObject );

				// NOTE: Since we are adding this skin to an internal non-Flex DisplayObjectContainer, simulate what LayoutManager would have done.

				SkinUtil.layout( backgroundSkin, this );
			}
		}

		/**
		 * Draws the specified BitmapData at the specified Rectangle (clipped by that Rectangle) on the specified Graphics context.
		 */
		protected function drawBitmapData( graphics:Graphics, bitmapData:BitmapData, rectangle:Rectangle, backgroundFill:IFill = null ):void
		{
			try
			{
				if ( bitmapData != null )
				{
					// Draw the background fill

					if ( backgroundFill != null )
					{
						graphics.lineStyle( 1, 0, 0, true );
						CONFIG::FLEX3 {
							backgroundFill.begin( graphics, rectangle );
						}
						CONFIG::FLEX4 {
							backgroundFill.begin( graphics, rectangle, null );
						}
						graphics.drawRect( rectangle.x, rectangle.y, rectangle.width, rectangle.height );
						backgroundFill.end( graphics );
					}

					// Draw the bitmap

					graphics.lineStyle( 1, 0, 0, true );
					graphics.beginBitmapFill( bitmapData, new Matrix(), false, true );
					graphics.drawRect( rectangle.x, rectangle.y, rectangle.width, rectangle.height );
					graphics.endFill();
				}
			}
			catch ( error:Error )
			{
				// NOTE: Intentionally ignored.
			}
		}

		/**
		 * Capture a snapshot of <code>content</code>.
		 */
		protected function captureContent():void
		{
			// Clean up (if applicable).

			if ( contentBitmapData != null )
			{
				contentBitmapData.dispose();
				contentBitmapData = null;
			}

			if ( modifiedContentBitmapData != null )
			{
				modifiedContentBitmapData.dispose();
				modifiedContentBitmapData = null;
			}

			if ( content != null )
			{
				// Capture the content to a BitmapData instance.

				contentBitmapData = ImageSnapshot.captureBitmapData( content );

				// Create a modified version for background.

				modifiedContentBitmapData = ( bitmapDataModifier != null ) ? bitmapDataModifier( contentBitmapData.clone() ) : null;
			}

			invalidateDisplayList();
		}

		/**
		 * Pan callback from DateRangeSliderThumb.
		 */
		protected function onPanThumb( thumb:DateRangeSliderThumb, complete:Boolean ):void
		{
			// TODO: Investigate making this cancelable.

			var index:int = thumbs.indexOf( thumb );

			updateSelectedDateRangesWithDateRange( thumb.dateRange, index );

			var dateRangeSliderEvent:DateRangeSliderEvent = new DateRangeSliderEvent( DateRangeSliderEvent.DATE_RANGE_PANNED );

			dateRangeSliderEvent.dateRange = thumb.dateRange;
			dateRangeSliderEvent.index = index;
			dateRangeSliderEvent.complete = complete;

			dispatchEvent( dateRangeSliderEvent );
		}

		/**
		 * Resize callback from DateRangeSliderThumb.
		 */
		protected function onResizeThumb( thumb:DateRangeSliderThumb, complete:Boolean ):void
		{
			// TODO: Investigate making this cancelable.

			var index:int = thumbs.indexOf( thumb );

			updateSelectedDateRangesWithDateRange( thumb.dateRange, index );

			var dateRangeSliderEvent:DateRangeSliderEvent = new DateRangeSliderEvent( DateRangeSliderEvent.DATE_RANGE_RESIZED );

			dateRangeSliderEvent.dateRange = thumb.dateRange;
			dateRangeSliderEvent.index = index;
			dateRangeSliderEvent.complete = complete;

			dispatchEvent( dateRangeSliderEvent );
		}

		/**
		 * Update the selectedDateRanges with the specified DateRange at the specified index.
		 */
		protected function updateSelectedDateRangesWithDateRange( dateRange:DateRange, index:int = 0 ):void
		{
			var modifiedDateRanges:Array = ArrayUtil.clone( selectedDateRanges );
			modifiedDateRanges[ index ] = dateRange;

			_selectedDateRanges = modifiedDateRanges;

			invalidateDisplayList();

			dispatchEvent( new Event( "selectedDateRangesChanged" ) );
		}

		/**
		 * Handle content FlexEvent.UPDATE_COMPLETE.
		 */
		protected function content_updateCompleteHandler( event:FlexEvent ):void
		{
			contentUpdated = true;

			invalidateDisplayList();
		}
	}
}