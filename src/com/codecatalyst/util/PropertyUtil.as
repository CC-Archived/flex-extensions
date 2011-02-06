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
	public class PropertyUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Traverse a 'dot notation' style property path.
		 */
		public static function getObjectPropertyValue( object:Object, propertyPath:String ):Object
		{
			var value:Object = null;
			
			// Split the 'dot notation' path into segments
			
			var path:Array = propertyPath.split( "." );
			
			try
			{
				// Traverse the path segments to the matching property value
				
				var node:Object = object;
				for each ( var segment:String in path )
				{
					// Set the new parent for traversal
					
					node = node[ segment ];
				}
				
				value = node;
			}
			catch ( e:ReferenceError )
			{
				value = null;
			}
			
			return value;
		}
	}
}