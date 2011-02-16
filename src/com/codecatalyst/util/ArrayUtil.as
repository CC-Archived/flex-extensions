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
	public class ArrayUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Returns a shallow clone of the specified Array.
		 */
		public static function clone( array:Array ):Array
		{
			return ( array != null ) ? array.concat() : null;
		}
		
		/**
		 * Returns a Boolean indicating whether the specified Arrays are identical (i.e. contain exactly the same content in the same order).
		 */
		public static function equals( array1:Array, array2:Array, sort:Boolean = false ):Boolean
		{
			if ( ( array1 == null ) && ( array2 == null ) )
			{
				return true;
			}
			else if ( ( array1 != null ) && ( array2 != null ) && ( array1.length == array2.length ) )
			{
				if ( sort )
				{
					// NOTE: Both Arrays are cloned before sorting to ensure the original Array is not altered.
					
					array1 = ArrayUtil.clone( array1 )
					array1.sort();
					
					array2 = ArrayUtil.clone( array2 )
					array2.sort();
				}
				
				var length:int = array1.length;
				for ( var index:int = 0; index < length; index++ )
				{
					if ( array1[ index ] != array2[ index ] )
						return false;
				}
				
				return true;
			}
			
			return false;
		}
		
		/**
		 * Returns a Boolean indicating whether the specified Array contains the specified item.
		 */
		public static function contains( array:Array, item:Object ):Boolean
		{
			return ( array != null ) ? ( array.indexOf( item ) != -1 ) : false;
		}
		
		/**
		 * Returns a Boolean indicating whether the specified Array contains the specified items.
		 */
		public static function containing( array:Array, ...items ):Boolean
		{
			var result:Boolean = true;
			
			for each ( var item:Object in items )
				result &&= contains( array, item );
			
			return result;
		}
		
		/**
		 * Creates a new Array by combining the unique items in the specified arrays (i.e. no duplicates in resulting Array).
		 */
		public static function merge( ...arrays ):Array
		{
			var result:Array = new Array();
		
			for each ( var array:Array in arrays )
			{
				for each ( var item:* in array )
				{
					if ( result.indexOf( item ) == -1 )
							result.push( item );
				}
			}
			
			return result;
		}
		
		/**
		 * Creates a new Array by combining the unique specified items into the specified Array (i.e. no duplicates in resulting Array).
		 */
		public static function merging( array:Array, ...items ):Array
		{
			return merge( array, items );
		}
		
		/**
		 * Returns a shallow clone of the specified target Array, excluding the specified items.
		 */
		public static function exclude( array:Array, items:Array ):Array
		{
			var result:Array = clone( array ) || new Array();
			
			for each ( var item:Object in items )
			{
				var itemIndex:int = result.indexOf( item );
				
				if ( itemIndex != -1 )
					result.splice( itemIndex, 1 );
			}
			
			return result;
		}
		
		/**
		 * Returns a shallow clone of the specified target Array, excluding the specified items.
		 */
		public static function excluding( array:Array, ...items ):Array
		{
			return exclude( array, items );
		}
		
		/**
		 * Returns the items that are not in both of the specified Arrays.
		 */
		public static function difference( array1:Array, array2:Array ):Array
		{
			return merge( exclude( array1, array2 ), exclude( array2, array1 ) );
		}
	}
}