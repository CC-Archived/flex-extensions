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
	public class FormatUtil
	{
		/**
		 * Format the specified value as a Number with an ordinal suffix (ex. 1st, 2nd, 3rd, etc. ).
		 */
		public static function formatNumberOrdinalSuffix( value:* ):String
		{
			// Only apply an ordinal suffix if the number is a whole number.
			
			if ( NumberUtil.isWholeNumber( value ) )
			{
				var number:Number = Number( value );
				
				// Numbers from 11 to 13 don't have st, nd, rd
				
				if ( (number % 100) > 10  && (number % 100) < 14 ) 
					return number + "th";
				
				switch ( number % 10 )
				{
					case 1:
						return number + "st";
					case 2:
						return number + "nd";
					case 3:
						return number + "rd";
					default:
						return number + "th";
				}
			}
			
			// Return the unaltered original value.
			
			return value;
		}
	}
}