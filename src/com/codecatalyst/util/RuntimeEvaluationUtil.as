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

package com.codecatalyst.util
{
	import com.codecatalyst.data.Property;

	public class RuntimeEvaluationUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Evaluates the specified value against the specified object instance.
		 * 
		 * If the specified value is a String, it is evaluated as a potential property path in 'dot notation' and the corresponding instance value is returned.
		 * If the specified value is a Function, it is called with the object instance (or evaluated callback field) as a parameter and its result is returned.
		 * Otherwise the value is returned unaltered.
		 * 
		 * @param instance  Target object instance.
		 * @param value     String - potentially specifying a property path in 'dot notation', Function callback or standalone value.
		 * @param callbackField Optional field to evaluate and pass to the callback function.
		 * 
		 * @return The evaluated value.
		 */
		public static function evaluate( instance:*, value:*, callbackField:String = null ):*
		{
			if ( value is String )
			{
				var property:Property = new Property( value as String );
				
				return property.exists( instance ) ? property.getValue( instance ) : value;
			}
			else if ( value is Function )
			{
				var callback:Function = value as Function;
				
				if ( callbackField )
				{
					var callbackProperty:Property = new Property( callbackField );
					
					return callback( callbackProperty.getValue( instance ) );
				}
				else
				{
					return callback( instance );
				}
			}
			else
			{
				return value;
			}
		}
	}
}