package com.codecatalyst.util
{
	public class FormatUtil
	{
		/**
		 * Format the specified value as a Number with an ordinal suffix (ex. 1st, 2nd, 3rd, etc. ).
		 */
		public static function formatNumberOrdinalSuffix( value:* ):String
		{
			// Only apply an ordinal suffix if the number is a whole number.
			
			if ( NumberUtil.isWholeNumber( value ) )
			{
				var number:Number = Number( value );
				
				// Numbers from 11 to 13 don't have st, nd, rd
				
				if ( (number % 100) > 10  && (number % 100) < 14 ) 
					return number + "th";
				
				switch ( number % 10 )
				{
					case 1:
						return number + "st";
					case 2:
						return number + "nd";
					case 3:
						return number + "rd";
					default:
						return number + "th";
				}
			}
			
			// Return the unaltered original value.
			
			return value;
		}
	}
}