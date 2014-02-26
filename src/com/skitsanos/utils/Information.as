package com.skitsanos.utils
{
	import flash.system.Capabilities;

	public class Information
	{
		/**
		 * Collects Flash Player version information
		 */
		public static function PlayerVersion():Object
		{
			var obj:Object = new Object();
			obj = {};

			obj["platform"] = Capabilities.version.split(" ")[0];

			var v:Array = Capabilities.version.split(" ")[1].toString().split(",");
			obj["majorVersion"] = v[0];
			obj["minorVersion"] = v[1];
			obj["buildVersion"] = v[2];

			return obj;
		}

		/**
		 * Checks if current flash player supports HD video
		 */
		public static function supportsHdVideo():Boolean
		{
			if (PlayerVersion().buildVersion >= 115)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
	}
}