package com.codecatalyst.util.invalidation.mxml
{
	import com.codecatalyst.util.invalidation.InvalidationTracker;
	
	import flash.events.IEventDispatcher;
	
	import mx.core.IMXMLObject;
	
	/**
	 * MXML implementation of InvalidationTracker.
	 * 
	 * @see com.codecatalyst.util.invalidation.InvalidationTracker
	 */
	public class InvalidationTracker extends com.codecatalyst.util.invalidation.InvalidationTracker implements IMXMLObject
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Indicates whether this component has been initialized.
		 */
		protected var _initialized:Boolean = false;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function InvalidationTracker()
		{
			super( null );
		}
		
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * @inheritDoc 
		 */
		public function initialized( document:Object, id:String ):void
		{
			source = document as IEventDispatcher;
			
			_initialized = true;
			
			setup();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override protected function setup():void
		{
			if ( _initialized )
				super.setup();
		}
	}
}