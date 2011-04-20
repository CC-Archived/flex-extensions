////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011 CodeCatalyst, LLC - http://www.codecatalyst.com/
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

package com.codecatalyst.component.template
{
	import com.codecatalyst.util.NumberUtil;
	import com.codecatalyst.util.StyleUtil;
	import com.codecatalyst.util.invalidation.InvalidationTracker;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.binding.BindingManager;
	import mx.containers.BoxDirection;
	import mx.containers.Canvas;
	import mx.containers.DividedBox;
	import mx.core.IUIComponent;
	import mx.core.ScrollPolicy;
	import mx.core.mx_internal;
	import mx.effects.Resize;
	import mx.effects.easing.Quartic;
	import mx.events.DividerEvent;
	import mx.events.EffectEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	use namespace mx_internal;
	
	[Event(name="resizeStart",type="flash.events.Event")]
	[Event(name="resizeComplete",type="flash.events.Event")]
	/**
	 * Master / Detail view template.
	 * 
	 * @author Thomas Burleson
	 * @author John Yanarella
	 */
	public class MasterDetail extends DividedBox
	{
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable]
		/**
		 * If animate is true, then the Resize tweening is enabled, otherwise the tweening duration is zero. 
		 */
		public var animate:Boolean = true;
		
		[Bindable]
		/**
		 * Resize animation duration.
		 */
		public var resizeDuration:Number = 1000;
		
		[Bindable]
		/**
		 * Resize animation easing function.
		 */
		public var resizeEasingFunction:Function = Quartic.easeInOut;
		
		[Bindable("expandToChanged")]
		/**
		 * The default percentage width or height to use when expanding the Detail view.
		 */
		public function get percentExpandTo():Number
		{
			return _percentExpandTo;
		}
		
		public function set percentExpandTo( value:Number ):void
		{
			if ( _percentExpandTo != value )
			{
				if ( value < 0 ) value = 0;
				if ( value > 1 ) value = value / 100;
				
				_percentExpandTo = value;
				_expandTo        = NaN;
				
				dispatchEvent( new Event( "expandToChanged" ) );
			}
		}
		
		[Bindable("expandToChanged")]
		[PercentProxy("percentExpandTo")]
		/**
		 * The default width or height to use when expanding the Detail view.
		 */
		public function get expandTo():Number
		{
			return _expandTo;
		}
		
		public function set expandTo( value:Number ):void
		{
			if ( _expandTo != value  )
			{
				_expandTo 		 = value > 0 ? value : 0;
				_percentExpandTo = NaN;
				
				dispatchEvent( new Event( "expandToChanged" ) );
			}
		}
		
		[Bindable]
		[Invalidate("displaylist")]
		/**
		 * Mutators to toggle the visibility of the lower detail view component 
		 */
		public var expanded:Boolean = false;
		
		[Bindable]
		[Invalidate("displaylist,properties")]
		/**
		 * UIComponent instance that will be displayed in the upper "master" view 
		 */
		public var master:IUIComponent = null;
		
		[Bindable]
		[Invalidate("displaylist,properties")]
		/**
		 * UIComponent instance that will be displayed in the lower "detail" view 
		 */
		public var detail:IUIComponent = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function MasterDetail()
		{
			super();
			
			// Default width and height to 100%.
			
			percentHeight = percentWidth = 100;
			
			// Create and initialize resize effect instance.
			
			resizeEffect = new Resize();
			resizeEffect.easingFunction = Quartic.easeInOut;
			resizeEffect.addEventListener( EffectEvent.EFFECT_END, resizeEffect_effectEndHandler, false, 0, true );
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
			
			addEventListener( DividerEvent.DIVIDER_RELEASE, dividerReleaseHandler, false, 0, true );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			// Update master and detail views.
			
			if ( propertyTracker.invalidated( [ "master", "detail" ] ) )
			{
				removeAllChildren();
				
				addChild( master as DisplayObject || new Canvas() );
				
				master.percentWidth = master.percentHeight = 100;
				
				if ( detail != null )
				{
					addChild ( detail as DisplayObject );
					
					if ( layoutObject.direction == BoxDirection.VERTICAL )    detail.height = calculatedDetailHeight;
					if ( layoutObject.direction == BoxDirection.HORIZONTAL )  detail.width  = calculatedDetailWidth;
					
					detail.visible = expanded;
				}
				
				setDividerVisiblity( detail != null );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			// Update the details view to reflect the invalidated expanded property value.
			
			if ( propertyTracker.invalidated( ["detail", "expanded"] ) )
			{
				updateDetailView();
			}
		}
		
		/**
		 * Update the detail view to reflect the current <code>expanded</code> state.
		 */
		protected function updateDetailView():void
		{
			if ( detail == null ) return;
			
			if ( expanded != detail.visible )
			{
				if ( expanded ) {		
					BindingManager.setEnabled(detail,true);
					
					detail.visible = true;
					if (detail.parent == null) addChild ( detail as DisplayObject );
				}
				
				if ( resizeEffect.isPlaying ) 
					resizeEffect.pause();
				
				resizeEffect.target   		= detail;
				resizeEffect.duration 		= animate ? resizeDuration       : 0;
				resizeEffect.easingFunction = animate ? resizeEasingFunction : null;
				resizeEffect.widthTo  		= calculatedDetailWidth;
				resizeEffect.heightTo 		= calculatedDetailHeight;
				
				resizeEffect.play();
				
				dispatchEvent(new Event('resizeStart'));
			}
		}
		
		/**
		 * Handle EffectEvent.EFFECT_END.
		 * Disable databindings and remove from displayList AFTER the resize finishes hiding.
		 */
		protected function resizeEffect_effectEndHandler( event:EffectEvent ):void
		{
			if ( ! expanded )
			{
				if ( detail && detail.parent )
				{
					BindingManager.setEnabled(detail,false);

					removeChild( detail as DisplayObject);
					detail.visible = false;
				}
			}
			
			dispatchEvent(new Event('resizeComplete'));
		}
		
		/**
		 * Show divider between master and detail views.
		 */
		protected function setDividerVisiblity( visible:Boolean ):void
		{
			setStyle( "verticalGap",       visible ? 8 : 0 );
			setStyle( "dividerAffordance", visible ? 5 : 0 );
		}
		
		/**
		 * Handle DividerEvent.DIVIDER_RELEASE.
		 */
		protected function dividerReleaseHandler( event:DividerEvent ):void 
		{
			// If the divider moves less than the toggle threshold, treat it as a 'click' and toggle expansion.
			
			if ( Math.abs( event.delta ) < DIVIDER_DELTA_THRESHOLD )
			{
				expanded = ! expanded;
			}
		}

		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>expandTo</code> property.
		 * 
		 * @see #expandTo
		 */
		protected var _expandTo:Number = NaN;
		
		/**
		 * Backing variable for <code>percentExpandTo</code> property.
		 * 
		 * @see #percentExpandTo
		 */
		protected var _percentExpandTo : Number = 0.5;
		
		/**
		 * Calculated detail height.
		 */
		protected function get calculatedDetailHeight():Number
		{
			if ( layoutObject.direction == BoxDirection.VERTICAL )
			{
				if ( expanded )
					return NumberUtil.sanitizeNumber( NumberUtil.sanitizeNumber( expandTo, percentExpandTo * height ), 0 );
				else
					return 0;
			}
			else // ( layoutObject.direction == BoxDirection.HORIZONTAL )
			{
				return Number.NaN;
			}
		}
		
		/**
		 * Calculated detail width.
		 */
		protected function get calculatedDetailWidth():Number
		{
			if ( layoutObject.direction == BoxDirection.HORIZONTAL )
			{
				if ( expanded )
					return NumberUtil.sanitizeNumber( NumberUtil.sanitizeNumber( expandTo, percentExpandTo * width ), 0 );
				else
					return 0;
			}
			else // ( layoutObject.direction == BoxDirection.VERTICAL )
			{
				return Number.NaN;
			}		
		}
		
		/**
		 * Invalidation tracker.
		 */
		protected var propertyTracker:InvalidationTracker = new InvalidationTracker( this as IEventDispatcher );
		
		/**
		 * Resize effect.
		 */
		protected var resizeEffect:Resize = null;
		
		// ========================================
		// Protected constants
		// ========================================
		
		/**
		 * Divider delta threshold.
		 */
		protected static const DIVIDER_DELTA_THRESHOLD:int = 3;
		
		// ========================================
		// Static initializers
		// ========================================
		
		/**
		 * Static initializer for default CSS styles.
		 */
		protected static var stylesInitialized:Boolean = initializeStyles();
		
		protected static function initializeStyles():Boolean
		{
			var declaration:CSSStyleDeclaration = StyleUtil.getStyleDeclaration( "MasterDetail" ) || new CSSStyleDeclaration();
			
			declaration.defaultFactory = 
				function ():void
				{
					this.horizontalScrollPolicy = ScrollPolicy.OFF;
					this.verticalScrollPolicy   = ScrollPolicy.OFF;
				};
			
			StyleUtil.setStyleDeclaration( "MasterDetail", declaration, false );
			
			return true;
		}
		
	}
}