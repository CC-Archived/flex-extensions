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

package com.codecatalyst.factory
{
	import com.codecatalyst.util.ClassUtil;
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;

	public class ClassFactory extends mx.core.ClassFactory implements IFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Parameters supplied to the constructor when generating instances of the generator Class.
		 */
		public var parameters:Array = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ClassFactory( generator:Class = null, parameters:Array = null, properties:Object = null )
		{
			super( generator );
			
			this.parameters = parameters;
			this.properties = properties;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public override function newInstance():*
		{
			var instance:Object = ClassUtil.createInstance( generator, parameters );
			
			// Apply properties.
			
			for ( var property:String in properties )
			{
				instance[ property ] = properties[ property ];
			}
			
			return instance;
		}
	}
}