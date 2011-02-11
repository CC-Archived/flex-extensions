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
 *  ItemRendererFactory is an implementation of the Class Factory design pattern
 *  for dynamic creaion of DataRenderer components. It allows dynamic passing of the 
 *  propeties, styles and event listeners during the object creation.
 *  Additionally, when the "data" value is changed, runtime styles and properties can
 *  be assigned... thus adding power to IList containers and Datagrid     
 *  
 *  @see mx.core.IFactory
 */	
	import flash.events.IEventDispatcher;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Dictionary;
	import flash.utils.Proxy;
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.events.FlexEvent;
	import mx.styles.IStyleClient;
	import mx.utils.*;


	public class ItemRendererFactory extends UIClassFactory implements IFactory {
		
		//Styles for the UI object to be created 
		//Event Listeners for the UI object to be created
		
		/**
		 * Hashmap of key/values assigned to itemRenderer instance during EACH
		 * data change/assignment.
		 * 
		 * NOTE: this map may include "style" keys which will be assigned as styles if possible
		 */
		public var runtimeProperties:Object = {};
		
		
		/**
		 * Hashmap of style settings assigned to itemRenderer instance during EACH
		 * data change/assignment.
		 * 
		 * NOTE: the instance must be an IStyleClient instance 
		 */
		public var runtimeStyles	:Object = {};
		
			
		
		public function ItemRendererFactory( 	cf				 :Object = null , 
												props			 :Object = null, 
												styles			 :Object = null, 
												eventListeners	 :Object = null,
												runtimeProperties:Object = null,
												runtimeStyles	 :Object = null) {
			
			super (cf,props,styles,eventListeners);
			
			this.runtimeProperties = runtimeProperties || { }
			this.runtimeStyles     = runtimeStyles     || { };  
		}
		
		
		/**
		 * IFactory-required method to create a new instance from the factory.
		 * This process will assign any constructor properties, styles, and event listeners configured.
		 * 
		 * @return Object instance of the generator
		 */ 
		override public function newInstance():* {
			var inst : * = super.newInstance();
			
			if (inst is IEventDispatcher) {
				inst.addEventListener(FlexEvent.DATA_CHANGE, onDataChange, false, 0, true);
			}
			
			return inst;
		}
		
		/**
		 * onDataChange is the handler for the DATA_CHANGE events. It uses runtimeStyles and
		 * runtimeProperties, which were added to Clear Toolkit’s version of 
		 * the DataGridColumn to handle styles and properties that were added dynamically.
		 * If you’ll use this UIClassFactory with regular DataGridColumns that does not 
		 * support dynamic styles, the onDataChange function won’t find any 
		 * runtimeStyles or runtimeProperties and won’t do anything. 
		 */   
		private function onDataChange(event:FlexEvent):void{
			var renderer:Object = event.currentTarget;
			
			/**
			 * Returns whether or not the given object is simple data type.
			 *
			 * @param object 	Object instance check
			 * @return true 	if the given object is a simple data type; false if not
			 */
			function shouldEnumerate(object:Object):Boolean {
				
				switch (typeof(object)) {
					case "function"	: return false;
					case "object"	: return !(object is Date) && !(object is Array);
				}
				
				return false;
			}
			
			/**
			 * Powerful method to update render properties with values.
			 * Supports property chains and dynamic value calculations
			 * 
			 * Then will update either the "final" target properties or styles
			 * 
			 * @param target 		Renderer instance
			 * @param attributes	Hashmap of runtime property or style key/value pairs
			 */
			function updateTargetWith(target : Object, attributes:Object):void {
				for (var key:String in attributes) {
					var value    : * 		= attributes[key];
					var callBack : Function = value as Function;
					
					if (callBack != null ) {
						try { 
							// Ask originator to build the value of the property dynamically with the itemRenderer data
							// NOTE: this data is used regardless of property chain recursion depth
							
							value = callBack(renderer.data);
							
						} catch (e:Error) {
							trace(e.message);
							continue;
						}
					}
					
					if ( !callBack && shouldEnumerate(value) && target.hasOwnProperty(key)) {
						// The key value is an Object that we should enumerate like a "property chain"
						
						updateTargetWith(target[key],value as Object);
						
					} else {
						// Accommodate shared usage where style settings are mixed with the 
						// property settings; set the style if the propertyKey does not exist.
						
						if (target.hasOwnProperty(key)) 	target[key] = value;
						else								target.setStyle(key, value);
					}
				}														
			}
			
			// Skip this call if caused by header renderers; we want to skip assignments to listData
			if ( isType(renderer.data, getType("mx.controls.dataGridClasses.DataGridColumn")) ) 					return;
			if ( isType(renderer.data, getType("mx.controls.advancedDataGridClasses.AdvancedDataGridColumn")) ) 	return;
			
			updateTargetWith( renderer, runtimeProperties );
			updateTargetWith( renderer, runtimeStyles );
		}	
		
		
		// ******************************************************************************************
		// Special Type utilities 
		// ******************************************************************************************
		
		/**
		 * Evaluates whether an object or class is derived from a specific
		 * data type, class or interface. The isType() method is comparable to
		 * ActionScript's <code>is</code> operator except that it also makes
		 * class to class evaluations.
		 * 
		 * @param	value			The object or class to evaluate.
		 * @param	type			The data type to check against.
		 * 
		 * @return					True if the object or class is derived from
		 * 							the data type.
		 */
		private static function isType(value:Object, type:Class):Boolean
		{
			if ( !(value is Class) ) 		return value is type;
			if ( value == type )			return true;
			
			var inheritance:XMLList = describeInheritance(value);
			return Boolean( inheritance.(@type == getQualifiedClassName(type)).length() > 0 );
		}
		
		/**
		 * Targeted reflection describing an object's inheritance, including
		 * extended classes and implemented interfaces.
		 * 
		 * @param	value			The object or class to introspect.
		 * 
		 * @return					A list of XML inheritance descriptions.
		 */
		public static function describeInheritance(value:Object):XMLList
		{
			var dtcr : DescribeTypeCacheRecord = DescribeTypeCache.describeType(value);
			return (dtcr.typeDescription as XML).factory.*.(localName() == "extendsClass" || localName() == "implementsInterface");
		}
		
		public static function getType(value:Object):Class
		{
			var results : Class = (value is String) ? typeCache[String(value)] as Class : null;
			
			if (results == null) {
				
				if (value is Class) 		results = value as Class;
				else if (value is Proxy)	results = getDefinitionByName(getQualifiedClassName(value as Proxy)) as Class;
				else if (value is String)   results = getDefinitionByName(String(value)) as Class;
				else						results = value.constructor as Class;
				
				if (value is String) 		typeCache[String(value)] = results;
			}
			
			return results;
		}
		
		/**
		 * Dictionary of Class values for registered string class names 
		 */		
		private static var typeCache:Dictionary    = new Dictionary();
		
	}
}