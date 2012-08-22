package com.codecatalyst.component.behavior.ui.events
{
	import flash.events.Event;
	
	public class ContentEvent extends Event
	{
		
		public static const CONTENT_CHANGE 		: String = "contentChange";
		public static const CONTENT_INITIALIZED : String = "contentInitialized";
		public static const CONTENT_READY 		: String = "contentReady";
		public static const CONTENT_RELEASED 	: String = "contentReleased";
		
		public var content : Object;
		
		
		public function ContentEvent(type:String, content:Object=null) 
		{
			super(type,false,false);
			this.content = content;
		}
		
		override public function clone():Event 
		{
			return new ContentEvent(type, content);
		}
	}
}