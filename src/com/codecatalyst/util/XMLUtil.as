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
	import mx.utils.StringUtil;
		
	/**
	 * This class attempts to set parameters on an object where child/attributes of an xml document match.
	 * 
	 * @author Thomas Burleson
	 */
	public final class XMLUtil
	{	
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Initialize an object from xml properties
		 */
		public static function initFromXML( target:Object, src:XML = null ):Object 
		{	
			// Try the child nodes
			toProperties(src.children(), target);
			
			// Try the attributes
			toProperties(src.attributes(), target);
			
			return target;
		}
		
		/**
		* Attempt to set properties on the target based on the specified XMLList.
		*/
		public static function toProperties( nodes:XMLList, target:Object = null, create:Boolean = true ):Object
		{
			target ||= new Object();
			
			if ( nodes != null )
			{
				for each ( var node:XML in nodes )
				{
					if ( node.hasSimpleContent() )
					{
						var key:String = String( node.name() );
						var value:String = String( node.valueOf() );
						
						if ( create || target.hasOwnProperty( key ) )
						{
							target[ key ] = isBoolean( value ) ? isTrue( value ) : value;
						}
					}
				}
			}
			
			return target;
		}
			
		/**
		 * Gets the specified attribute.
		 */
		public static function getAttribute( source:XML, searchKey:String, defaultValue:String = "", caseSensitive:Boolean = true, scanContent:Boolean = false ):String
		{
			var result:String = defaultValue;
			
			if ( source != null )
			{
				var attributes:XMLList = source.attributes();
				
				for each ( var attribute:XML in attributes )
				{
					var name:String  = String( attribute.name() );
					var value:String = StringUtil.trim( String( source.attribute( name )[ 0 ] ) );
					
					if ( caseSensitive != true )
					{
						name	  = name.toLowerCase();
						searchKey = searchKey.toLowerCase();
					}
					
					if (name == searchKey)
					{
						result = value; 		
						break;
					}
					else if ( scanContent == true )
					{
						var contents:XMLList = source.child( searchKey );
						var content:XML	     = ( contents.length() > 0 ) ? contents[ 0 ] as XML : null;

						if ( content && content.hasSimpleContent() )
						{
							var body : XMLList= content.text(); 
							result = ( body && body.length() > 0 ) ? String( body[0] ) : "";
							break;
						}
					}
				}
			 }
			 
			 return result;
		}
		
		/**
		 * Returns a Boolean indicating whether the specified attribute is true.
		 */
		public static function isAttributeTrue( source:XML, searchKey:String, defaultValue:Boolean = false ):Boolean
		{
			return isTrue( getAttribute( source, searchKey, defaultValue ? "true" : "false" ) );
		}
		
		/**
		 * Returns a Boolean indicating whether the specified String value represents a Boolean.
		 */
		public static function isBoolean( value:String ):Boolean
		{
			var result:Boolean = false;
			 
			if ( value && value != "" )
			{
				 // e.g. src === "true" or "yes" or "TruE"
				var pattern:RegExp = /^(true|yes|false|no)$/i;
				var matches:Array  = value.match( pattern );
				
				result = ( matches && matches.length );
			}
			 
			return result;				
		}
			 
		/**
		 * Returns a Boolean representation of the specified value.
		 */
		public static function isTrue( value:String ):Boolean
		{
			var result:Boolean = false;
			  
			if ( value && value != "" )
			{
				// e.g. src === "true" or "1" or "yes" or "TruE"
				var pattern:RegExp = /(true|1|yes|selected)/i;
				var matches:Array  = value.match( pattern );
				
				result = ( matches && matches.length );
			}
			
			return result;				
		}
	}
}