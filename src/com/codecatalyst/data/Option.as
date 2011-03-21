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

package com.codecatalyst.data
{
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class Option extends EventDispatcher
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>label</code> property.
		 * 
		 * @see #label
		 */
		protected var _label:String = null;
		
		/**
		 * Backing variable for <code>value</code> property.
		 * 
		 * @see #value
		 */
		protected var _value:* = null;

		// ========================================
		// Public properties
		// ========================================
		
		[Bindable("labelChanged")]
		/**
		 * Display label.
		 */
		public function get label():String
		{
			return _label;
		}
		
		[Bindable("valueChanged")]
		/**
		 * Associated value.
		 */
		public function get value():*
		{
			return _value;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function Option( label:String, value:* )
		{
			super();
			
			_label   = label;
			_value   = value;
		}
	}
}