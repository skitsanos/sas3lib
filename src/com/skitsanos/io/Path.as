package com.skitsanos.io
{
	import com.skitsanos.utils.Strings;

	public class Path
	{
		/**
		 * Gets filename with extension for path specified
		 *
		 */
		public static function getFileName(path:String):String
		{
			if (Strings.startsWith(path, "/") == false)
			{
				path = "/" + path;
			}

			var reg:RegExp = new RegExp("/(?<filename>.*?\\.(?<ext>\\w+))");
			var obj:* = reg.exec(path);
			return obj[1];
		}

		public static function getFileNameWithoutExtension(path:String):String
		{
			//(.*)[\/\\]([^\/\\]+)\.\w+$
			var reg:RegExp = /(.*)[\/\\]([^\/\\]+)\.\w+$/
			var obj:* = reg.exec(path);
			return obj[2];
		}

		/**
		 * Returns .ext
		 */
		public static function getFileExtension(path:String):String
		{
			var reg:RegExp = new RegExp("(.*?)(\.[^.]*$|$)");
			var obj:* = reg.exec(path);
			return obj[2];
		}
	}
}