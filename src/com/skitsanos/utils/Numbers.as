package com.skitsanos.utils
{
	public class Numbers
	{
		public static function isNumber(value:*):Boolean
		{
			return value is Number;
		}

		public static function isEven(num:Number):Boolean
		{
			return num % 2 == 0;
		}

		public static function toPercent(value:Number, total:Number):Number
		{
			return value * (100 / total); //250*(100/1200)
		}

		public static function toCurrency(n:Number):String
		{
			return n.toFixed(2).toString();
		}

		public static function hexStringToNumber(value:String):Number
		{
			if (value.charAt(0) == "#" && value.length > 7)
			{
				return Number("*"); // NaN;
			}

			if (value.charAt(0) != "#" && value.length > 6)
			{
				return Number("*"); // NaN;
			}

			var newStr:String = value;
			if (value.charAt(0) == "#")
			{
				newStr = value.substr(1, value.length);
			}

			if (newStr.length < 6)
			{
				var z:String = "000000";
				// add zeros to the string to make it 6 characters long
				newStr = newStr + z.substr(0, z.length - newStr.length);
			}

			var numStr:String = "0x" + newStr;
			return Number(numStr);
		}
	}
}