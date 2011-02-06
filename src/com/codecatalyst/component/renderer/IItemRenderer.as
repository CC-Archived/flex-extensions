////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2008 CodeCatalyst, LLC - http://www.codecatalyst.com/
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

package com.codecatalyst.component.renderer
{
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.IDropInListItemRenderer;
	import mx.controls.listClasses.IListItemRenderer;

	/**
	 *  Name of the class to use as the default skin for the background and border. 
	 *  @default "mx.skins.halo.HaloBorder"
	 */
	[Style( name="borderSkin", type="Class", inherit="no", states="up, over, down, disabled, selectedUp, selectedOver, selectedDown, selectedDisabled" )]
	
	public interface IItemRenderer extends IListItemRenderer, IDropInListItemRenderer
	{
		[Bindable( "isMouseOverChanged" )]
		/**
		 * Indicates whether the mouse is over this item.
		 */
		function get isMouseOver():Boolean;

		[Bindable( "isMouseDownChanged" )]
		/**
		 * Indicates whether the mouse is down on this item.
		 */
		function get isMouseDown():Boolean;

		[Bindable( "isHighlightedChanged" )]
		/**
		 * Indicates whether this item is highlighted.
		 */
		function get isHighlighted():Boolean;

		[Bindable( "isSelectedChanged" )]
		/**
		 * Indicates whether this item is selected.
		 */
		function get isSelected():Boolean;
	}
}