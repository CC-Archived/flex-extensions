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
	 * ClassFactory has significant improvements upon the mx.core.ClassFactory:
	 * 
	 * 	1) The generator specified can be a Class, String, IFactory, or Object instance.
	 * 	2) Constructor parameters are supported.
	 * 	3) Initialization properties [key/value pairs] are auto-assigned at each instantiation.
	 *  4) If the instance is an IEventDispatcher, 1 or more eventHandlers may be auto-attached for specified event types
	 *
	 * This is the base factory used for instantiations of components where assigning
	 * styles is not needed. Nor are these instances used as special renderers that require 
	 * runtime property changes as the IDataRenderer data dynamically changes. 
	 * 
	 * NOTE: This factory can still be used in Grids and Lists, but the runtime changes will not be detected.
	 * 
	 * @see UIComponentFactory
	 * @see DataRendererFactory
	 * 
	 * @example
	 * <fe:ClassFactory
	 * 			id="factory
	 * 			generator="{ flash.display.Bitmap }"
	 * 			parameters="{ [null, true]  }"
	 * 			properties="{ { smoothing:true, filters:[ new DropShadowFilter() ]  } }" 
	 * 			xmlns:fe="http://www.codecatalyst.com/2011/flex-extensions" />
	 *  
	 * @author Thomas Burleson
	 * @author John Yanarella
	 * 
	 * 
	 */
	
	public class ClassFactory implements IFactory
	{
		// ========================================
		// Public properties
		// ========================================
		
		/**
		 * Parameters supplied to the constructor when generating instances of the generator Class.
		 */
		public var parameters		:Array = null;
		

		/**
		 * Hashmap of key/values used to initialize a factory instance during 
		 * construction. 
		 * NOTE: this map may include "style" keys which will be assigned as styles if possible
		 */
		public var properties		:Object = null;

		
		
		/**
		 * Event listeners to apply when generating instances of the generator Class.
		 */
		public var eventListeners	:Object = null;
		
		
		/**
		 *  Public setter to dynamically prepare a class instance generator
		 *  from a variety of source types.
		 * 
		 *  @param source   Object which could be a IFactory, Class, or String  
		 */
		public function set generator (source:Object) : void {
			// Save for later
			_generator = source || Object; 			
		} 


		/**
		 * Identifier for the instance of the Factory; useful when the ClassFactory is instantiated
		 * as an mxml tag instance. 
		 */
		public var id : String = "";
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ClassFactory( generator			:Object = null, 
									  parameters		:Array  = null, 
									  properties		:Object = null, 
									  eventListeners	:Object = null )
		{
			this.generator  	= generator;	
			this.parameters 	= parameters;
			this.properties 	= properties;
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
			var instance:Object =	generatorFactory  					? 
									generatorFactory.newInstance()		: 
									ClassUtil.createInstance( generatorClazz , parameters );
			
			
			// Iterate each property pair and assign; not propertychains are supported and
			// resolved for each new instance
			
			applyProperties(instance);
			
			// Add event listeners [if any handlers are configured AND the instance is an IEventDispatcher]
			
			EventDispatcherUtil.addEventListeners( (instance as IEventDispatcher) , eventListeners, false, 0, true );
			
			return instance;
		}
		
		
		/**
		 * Apply the static property values to the new instance; called 'static' since only applied at construction
		 *  
		 * @param instance 	New object instance from the IFactory::newInstance() request
		 * @return Object 	instance initialized with "property" values;
		 * 
		 */
		protected function applyProperties(instance:Object):* {
			try 
			{
				// Iterate each property pair and assign 
				// 
				
				PropertyUtil.applyProperties(instance, properties);
			} 
			catch ( error:ReferenceError ) 
			{
				trace(error.message);	
			}
			
			
			return instance;			
		}
		
		
		protected function get generatorFactory():IFactory {
			return _generator as IFactory;
		}
		
		/**
		 * Method to determine Class from string or object instance type.
		 * For optimization will cache the Class reference for multiple uses
		 * in newInstance();
		 * 
		 * @return Class 
		 */
		protected function get generatorClazz():Class {
			var results : Class = _generator as Class;
			
			if (!results && !(_generator is IFactory)) {
				
				// If the original generator is a String or Object instance
				// we overwrite with its Class reference.
				
				_generator = ClassUtil.getClassFor( _generator ); 
			}
			
			return results;
		}
		
		/**
		 * A Class that will be used as a template to create instances upon demand. If the generator type is a 
		 * String or object instance then Class is dynamically determined.  
		 */
		protected var _generator : * = null;

	}
}