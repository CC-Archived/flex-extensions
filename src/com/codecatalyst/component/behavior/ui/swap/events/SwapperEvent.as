package com.codecatalyst.component.behavior.ui.swap.events
{
	import flash.events.Event;
	
	import mx.core.UIComponent;

	public class SwapperEvent extends Event
	{
		static 	public var STARTED 		: String 		= "swapStarted";
		static  public var SWAPPED      : String        = "swapPerformed";
		static  public var FINISHED     : String        = "swapFinished";
		
				public var source 		: UIComponent	= null;
				public var dest         : UIComponent   = null;
				public var allItems     : Array         = [];
				
		public function SwapperEvent(type:String, source:UIComponent, dest:UIComponent=null, items:Array=null)
		{
			super(type, true, true);			
			this.source 	= source;
			this.dest 	    = dest;
			this.allItems	= items==null ? [] : items;
		}		
	}
}