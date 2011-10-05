package com.codecatalyst.util
{
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import mx.core.UIComponent;
	
	[Event(name="layoutRestored", type="flash.events.Event")]
	
	public class LayoutCache extends EventDispatcher
	{
		public function get items():Array {  return __cache;  }
		public function get bounds():Array {
			var results : Array = new Array();
			
			// build list of all bounds
			for each (var detail:Object in __cache) {
				results.push(detail.bounds);	
			}
			
			return results;
		}

		public function LayoutCache(items:Array = null) {	
			init(items);	
		}

		public function swapAnchors(item1:*,item2:*):void {
			// Make sure we have both items in our 'managed' list
			var entry1 : CacheEntry = addItem(item1);
			var entry2 : CacheEntry = addItem(item2);
			
			// Simply exchange the anchor information
			var tmp : Object  = entry1.anchors;
			entry1.anchors    = entry2.anchors;
			entry2.anchors    = tmp;
		}		

		public function getItemBoundsFor(src:*, withScaling:Boolean=false):Rectangle {
			var results : Rectangle = CacheEntry.getBounds(src);
			
			for each (var it:CacheEntry in __cache) {
				if (it == src) {
					results = it.bounds;
					break;
				}
			}
			return withScaling ? adjustForScale(results.clone(),src as DisplayObject) : results.clone();
		}
		
		public function getItemAnchorsFor(src:*):Object {
			var results : Object = null;
			
			for each (var it:CacheEntry in __cache) {
				if (it == src) {
					results = it.anchors ;
					break;
				}
			}
			
			return results;
		}

		public function release(shouldRestore:Boolean = true):void {
			if (shouldRestore == true)  restoreAll();
			removeAll();
		}
		
		public function removeAll():void{
			__cache = new Array();
		}
		
		public function addItem(item:*):CacheEntry {
			if (item == null) return null;			
			
			var entry : CacheEntry = contains(item);
			
			if (entry == null) {	
				entry = new CacheEntry(item);		
				__cache.push(entry);		
			}
			
			return entry;
		}
		
		public function updateItem(item:*,addRequested:Boolean = true):void {
			if (item == null) return;
			
			var entry : CacheEntry = contains(item);		
				
			if (entry != null) 			entry.updateBounds();			
			else if (addRequested)		this.addItem(item);
		}
		
		public function restoreAll(update:Boolean=true):void {
			for each (var detail:CacheEntry in __cache) {
				if(detail == null) continue;
												
				detail.restoreBounds(update);
				detail.restoreAnchors(update);
				
				var srcUI : UIComponent = detail.src as UIComponent;
				if (srcUI != null) srcUI.dispatchEvent(new Event("layoutRestored"));
			}
		}
		
		public function restoreAnchors():void {
			for each (var detail:CacheEntry in __cache) {								
				detail.restoreAnchors();
			}
		}
		
		private function init(targetItems:Array = null):void {
			__cache = new Array();
		   if (targetItems == null) targetItems = new Array();		   
		
			for each (var item:* in targetItems) {
				if (item == null) continue;
				
				__cache.push( new CacheEntry(item) );
			}	
		}
		

		private function contains(ui:*): CacheEntry {
			for each (var item:CacheEntry in __cache) {
				if (item.src == ui) return item;
			}	
			
			return null;
		}	
		
		private function adjustForScale(size:Rectangle,src:DisplayObject):Rectangle {
			if (src != null) {
				size.width  *= src.transform.matrix.a;		// ScaleX
				size.height *= src.transform.matrix.d;		// ScaleY
			}
			
			return size;
		}
		
		private var __cache : Array = new Array();
	}
}

	import flash.geom.Rectangle;
	import mx.core.UIComponent;
	import flash.geom.Point;
	import flash.display.DisplayObject;
	
	 class CacheEntry {
		
		public var src 		: * 		= null;
		public var anchors  : Object	= null;
		public var bounds	: Rectangle	= new Rectangle();
		public var percents : Object    = {};
		
		public function CacheEntry(item:*) {
			this.src = ((item is UIComponent) ? item : null);
			if (this.src != null) {
			
				this.anchors  = CacheEntry.getAnchors(item as UIComponent);
				this.percents = CacheEntry.getPercentBounds(item as UIComponent);
				this.bounds	  = CacheEntry.getBounds(item);
							
				clearUIAnchors();
				
			}			
		}
		
		public function updateBounds():void {
			this.bounds	= CacheEntry.getBounds(src);
		}
		
		public function restoreBounds(update:Boolean=true):void {
			var srcUI : UIComponent = this.src as UIComponent;
			
			if (srcUI != null) {
				// use new size/position or original values?
				var bnds : Rectangle = update ? getBounds(srcUI) : this.bounds;
							
				srcUI.x      = bnds.x
				srcUI.y      = bnds.y;
				
				// Restore percentage Width/Height if originally set
				if (percents['percentWidth'] != null) srcUI.percentWidth = percents['percentWidth'];
				else                                  srcUI.width        = bnds.width;

				if (percents['percentHeight'] != null) srcUI.percentHeight = percents['percentHeight'];
				else                                  srcUI.height         = bnds.height;
			}		
		}
		
		public function restoreAnchors(update:Boolean=true):void {
			var srcUI : UIComponent = this.src as UIComponent;
			
			if ((srcUI != null) && (this.anchors != null)) {
				// use original anchor values or calculate new values based on current position/size
				var bnds : Object = update ? getEffectiveAnchors() : this.anchors;		
				
				if (this.anchors["left"]   					 != undefined) { srcUI.setStyle("left",  											bnds.left);		}
				if (this.anchors["top"]    					 != undefined) { srcUI.setStyle("top",   											bnds.top);		}
				if (this.anchors["right"]  					 != undefined) { srcUI.setStyle("right", 											bnds.right);	}
				if (this.anchors["bottom"] 					 != undefined) { srcUI.setStyle("bottom",											bnds.bottom);	}
				if (this.anchors["horizontalCenter"] != undefined) { srcUI.setStyle("horizontalCenter",	bnds.horizontalCenter);	}
				if (this.anchors["verticalCenter"]   != undefined) { srcUI.setStyle("verticalCenter",			bnds.verticalCenter);	}
			}		
		}


		public static function getBounds(item:*):Rectangle {
			var location : Rectangle = new Rectangle();
			
			if      (item is UIComponent) 	{	location  = new Rectangle(item.x,    item.y,   item.width, item.height);	}
			else if (item is Object) 		{	location  = new Rectangle(item.left, item.top, item.width, item.height);	}
			else if (item is Rectangle)		{	location  = item as Rectangle;												}
			
			return location;
		}
		
		public static function getPercentBounds(ui:UIComponent):Object {
			var results : Object = {};
			
			if (ui != null) {
				if (Boolean(ui.percentWidth) != false)	results['percentWidth']  = ui.percentWidth; 
				if (Boolean(ui.percentHeight) != false)	results['percentHeight'] = ui.percentHeight; 
			}
			
			return results;
		}

		public static function getAnchors(item:UIComponent):Object {
			var sticky : Object = null;
			
			
			if (item != null) {
				var left 	: * = item.getStyle("left");
				var top  	: * = item.getStyle("top");
				var right	: * = item.getStyle("right");
				var bottom  : * = item.getStyle("bottom");
				var hCenter : * = item.getStyle("horizontalCenter");
				var vCenter : * = item.getStyle("verticalCenter");
				
				
				if (left || right || top || bottom || hCenter || vCenter) {
					sticky = { left	  					: left, 
					           top	  					: top, 
					           right  					: right, 
					           bottom 					: bottom,
					           horizontalCenter : hCenter,
					           verticalCenter   : vCenter };					
				}
			}
			return sticky;
		}
		
		/**
		 * Calculate (relative to parent) the effective anchor values were specified
		 * 
		 * @return (left,top,right,bottom) anchor values for current position of target 
		 */
		public function getEffectiveAnchors():Object {
			var results : Object        = { left:0, top:0, right:0, bottom:0 };
			
			var ui      : DisplayObject = this.src as DisplayObject;
			var cntr    : DisplayObject = ui ? ui.parent : null;
			
			if (ui && cntr) {
				var bnds : Rectangle = new Rectangle(ui.x,ui.y,ui.width,ui.height);
				
				results.left         = bnds.x;
				results.top          = bnds.y;
				results.right        = cntr.width - (bnds.x + bnds.width);
				results.bottom       = cntr.height- (bnds.y + bnds.height);
				
				getEffectiveCenterAnchors(results);
			}
			
			return results;
		}
		
		public function getEffectiveCenterAnchors(anchors:Object):void {
			var ui      : DisplayObject = this.src as DisplayObject;
			var cntr    : DisplayObject = ui ? ui.parent : null;
			
			if (ui && cntr) {
				anchors.horizontalCenter = Math.round((ui.x + (ui.width/2))  - cntr.width/2); 
				anchors.verticalCenter   = Math.round((ui.y + (ui.height/2)) - cntr.height/2); 
			}			
		}

		private function clearUIAnchors():void {
			if ((src !=null) && (bounds != null)) {
				// clear anchors for swapping purposes
				src.setStyle("left",	undefined);
				src.setStyle("right",	undefined);
				src.setStyle("top",		undefined);
				src.setStyle("bottom",	undefined);
				
				// Always clear centering anchors
				src.setStyle("horizontalCenter", undefined);
				src.setStyle("verticalCenter", undefined);
				
				// Instead of using anchors, explicitly set the x,y & width,heights
				src.x 	 = bounds.left;
				src.y 	 = bounds.top;
				src.width = bounds.width;
				src.height= bounds.height; 
			}			
		}
		
	}