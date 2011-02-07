package asset.image.cursor
{
	public class CursorAsset
	{
		[Embed(source="/asset/image/cursor/grab.png")]
		/**
		 * 'Grab' cursor.
		 */
		public static const GRAB:Class;
		
		[Embed(source="/asset/image/cursor/grabbing.png")]
		/**
		 * 'Grabbing' cursor.
		 */
		public static const GRABBING:Class;
		
		[Embed(source="/asset/image/cursor/resize-column.png")]
		/**
		 * 'Resize Column' cursor.
		 */
		public static const RESIZE_COLUMN:Class;
		
		[Embed(source="/asset/image/cursor/resize-row.png")]
		/**
		 * 'Resize Row' cursor.
		 */
		public static const RESIZE_ROW:Class;
		
		[Embed(source="/asset/image/cursor/zoom-in.png")]
		/**
		 * 'Zoom In' cursor.
		 */
		public static const ZOOM_IN:Class;
		
		[Embed(source="/asset/image/cursor/zoom-out.png")]
		/**
		 * 'Zoom Out' cursor.
		 */
		public static const ZOOM_OUT:Class;
	}
}