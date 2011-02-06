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

package com.codecatalyst.util
{	
	import flash.utils.Dictionary;
	
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	
	public class FactoryPool implements IObjectPool
	{
		// ========================================
		// Protected properties
		// ========================================
		
		/**
		 * Factory.
		 */
		protected var factory:IFactory;
		
		/**
		 * Maximum size (i.e. maximum # of pooled instances).
		 */
		protected var maximumSize:Number = NaN;
		
		/**
		 * Index of instances created by this pool.
		 */
		protected var instanceIndex:Dictionary = new Dictionary();
		
		/**
		 * Pooled instance(s).
		 */
		protected var pooledInstances:Array = new Array();
		
		/**
		 * Index of pooled instance(s) - for fast lookup. 
		 */
		protected var pooledInstanceIndex:Dictionary = new Dictionary();
		
		/**
		 * Indicates whether this pool is full.
		 */
		protected function get isFull():Boolean
		{
			return ( ! isNaN( maximumSize ) && pooledInstances.length >= maximumSize );
		}
		
		// ========================================
		// Constructor
		// ========================================
		
		/**
		 * Constructor.
		 */
		public function FactoryPool( factory:IFactory, maximumSize:Number = NaN )
		{
			super();
			
			this.factory = factory;
			this.maximumSize = maximumSize;
		}
		
		// ========================================
		// Public methods
		// ========================================	
		
		/**
		 * @inheritDoc
		 */
		public function acquireInstance():*
		{
			if ( pooledInstances.length > 0 )
			{
				// Pop and return a pooled instance.
				
				var pooledInstance:* = pooledInstances.pop();
				pooledInstanceIndex[ pooledInstance ] = null;
				
				return pooledInstance;
			}
			else
			{
				// Create and return a new instance.
				
				var instance:* = factory.newInstance();
				instanceIndex[ instance ] = true;
				
				return instance;
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function releaseInstance( instance:* ):void
		{
			// Check that the specified instance was created by this FactoryPool instance.
			
			if ( instanceIndex[ instance ] != null )
			{
				// Check that the pool is not full.
				
				if ( ! isFull )
				{
					// Check that the specified instance is not already in the pool.
					
					if ( ! pooledInstanceIndex[ instance ] )
					{
						// Add the instance to the pool.
						
						pooledInstances.push( instance );
						pooledInstanceIndex[ instance ] = instance;
					}
				}
				else
				{
					instanceIndex[ instance ] = null;
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function reset():void
		{
			instanceIndex = null;
			pooledInstances = new Array();
			pooledInstanceIndex = null;
		}
	}
}