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

package com.codecatalyst.util.persistence
{
	/**
	 * Concrete implementation of IKeyValueStore that adapts any key value store's get value and set value functions.
	 * 
	 * @author John Yanarella
	 */
	public class KeyValueStoreAdapter implements IKeyValueStore
	{
		// ========================================
		// Public factory methods.
		// ========================================
		
		/**
		 * Creates a new KeyValueStoreAdapter, adapting the specified get value / set value callback functions.
		 */
		public static function adapt( getValueCallback:Function, setValueCallback:Function ):KeyValueStoreAdapter
		{
			return new KeyValueStoreAdapter( getValueCallback, setValueCallback );
		}
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable]
		/**
		 * Key value getter callback function.
		 */
		public var getValueCallback:Function = null;
		
		[Bindable]
		/**
		 * Key value setter callback function.
		 */
		public var setValueCallback:Function = null;
		
		// ========================================
		// Constructor
		// ========================================

		/**
		 * Constructor.
		 */
		public function KeyValueStoreAdapter( getValueCallback:Function = null, setValueCallback:Function = null )
		{
			super();
			
			this.getValueCallback = getValueCallback;
			this.setValueCallback = setValueCallback;
		}
		
		// ========================================
		// Public methods.
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public function getValue( key:String ):Object
		{
			return getValueCallback( key );
		}
		
		/**
		 * @inheritDoc
		 */
		public function setValue( key:String, value:Object ):void
		{
			setValueCallback( key, value );
		}
	}
}