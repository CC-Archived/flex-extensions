package com.codecatalyst.component.templates
{
	import com.codecatalyst.factory.UIClassFactory;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
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
		 * When expanded, the detail component will have its height animated to 
		 * to the heightTo value  
		 */
		public function get heightTo():Number {
			return Math.round( isNaN(_heightTo) ? (this.height * .65) : _heightTo);
		}
		public function set heightTo(value:Number):void {
			_heightTo = (value < 0) ? NaN : value;
		}

		[Bindable("expandedChange")]
		public function get expanded():Boolean {
			return _show; 
		}
		public function set expanded(val:Boolean):void {
			if (val != _show) {
				_show = val;
				_showChanged = true;
				
				invalidateProperties();
			}
		}
		
		/**
		 * Mutators for the "master" view 
		 */
		public function get master():IUIComponent {
			return _master;
		}
		public function set master(value:IUIComponent):void {
			if (value === _master) return;
			
			_master        = value;
			_masterChanged = true;
			
			invalidateProperties();
		}

		/**
		 * Mutators for the "detail" view 
		 */
		public function get detail():IUIComponent {			
			return _detail;
		}
		public function set detail(value:IUIComponent):void {
			if (value === _detail) return;
			_detail 		= value;
			_detailChanged 	= true;
		}
		
		
		// ***********************************************************************************************
		// Constructor
		// ***********************************************************************************************
		
		/**
		 * Constructor defaults to vertical layout
		 */
		public function MasterDetails() {
			super();
			
			mx_internal::layoutObject.direction = BoxDirection.VERTICAL;
			
			percentHeight = percentWidth = 100;
			visible       = true;
			
			setStyle("verticalGap"		, 0);
			setStyle("dividerAffordance", 0);
			setStyle("horizontalScrollPolicy", "off");
			setStyle("verticalScrollPolicy"	 , "off");
			
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
			
			if (_masterChanged || _detailChanged) {
				var oldHeight : Number = (_detail ? _detail.height : 0);
				
				removeAllChildren();
				addChild( (_master ? _master : _factory.newInstance()) as DisplayObject );
				
				if (_detail != null) {
					addChild ( _detail as DisplayObject );
					
					_detail.height    = oldHeight;
					_detail.visible &&= (oldHeight != 0);
				}

				_masterChanged = false;
				_detailChanged = false;
			}
			
			_resizer.target = _detail;
			
			invalidateSize();
			invalidateDisplayList();
		}
		
		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
			super.updateDisplayList(unscaledWidth,unscaledHeight);
			
			if (_showChanged == true) {
				_showChanged = false;
				showDetailsView(_show);
			}
		}
		
		// ***********************************************************************************************
		// Protected Methods
		// ***********************************************************************************************

		protected function onResizeFinished(event:EffectEvent):void {
			if (_detail == null) return;
			
			if (_detail.height == 0) {
				
				setStyle("verticalGap"		, 0);
				setStyle("dividerAffordance", 0);
				
				_detail.visible = false;
				_show           = false;
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
			if (_detail == null) 				return;
			if (!show && !_detail.visible) 		return;
			if ( show &&  _detail.visible)		return;
			
			if (show == true) {
				_detail.visible = true;
				
				setStyle("verticalGap"		, 8);
				setStyle("dividerAffordance", 5);
			} 
			
			if (_resizer.isPlaying == true) _resizer.stop();
			
			_resizer.heightTo = show ? heightTo : 0;
			_resizer.target   = _detail;
			_resizer.play();					
		}

		// ***********************************************************************************************
		// Private Attributes
		// ***********************************************************************************************
		
		private var _show			: Boolean       = false;
		private var _showChanged    : Boolean       = false;
		
		private var _resizer 		: Resize		= null;   
		
		private var _master 		: IUIComponent 	= null;
		private var _detail 		: IUIComponent 	= null;

		private var _masterChanged 	: Boolean 		= true;
		private var _detailChanged 	: Boolean 		= true;
		
		
		private var _heightTo 		: Number 		= NaN;
		
		private var _factory        : UIClassFactory= new UIClassFactory(Canvas,{percentHeight:100,percentWidth:100});
	}
}