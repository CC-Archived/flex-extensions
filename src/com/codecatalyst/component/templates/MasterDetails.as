package com.codecatalyst.component.templates
{
	import com.codecatalyst.factory.UIClassFactory;
	import com.codecatalyst.util.invalidation.InvalidationTracker;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	import mx.containers.BoxDirection;
	import mx.containers.Canvas;
	import mx.containers.DividedBox;
	import mx.core.IUIComponent;
	import mx.core.mx_internal;
	import mx.effects.Resize;
	import mx.effects.easing.Quartic;
	import mx.events.DividerEvent;
	import mx.events.EffectEvent;
	
	/**
	 * ATTENTION: Only vertical layout is currently supported
	 *            Disabling animation or changing speed is not yet supported! 
	 */
	public class MasterDetails extends DividedBox {		
		
		// ***********************************************************************************************
		// Public Properties
		// ***********************************************************************************************
		
		/**
		 * If animate is true, then the Resize tweening is enabled
		 * otherwise the tweening duration is zero. 
		 */
		public var enableTween : Boolean = true; 
		
		/**
		 * When expanded, the detail component will have its height animated to 
		 * to the heightTo value  
		 */
		public function get heightTo():Number {
			return Math.round( isNaN(_heightTo) ? (this.height * .65) : _heightTo);
		}
		public function set heightTo(value:Number):void {
			_heightTo = (value < 0) ? NaN : value;
		}
		
		/**
		 * Mutators to toggle the visibility of the lower detail view component 
		 */
		[Bindable]
		[Invalidate("displaylist")]
		public var expanded : Boolean = false;
		
		/**
		 * UIComponent instance that will be displayed in the upper "master" view 
		 */
		[Bindable]
		[Invalidate("displaylist,size,properties")]
		public var master : IUIComponent = null;
		
		/**
		 * UIComponent instance that will be displayed in the lower "detail" view 
		 */
		[Bindable]
		[Invalidate("displaylist,size,properties")]
		public var detail : IUIComponent = null;
		
		
		// ***********************************************************************************************
		// Constructor
		// ***********************************************************************************************
		
		/**
		 * Constructor defaults to vertical layout
		 */
		public function MasterDetails() {
			super();
			
			percentHeight = percentWidth = 100;
			visible       = true;
			
			setStyle("verticalGap"		, 0);
			setStyle("dividerAffordance", 0);
			setStyle("horizontalScrollPolicy", "off");
			setStyle("verticalScrollPolicy"	 , "off");
			
			mx_internal::layoutObject.direction = BoxDirection.VERTICAL;
			
		}
		
		// ***********************************************************************************************
		// Protected Override Methods
		// ***********************************************************************************************
		
		override protected function createChildren():void {
			super.createChildren();
			
			_resizer = new Resize();
			_resizer.duration = 1000;
			_resizer.easingFunction = Quartic.easeInOut;
			_resizer.addEventListener(EffectEvent.EFFECT_END,onResizeFinished,false,0,true);
			
			addEventListener(DividerEvent.DIVIDER_RELEASE, onDividerRelease, false, 0, true);
		}
		
		
		override protected function commitProperties():void {
			super.commitProperties();
			
			if ( _changes.invalidated(["master","detail"]) ) {
				var oldDetail : DisplayObject = _changes.previousValue("detail") as DisplayObject;
				var oldHeight : int           = oldDetail ? oldDetail.height : 0;
				
				removeAllChildren();
				addChild( (master ? master : _factory.newInstance()) as DisplayObject );
				
				if (detail != null) {
					addChild ( detail as DisplayObject );
					
					detail.height    = oldHeight;
					detail.visible &&= (oldHeight != 0);
				}
			}
			
			_resizer.target = detail;
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			if ( _changes.invalidated("expanded") ) showDetailsView(expanded);
		}
		
		// ***********************************************************************************************
		// Protected Methods
		// ***********************************************************************************************
		
		protected function onResizeFinished(event:EffectEvent):void {
			if (detail == null) return;
			
			if (detail.height == 0) {
				
				setStyle("verticalGap"		, 0);
				setStyle("dividerAffordance", 0);
				
				detail.visible = false;
			}
			
			dispatchEvent(new Event("expandedChange"));
			
		}
		
		protected function onDividerRelease(event:DividerEvent):void  {
			if (Math.abs(event.delta) < 3) showDetailsView(false);
		}
		
		// ***********************************************************************************************
		// Private Methods
		// ***********************************************************************************************
		
		protected function showDetailsView(show:Boolean):void {
			if (detail == null) 				return;
			
			if (!show && !detail.visible) 		return;
			if ( show &&  detail.visible)		return;
			
			if (show == true) {
				detail.visible = true;
				
				setStyle("verticalGap"		, 8);
				setStyle("dividerAffordance", 5);
			} 
			
			if (_resizer.isPlaying == true) _resizer.stop();
			
			_resizer.heightTo = show ? heightTo : 0;
			_resizer.target   = detail;
			_resizer.duration = enableTween ? 1000 : 0;
			_resizer.play();					
		}
		
		// ***********************************************************************************************
		// Private Attributes
		// ***********************************************************************************************
		
		private var _resizer 		: Resize		= null;   
		private var _heightTo 		: Number 		= NaN;
		
		private var _changes        : InvalidationTracker 	= new InvalidationTracker(this as IEventDispatcher);
		private var _factory        : UIClassFactory		= new UIClassFactory(Canvas,{percentHeight:100,percentWidth:100});
	}
}