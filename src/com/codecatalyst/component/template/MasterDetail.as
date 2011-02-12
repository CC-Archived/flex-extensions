package com.codecatalyst.component.template
{
	import com.codecatalyst.util.invalidation.InvalidationTracker;
	
	import flash.display.DisplayObject;
	
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
		// Protected constants
		// ========================================

		/**
		 * Divider toggle threshold.
		 */
		protected static const DIVIDER_TOGGLE_THRESHOLD:int = 3;
		
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
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Invalidation tracker.
		 */
		protected var changes:InvalidationTracker = null;
		
		/**
		 * Resize effect.
		 */
		protected var resizeEffect:Resize = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable]
		/**
		 * If animate is true, then the Resize tweening is enabled, otherwise the tweening duration is zero. 
		 */
		public var animate:Boolean = true;
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * Resize animation duration.
		 */
		public var resizeDuration:Number = 1000;
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * Resize animation easing function.
		 */
		public var resizeEasingFunction:Function = Quartic.easeInOut;
		
		[Bindable]
		[PercentProxy("expandToPercentage")]
		/**
		 * The default width or height percentange to use when expanding the detail view.
		 */
		public var expandToPercentage:Number = 0.5;
		
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
			
			// Update resizeEffect easing function to reflect resizeEasingFunction property value.
			
			if ( changes.invalidated( "resizeEasingFunction" ) )
			{
				resizeEffect.easingFunction = resizeEasingFunction;
			}
			
			// Update master and detail views.
			
			if ( changes.invalidated( "master" ) || changes.invalidated( "detail" ) )
			{
				removeAllChildren();
				
				addChild( ( master != null ) ? master as DisplayObject : new Canvas() );
				
				master.percentWidth = master.percentHeight = 100;
				
				if ( detail != null )
				{
					addChild ( detail as DisplayObject );
					
					if ( layoutObject.direction == BoxDirection.VERTICAL )
					{
						detail.height = ( expanded ) ? expandToPercentage * height : 0;
					}
					else // ( layoutObject.direction == BoxDirection.HORIZONTAL )
					{
						detail.width  = ( expanded ) ? expandToPercentage * width : 0;
					}
						
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
			if ( detail == null )
				return;
			
			if ( expanded != detail.visible )
			{
				if ( expanded )
					detail.visible = true;
				
				if ( resizeEffect.isPlaying ) 
					resizeEffect.pause();
				
				resizeEffect.duration = animate ? resizeDuration : 0;
				resizeEffect.target   = detail;

				if ( layoutObject.direction == BoxDirection.VERTICAL )
				{
					resizeEffect.widthTo  = Number.NaN;
					resizeEffect.heightTo = expanded ? expandToPercentage * height : 0;
				}
				else // ( layoutObject.direction == BoxDirection.HORIZONTAL )
				{
					resizeEffect.widthTo  = expanded ? expandToPercentage * width : 0;
					resizeEffect.heightTo = Number.NaN;
				}
				
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
			
			if ( Math.abs( event.delta ) < DIVIDER_TOGGLE_THRESHOLD )
			{
				expanded = ! expanded;
			}
		}
	}
}