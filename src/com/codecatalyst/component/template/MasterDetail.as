package com.codecatalyst.component.template
{
	import com.codecatalyst.util.invalidation.InvalidationTracker;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
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
		
		/**
		 * The percentage width or height value to use when expanding/showing the Detail view.
		 */
		[Bindable("expandToChanged")]
		public function get percentExpandTo():Number {
			return _percentExpandTo;
		}
		public function set percentExpandTo(val:Number):void {
			if (val != _percentExpandTo) {
				if (val < 0) val = 0;
				if (val > 1) val = val / 100;
				
				_percentExpandTo = val;
				_expandTo        = NaN;
				
				dispatchEvent(new Event('expandToChanged'));
			}
		}
		
		/**
		 * 
		 */
		[Bindable("expandToChanged")]
		[PercentProxy("percentExpandTo")]
		/**
		 * The default width or height to target when expanding the detail view.
		 */
		public function get expandTo():Number {
			return _expandTo;
		}
		public function set expandTo(val:Number):void {
			if (val != _expandTo) {
				_expandTo 		 = val > 0 ? val : 0;
				_percentExpandTo = NaN;
				
				dispatchEvent(new Event('expandToChanged'));
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
			
			// Create and initialize InvalidationTracker.
			
			changes = new InvalidationTracker( this );
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
			
			if ( changes.invalidated( [ "master", "detail" ] ) )
			{
				removeAllChildren();
				
				addChild( ( master != null ) ? master as DisplayObject : new Canvas() );
				
				master.percentWidth = master.percentHeight = 100;
				
				if ( detail != null )
				{
					addChild ( detail as DisplayObject );
					
					if ( layoutObject.direction == BoxDirection.VERTICAL )  detail.height = this.desiredHeight;
					else													detail.width  = this.desiredWidth;
						
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
			
			if ( changes.invalidated( "expanded" ) )
			{
				updateDetailView();
			}
		}
		
		/**
		 * Update the detail view to reflect the current <code>expanded</code> state.
		 */
		protected function updateDetailView():void
		{
			if ( detail == null )  return;
			
			if ( expanded != detail.visible )
			{
				if ( expanded )
					detail.visible = true;
				
				if ( resizeEffect.isPlaying ) 
					resizeEffect.pause();
				
				resizeEffect.target   		= detail;
				resizeEffect.duration 		= animate ? resizeDuration 			: 0;
				resizeEffect.easingFunction = animate ? resizeEasingFunction	: null;
				resizeEffect.widthTo  		= ( layoutObject.direction == BoxDirection.VERTICAL ) ? Number.NaN			: this.desiredWidth;
				resizeEffect.heightTo 		= ( layoutObject.direction == BoxDirection.VERTICAL ) ? this.desiredHeight	: Number.NaN;
				
				resizeEffect.play();
			}
		}
		
		/**
		 * Handle EffectEvent.EFFECT_END.
		 */
		protected function resizeEffect_effectEndHandler( event:EffectEvent ):void
		{
			if ( ! expanded )
			{
				if ( detail != null )
					detail.visible = false;
			}
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
			
			if ( Math.abs( event.delta ) < DELTA_THRESHOLD )
			{
				expanded = ! expanded;
			}
		}

		
		// ========================================
		// Protected properties
		// ========================================
		
		protected function get desiredHeight():Number {
			return	( !expanded 	  ) 		? 0  						  	:
					( isNaN(expandTo) ) 		? percentExpandTo * height 	:
					( isNaN(percentExpandTo) )  ? expandTo                      : 0;
		}
		
		protected function get desiredWidth():Number {
			return  ( !expanded 	  ) 		? 0  						  	:	
					( isNaN(expandTo) ) 		? percentExpandTo * width   :
					( isNaN(percentExpandTo) )  ? expandTo                    	: 0;			
		}
		
		
		/**
		 * Invalidation tracker.
		 */
		protected var changes:InvalidationTracker = null;
		
		/**
		 * Resize effect.
		 */
		protected var resizeEffect:Resize = null;

		
		// ========================================
		// Protected constants
		// ========================================
		
		/**
		 * Divider toggle threshold.
		 */
		protected static const DELTA_THRESHOLD:int = 3;

		
		// ========================================
		// Static initializers
		// ========================================
		
		/**
		 * Static initializer for default CSS styles.
		 */
		protected static var stylesInitialized:Boolean = initializeStyles();
		
		protected static function initializeStyles():Boolean
		{
			var declaration:CSSStyleDeclaration = StyleManager.getStyleDeclaration( "MasterDetail" ) || new CSSStyleDeclaration();
			
			declaration.defaultFactory = 
				function ():void
				{
					this.horizontalScrollPolicy = ScrollPolicy.OFF;
					this.verticalScrollPolicy   = ScrollPolicy.OFF;
				};
			
			StyleManager.setStyleDeclaration( "MasterDetail", declaration, false );
			
			return true;
		}
		

		
		private var _percentExpandTo : Number = 0.5;
		private var _expandTo        : Number = NaN;
		
	}
}