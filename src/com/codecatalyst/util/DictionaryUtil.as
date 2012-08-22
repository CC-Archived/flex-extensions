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
	import flash.utils.Dictionary;
	
	public class DictionaryUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Returns an Array of the keys in the specified dictionary.
		 *  
		 * @param dictionary Dictionary instance
		 * @return Array of keys in the dictionary
		 */
		public static function keys( dictionary:Dictionary, flatten:Boolean=false ):Array
		{
			var list:Array = [];
			
			for ( var key:* in dictionary )
			{
				if ( flatten )
				{
					if ( dictionary[key] is Dictionary )
						list.concat( keys( dictionary[key] as Dictionary, flatten ) );
				}
				else					
					list.push( key );
			}
			
			return list;
		}
		
		/**
		 * Returns an Array of the values in the specified dictionary.
		 *  
		 * @param dictionary Dictionary instance
		 * @return Array of values in the dictionary
		 */
		public static function values( dictionary:Dictionary, flatten:Boolean=false ):Array
		{
			var list:Array = [];
			
			for each ( var item:* in dictionary )
			{
				if ( flatten )
				{
					if (item is Dictionary)	
						list = list.concat( values( item as Dictionary, flatten ) );
					else if (item is Array)
						list = list.concat( item as Array );
				}
				else
					list.push( item );			
			}
			
			return list;
		}
		
		/**
		 * Returns the number of keys in the specified Dictionary
		 */ 
		public static function keyCount( dictionary:Dictionary, flatten:Boolean=false ):int
		{
			var count:int = 0;
			
			for ( var key:* in dictionary )
			{
				if ( flatten )
				{
					if ( dictionary[key] is Dictionary )
						count += keyCount( dictionary[key] as Dictionary, flatten);
					else if ( dictionary[key] is Array )
						count += (dictionary[key] as Array).length;
				}
				else
					count += 1;
			}
			
			return count;
		}
		
		/**
		 * Create an Array representation of the values in the specified dictionary.
		 * 
		 * @param dictionary Dictionary
		 * @return Array of values in the dictionary
		 * 
		 * @see #values()
		 */
		public static function toArray( dictionary:Dictionary,flatten:Boolean=false ):Array
		{
			return values( dictionary, flatten );
		}
		
		/**
		 * Given an Object instance and an iterable set (Array, ArrayCollection, Proxy, etc.) of properties, returns a Dictionary of the property values indexed by property name.
		 */
		public static function createFromObjectProperties( object:Object, properties:* ):Dictionary
		{
			var result:Dictionary = new Dictionary();
			
			for each ( var property:String in properties )
				result[ property ] = PropertyUtil.getObjectPropertyValue( object, property );
			
			return result;
		}
		
		/**
		 * Given an iterable set (Array, ArrayCollection, Proxy, etc.) of Objects, returns a Dictionary of Booleans indexed by Object instances.
		 */
		public static function createExistenceIndex( objects:*, childrenFieldName:String = null, weakKeys:Boolean = false ):Dictionary
		{
			var existenceIndex:Dictionary = new Dictionary( weakKeys );
			
			function populateExistenceIndexFromObjects( objects:* ):void
			{
				for each ( var object:Object in objects )
				{
					existenceIndex[ object ] = true;
					
					if ( childrenFieldName != null )
					{
						var children:* = getChildren( object, childrenFieldName );
						if ( children != null )
							populateExistenceIndexFromObjects( children );
					}
				}
			}
			
			populateExistenceIndexFromObjects( objects );
			
			return existenceIndex;
		}
		
		/**
		 * Given an iterable set (Array, ArrayCollection, Proxy, etc.) of Objects, returns a Dictionary of Objects indexed by the specified key property name.
		 * 
		 * NOTE: 'dot notation' is supported.
		 * 
		 * NOTE: Assumes that the specified property is a unique key - i.e. only one Object will have that value.
		 */
		public static function createObjectIndexByKey( objects:*, propertyPath:String, childrenFieldName:String = null, weakKeys:Boolean = false ):Dictionary
		{
			var objectIndex:Dictionary = new Dictionary( weakKeys );
			
			function populateObjectIndexFromObjects( objects:* ):void
			{
				for each ( var object:Object in objects )
				{
					var propertyValue:* = PropertyUtil.getObjectPropertyValue( object, propertyPath );
					
					objectIndex[ propertyValue ] = object;
					
					if ( childrenFieldName != null )
					{
						var children:* = getChildren( object, childrenFieldName );
						if ( children != null )
							populateObjectIndexFromObjects( children );
					}
				}
			}
			
			populateObjectIndexFromObjects( objects );
			
			return objectIndex;
		}
		
		/**
		 * Given an iterable set (Array, ArrayCollection, Proxy, etc.) of Objects, returns a Dictionary of Objects indexed by the specified property name.
		 * 
		 * NOTE: 'dot notation' is supported.
		 */
		public static function createObjectIndexByProperty( objects:*, propertyPath:String, childrenFieldName:String = null, weakKeys:Boolean = false ):Dictionary
		{
			var objectIndex:Dictionary = new Dictionary( weakKeys );
			
			function populateObjectIndexFromObjects( objects:* ):void
			{
				for each ( var object:Object in objects )
				{
					var propertyValue:* = PropertyUtil.getObjectPropertyValue( object, propertyPath );
					
					objectIndex[ propertyValue ] ||= new Array();
					objectIndex[ propertyValue ].push( object );
					
					if ( childrenFieldName != null )
					{
						var children:* = getChildren( object, childrenFieldName );
						if ( children != null )
							populateObjectIndexFromObjects( children );
					}
				}
			}
			
			populateObjectIndexFromObjects( objects );
			
			return objectIndex;
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