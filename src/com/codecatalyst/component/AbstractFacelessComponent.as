////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2010 CodeCatalyst, LLC - http://www.codecatalyst.com/
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

package com.codecatalyst.component
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	import mx.core.IInvalidating;
	import mx.core.IMXMLObject;
	import mx.core.UIComponent;
	import mx.events.FlexEvent;
	
	/**
	 * Dispatched when the faceless component has finished its construction and has all initialization properties set.
	 */
	[Event( name="initialize", type="mx.events.FlexEvent" )]
	
	/**
	 * Dispatched when the faceless component has finished its construction and property processing.
	 */
	[Event( name="creationComplete", type="mx.events.FlexEvent" )]
	
	public class AbstractFacelessComponent extends EventDispatcher implements IMXMLObject, IInvalidating
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Backing variable for <code>document</code> property.
		 */
		protected var _document:Object = null;
		
		/**
		 * Backing variable for <code>id</code> property.
		 */
		protected var _id:String = null;
		
		/**
		 * Backing variable for <code>initialized</code> property.
		 */
		protected var _initialized:Boolean = false;
		
		/**
		 * Backing variable for <code>isDocumentCreated</code> property.
		 */
		protected var _isDocumentCreated:Boolean = false;
		
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable( "initialize" )]
		/**
		 * Enclosing document in which this component lives.
		 */
		public function get document():Object
		{
			return _document;
		}
		
		[Bindable( "initialize" )]
		/**
		 * Unique identifier given to this component.
		 */
		public function get id():String
		{
			return _id;
		}
		
		[Bindable( "initialize" )]
		/**
		 * Initialization state.
		 */
		public function get isInitialized():Boolean
		{
			return _initialized;
		}
		
		[Bindable( "creationComplete" )]
		/**
		 * Document creation state.
		 */
		public function get isDocumentCreated():Boolean
		{
			return _isDocumentCreated;
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function AbstractFacelessComponent( target:IEventDispatcher = null )
		{
			super( target );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		public function initialized( document:Object, id:String ):void
		{
			_id 		 = id;
			_initialized = true;
			_document    = document;
			
			dispatchEvent( new FlexEvent( FlexEvent.INITIALIZE ) );
			
			setDocument( document );
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateProperties():void
		{
			// Implement in subclasses (if applicable).
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateSize():void
		{
			// Implement in subclasses (if applicable).
		}
		
		/**
		 * @inheritDoc
		 */
		public function invalidateDisplayList():void
		{
			// Implement in subclasses (if applicable).
		}
		
		/**
		 * @inheritDoc
		 */
		public function validateNow():void
		{
			// Implement in subclasses (if applicable).
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * Internal setter for <code>document</code> property.
		 * 
		 * @see #documentedCreated()
		 */
		protected function setDocument( value:Object ):void
		{
			_document = value;
			_isDocumentCreated = false;
			
			if ( _document is IEventDispatcher )
			{
				var documentDispatcher:IEventDispatcher = _document as IEventDispatcher;
				
				if ( documentDispatcher is UIComponent )
				{
					var documentComponent:UIComponent = documentDispatcher as UIComponent;
					
					if ( documentComponent.initialized )
						documentCreated();
				}
				
				if ( !_isDocumentCreated )
				{
					// Listen for 'creationComplete' on containing document to ensure all bound properties have been set.
					
					documentDispatcher.addEventListener( FlexEvent.CREATION_COMPLETE, document_creationCompleteHandler );
				}
			}			
		}
		
		/**
		 * Document created handler.  Subclasses should override to do post-document initialization.
		 */
		protected function documentCreated():void
		{
			_isDocumentCreated = true;
			dispatchEvent( new FlexEvent( FlexEvent.CREATION_COMPLETE ) );
		}
		
		/**
		 * Internal handler for document FlexEvent.CREATION_COMPLETE.
		 * 
		 * @private
		 */
		protected function document_creationCompleteHandler( event:FlexEvent ):void
		{
			_document.removeEventListener( FlexEvent.CREATION_COMPLETE, document_creationCompleteHandler );
			
			documentCreated();
		}
	}
}