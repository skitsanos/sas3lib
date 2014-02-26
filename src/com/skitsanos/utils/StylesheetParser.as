package com.skitsanos.utils
{
	public class StylesheetParser
	{
		/**
		 * Allows to parse css like definitions from string to object
		 */
		public static function Parse(input:String):Object
		{
			if (input == null || !Boolean(input)) return null;
			var retObject:Object = {};

			var cursor:int = 0;
			var found_key:String;
			var index:int;
			while (true)
			{

				if (found_key == null)
				{
					index = input.indexOf(':', cursor);
					if (index >= 0)
					{
						while (input.charAt(index - 1) == ' ') index--;
						found_key = input.substring(cursor, index);
						cursor = index + 1;
						while (input.charAt(cursor) == ' ') cursor++;
					}
					else
					{
						break;
					}
				}
				else
				{
					index = input.indexOf(';', cursor);
					if (index >= 0)
					{
						while (input.charAt(index - 1) == ' ') index--;
						retObject[ found_key ] = input.substring(cursor, index);
						found_key = null;
						cursor = index + 1;
						while (input.charAt(cursor) == ' ') cursor++;
					}
					else
					{
						retObject[ found_key ] = input.substr(cursor);
						break;
					}
				}
			}

			return retObject;
		}
	}
}