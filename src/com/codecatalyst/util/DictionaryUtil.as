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
		 * Create an Array representation of the specified Dictionary's contents.
		 *  
		 * @param source Dictionary
		 * @return Array of items managed by the dictionary
		 */
		public static function toArray( source:Dictionary ):Array
		{
			var result:Array = [];
			
			for each ( var item:* in source ) 
				result.push( item );
			
			return result;
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
		public static function createExistenceIndex( objects:*, weakKeys:Boolean = false ):Dictionary
		{
			var existenceIndex:Dictionary = new Dictionary( weakKeys );
			
			var indexCount:int = 0;
			for each ( var object:Object in objects )
			{
				existenceIndex[ object ] = true;
				
				indexCount++;
			}
			
			return existenceIndex;
		}
		
		/**
		 * Given an iterable set (Array, ArrayCollection, Proxy, etc.) of Objects, returns a Dictionary of Objects indexed by the specified key property name.
		 * 
		 * NOTE: 'dot notation' is supported.
		 * 
		 * NOTE: Assumes that the specified property is a unique key - i.e. only one Object will have that value.
		 */
		public static function createObjectIndexByKey( objects:*, propertyPath:String, weakKeys:Boolean = false ):Dictionary
		{
			var objectIndex:Dictionary = new Dictionary( weakKeys );
			
			var indexCount:int = 0;
			for each ( var object:Object in objects )
			{
				var propertyValue:* = PropertyUtil.getObjectPropertyValue( object, propertyPath );
				
				objectIndex[ propertyValue ] = object;
				
				indexCount++;
			}
			
			return objectIndex;
		}
		
		/**
		 * Given an iterable set (Array, ArrayCollection, Proxy, etc.) of Objects, returns an array of the object values for the key property name.
		 */		
		public static function createArrayByKey(  objects:*, propertyPath:String ) : Array {
			var results : Array = [ ];
			
			for each ( var object:Object in objects )
			{
				results.push( PropertyUtil.getObjectPropertyValue( object, propertyPath ) );
			}
			
			return results;
		}
		
		/**
		 * Given an iterable set (Array, ArrayCollection, Proxy, etc.) of Objects, returns a Dictionary of Objects indexed by the specified property name.
		 * 
		 * NOTE: 'dot notation' is supported.
		 */
		public static function createObjectIndexByProperty( objects:*, propertyPath:String, weakKeys:Boolean = false ):Dictionary
		{
			var objectIndex:Dictionary = new Dictionary( weakKeys );
			
			var indexCount:int = 0;
			for each ( var object:Object in objects )
			{
				var propertyValue:* = PropertyUtil.getObjectPropertyValue( object, propertyPath );
				
				objectIndex[ propertyValue ] ||= new Array();
				objectIndex[ propertyValue ].push( object );
				
				indexCount++;
			}
			
			return objectIndex;
		}
	}
}