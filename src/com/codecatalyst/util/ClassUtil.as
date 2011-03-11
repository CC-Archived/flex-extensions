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
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;

	public class ClassUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Get the corresponding Class for the specified String or Object instance.
		 */
		public static function getClassFor( source:* ):Class
		{
			if ( source == null )
				return null;
			
			if ( source as Class != null )
				return source as Class;
			
			if ( source is String )
				return getDefinitionByName( source as String ) as Class;
			
			return getDefinitionByName( getQualifiedClassName( source ) ) as Class;
		}
		
		/**
		 * Create an instance of the specified Class, using the specified parameters (up to 10 parameters).
		 */
		public static function createInstance( generator:Class, parameters:Array ):Object
		{
			var newInstance:Object;
			
			if ( ( parameters == null ) || ( parameters.length == 0 ) )
			{
				newInstance = new generator();
			}
			else
			{
				// Workaround for AS3 limitations.
				
				switch (parameters.length)
				{
					case 1:  newInstance = new generator(parameters[0]); break;
					case 2:  newInstance = new generator(parameters[0], parameters[1]); break;
					case 3:  newInstance = new generator(parameters[0], parameters[1], parameters[2]); break;
					case 4:  newInstance = new generator(parameters[0], parameters[1], parameters[2], parameters[3]); break;
					case 5:  newInstance = new generator(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4]); break;
					case 6:  newInstance = new generator(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5]); break;
					case 7:  newInstance = new generator(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6]); break;
					case 8:  newInstance = new generator(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7]); break;
					case 9:  newInstance = new generator(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8]); break;
					case 10: newInstance = new generator(parameters[0], parameters[1], parameters[2], parameters[3], parameters[4], parameters[5], parameters[6], parameters[7], parameters[8], parameters[9]); break;
				}
			}
			
			return newInstance;
		}
	}
}