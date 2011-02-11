////////////////////////////////////////////////////////////////////////////////
//
//  Copyright 2009 Farata Systems LLC
//  All Rights Reserved.
//
//  NOTICE: Farata Systems permits you to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//
////////////////////////////////////////////////////////////////////////////////

package com.codecatalyst.factory
{
/**
 *  UIClassFactory is an implementation of the Class Factory design pattern
 *  for dynamic creaion of DataRenderer components. It allows dynamic passing of the 
 *  propeties, styles and event listeners during the object creation.
 *  Additionally, when the "data" value is changed, runtime styles and properties can
 *  be assigned... thus adding power to IList containers and Datagrid     
 *  
 *  @see mx.core.IFactory
 */	
	import flash.events.IEventDispatcher;
	import flash.utils.describeType;
	import flash.utils.getDefinitionByName;
	
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	import mx.styles.IStyleClient;


	public class UIClassFactory implements IFactory{
		
		//Styles for the UI object to be created 
		//Event Listeners for the UI object to be created
		
		/**
		 * Hashmap of key/values used to initialize a factory instance during 
		 * construction. 
		 * NOTE: this map may include "style" keys which will be assigned as styles if possible
		 */
		public var properties		:Object = {};
		
		
		/**
		 * Hashmap of style settings used to initialize a IStyleClient instance 
		 * during construction. 
		 */
		public var styles			:Object = {};
		
		/**
		 * Hashmap of event type/"handler function" pairs that will be assigned if the
		 * instance is an IEventDispatcher.
		 * NOTE: this are assigned as weak references to trigger during the "bubble" phase   
		 */		
		public var eventListeners	:Object = {};
		
		/**
		 * Accessor to the internal IFactory of the generator
		 * @return 
		 * 
		 */
		public function get wrappedClassFactory():ClassFactory {
			return _wrappedClassFactory;
		}
		
		/**
		 *  Public mutator to dynamically prepare a class instance generator
		 *  from a variety of source types.
		 * 
		 *  @param cf   Object which could be a IFactory, Class, Function or String  
		 */
		public function set generator (cf:Object) : void {
			
					function buildFactory( src:String ):ClassFactory {
						var results  : ClassFactory = null;
						var className: String       = String(src);
						try {
							results = new  ClassFactory(getDefinitionByName(className) as Class);
						} catch (e:Error) 	{
							trace(" Class '"+ className + "' can't be loaded dynamically. Ensure it's explicitly referenced in the application file or specified via @rsl.");
						}
						
						return results;
					}
					
					function announceError( src:Object ):void {
						var className : String = src ? describeType(src).@name.toString() : "null";
						trace("'" + className + "'" + " is invalid parameter for UIClassFactory constructor.");
					}

			if      ( cf is UIClassFactory ) 	_wrappedClassFactory = UIClassFactory(cf).wrappedClassFactory;
			else if ( cf is ClassFactory )  	_wrappedClassFactory = cf as ClassFactory;
			else if ( cf is Class ) 		 	_wrappedClassFactory = new ClassFactory(Class(cf));
			else if ( cf is String ) 			_wrappedClassFactory = buildFactory(cf as String); 
			else if ( cf is Function )			factoryFunction      = cf as Function;
			else 								announceError(cf);
			
			_wrappedClassFactory ||= new ClassFactory(Object);
			
		} 
		
		
		/**
		 * Constructor of UIClassFactory takes four arguments
		 * cf   -  The object to build. It can be a class name, 
		 *         a string containing the class name, a function,
		 *         or another class factory object;
		 * props - inital values for some or all properties if the object;
		 * styles - styles to be applied to the object being built
		 * eventListeners - event listeners to be added to the object being built
		 */ 	
		public function UIClassFactory( cf: Object = null , props:Object = null, 
										styles:Object = null, eventListeners:Object = null ) {
			
			if (cf != null) generator = cf;
			
			this.properties 	= props  			|| { };
			this.styles     	= styles 			|| { };
			this.eventListeners	= eventListeners	|| { };
		}
		
        /**
        * IFactory-required method to create a new instance from the factory.
		* This process will assign any constructor properties, styles, and event listeners configured.
		* 
		* @return Object instance of the generator
        */ 
		public function newInstance():* {
			var inst:* = (factoryFunction != null) ? factoryFunction() : _wrappedClassFactory.newInstance();

			// Copy(aggregate) the properties to the new object 
			
			if (properties != null)  {
	        	for (var p:String in properties) {
	        		if ( (inst as Object).hasOwnProperty(p) )  inst[p] = properties[p];
					else 									   inst.setStyle(p, properties[p]);
				}
	       	}
			
			// Set the styles on the new object
			
			if ((styles != null) && (inst is IStyleClient))  {
	        	for (var s:String in styles) {
	        		inst.setStyle(s,  styles[s]);
				}
			}
			
			// add event listeners, if any
			
			if ((eventListeners != null) && (inst is IEventDispatcher))  {
	        	for (var e:String in eventListeners) {
	        		inst.addEventListener(e,  eventListeners[e], false, 0, true);
				}
			}
			
			return inst;
		}

		
		/**
		 * A class factory object that serves as a wrapper for classes, functions, strings, 
		 * and even class factories
		 */
		protected var _wrappedClassFactory : ClassFactory = null;
		
		/**
		 * A reference to a function if the object instances are to be created by a function
		 */
		protected var factoryFunction 	: Function 		= null;
	}
}