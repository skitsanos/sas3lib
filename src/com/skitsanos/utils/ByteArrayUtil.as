/**
 * ByteArray Utils
 * @author Evgenios Skitsanos
 */
package com.skitsanos.utils
{
	import flash.utils.ByteArray;

	public class ByteArrayUtil
	{
		public static function stringToArray(text:String, encoding:String = "UTF-8"):ByteArray
		{
			var ba:ByteArray = new ByteArray();
			ba.writeMultiByte(text, encoding);
			return ba;
		}


		public static function arrayToString(array:ByteArray):String
		{
			return array.readUTF()
		}
	}
}