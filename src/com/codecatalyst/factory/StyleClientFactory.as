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

package com.codecatalyst.factory
{
	import com.codecatalyst.util.StyleUtil;
	
	import mx.styles.IStyleClient;

	public class StyleClientFactory extends ClassFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Styles applied when generating instances of the generator Class.
		 */
		public var styles:Object = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function StyleClientFactory( generator:Class, parameters:Array = null, properties:Object = null, styles:Object = null )
		{
			super( generator, parameters, properties );
			
			this.styles = styles;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public override function newInstance():*
		{
			var instance:Object = super.newInstance();
			
			// Apply styles.
			
			StyleUtil.applyStyles( IStyleClient( instance ), styles );
						
			return instance;
		}
	}
}