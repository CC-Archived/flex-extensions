package com.codecatalyst.util
{
	import flash.display.DisplayObject;
	
	public class MouseUtil
	{
		/**
	     *  @private
	     *  Returns true if the mouse is over the specified target.
	     * 
	     *  from ToolTipManagerImpl
	     */
	    public static function mouseIsOver(target:DisplayObject):Boolean
	    {
	    	if (!target || !target.stage)
	    		return false;
	    		
	    	//SDK:13465 - If we pass through the above if block, then
	    	//we have a target component and its been added to the 
	    	//display list. If the mouse coordinates are (0,0), there 
	    	//is a chance the component has not been positioned yet 
	    	//and we'll end up mistakenly showing tooltips since the 
	    	//target hitTest will return true. 
	    	if ((target.stage.mouseX == 0)	 && (target.stage.mouseY == 0))
	    		return false;
	    		
	    	return target.hitTestPoint(target.stage.mouseX,
	    							   target.stage.mouseY, true);
	    }

	}
}