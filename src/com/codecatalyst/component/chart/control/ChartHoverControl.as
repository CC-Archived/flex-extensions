package com.codecatalyst.component.chart.control
{
	import com.codecatalyst.util.invalidation.InvalidationTracker;
	
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import mx.charts.chartClasses.CartesianDataCanvas;
	import mx.charts.chartClasses.ChartState;
	
	/**
	 * Dispatched when the user hovers the mouse over the chart.
	 */
	[Event(name="hover", type="com.codecatalyst.component.chart.control.ChartHoverEvent")]
	
	public class ChartHoverControl extends CartesianDataCanvas
	{
		// ========================================
		// Public properties
		// ========================================
		
		[Bindable]
		[Invalidate("displaylist")]
		/**
		 * Hover X value, in data coordinates.
		 */
		public var hoverX:*;
		
		[Bindable]
		[Invalidate("displaylist")]
		/**
		 * Hover Y value, in data coordinates.
		 */
		public var hoverY:*;
		
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Property invalidation tracker.
		 */
		protected var propertyTracker:InvalidationTracker = new InvalidationTracker( this as IEventDispatcher );	

		/**
		 * Indicates whether this control is currently performing a hover operation.
		 */
		protected var isHovering:Boolean = false;
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function ChartHoverControl()
		{
			super();
		}
		
		// ========================================
		// Protected methods
		// ========================================
		
		/**
		 * @inheritDoc
		 */
		override protected function createChildren():void
		{
			super.createChildren();
			
			// Add MouseEvent.ROLL_OVER, MouseEvent.ROLL_OUT event listeners.
			
			chart.addEventListener( MouseEvent.ROLL_OVER, rollOverHandler, false, 0, true );
			chart.addEventListener( MouseEvent.ROLL_OUT,  rollOutHandler,  false, 0, true );
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function updateDisplayList( unscaledWidth:Number, unscaledHeight:Number ):void
		{
			super.updateDisplayList( unscaledWidth, unscaledHeight );
			
			if ( ( chart == null ) || ( chart.chartState == ChartState.PREPARING_TO_HIDE_DATA ) || ( chart.chartState == ChartState.HIDING_DATA ) )
				return;		
			
			graphics.clear();
			
			if ( enabled )
			{
				if ( ( hoverX != null ) || ( hoverY != null ) )
				{
					var point:Point = dataToLocal( hoverX, hoverY );
					
					drawHoverIndicatorForPoint( point );
				}
			}
		}
		
		/**
		 * Draw a hover indicator at the specified point.
		 */
		protected function drawHoverIndicatorForPoint( point:Point ):void
		{
			// Override in subclasses.
		}
		
		/**
		 * Hover at the specified Point in local coordinates.
		 */
		protected function hover( point:Point ):void
		{
			// Store the hover coordinate in data coordinates.
			
			if ( point != null )
			{
				var hoverData:Object = localToData( point );
				
				hoverX = hoverData[ 0 ];
				hoverY = hoverData[ 1 ];
			}
			else
			{
				hoverX = null;
				hoverY = null;
			}

			// Create, populate and dispatch a ChartHoverEvent.HOVER event
			
			var chartHoverEvent:ChartHoverEvent = new ChartHoverEvent( ChartHoverEvent.HOVER );
			
			if ( hoverData != null )
			{
				chartHoverEvent.x = hoverX;
				chartHoverEvent.y = hoverY;
			}
			
			dispatchEvent( chartHoverEvent );
			
			// Mark the display as dirty
			
			invalidateDisplayList();
		}
		
		/**
		 * Handle MouseEvent.MOUSE_MOVE.
		 */
		protected function mouseMoveHandler( event:MouseEvent ):void
		{
			// Update the hover point.
			
			var point:Point = new Point( this.mouseX, this.mouseY );
			
			hover( point );
		}
		
		/**
		 * Handle MouseEvent.ROLL_OVER.
		 */
		protected function rollOverHandler( event:MouseEvent ):void
		{
			// Hover operation initiated
			
			isHovering = true;
			
			// Add MouseEvent.MOUSE_MOVE event listener
			
			systemManager.addEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler, false, 0, true );
		}
		
		/**
		 * Handle MouseEvent.ROLL_OUT.
		 */
		protected function rollOutHandler( event:MouseEvent ):void
		{
			// Clear the hover point.
			
			hover( null );
			
			// Hover operation completed
			
			isHovering = false;
						
			// Remove MouseEvent.MOUSE_MOVE event listener
			
			systemManager.removeEventListener( MouseEvent.MOUSE_MOVE, mouseMoveHandler );
		}
	}
}