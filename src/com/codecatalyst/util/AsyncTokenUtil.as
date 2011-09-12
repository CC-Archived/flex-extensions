////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2009 CodeCatalyst, LLC - http://www.codecatalyst.com/
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
////////////////////////////////////////////////////////////////////////////////

package com.codecatalyst.util
{
<<<<<<< HEAD
=======
	import com.codecatalyst.util.promise.Deferred;
	import com.codecatalyst.util.promise.Promise;
	
>>>>>>> d1aea2534f5af9120627ef0b5e39666d28ac9b3f
	import mx.rpc.AsyncToken;
	import mx.rpc.IResponder;
	import mx.rpc.Responder;

	/**
	 * AsyncTokenUtil
	 * 
	 * @author John Yanarella
	 */
	public class AsyncTokenUtil
	{
		/**
		 * Creates and returns a proxy AsyncToken based on the specified AsyncToken, adding an intercepting IResponder
		 * to the original token based on the specified result and fault Functions.
		 * 
		 * The result and fault Functions may optionally transform the result or fault data to be used when the proxy
		 * AsyncToken notifies its responders by returning a transformed value.
		 */
		public static function intercept( token:AsyncToken, result:Function, fault:Function = null ):AsyncToken
		{
<<<<<<< HEAD
			// create a proxy AsyncToken based on the original AsyncToken
			
			var proxyToken:AsyncToken = new AsyncToken( token.message );
			
			// create and add an intercepting IResponder to the original AsyncToken
			
			token.addResponder(

				new Responder(

					// create a result handling function closure
					
=======
			// Create a proxy AsyncToken based on the original AsyncToken.
			var proxyToken:AsyncToken = new AsyncToken( token.message );
			
			// Create and add an intercepting IResponder to the original AsyncToken.
			token.addResponder(

				new Responder(
					
					// Create a result handling function closure.
>>>>>>> d1aea2534f5af9120627ef0b5e39666d28ac9b3f
					function ( data:Object ):void
					{
						var resultData:Object = data;
						
<<<<<<< HEAD
						// execute the specified result interceptor function
=======
						// Execute the specified result interceptor function.
>>>>>>> d1aea2534f5af9120627ef0b5e39666d28ac9b3f

						if ( result != null )
						{
							var interceptorReturnValue:* = result( data );
							
							if ( interceptorReturnValue != undefined )
								resultData = interceptorReturnValue;
						}
						
<<<<<<< HEAD
						// notify the proxy AsyncToken's responders
						
=======
						// Notify the proxy AsyncToken's responders.
>>>>>>> d1aea2534f5af9120627ef0b5e39666d28ac9b3f
						for each ( var responder:IResponder in proxyToken.responders )
						{						
							responder.result( resultData );
						}
					},
					
<<<<<<< HEAD
					// create a fault handling function closure
					
=======
					// Create a fault handling function closure.
>>>>>>> d1aea2534f5af9120627ef0b5e39666d28ac9b3f
					function ( info:Object ):void
					{
						var faultInfo:Object = info;
						
<<<<<<< HEAD
						// execute the specified fault interceptor function
						
=======
						// Execute the specified fault interceptor function.
>>>>>>> d1aea2534f5af9120627ef0b5e39666d28ac9b3f
						if ( fault != null )
						{
							var interceptorReturnValue:* = fault( info );
							
							if ( interceptorReturnValue != undefined )
								faultInfo = interceptorReturnValue;
						}
						
<<<<<<< HEAD
						// notify the proxy AsyncToken's responders
						
=======
						// Notify the proxy AsyncToken's responders.
>>>>>>> d1aea2534f5af9120627ef0b5e39666d28ac9b3f
						for each ( var responder:IResponder in proxyToken.responders )
						{						
							responder.fault( faultInfo );
						}
					}
				)
			);
			
			return proxyToken;
		}
<<<<<<< HEAD
=======
		
		/**
		 * Create a Promise for the specified AsyncToken.
		 * 
		 * @see com.codecatalyst.util.promise.Promise
		 */
		public static function createPromise( token:AsyncToken ):Promise
		{
			var deferred:Deferred = new Deferred();
			
			var responder:Responder = new Responder( deferred.resolve, deferred.reject );
			token.addResponder( responder );
			
			return deferred.promise;
		}
>>>>>>> d1aea2534f5af9120627ef0b5e39666d28ac9b3f
	}
}