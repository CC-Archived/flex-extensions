package utils.display
{
	import flash.display.DisplayObject;
	
	import utils.number.clamp;

	/**
	 * Brings the DisplayObject to the front of the display list. The <code>back</code> parameter can be used to pull the DisplayObject back a few levels from the front.
	 * @param object the DisplayObject to reorder
	 * @param back the number of levels from the front of the display list
	 * @return the new index of the DisplayObject
	 */
	public function bringToFront(object:DisplayObject, back:uint = 0):int
	{
		if (!object.parent)   return -1;

		// Is this a Spark Container (with completely screwed up layer management) !?
		
		var spark : Boolean  = object.parent.hasOwnProperty("setElementIndex");
		
		var invoke: Function = spark ? object.parent["setElementIndex"] 	: object.parent["setChildIndex"];
		var total : int      = spark ? object.parent["numElements"] 		: object.parent["numChildren"];
		var index : int 	 = total - (back + 1);
		
			index = clamp(index, 0, total - 1);
			invoke(object, index);
			
		return index;
	}
}