package com.codecatalyst.util.promise
{
	import com.codecatalyst.util.PropertyUtil;
	
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	
	/**
	 * Utility methods related to Promises and adapting Flash and ActionScript asynchronous operations for use with Promises.
	 * 
	 * @see com.codecatalyst.util.AsyncTokenUtil#createPromise()
	 * 
	 * @author John Yanarella
	 */
	public class PromiseUtil
	{
		/**
		 * Creates a Promise that adapts an asynchronous operation that uses Event based notification, given
		 * the event dispatcher, a single result event type, an Array of potential fault types, and an optional progress type.
		 * 
		 * NOTE: Event dispatchers that dispatch Events corresponding to multiple concurrent asynchronous operations cannot be adapted with this approach unless
		 * there is a 'token' property accessible via the Event or Event target which can be used to correlate an operation with its Events.
		 * In this case, use the optional eventTokenProperty and eventTokenPropertyPath parameters to specify this token and its path (in dot notation) relative to the Events.
		 * 
		 * Promise callbacks will be called with the corresponding Event; consider using Promise's pipe() method to process the Event into result or fault values. 
		 * @see com.codecatalyst.util.promise.Promise#pipe()
		 * 
		 * NOTE: It is critical to specify the result event type and all possible fault event types to avoid introducing memory leaks.
		 */
		public static function listen( dispatcher:IEventDispatcher, resultEventType:String, faultEventTypes:Array, progressEventType:String = null, progressEventProperty:String = null, useCapture:Boolean = false, priority:int = 0, eventTokenPropertyPath:String = null, expectedTokenValue:* = null ):Promise
		{
			var deferred:Deferred = new Deferred();
			
			// Check for a correlating token value, if applicable.
			function checkToken( event:Event ):Boolean
			{
				if ( eventTokenPropertyPath != null )
				{
					var token:* = PropertyUtil.getObjectPropertyValue( event, eventTokenPropertyPath );
					
					return ( token == expectedTokenValue );
				}
				
				return true;
			}
			
			// Result event handling closure.
			function resolve( event:Event ):void
			{
				if ( checkToken() )
				{
					deferred.resolve( event );
					release();
				}
			}
			
			// Fault event handling closure.
			function reject( event:Event ):void
			{
				if ( checkToken() )
				{
					deferred.reject( event );
					release();
				}
			}
			
			// Progress event handling closure.
			function update( event:Event ):void
			{
				if ( checkToken() )
				{
					deferred.update( event[ progressEventProperty ] );
				}
			}
			
			// Clean-up logic - required to avoid memory leaks.
			function release():void
			{
				dispatcher.removeEventListener( resultEventType, resolve, useCapture );
				
				for each ( var faultEventType:String in faultEventTypes )
				{
					dispatcher.removeEventListener( faultEventType, reject, useCapture );
				}
				
				if ( ( progressEventType != null ) && ( progressEventProperty != null ) )
					dispatcher.removeEventListener( progressEventType, update, useCapture );
			}
			
			// Listen for result event.
			dispatcher.addEventListener( resultEventType, resolve, useCapture, priority );
			
			// Listen for fault event.
			for each ( var faultEventType:String in faultEventTypes )
			{
				dispatcher.addEventListener( faultEventType, reject, useCapture, priority );
			}
			
			// Listen for progress event, if applicable.
			if ( ( progressEventType != null ) && ( progressEventProperty != null ) )
				dispatcher.addEventListener( progressEventType, update, useCapture, priority );
			
			return deferred.promise;
		}
	}
}