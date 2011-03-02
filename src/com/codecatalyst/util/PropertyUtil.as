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
	import com.codecatalyst.data.Property;
	
	import mx.styles.IStyleClient;
	
	public class PropertyUtil
	{
		// ========================================
		// Public methods
		// ========================================

		/**
		 * Evaluate and apply the specified properties to the specified object instance.
		 */
		public static function applyProperties( instance:Object, properties:Object, applyAsStyles:Boolean = false, enableRuntimeEvaluate:Boolean=false ):void
		{
			if (properties == null) properties = {};
			
			applyAsStyles = applyAsStyles && (instance is IStyleClient);

			for ( var key:String in properties )
			{
				var value         : *        = evaluateValueOf( instance, properties[ key ], enableRuntimeEvaluate );
				var targetProperty: Property = new Property( key );
				
				if ( targetProperty.exists( instance ) )
				{
					targetProperty.setValue( instance, value );
				}
				else 
				{
					// If not styleable, then interrupt on the FIRST error
					
					if ( applyAsStyles )  IStyleClient(instance).setStyle(key,value);					
					else				  throw new ReferenceError( "Specified property '"+key+"' does not exist." );					
				}
			}
		}
		
		
		/**
		 * Evaluate the specified value - which may be a (nested 'dot notation') property path, callback or just a standalone value.
		 * 
		 * NOTE: If the key is a Function, then the instance should be an IDataRenderer so the callback
		 * 		 will evaluate based on the instance data values.
		 */
		public static function evaluateValueOf( instance:*, key:*, evaluate:Boolean=false ):*
		{
			if ( key is String )
			{
				var property : Property = new Property( key as String );
				
				return property.exists(instance) ? property.getValue( instance ) : key;
			}
			else if ( evaluate && (key is Function) )
			{
				// Functions such as labelFunctions are not evaluated. Functions for IDataRenderers [that use
				// the instance data to determine the result] also should be supported and are 'evaluated' here
				
				var callback:Function = key as Function;
				var data    : Object  = instance.hasOwnProperty("data") ? instance['data'] : null;
				
				return data ? callback( data ) : null;
			}
			else
			{
				return key;
			}
		}		
		
		// ========================================
		// Public methods
		// ========================================
		
		public static function setObjectPropertyValue(object:Object, propertyPath:Object, value:*):void 
		{
			try
			{
				var target  : Object = traversePropertyPath( object, String(propertyPath), true );
				var segment : Object = propertyPath.split(".").pop();
				
				target[segment] = value;
			}
			catch ( error:ReferenceError )
			{
				// return null;
			}
		}
		
		/**
		 * Traverse a 'dot notation' style property path for the specified object instance and return the corresponding value.
		 */
		public static function getObjectPropertyValue( object:Object, propertyPath:String ):Object
		{
			try
			{
				return traversePropertyPath( object, propertyPath );
			}
			catch ( error:ReferenceError )
			{
				// return null;
			}
			
			return null;
		}
		
		/**
		 * Traverse a 'dot notation' style property path for the specified object instance and return a Boolean indicating whether the property exists.
		 */
		public static function hasProperty( object:Object, propertyPath:String ):Boolean
		{
			try
			{
				traversePropertyPath( object, propertyPath );
				
				return true;
			}
			catch ( error:ReferenceError )
			{
				// return false;
			}
			
			return false;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Traverse a 'dot notation' style property path for the specified object instance and return the corresponding value.
		 */
		protected static function traversePropertyPath( object:Object, propertyPath:String, excludeLastSegment:Boolean = false ):*	
		{
			// Split the 'dot notation' path into segments
			
			var path:Array = propertyPath.split( "." );
			
				// Should we exclude the last property segment
			    // Note: this effectively gives us the 'owning' instance of the last segment
			
			    if (excludeLastSegment == true) {
					path = path.length > 1 ? path.splice(0, path.length-2) : [ ];
				}
			
			// Traverse the path segments to the matching property value
			
			var node:* = object;
			for each ( var segment:String in path )
			{
				// Set the new parent for traversal
				
				node = node[ segment ];
			}
			
			return node;			
		}
	}
}