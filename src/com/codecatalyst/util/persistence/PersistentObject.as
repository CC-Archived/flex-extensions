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

package com.codecatalyst.util.persistence
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import mx.binding.utils.ChangeWatcher;
	import mx.events.PropertyChangeEvent;
	import mx.utils.DescribeTypeCache;
	
	/**
	 * An Object whose [Bindable] [Persistent] properties are persisted via a key value store when changed.
	 * 
	 * @author John Yanarella
	 */
	public class PersistentObject extends EventDispatcher
	{
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable("keyValueStoreChanged")]
		/**
		 * Key value store.
		 */
		public function get keyValueStore():IKeyValueStore
		{
			return _keyValueStore;
		}
		
		public function set keyValueStore( value:IKeyValueStore ):void
		{
			if ( value != _keyValueStore )
			{
				_keyValueStore = value;
				
				if ( keyValueStore != null )
					restorePersistedValues();
				
				dispatchEvent( new Event( "keyValueStoreChanged" ) );
			}
		}
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>keyValueStore</code>.
		 */
		protected var _keyValueStore:IKeyValueStore;
		
		/**
		 * Persistent properties.
		 */
		protected var persistentPropertyNames:Array = new Array();
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function PersistentObject( keyValueStore:IKeyValueStore = null )
		{
			super();
			
			this.keyValueStore = keyValueStore;
			
			processPersistentAnnotations();
			
			if ( keyValueStore != null )
				restorePersistedValues();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Process any [Persisted] annotations on this instance.
		 */
		protected function processPersistentAnnotations():void
		{
			var description:XML = DescribeTypeCache.describeType( this ).typeDescription;
			
			var list:XMLList = description..metadata.(@name == 'Persistent');
			for each ( var item:XML in list )
			{
				// Parse the type description.
				var property:XML = item.parent();
				var invalidateMetadata:XML = property.metadata.(@name == "Persistent")[0]; 
				var propertyName:String = property.@name;
				
				// Watch for property value changes.
				if ( ! ChangeWatcher.canWatch( this, propertyName ) )
					throw new Error( "The specified property is not [Bindable]." );
				
				var watcher:ChangeWatcher = ChangeWatcher.watch( this, [ propertyName ], createChangeEventHandler( propertyName ) );
				
				// Add the property's name to the set of persistent properties.
				persistentPropertyNames.push( propertyName );
			}
		}
		
		/**
		 * Restore persisted values for persistent properties.
		 */
		protected function restorePersistedValues():void
		{
			for each ( var propertyName:String in persistentPropertyNames )
			{
				this[ propertyName ] = getPropertyValue( propertyName );
			}
		}
		
		/**
		 * Create a change event handler for the specified property name.
		 */
		protected function createChangeEventHandler( propertyName:String ):Function
		{
			var handler:Function =
				
				function ( event:Event ):void
				{
					if ( event is PropertyChangeEvent )
					{
						if ( ( event as PropertyChangeEvent ).property == propertyName )
						{
							setPropertyValue( propertyName, this[ propertyName ] );
						}
					}
					else
					{
						setPropertyValue( propertyName, this[ propertyName ] );
					}
				};
			
			return handler;
		}
		
		/**
		 * Get the specified property's value.
		 */
		protected function getPropertyValue( propertyName:String ):Object
		{
			return keyValueStore.getValue( propertyName );
		}
		
		/**
		 * Set the specified property's value.
		 */
		protected function setPropertyValue( propertyName:String, value:Object ):void
		{
			keyValueStore.setValue( propertyName, value );
		}
	}
}