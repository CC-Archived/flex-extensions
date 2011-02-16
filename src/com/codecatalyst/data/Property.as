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

package com.codecatalyst.data
{
	import com.codecatalyst.util.PropertyUtil;

	public class Property
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>path</code> property.
		 */
		protected var _path:String;
		
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Returns the path for this property, using 'dot notation' (ex. 'a.b.c').
		 */
		public function get path():String
		{
			return _path;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor
		 */
		public function Property( path:String, parent:Property = null )
		{
			_path = ( parent != null ) ? parent.path + "." + path : path;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Gets the value for a property of this type for a given object instance.
		 */
		public function getValue( object:Object ):*
		{
			return PropertyUtil.getObjectPropertyValue( object, path );
		}
		
		/**
		 * Sets the value for a property of this type for a given object instance.
		 */
		public function setValue( object:Object, value:* ):void
		{
			object[ path ] = value;
		}
		
		/**
		 * Returns a Boolean indicating whether the specified object instance has this property.
		 */
		public function exists( object:Object ):Boolean
		{
			return PropertyUtil.hasProperty( object, path );
		}
		
		/**
		 * @inheritDoc
		 */
		public function toString():String
		{
			return path;
		}
	}
}