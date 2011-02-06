////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008 CodeCatalyst, LLC - http://www.codecatalyst.com/
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

package com.codecatalyst.component.renderer
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.containers.Canvas;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.ListBase;
	import mx.core.IStateClient;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;
			
	use namespace mx_internal;

	/**
	 *  Name of the class to use as the default skin for the background and border. 
	 *  @default "mx.skins.halo.HaloBorder"
	 */
	[Style( name="borderSkin", type="Class", inherit="no", states="up, over, down, disabled, selectedUp, selectedOver, selectedDown, selectedDisabled" )]
	
	public class CanvasItemRenderer extends Canvas implements IContainerItemRenderer
	{
		// ========================================
		// Protected properties
		// ========================================

		/**
		 * Backing variable for <code>isMouseOver</code> property.
		 */
		protected var _isMouseOver:Boolean = false;

		/**
		 * Backing variable for <code>isMouseDown</code> property.
		 */
		protected var _isMouseDown:Boolean = false;
		
		/**
		 * Backing variable for <code>isHighlighted</code> property.
		 */
		protected var _isHighlighted:Boolean = false;

		/**
		 * Backing variable for <code>isSelected</code> property.
		 */
		protected var _isSelected:Boolean = false;
		
		/**
		 * Backing variable for <code>listData</code> property.
		 */
		protected var _listData:BaseListData;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable( "isMouseOverChanged" )]
		/**
		 * @inheritDoc
		 */
		public function get isMouseOver():Boolean
		{
			return _isMouseOver;
		}

		[Bindable( "isMouseDownChanged" )]
		/**
		 * @inheritDoc
		 */
		public function get isMouseDown():Boolean
		{
			return _isMouseDown;
		}

		[Bindable( "isHighlightedChanged" )]
		/**
		 * @inheritDoc
		 */
		public function get isHighlighted():Boolean
		{
			return _isHighlighted;
		}

		[Bindable( "isSelectedChanged" )]
		/**
		 * @inheritDoc
		 */
		public function get isSelected():Boolean
		{
			return _isSelected;
		}

		[Bindable( "dataChange" )]
		/**
		 * List data.
		 */
		public function get listData():BaseListData
		{
			return _listData;
		}
		
		public function set listData( value:BaseListData ):void
		{
			_listData = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set styleName( value:Object ):void
		{
			// Workaround for bug in the standard Flex components that cause them to overwrite a pre-existing styleName attribute value with a component reference.
			
			if ( ( ( ! initialized ) && ( styleName != null ) && ( styleName is String ) ) && ! ( value is String ) )
				return;
			
			super.styleName = value;
		}
		
		// ========================================
		// Constructor
		// ========================================

		/**
		 * Constructor
		 */
		public function CanvasItemRenderer()
		{
			super();
			
			horizontalScrollPolicy = ScrollPolicy.OFF;
			verticalScrollPolicy = ScrollPolicy.OFF;
			
			addEventListener( MouseEvent.ROLL_OVER,  rollOverHandler,  false, 0, true );
			addEventListener( MouseEvent.ROLL_OUT,   rollOutHandler,   false, 0, true );
			addEventListener( MouseEvent.MOUSE_DOWN, mouseDownHandler, false, 0, true );
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

			if ( ( _listData != null ) && ( _listData.owner is ListBase ) )
			{
				var listBase:ListBase = _listData.owner as ListBase;
				
				setHighlighted( listBase.isItemHighlighted( data ) );
				setSelected( listBase.isItemSelected( data ) );
			}
						
			if ( border != null )
			{
				if ( border is mx.core.IStateClient )
					( border as mx.core.IStateClient ).currentState = getCurrentState();
			}
		}
		
		/**
		 * Handle MouseEvent.MOUSE_DOWN
		 */
		protected function mouseDownHandler( event:MouseEvent ):void
		{
			setMouseDown( true );
			
			systemManager.addEventListener( MouseEvent.MOUSE_UP, mouseUpHandler, false, 0, true );
			
			event.updateAfterEvent();
		}

		/**
		 * Handle MouseEvent.MOUSE_UP
		 */
		protected function mouseUpHandler( event:MouseEvent ):void
		{
			setMouseDown( false );
			
			systemManager.removeEventListener( MouseEvent.MOUSE_UP, mouseUpHandler );
			
			event.updateAfterEvent();
		}

		/**
		 * Handle MouseEvent.ROLL_OVER
		 */
		protected function rollOverHandler( event:MouseEvent ):void
		{
			setMouseOver( true );

			event.updateAfterEvent();
		}
		
		/**
		 * Handle MouseEvent.ROLL_OUT
		 */
		protected function rollOutHandler( event:MouseEvent ):void
		{
			setMouseOver( false );
			setMouseDown( false );

			event.updateAfterEvent();
		}
		
		/**
		 * Internal setter for <code>isMouseOver</code> property.
		 */
		protected function setMouseOver( value:Boolean ):void
		{
			if ( _isMouseOver != value )
			{
				_isMouseOver = value;
				dispatchEvent( new Event( "isMouseOverChanged" ) );

				invalidateDisplayList();
			}
		}			

		/**
		 * Internal setter for <code>isMouseDown</code> property.
		 */
		protected function setMouseDown( value:Boolean ):void
		{
			if ( _isMouseDown != value )
			{
				_isMouseDown = value;
				dispatchEvent( new Event( "isMouseDownChanged" ) );

				invalidateDisplayList();
			}
		}
					
		/**
		 * Internal setter for <code>isHighlighted</code> property.
		 */
		protected function setHighlighted( value:Boolean ):void
		{
			if ( _isHighlighted != value )
			{
				_isHighlighted = value;
				dispatchEvent( new Event( "isHighlightedChanged" ) );
				
				invalidateDisplayList();
			}
		}
		
		/**
		 * Internal setter for <code>isSelected</code> property.
		 */
		protected function setSelected( value:Boolean ):void
		{
			if ( _isSelected != value )
			{
				_isSelected = value;
				dispatchEvent( new Event( "isSelectedChanged" ) );
				
				invalidateDisplayList();
			}
		}
		
		/**
		 * Get the current state based on component property state.
		 * 
		 * @returns The current state. 
		 */
		protected function getCurrentState():String
		{
			var stateName:String = null;
			
			if (!enabled)
			{
				stateName = isSelected ? "selectedDisabled" : "disabled";
			}
			else if ( isMouseDown )
			{
				stateName = isSelected ? "selectedDown" : "down";
			}
			else if ( isMouseOver )
			{
				stateName = isSelected ? "selectedOver" : "over";
			}
			else
			{
				stateName = isSelected ? "selectedUp" : "up";
			}
			
			return stateName;
		}
	}
}