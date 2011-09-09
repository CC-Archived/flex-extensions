////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011 CodeCatalyst, LLC - http://www.codecatalyst.com/
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

package com.codecatalyst.util.promise
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 * Deferred.
	 * 
	 * A chainable utility object that can register multiple callbacks into callback queues, invoke callback queues,
	 * and relay the success, failure and progress state of any synchronous or asynchronous operation.
	 * 
	 * @see com.codecatalyst.util.promise.Promise
	 * 
	 * Inspired by jQuery's Deferred implementation.
	 * 
 	 * @author John Yanarella
	 */
	public class Deferred extends EventDispatcher
	{
		// ========================================
		// Protected constants
		// ========================================
		
		/**
		 * Internal state change Event type.
		 */
		internal static const STATE_CHANGED:String = "stateChanged";

		// ========================================
		// Protected constants
		// ========================================
		
		/**
		 * State for a Deferred that has not yet been resolved, rejected or cancelled.
		 */
		protected static const PENDING_STATE:String = "pending";

		/**
		 * State for a Deferred that has been resolved.
		 */
		protected static const SUCCEEDED_STATE:String = "succeeded";

		/**
		 * State for a Deferred that has been rejected.
		 */
		protected static const FAILED_STATE:String = "failed";
		
		/**
		 * State for a Deferred that has been cancelled.
		 */
		protected static const CANCELLED_STATE:String = "cancelled";
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Promise.
		 */
		public function get promise():Promise
		{
			return _promise;
		}
		
		[Bindable( "stateChanged" )]
		/**
		 * Indicates this Deferred has not yet been resolved, rejected or cancelled.
		 */
		public function get pending():Boolean
		{
			return ( state == PENDING_STATE );
		}
		
		[Bindable( "stateChanged" )]
		/**
		 * Indicates this Deferred has been resolved.
		 */
		public function get succeeded():Boolean
		{
			return ( state == SUCCEEDED_STATE );
		}
		
		[Bindable( "stateChanged" )]
		/**
		 * Indicates this Deferred has been rejected.
		 */
		public function get failed():Boolean
		{
			return ( state == FAILED_STATE );
		}
		
		[Bindable( "stateChanged" )]
		/**
		 * Indicates this Deferred has been cancelled.
		 */
		public function get cancelled():Boolean
		{
			return ( state == CANCELLED_STATE );
		}
		
		[Bindable( "stateChanged" )]
		/**
		 * Progress supplied when this Deferred was updated.
		 */
		public function get progress():*
		{
			return _progress;
		}
		
		[Bindable( "stateChanged" )]
		/**
		 * Result supplied when this Deferred was resolved.
		 */
		public function get result():*
		{
			return _result;
		}
		
		[Bindable( "stateChanged" )]
		/**
		 * Error supplied when this Deferred was rejected.
		 */
		public function get error():*
		{
			return _error;
		}
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>promise</code> property.
		 */
		protected var _promise:Promise = null;
		
		/**
		 * Backing variable for <code>progress</code.
		 */
		protected var _progress:* = null;
		
		/**
		 * Backing variable for <code>result</code.
		 */
		protected var _result:* = null;
		
		/**
		 * Backing variable for <code>error</code.
		 */
		protected var _error:* = null;
		
		/**
		 * Deferred state.
		 * 
		 * @see #STATE_PENDING
		 * @see #STATE_SUCCEEDED
		 * @see #STATE_FAILED
		 * @see #STATE_CANCELLED
		 */
		protected var state:String = Deferred.PENDING_STATE;
		
		/**
		 * Callbacks to be called when this Deferred is updated.
		 */
		protected var progressCallbacks:Array = [];
		
		/**
		 * Callbacks to be called when this Deferred is resolved.
		 */
		protected var resultCallbacks:Array = [];
		
		/**
		 * Callbacks to be called when this Deferred is rejected.
		 */
		protected var errorCallbacks:Array = [];
		
		/**
		 * Callbacks to be called when this Deferred is resolved or rejected.
		 */
		protected var alwaysCallbacks:Array = [];
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function Deferred()
		{
			super();
			
			_promise = new Promise( this );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Register callbacks to be called when this Deferred is resolved or rejected.
		 */
		public function then( resultCallback:Function, errorCallback:Function = null, progressCallback:Function = null ):Deferred
		{
			onResult( resultCallback );
			onError( errorCallback );
			onProgress( progressCallback );
			
			return this;
		}
		
		/**
		 * Registers a callback to be called when this Deferred is either resolved or rejected.
		 */
		public function always( alwaysCallback:Function ):Deferred
		{
			if ( alwaysCallback != null )
			{
				if ( pending )
				{
					alwaysCallbacks.push( alwaysCallback );
				}
				else if ( succeeded )
				{
					notify( [ alwaysCallback ], result );
				}
				else if ( failed )
				{
					notify( [ alwaysCallback ], error );
				}
			}
				
			return this;
		}
		
		/**
		 * Utility method to filter and/or chain Deferreds.
		 */
		public function pipe( resultCallback:Function, errorCallback:Function = null ):Promise
		{
			var deferred:Deferred = new Deferred();
			
			then(
				function ( result:* ):void
				{
					if ( resultCallback != null )
					{
						var returnValue:* = resultCallback( result );
						if ( returnValue is Deferred )
						{
							returnValue.promise.then( deferred.resolve, deferred.reject, deferred.update );
						}
						else if ( returnValue is Promise )
						{
							returnValue.then( deferred.resolve, deferred.reject, deferred.update );
						}
						else
						{
							deferred.resolve( returnValue );
						}
					}
					else
					{
						deferred.resolve( result );
					}
				},
				function ( error:* ):void
				{
					if ( errorCallback != null )
					{
						var returnValue:* = errorCallback( error );
						if ( returnValue is Deferred )
						{
							returnValue.promise.then( deferred.resolve, deferred.reject, deferred.update );
						}
						else if ( returnValue is Promise )
						{
							returnValue.then( deferred.resolve, deferred.reject, deferred.update );
						}
						else
						{
							deferred.reject( returnValue );
						}
					}
					else
					{
						deferred.reject( error );
					}
				}
			);
			
			return deferred.promise;
		}
		
		/**
		 * Registers a callback to be called when this Deferred is updated.
		 */
		public function onProgress( progressCallback:Function ):Deferred
		{
			if ( progressCallback != null )
			{
				if ( pending )
				{
					progressCallbacks.push( progressCallback );
					
					if ( progress != null )
						notify( [ progressCallback ], progress );
				}
			}
			
			return this;
		}
		
		/**
		 * Registers a callback to be called when this Deferred is resolved.
		 */
		public function onResult( resultCallback:Function ):Deferred
		{
			if ( resultCallback != null )
			{
				if ( pending )
				{
					resultCallbacks.push( resultCallback );
				}
				else if ( succeeded )
				{
					notify( [ resultCallback ], result );
				}
			}
			
			return this;
		}
		
		/**
		 * Registers a callback to be called when this Deferred is rejected.
		 */
		public function onError( errorCallback:Function ):Deferred
		{
			if ( errorCallback != null )
			{
				if ( pending )
				{
					errorCallbacks.push( errorCallback );
				}
				else if ( failed )
				{
					notify( [ errorCallback ], error );
				}
			}
			
			return this;
		}
		
		/**
		 * Update this Deferred and notify relevant callbacks.
		 */
		public function update( progress:* ):void
		{
			if ( pending )
			{
				_progress = progress;
				
				notify( progressCallbacks, progress );
			}
		}
		
		/**
		 * Resolve this Deferred and notify relevant callbacks.
		 */
		public function resolve( result:* ):void
		{
			if ( pending )
			{
				_result = result;
				setState( Deferred.SUCCEEDED_STATE );
				
				notify( resultCallbacks.concat( alwaysCallbacks ), result );
				releaseCallbacks();
			}
		}
		
		/**
		 * Reject this Deferred and notify relevant callbacks.
		 */
		public function reject( error:* ):void
		{
			if ( pending )
			{
				_error = error;
				setState( Deferred.FAILED_STATE );
				
				notify( errorCallbacks.concat( alwaysCallbacks ), error );
				releaseCallbacks();
			}
		}
		
		/**
		 * Cancel this Deferred.
		 */
		public function cancel():void
		{
			if ( pending )
			{
				setState( Deferred.CANCELLED_STATE );
			
				releaseCallbacks();
			}
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Set the state for this Deferred.
		 * 
		 * @see #pending
		 * @see #succeeded
		 * @see #failed
		 * @see #cancelled
		 */
		protected function setState( value:String ):void
		{
			if ( value != state )
			{
				state = value;				
				dispatchEvent( new Event( STATE_CHANGED ) );
			}
		}
		
		/**
		 * Notify the specified callbacks, optionally passing the a reference to this Deferred and the specified value.
		 */
		protected function notify( callbacks:Array, value:* ):void
		{
			for each ( var callback:Function in callbacks )
			{
				switch ( callback.length )
				{
					case 2:
						callback( promise, value );
						break;
					
					case 1:
						callback( value );
						break;
					
					default:
						callback();
						break;
				}
			}
		}
		
		/**
		 * Release references to all callbacks registered with this Deferred.
		 */
		protected function releaseCallbacks():void
		{
			resultCallbacks = [];
			errorCallbacks = [];
			progressCallbacks = [];
			alwaysCallbacks = [];
		}
	}
}