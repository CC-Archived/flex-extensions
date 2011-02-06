////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2006 CodeCatalyst, LLC - http://www.codecatalyst.com/
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
	import flash.events.TimerEvent;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	public class DelayedCall
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Scheduled calls.
		 */
		protected static var scheduledCalls:Dictionary = new Dictionary();
		
		/**
		 * Function.
		 */
		protected var func:Function = null;
		
		/**
		 * Function arguments.
		 */
		protected var args:Array = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function DelayedCall()
		{
			super();
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Schedule a delayed function or method call.
		 * 
		 * @param func  The function or class method to call.
		 * @param args  The parameters to pass to the function / class method.
		 * @param delay The time in milliseconds to delay before making the function / class method call.
		 */
		public static function schedule( func:Function, args:Array, delay:Number ):void
		{
			var call:DelayedCall = new DelayedCall();
			
			call.initiate( func, args, delay );
			
			// Grab a reference so the call doesn't get prematurely garbage-collected
			
			scheduledCalls[ call ] = call;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Release reference to a completed DelayedCall instance.
		 */
		protected static function release( call:DelayedCall ):void
		{
			// Release reference so that call can be garbage-collected
			
			delete scheduledCalls[ call ];
		}
		
		/**
		 * Initiate a delayed call.
		 */
		protected function initiate( func:Function, args:Array, delay:Number ):void
		{
			this.func = func;
			this.args = args;
			
			// Create and start a timer
			
			var timer:Timer = new Timer( delay, 1 );
			timer.addEventListener( TimerEvent.TIMER_COMPLETE, timerCompleteHandler );
			
			timer.start();		
		}
		
		/**
		 * Handle TimerEvent.TIMER_COMPLETE - execute the delayed call.
		 */
		protected function timerCompleteHandler( event:TimerEvent ):void
		{
			var timer:Timer = event.target as Timer;
			timer.removeEventListener( TimerEvent.TIMER_COMPLETE, timerCompleteHandler );
			
			// Execute the delayed function call
			
			if ( func != null )
				func.apply( null, args );
			
			release( this );
		}
	}
}