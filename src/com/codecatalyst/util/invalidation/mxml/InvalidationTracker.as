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

package com.codecatalyst.util.invalidation.mxml
{
	import com.codecatalyst.util.invalidation.InvalidationTracker;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.IMXMLObject;
	
	/**
	 * MXML implementation of InvalidationTracker.
	 * 
	 * @see com.codecatalyst.util.invalidation.InvalidationTracker
	 */
	public class InvalidationTracker extends com.codecatalyst.util.invalidation.InvalidationTracker implements IMXMLObject
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Indicates whether this component has been initialized.
		 */
		protected var _initialized:Boolean = false;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function InvalidationTracker()
		{
			super( null );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc 
		 */
		public function initialized( document:Object, id:String ):void
		{
			source = document as IEventDispatcher;
			
			_initialized = true;
			
			setup();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override protected function setup():void
		{
			if ( _initialized )
				super.setup();
		}
	}
}