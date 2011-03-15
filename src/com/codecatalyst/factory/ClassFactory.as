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
	import com.codecatalyst.util.EventDispatcherUtil;
	import com.codecatalyst.util.PropertyUtil;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.IFactory;

	/**
	 * ClassFactory improves significantly upon the mx.core.ClassFactory:
	 * 
	 * 	1) The generator specified can be a Class, String, IFactory, or Object instance.
	 * 	2) Constructor parameters are supported.
	 * 	3) Initialization properties (specified as key/value pairs) are assigned to each instance created by the factory.
	 *  4) Event listener(s) can be added for specified event types (if the instance created is an IEventDispatcher).
	 *
	 * This is the base factory used for instantiations of basic Classes. 
	 * 
	 * StyleableFactory and StyleableRendererFactory extend ClassFactory, adding support for IStyleClient style initialization.
	 * DataRendererFactory and StyleableRendererFactory extend ClassFactory, adding support for IDataProvider data-driven runtime properties and styles.
	 * 
	 * @see com.codecatalyst.factory.DataRendererFactory
	 * @see com.codecatalyst.factory.StyleableFactory
	 * @see com.codecatalyst.factory.StyleableRendererFactory
	 * 
	 * @example
	 * <fe:ClassFactory
	 *     id="factory
	 *     generator="{ flash.display.Bitmap }"
	 *     parameters="{ [ null, true ] }"
	 *     properties="{ { smoothing: true, filters: [ new DropShadowFilter() ] } }" 
	 *     xmlns:fe="http://fe.codecatalyst.com/2011/flex-extensions" />
	 *  
	 * @author Thomas Burleson
	 * @author John Yanarella
	 */
	public class ClassFactory implements IFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Identifier for this ClassFactory instance; useful when instantiated as an MXML tag. 
		 */
		public var id:String = "";
		
		/**
		 * Constructor parameters to apply to generated instances.
		 * 
		 * NOTE: Not supported when <code>generator</code> is an IFactory.
		 */
		public var parameters:Array = null;
		
		/**
		 * Property values to assign to generated instances.
		 * 
		 * Hashmap of property values, keyed by property name.
		 * 
		 * NOTE: Property chains are supported via 'dot notation' and resolved for each new instance.
		 * NOTE: Property values are only assigned when the class is generated.
		 */
		public var properties:Object = null;
		
		/**
		 * Event listener to add to generated instances.
		 * 
		 * Hashmap of Event listener functions, keyed by Event type.
		 */
		public var eventListeners:Object = null;
		
		/**
		 * IFactory, Class or String used to generate instances.
		 */
		public function get generator():*
		{
			return _generator;
		}
		
		public function set generator( value:* ):void
		{
			_generator = value || Object;
			
			if ( ! ( _generator is IFactory ) )
				generatorClass = ( _generator is Class ) ? _generator : ClassUtil.getClassFor( _generator );
		}
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>generator</code> property.
		 * 
		 * @see #generator
		 */
		protected var _generator:* = null;
		
		/**
		 * Cached generator Class - used to avoid redundant Class definition lookups.
		 * 
		 * @see #generator
		 */
		protected var generatorClass:Class = null;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ClassFactory( generator:Object = null, parameters:Array  = null, properties:Object = null, eventListeners:Object = null )
		{
			this.generator      = generator;	
			this.parameters     = parameters;
			this.properties     = properties;
			this.eventListeners	= eventListeners;
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public function newInstance():*
		{
			var instance:Object = ( generator is IFactory ) ? generator.newInstance() : ClassUtil.createInstance( generatorClass, parameters );
			
			// Iterate and assign each property key / value pair.
			
			applyProperties( instance );
			
			// Add event listeners (if any handlers are configured AND the instance is an IEventDispatcher)
			
			EventDispatcherUtil.addEventListeners( ( instance as IEventDispatcher ), eventListeners, false, 0, true );
			
			return instance;
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Apply <code>properties</code> to the new instance.
		 * 
		 * @param instance Target object instance
		 * 
		 * @see #properties
		 */
		protected function applyProperties( instance:Object ):void
		{
			try 
			{
				PropertyUtil.applyProperties( instance, properties );
			} 
			catch ( error:ReferenceError ) 
			{
				trace( error.message );	
			}		
		}
	}
}