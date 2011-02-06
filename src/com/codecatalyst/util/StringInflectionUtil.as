////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008 CodeCatalyst, LLC - http://www.codecatalyst.com/
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
	import mx.utils.StringUtil;
	
	public class StringInflectionUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Returns either the <code>singular</code> or <code>plural</code> String based on <code>count</code>.
		 * 
		 * @example
		 * <listing version="3.0">
		 *  n( "Snake on a plane.", "Snakes on a plane!", count );
		 *  n( "There is {0} goose.", "There are {0} geese.", count );
		 * </listing>
		 */
		public static function n( singular:String, plural:String, count:int ):String
		{
			return ( count > 1 ) ? StringUtil.substitute( plural, count ) : StringUtil.substitute( singular, count );
		}
	}
}