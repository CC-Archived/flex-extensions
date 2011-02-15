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
	import flash.display.DisplayObjectContainer;
	
	/**
	 * Dispatched when the user selects a Selectable DisplayObject.
	 */
	[Event(name="change",type="flash.events.Event")]
	
	public class Selectable extends AbstractBehavior implements IBehavior
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>selectedItems</code> property.
		 * 
		 * @see #selectedItems
		 */
		protected var _selectedItems:Array = new Array();
		
		/**
		 * Indicates whether the <code>selectedItems</code> property has been invalidated.
		 * 
		 * @see #selectedItems
		 * @see #commitProperties()
		 */
		protected var selectedItemsChanged:Boolean = false;
		
		/**
		 * Invalidation tracker.
		 */
		protected var tracker:InvalidationTracker = new InvalidationTracker( this as IEventDispatcher );
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable]
		[Invalidate]
		/**
		 * Target item 'selected' property path.
		 */
		public var selectedField:String = "selected";
		
		[Bindable]
		[Invalidate]
		/**
		 * Target item 'data' property path.
		 */
		public var dataField:String = "dataField";
		
		[Bindable]
		[Invalidate]
		/**
		 * Target container.
		 */
		public var target:DisplayObjectContainer = null;
		
		[Bindable("selectedItemsChanged")]
		[Invalidate]
		/**
		 * Selected items.
		 */
		public function get selectedItem():Object
		{
			try
			{
				return selectedItems[ 0 ] as DateRange;
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
		[Invalidate]
		/**
		 * Selected items.
		 */
		public function get selectedItems():void
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
			
			if ( targetChanged )
			{
				updateSelection();
				
				targetChanged = false;
			}
			
			if ( selectedItemsChanged )
			{
				updateSelection();
				
				selectedItemsChanged = false;
			}
		}
		
		/**
		 * Update the target children to reflect the selection state.
		 */
		protected function updateSelection():void
		{
			var children:Array = DisplayObjectContainerUtil.children( target );
			
			for each ( var child:DisplayObject in children )
			{
				var selectedProperty:Property = new Property( selectedField );
				var dataProperty:Property     = new Property( dataField );
				
				dataProperty.setValue( ArrayUtil.contains( selectedItems, selectedProperty.getValue( child ) );
			}
		}
	}
}