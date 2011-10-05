package com.codecatalyst.util
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.GradientType;
	import flash.display.Graphics;
	import flash.display.InterpolationMethod;
	import flash.display.SpreadMethod;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.core.Container;
	import mx.core.IChildList;
	import mx.core.IRawChildrenContainer;
	import mx.core.UIComponent;
	import mx.graphics.IStroke;
	import mx.utils.GraphicsUtil;
	
	public class LayoutUtil
	{

		public static function inBounds(bounds:Rectangle, pos:Point):Boolean {
			return !( 
					 (pos.x < bounds.left) 		|| 
			         (pos.x > bounds.right) 	||
			         (pos.y < bounds.top)       ||
			         (pos.y > bounds.bottom)
			       );
		}
		
		public static function getAnchors(item:UIComponent):Rectangle {
			var sticky : Rectangle = null;
			
			if (item != null) {
				var left 	: uint = item.getStyle("left");
				var top  	: uint = item.getStyle("top");
				var right	: uint = item.getStyle("right");
				var bottom  : uint = item.getStyle("bottom");
				
				if (left || right || top || bottom) {
					sticky = new Rectangle(left,top,bottom,right);					
				}
			}
			
			return sticky;
		}

		
		public static function useBoundsAsAnchors(ui:UIComponent):void {
					var rightGap  : int = ui.parent.width  - ui.x - ui.width;
					var bottomGap : int = ui.parent.height - ui.y - ui.height;
					
					
					// set anchors so resize parent maintains the gap while zooming...
					ui.setStyle("left",   ui.x      );
					ui.setStyle("top",    ui.y      );
					ui.setStyle("right",  rightGap  ); 
					ui.setStyle("bottom", bottomGap );
		}		


		public static function clearAnchors(ui:UIComponent):void {
					ui.setStyle("left",   undefined);
					ui.setStyle("top",    undefined);
					ui.setStyle("right",  undefined); 
					ui.setStyle("bottom", undefined);
		}		

		public static function getBounds(ui:DisplayObject):Rectangle 	{   
			var results : Rectangle = null;
			if (ui != null) {
				results = new Rectangle(ui.x, ui.y, ui.width, ui.height);
			}
			return results;
		}				

		// ***********************************************************************
		// Transformation Routines to determine outline points
		// ***********************************************************************

       
       
        
        public static function getUnrotatedBoundary(ui:DisplayObject,offset :Number = 0):Array {
        	var rotatedBy : Number  = ui.rotation;
					
					try {  				      	
	        	ui.rotation = 0;
	        	
	        	var noTransforms : Boolean   = ((ui.transform.matrix.a == 1) && (ui.transform.matrix.d == 1));
	          var bounds 		   : Rectangle = noTransforms  ? ui.getBounds(ui.parent) : new Rectangle(ui.x, ui.y, ui.width, ui.height);
	        	var cntr         : Container = ui.parent as Container;

						// Account for scroll position (if scroll bars are used!)	        	
	        	if (cntr != null) bounds.offset(cntr.horizontalScrollPosition,cntr.verticalScrollPosition);

	        	var points : Array 		 = [
										           					new Point(bounds.left - offset,    bounds.top - offset),
														            new Point(bounds.right,   				 				bounds.top - offset),
														            new Point(bounds.right,   				 				bounds.bottom),
														            new Point(bounds.left - offset,    bounds.bottom),
														            new Point(bounds.left - offset,    bounds.top- offset)
										                 ];
										                 
						// FIXME: need to get offset for scrolling Rect...
						
					} finally {
						ui.rotation = rotatedBy;
					}
		                 
        	return points;
        }
        
        
        public static function applyTransformTo(points:Array,transform:Matrix):Array {
        	  var results : Array = [];
						for (var j:int=0;j<points.length; j++) {
							results.push(transform.transformPoint(points[j]));
						}
						
        	 return results;
        }


		public static function bounds2Points(bounds:Rectangle):Array {
			var results : Array = [];
			
				results.push(new Point(bounds.left,bounds.top));
				results.push(new Point(bounds.right,bounds.top));
				results.push(new Point(bounds.right,bounds.bottom));
				results.push(new Point(bounds.left,bounds.bottom));

			return results;				
		}

			public static function flip(target:DisplayObject,direction:String="vertical"):void {
				if (target == null) return;
				
				var rotateBy 		: Number  = target.rotation;
				var hAction  		: Boolean = (direction.toLowerCase() == "horizontal");
				 
				target.rotation = 0;
				
				try {
						var topLeft   	:Point  	= new Point(target.x, target.y); 
						var center      :Point    = new Point(target.width/2,target.height/2);
						var transform		:Matrix 	= target.transform.matrix.clone();

					 	var hOffset : Number = target.width  * ((transform.a < 0) ? -1 : 1);
					 	var vOffset : Number = target.height * ((transform.d < 0) ? -1 : 1);
					 	 
					 	if (hAction == true) {
					 		transform.a = transform.a * -1;
					 		transform.tx = topLeft.x + hOffset;
					 	} else {
					 		transform.d = transform.d * -1;
					 		transform.ty = topLeft.y + vOffset;
					 	}
						
				} finally {

					target.transform.matrix=transform;
					target.rotation = -rotateBy;
				}
			}

		
		// *****************************************************************************
		// Drawing Utils
		// ******************************************************************************
		
        public static function getLineIntersection(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number) : Point {
            var _loc_11:Number;
            var _loc_12:Number;
            var _loc_13:Number;
            var _loc_14:Number;
            var _loc_9:* = (param4 - param2) / (param3 - param1);
            var _loc_10:* = (param8 - param6) / (param7 - param5);
            if (_loc_9 == _loc_10){
                return null;
            }
            if (!isFinite(_loc_9)){
                _loc_11 = param1;
                _loc_14 = param6 - _loc_10 * param5;
                _loc_12 = _loc_10 * _loc_11 + _loc_14;
            }
            else if (!isFinite(_loc_10)){
                _loc_13 = param2 - _loc_9 * param1;
                _loc_11 = param5;
                _loc_12 = _loc_9 * _loc_11 + _loc_13;
            }
            else{
                _loc_13 = param2 - _loc_9 * param1;
                _loc_14 = param6 - _loc_10 * param5;
                _loc_11 = (_loc_13 - _loc_14) / (_loc_10 - _loc_9);
                _loc_12 = _loc_9 * _loc_11 + _loc_13;
            }
            return new Point(_loc_11, _loc_12);
        }
        
		public static function drawDashedPolyLine(target:Graphics,stroke:IStroke,pattern:Array,points:Array):void
		{
			if ((points.length == 0) || (stroke == null)) return;
				
			var prev:Object = points[0];

			var struct:DashStruct = new DashStruct();							
			target.moveTo(prev.x,prev.y);
			for(var i:int = 1;i<points.length;i++)
			{
				var current:Object = points[i];
				_drawDashedLine(target,stroke,pattern,struct,prev.x,prev.y,current.x,current.y);
				prev = current;
			}
		}

		private static function _drawDashedLine(target:Graphics,stroke:IStroke,pattern:Array,
												drawingState:DashStruct,
												x0:Number,y0:Number,x1:Number,y1:Number):void
		{			
			var dX:Number = x1 - x0;
			var dY:Number = y1 - y0;
			var len:Number = Math.sqrt(dX*dX + dY*dY);
			dX /= len;
			dY /= len;
			var tMax:Number = len;
			
			
			var t:Number = -drawingState.offset;
			var bDrawing:Boolean = drawingState.drawing;
			var patternIndex:int = drawingState.patternIndex;
			var styleInited:Boolean = drawingState.styleInited;
			while(t < tMax)
			{
				t += pattern[patternIndex];
				if(t < 0)
				{
					var x:int = 5;
				}
				if(t >= tMax)
				{
					drawingState.offset = pattern[patternIndex] - (t - tMax);
					drawingState.patternIndex = patternIndex;
					drawingState.drawing = bDrawing;
					drawingState.styleInited = true;
					t = tMax;
				}
				
				if(styleInited == false)
				{
					if(bDrawing)
					{
						CONFIG::FLEX3 {
							stroke.apply(target);
						}
						CONFIG::FLEX4 {
							stroke.apply(target, null, null );
						}
					} else {
						
						target.lineStyle(0,0,0);
					}
				}
				else
				{
					styleInited = false;
				}
					
				target.lineTo(x0 + t*dX,y0 + t*dY);

				bDrawing = !bDrawing;
				patternIndex = (patternIndex + 1) % pattern.length;
			}
		}

		public static function drawRadialGradient(ui			:  UIComponent,
									  			  bounds		:  Rectangle	=  null,
												  centerColor	:  Number		=  0xFFFFFF, 
												  edgeColor		:  Number		=  0x000000,
												  centerAlpha   :  Number       =  1,
												  edgeAlpha     :  Number       =  1)  :  void {
																
			var s 			: Rectangle = ((bounds == null) ? LayoutUtil.getBounds(ui) : bounds);	        
			var m 			: Matrix    = new Matrix();
			var w 			: Number    = s.width  * 1.5;
			var h 			: Number    = s.height * 1.5;
			var boxRotation : Number    = Math.PI/2; // 90˚
			var tx 			: Number    = -s.width  * 0.25;
			var ty 			: Number    = -s.height * 0.25;
			var tr 			: Number 	= 0;
			var br 			: Number 	= 0;
			
			var fillColors : Array = [ centerColor, edgeColor  ];
			var g : Graphics = ui.graphics;				

			g.clear();

			m.createGradientBox(w, h, boxRotation, tx, ty);

			g.beginGradientFill(GradientType.RADIAL, fillColors, [0, edgeAlpha], [0, 255], m, SpreadMethod.PAD, InterpolationMethod.RGB, 0);
			mx.utils.GraphicsUtil.drawRoundRectComplex(g, s.x, s.y, w, h, tr, tr, br, br);
			g.endFill();			
		}
		
        public static function drawDashedLine(param1:Graphics, param2:IStroke, param3:Array, param4:Number, param5:Number, param6:Number, param7:Number) : void {
            param1.moveTo(param4, param5);
            var _loc_8:* = new DashStruct();
            _drawDashedLine(param1, param2, param3, _loc_8, param4, param5, param6, param7);
            return;
        }
        public static function drawRoundRect(param1:Graphics, param2:Number, param3:Number, param4:Number, param5:Number, param6:Array) : void {
            var _loc_7:* = param6[0];
            var _loc_8:* = param6[1];
            var _loc_9:* = param6[2];
            var _loc_10:* = param6[3];
            param2 = param2 + param4 / 2;
            param3 = param3 + param5 / 2;
            var _loc_11:* = param4 / 2;
            var _loc_12:* = param5 / 2;
            param1.moveTo(param2 + _loc_11 - _loc_10, param3 + _loc_12);
            param1.lineTo(param2 - _loc_11 + _loc_7, param3 + _loc_12);
            param1.curveTo(param2 - _loc_11, param3 + _loc_12, param2 - _loc_11, param3 + _loc_12 - _loc_7);
            param1.lineTo(param2 - _loc_11, param3 - _loc_12 + _loc_8);
            param1.curveTo(param2 - _loc_11, param3 - _loc_12, param2 - _loc_11 + _loc_8, param3 - _loc_12);
            param1.lineTo(param2 + _loc_11 - _loc_9, param3 - _loc_12);
            param1.curveTo(param2 + _loc_11, param3 - _loc_12, param2 + _loc_11, param3 - _loc_12 + _loc_9);
            param1.lineTo(param2 + _loc_11, param3 + _loc_12 - _loc_10);
            param1.curveTo(param2 + _loc_11, param3 + _loc_12, param2 + _loc_11 - _loc_10, param3 + _loc_12);
            return;
        }		
				
       protected function drawArc(param0:Graphics, param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Boolean = true) : void {
            var _loc_12:int;
            var _loc_7:* = param5 - param4;
            var _loc_8:* = 1 + Math.floor(Math.abs(_loc_7) / (Math.PI / 4));
            var _loc_9:* = _loc_7 / (2 * _loc_8);
            var _loc_10:* = Math.cos(_loc_9);
            var _loc_11:* = Math.cos(_loc_9) ? (param3 / _loc_10) : (0);
            if (param6){
                param0.moveTo(param1 + Math.cos(param4) * param3, param2 - Math.sin(param4) * param3);
            }
            else{
                param0.lineTo(param1 + Math.cos(param4) * param3, param2 - Math.sin(param4) * param3);
            }
            _loc_12 = 0;
            while (_loc_12 < _loc_8){
                param5 = param4 + _loc_9;
                param4 = param5 + _loc_9;
                param0.curveTo(param1 + Math.cos(param5) * _loc_11, param2 - Math.sin(param5) * _loc_11, param1 + Math.cos(param4) * param3, param2 - Math.sin(param4) * param3);
                _loc_12++;
            }
            return;
        }
	
	
	// ************************************************************************
	// DisplayObject Layering Methods
	// ************************************************************************	
	
	/*public static function bringToFrontOfContainer(ui:DisplayObject,offset:int=int.MAX_VALUE):int  	{
		
		if (ui != null)  {
			var parent : * = ui.parent;
			
			if ((parent != null) && (parent.numChildren > 1)) { 
				var list         : IChildList = (parent is IRawChildrenContainer) ?  IRawChildrenContainer(parent).rawChildren : IChildList(parent);
				
				/* 
				  Note: if cntr.contentPane exists, then UIComponents have "alternate" parents
				        since contentPane created for clipping during scrolling or clipContent...
				
				if ((ui is IUIComponent) && (list != ui.parent)) {
					list = IChildList(ui.parent);	
				}
				
				var currentIndex : int        = list.getChildIndex(ui);
				var maxIndex     : int        = list.numChildren - 1;
				var newIndex     : int        = (offset == int.MAX_VALUE) ? maxIndex : currentIndex + offset;
				
				if (newIndex < 0) 			newIndex = 0;
				if (newIndex > maxIndex) 	newIndex = maxIndex;
				try {
					list.setChildIndex(ui,newIndex);
				} catch(e:Error) {
					/* capture error and ignore 
					trace(e.message); 
				}
			}	
			
			return currentIndex;
		}
		
		return (ui && ui.parent) ? ui.parent.getChildIndex(ui) : -1;
	}*/
	
	public static function bringToFront(ui:DisplayObject, offset:int=int.MAX_VALUE):int {
		if (ui == null) return -1;
		
		var cntr : DisplayObjectContainer   = ui.parent as DisplayObjectContainer;
		var index: int                      = -1; 
		if (cntr != null) { 
			try {	 															
				var maxIndex     : int = cntr.numChildren - 1;
				var currentIndex : int = cntr.getChildIndex(ui);		 																				
				var newIndex     : int = (offset == int.MAX_VALUE) ? maxIndex : currentIndex + offset;
				
				if (newIndex < 0) 			newIndex = 0;
				if (newIndex > maxIndex) 	newIndex = maxIndex;
				
				cntr.setChildIndex(ui,newIndex);
				index = newIndex;
				
			}catch(error:Error) {
				trace(error.message); 
			}
		}	  
		
		return index;
	}
	
	public static function bringToFrontOf(ui:DisplayObject,relativeTo:Array):void {
		if(ui.parent && (relativeTo.length>0) && (relativeTo[0].parent==ui.parent)) {
			var parent  : *   = ui.parent;
			var list	 : IChildList    =  !(ui is UIComponent) && (parent is IRawChildrenContainer) 	?  
											IRawChildrenContainer(parent).rawChildren 					: 
											IChildList(parent);
			try {	 															
				// Scan for highest z-order in the "relativeTo" list		 			
				var topIndex : int = 0;
				for each (var it:DisplayObject in relativeTo) {
					if (!it || !it.parent) 	 continue;
					if (list != it.parent)   continue;
					
					if (list.getChildIndex(it)>topIndex) {
						topIndex = list.getChildIndex(it);
					}
				}
				
				var maxIndex     : int = list.numChildren - 1;
				var newIndex     : int = topIndex + 1;
				
				if (newIndex < 0) 				newIndex = 0;
				if (newIndex > maxIndex) 	newIndex = maxIndex;
				
				list.setChildIndex(ui,newIndex);
				
			}catch(error:Error) { }
		}
	}
	
	public static function bringToIndex(ui:DisplayObject,index:int):void {
		var parent : DisplayObjectContainer = ui ? ui.parent : null;
		if (parent != null) {
			try {
				if (parent is Container) {
					if 	(ui is UIComponent)  Container(parent).setChildIndex(ui,index);
					else 					 Container(parent).rawChildren.setChildIndex(ui,index);
				} else {
					parent.setChildIndex(ui,index);
				}
			} catch (e:Error) { trace(e.message); }
		}  
	}
	
	/**
	 * Only issue if sending Sprites to back layers in a Container!
	 * Non-UIComponents must be in the "rawChildren" subcontainer... 
	 */
	public static function sendToBack(ui:DisplayObject,parent:DisplayObjectContainer=null, offset:int=int.MAX_VALUE, forceAsRaw:Boolean = false):void {
		if (ui == null) 		return;
		if (parent == null) 	parent = ui.parent as DisplayObjectContainer;
		
		removeChildX(ui);
		addChildXAt(ui,parent, offset == int.MAX_VALUE ? 0 : offset);
	}	

	static public function isInFront(it1:DisplayObject,it2:DisplayObject):Boolean {
		// Items must be in same container!
		if (it1.parent == it2.parent) {
			return it1.parent.getChildIndex(it1) >= it2.parent.getChildIndex(it2);  		 																				
		} else {
			// Different parents... scan up it1 to see if the parent(s) are "in front" of it2
			return isInFront(it1.parent,it2);	
		}
	}
	

	static private function removeChildX(it:DisplayObject,parent:DisplayObjectContainer=null):Boolean {
		if (it == null) return false;
		if (parent == null) parent = it.parent as DisplayObjectContainer;
		
		if (parent != null) {
			if (parent is Container) {
				if (it is UIComponent) Container(parent).removeChild(it);
				else                   Container(parent).rawChildren.removeChild(it);
			} else parent.removeChild(it);
		}
		
		return true;
	}
	
	static public function addChildXAt(it:DisplayObject,parent:DisplayObjectContainer, index:int=int.MAX_VALUE):int {
		if (it == null) return -1;
		
		if (parent == null) parent = it.parent as DisplayObjectContainer;
		if (parent is Container) {
			var rCntr : IChildList = (it is UIComponent) ? IChildList(parent) : Container(parent).rawChildren;

			removeChildX(it);
			if (index != int.MAX_VALUE) {
				index = rawContainer_findMinimumIndex(rCntr,index);
				
				if (it is UIComponent) parent.addChildAt(it,index);
				else                   Container(parent).rawChildren.addChildAt(it,index);
			} else {
				if (it is UIComponent) parent.addChild(it);
				else                   Container(parent).rawChildren.addChild(it);
			}

		} else {
			if (index >= parent.numChildren) index = parent.numChildren - 1;
			if (index < 0)                   index = 0;
			
			parent.addChildAt(it,index);
		}
		
		return index;
	}	
	
			static private function rawContainer_findMinimumIndex(list:IChildList,index:int):int {
				var skips : Array = [];
				for (var j:int=0; j<list.numChildren; j++) {
					var it:DisplayObject = list.getChildAt(j);
					var id:String        = it.hasOwnProperty("id") ? it["id"] : it.name;
					
					if ((id == "border") || (id == "contentPane") || (id=="focusPane")) {
						skips.push({id: id, index:j});	// push index to skip list
					}
				}
				
				// Sort indices to highestlast
				if (skips.length > 0) {
					skips.sort(function(a:Object,b:Object):Boolean{return (a.index > b.index);},Array.NUMERIC);
					
					var max : Object = skips[skips.length-1];
					if ((index == int.MAX_VALUE) || (index <= max.index)) {
						index = max.index + 1;
					}
				}
				
				return index;
			}	
	
	
	
	}	
}
	
	class DashStruct
	{
		public function init():void
		{
			drawing = true;
			patternIndex = 0;
			offset = 0;
		}
		public var drawing:Boolean = true;
		public var patternIndex:int = 0;
		public var offset:Number = 0;	
		public var styleInited:Boolean = false;
	}
