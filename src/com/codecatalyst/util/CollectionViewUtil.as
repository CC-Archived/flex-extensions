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

package com.codecatalyst.util
{
	import mx.collections.ArrayCollection;
	import mx.collections.ICollectionView;
	import mx.collections.IList;
	import mx.collections.ListCollectionView;
	import mx.collections.XMLListCollection;
	import mx.core.mx_internal;
	
	use namespace mx_internal;
	
	public class CollectionViewUtil
	{
		// ========================================
		// Public methods
		// ========================================
		
		/**
		 * Create a ICollectionView for the specified data provider object.
		 */
		public static function create( value:Object ):ICollectionView
		{
			var collectionView:ICollectionView = null;
			
			if ( value is Array )
			{
				collectionView = new ArrayCollection( value as Array );
			}
			else if ( value is ICollectionView )
			{
				collectionView = ICollectionView( value );
			}
			else if ( value is IList )
			{
				collectionView = new ListCollectionView( IList( value ) );
			}
			else if ( value is XMLList )
			{
				collectionView = new XMLListCollection( value as XMLList );
			}
			else if ( value is XML )
			{
				var xl:XMLList = new XMLList();
				xl += value;
				
				collectionView = new XMLListCollection( xl );
			}
			else
			{
				var temp:Array = [];
				
				if ( value != null )
					temp.push( value );
				
				collectionView = new ArrayCollection( temp );
			}
			
			return collectionView;			
		}
		
		/**
		 * Silently clear the filterFunction and reset the list to have all elements available
		 * for a future filter scan.
		 *  
		 * @param target
		 * @param silent
		 */
		public static function reset( target : ListCollectionView, silent:Boolean=true) : ListCollectionView
		{
			if (target.filterFunction != null) {
				
				var origFlag : Boolean = target.mx_internal::dispatchResetEvent;
				
				target.filterFunction = null;
				
				try {
					if (silent == true) {
						
						target.mx_internal::dispatchResetEvent = false;
						target.mx_internal::reset();
						
					} else {
						
						target.refresh();
						
					}
					
				} finally {
					
					target.mx_internal::dispatchResetEvent = origFlag;
				}
			}
			
			return target;
		}
		
		/**
		 * Since ListCollectionViews may have filters applied to the list
		 * this method quickly gathers all non-filtered items into an array.
		 *  
		 * @param list ListCollectionView
		 * @return Array
		 */
		public static function toArray( list:ListCollectionView ) : Array 
		{
			var results : Array = [ ];
			
			if ( list != null) 
			{
				for each (var it:* in list) 
				{
					results.push(it);
				}
			}
			
			return results;
		}
	}
	
}