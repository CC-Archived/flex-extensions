package asset.image.search
{
	public class SearchAsset
	{
		[Embed(source="/asset/image/search/clearSearch.png")]
		/**
		 * 'Clear' search icon.
		 */
		public static const SEARCH_CLEAR:Class;
		
		[Embed(source="/asset/image/search/search.png")]
		/**
		 * 'Search For...' search icon.
		 */
		public static const SEARCH_FOR:Class;
		
		
		[Embed(source="/asset/image/search/busy.png")]
		/**
		 * 'Busy searching...' icon.
		 */
		public static const SEARCH_BUSY:Class;
		
	}
}