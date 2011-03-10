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

package com.codecatalyst.component.behavior.ui
{
	import com.codecatalyst.component.behavior.AbstractBehavior;
	import com.codecatalyst.component.behavior.IBehavior;
	import com.codecatalyst.data.Property;
	import com.codecatalyst.util.ArrayUtil;
	import com.codecatalyst.util.DisplayObjectContainerUtil;
	import com.codecatalyst.util.invalidation.InvalidationTracker;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	
	import mx.core.Container;
	import mx.events.ChildExistenceChangedEvent;

	/**
	 * Dispatched when the user selects a child DisplayObject.
	 */
	[Event(name="change",type="flash.events.Event")]
	
	public class Selectable extends AbstractBehavior implements IBehavior
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>selectedItem</code> and <code>selectedItems</code> properties.
		 * 
		 * @see #selectedItem
		 * @see #selectedItems
		 */
		protected var _selectedItems:Array = new Array();
		
		/**
		 * Property invalidation tracker.
		 */
		protected var propertyTracker:InvalidationTracker = new InvalidationTracker( this as IEventDispatcher );
		
		/**
		 * 'data' Property.
		 * 
		 * @see #dataField
		 */
		protected var dataProperty:Property = null;
		
		/**
		 * 'selected' Property.
		 * 
		 * @see #selectedField
		 */
		protected var selectedProperty:Property = null;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * Target container.
		 */
		public var target:Container = null;
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * Target item 'selected' property path.
		 */
		public var selectedField:String = "selected";
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * Target item 'data' property path.
		 */
		public var dataField:String = "data";
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * Target container child selection change event.
		 */
		public var changeEventType:String = Event.CHANGE;
		
		[Bindable]
		[Invalidate("properties")]
		/**
		 * Allow multiple selection.
		 */
		public var allowMultipleSelection:Boolean = true;
		
		[Bindable("selectedItemsChanged")]
		[Invalidate("properties")]
		/**
		 * Selected items.
		 */
		public function get selectedItem():Object
		{
			try
			{
				return selectedItems[ 0 ];
			}
			catch ( error:Error )
			{
				// NOTE: Intentionally ignored.
			}
			
			return null;
		}
		
		public function set selectedItem( value:Object ):void
		{
			if ( selectedItem != value )
			{
				_selectedItems = [ value ];
				
				dispatchEvent( new Event( "selectedItemsChanged" ) );
			}
		}
		
		[Bindable( "selectedItemsChanged" )]
		[Invalidate("properties")]
		/**
		 * Selected items.
		 */
		public function get selectedItems():Array
		{
			return _selectedItems;
		}
		
		public function set selectedItems( value:Array ):void
		{
			if ( _selectedItems != value )
			{
				_selectedItems = value;
				
				dispatchEvent( new Event( "selectedItemsChanged" ) );
			}
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function Selectable()
		{
			super();
			
			dataProperty     = new Property( dataField );
			selectedProperty = new Property( selectedField );
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if ( propertyTracker.invalidated( "target" ) )
			{
				var previousTarget:Container = propertyTracker.previousValue( "target" );
				if ( previousTarget != null )
				{
					removeContainerListeners( previousTarget );
					apply( previousTarget, removeChangeListener, changeEventType );
				}
				
				if ( target != null )
				{
					apply( target, addChangeListener, changeEventType );
					addContainerListeners( target );
				}
			}
			
			if ( propertyTracker.invalidated( "changeEventType" ) )
			{
				var previousChangeEventType:String = propertyTracker.previousValue( "changeEventType" );
				
				apply( target, removeChangeListener, previousChangeEventType );
				apply( target, addChangeListener, changeEventType );
			}
			
			if ( propertyTracker.invalidated( "dataField" ) )
			{
				dataProperty = new Property( dataField );
			}
			
			if ( propertyTracker.invalidated( "selectedField" ) )
			{
				selectedProperty = new Property( selectedField );
			}

			if ( propertyTracker.invalidated( [ "target", "dataField", "selectedField", "allowMultipleSelection", "selectedItems", "selectedItem" ] ) )
			{
				if ( target != null )
					apply( target, updateSelection );
			}
		}
		
		/**
		 * Apply the specified method to the children of the specified container.
		 */
		protected function apply( container:Container, method:Function, ...additionalParameters ):void
		{
			DisplayObjectContainerUtil.children( container )
				.forEach( function ( child:DisplayObject, index:int, array:Array ):void {
					method.apply( null, [ child ].concat( additionalParameters ) );
				});
		}
		
		/**
		 * Add Container ChildExistenceChangedEvent listeners.
		 */
		protected function addContainerListeners( container:Container ):void
		{
			container.addEventListener( ChildExistenceChangedEvent.CHILD_ADD, container_childAddHandler, false, 0, true );
			container.addEventListener( ChildExistenceChangedEvent.CHILD_REMOVE, container_childRemoveHandler, false, 0, true );
		}
		
		/**
		 * Remove Container ChildExistenceChangedEvent listeners.
		 */
		protected function removeContainerListeners( container:Container ):void
		{
			container.removeEventListener( ChildExistenceChangedEvent.CHILD_ADD, container_childAddHandler );
			container.removeEventListener( ChildExistenceChangedEvent.CHILD_REMOVE, container_childRemoveHandler );
		}
		
		/**
		 * Add change event handler to the specified DisplayObject.
		 */
		protected function addChangeListener( child:DisplayObject, changeEventType:String ):void
		{
			child.addEventListener( changeEventType, child_changeHandler, false, 0, true );
		}	
		
		/**
		 * Remove change event handler from the specified DisplayObject.
		 */
		protected function removeChangeListener( child:DisplayObject, changeEventType:String ):void
		{
			child.removeEventListener( changeEventType, child_changeHandler );
		}
		
		/**
		 * Update the specified DisplayObject to reflect the current selection state.
		 */
		protected function updateSelection( child:DisplayObject ):void
		{
			if ( dataProperty.exists( child ) && selectedProperty.exists( child ) )
			{
				var data:Object = dataProperty.getValue( child );
				var selected:Boolean = allowMultipleSelection ? ArrayUtil.contains( selectedItems, data ) : ( selectedItem == data );
				
				selectedProperty.setValue( child, selected );
			}
		}
		
		/**
		 * Handle Container ChildExistenceChangedEvent.CHILD_ADD.
		 */
		protected function container_childAddHandler( event:ChildExistenceChangedEvent ):void
		{
			updateSelection( event.relatedObject );
			
			addChangeListener( event.relatedObject, changeEventType );
		}
		
		/**
		 * Handle Container ChildExistenceChangedEvent.CHILD_REMOVE.
		 */
		protected function container_childRemoveHandler( event:ChildExistenceChangedEvent ):void
		{
			removeChangeListener( event.relatedObject, changeEventType );
		}
		
		/**
		 * Handle DisplayObject change event.
		 * 
		 * @see #addChangeListener()
		 * @see #removeChangeListener()
		 * @see #changeEventType
		 */
		protected function child_changeHandler( event:Event ):void
		{
			var child:DisplayObject = event.target as DisplayObject;
			
			if ( dataProperty.exists( child ) && selectedProperty.exists( child ) )
			{
				var data:Object      = dataProperty.getValue( child );
				var selected:Boolean = selectedProperty.getValue( child );
				
				if ( allowMultipleSelection )
				{
					if ( selected )
						selectedItems = ArrayUtil.merging( selectedItems, data );
					else
						selectedItems = ArrayUtil.excluding( selectedItems, data );
				}
				else
				{
					selectedItem = data;
				}
				
				dispatchEvent( new Event( Event.CHANGE ) );
			}
		}
	}
}