////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010 CodeCatalyst, LLC - http://www.codecatalyst.com/
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

    public class NumberUtil
    {
        // ========================================
        // Public methods
        // ========================================

        /**
         * Comparator function for two Numbers.
         */
        public static function compare(a:Number, b:Number):int
        {
            if (a < b)
            {
                return -1;
            }
            else if (b < a)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        /**
         * Returns a Boolean indicating whether the specified value is a whole number (ex. 1, 2, 3, etc.).
         */
        public static function isWholeNumber(value:*):Boolean
        {
            var number:Number = Number(value);

            return (Math.floor(Math.abs(number)) == value);
        }

        /**
         * Returns the first parameter if it is a valid Number, otherwise returns the second parameter.
         */
        public static function sanitizeNumber(value:*, otherwise:Number):Number
        {
            var number:Number = Number(value);

            return ((value == null) || isNaN(number)) ? otherwise : number;
        }

        public static function inRange(value:*, min:Number, max:Number):Boolean
        {
            var number:Number = Number(value);
            return ((value == null) || isNaN(number)) ? false : ((value >= min) && (value < max));

        }
    }
}
