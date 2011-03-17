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
	public class IterableUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Get a item of an iterable set of items (Array, ArrayCollection, Proxy, etc.) by unique identifier.
		 */
		public static function getItemById( items:*, id:Object, idFieldName:String, childrenFieldName:String = null ):Object
		{
			for each ( var item:Object in items )
			{
				var itemId:Object = PropertyUtil.getObjectPropertyValue( item, idFieldName );
				
				if ( itemId == id )
					return item;
				
				var children:* = getChildren( item, childrenFieldName );
				
				if ( children != null )
				{
					var result:Object = getItemById( children, id, idFieldName, childrenFieldName );
					
					if ( result != null )
						return result;
				}
			}
			
			return null;
		}
		
		/**
		 * Get the index for an item of an iterable set of items (Array, ArrayCollection, Proxy, etc.) by unique identifier.
		 */
		public static function getItemIndexById( items:*, id:Object, idFieldName:String ):int
		{
			var count:int = items.length;
			for ( var index:int = 0; index < count; index++ )
			{
				var item:Object = items[ index ];
				
				var itemId:Object = PropertyUtil.getObjectPropertyValue( item, idFieldName );
				
				if ( itemId == id )
					return index;
			}
			
			return -1;
		}
		
		/**
		 * Returns the item at the specified index in the iterable set of items (Array, ArrayCollection, Proxy, etc.), or null if unavailable.
		 */
		public static function getItemByIndex( items:*, index:int ):*
		{
			if ( ( items != null ) && ( index < items.length ) )
			{
				return items[ index ];
			}
			
			return null;
		}
		
		/**
		 * Returns the first item in the iterable set of items (Array, ArrayCollection, Proxy, etc.), or null if unavailable.
		 */
		public static function getFirstItem( items:* ):*
		{
			if ( ( items != null ) && ( items.length > 0 ) )
			{
				return items[ 0 ];
			}
			
			return null;
		}
		
		/**
		 * Returns the last item in the iterable set of items (Array, ArrayCollection, Proxy, etc.), or null if unavailable.
		 */
		public static function getLastItem( items:* ):*
		{
			if ( ( items != null ) && ( items.length > 0 ) )
			{
				return items[ items.length - 1 ];
			}
			
			return null;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Get the iterable set of children (Array, ArrayCollection, Proxy, etc.) for the specified item and child field name.
		 */
		protected static function getChildren( item:Object, childrenFieldName:String ):*
		{
			if ( item is XML )
			{
				var children:XMLList = ( item as XML ).children();
				
				if ( children.length() > 0 )
					return new XMLList( children );
				
				return null;
			}
			else
			{
				if ( ( childrenFieldName != null ) && ( item.hasOwnProperty( childrenFieldName ) ) )
					return item[ childrenFieldName ];
				
				return null;
			}
		}
	}
}