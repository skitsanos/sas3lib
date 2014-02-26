/**
 * Date/Time functions
 * @author Skitsanos
 */

package com.skitsanos.utils
{
	import flash.globalization.DateTimeFormatter;
	import flash.globalization.LocaleID;

	public class DateTime
	{

		public static function isDate(value:*):Boolean
		{
			return value is Date;
		}

		public static function lastDateInMonth(d:Date):int
		{
			var month:Date = new Date(d.fullYear, d.month + 1, 0);
			return month.date;
		}

		public function daysInMonth(month:int, year:int):int
		{
			var dd:Date = new Date(year, month, 0);
			return dd.getDate();
		}

		public static function isLeapYear(year:int):Boolean
		{
			return (year % 400 == 0) || ((year % 4 == 0) && (year % 100 != 0));
		}

		/**
		 * Retreives current date
		 */
		public static function today(requestedLocaleIDName:String = LocaleID.DEFAULT):String
		{
			var dateRateFormatter:DateTimeFormatter = new DateTimeFormatter(requestedLocaleIDName);
			var today:Date = new Date();
			return dateRateFormatter.format(today);
		}

		/**
		 * Retreives date of the day 3 days from now
		 */
		public static function getNextDate(today:Date = null, interval:int = 3, requestedLocaleIDName:String = LocaleID.DEFAULT):String
		{
			if (today == null)
			{
				today = new Date();
			}
			today = addDays(today, interval);
			var dateRateFormatter:DateTimeFormatter = new DateTimeFormatter(requestedLocaleIDName);
			return dateRateFormatter.format(today);
		}

		public static function addWeeks(date:Date, weeks:Number):Date
		{
			return addDays(date, weeks * 7);
		}

		public static function addDays(date:Date, days:Number):Date
		{
			return addHours(date, days * 24);
		}

		public static function addHours(date:Date, hrs:Number):Date
		{
			return addMinutes(date, hrs * 60);
		}

		public static function addMinutes(date:Date, mins:Number):Date
		{
			return addSeconds(date, mins * 60);
		}

		public static function addSeconds(date:Date, secs:Number):Date
		{
			var mSecs:Number = secs * 1000;
			var sum:Number = mSecs + date.getTime();
			return new Date(sum);
		}

		/**
		 * Compares two dates and returns difference as number
		 * @param    date1
		 * @param    date2
		 * @return
		 */
		public function compare(date1:Date, date2:Date):Number
		{
			var date1Timestamp:Number = date1.getTime();
			var date2Timestamp:Number = date2.getTime();

			var result:Number = -1;

			if (date1Timestamp == date2Timestamp)
			{
				result = 0;
			} else if (date1Timestamp > date2Timestamp)
			{
				result = 1;
			}

			return result;
		}

		/**
		 * Add working days to the date paramater
		 * */
		public static function addWorkingDays(date:Date, days:Number):Date
		{
			var tempDate:Date;
			var j:Number = days;

			for (var i:int = 1; i < days + 1; i++)
			{
				tempDate = addDays(date, i);
				if (tempDate.getDay() == 0 || tempDate.getDay() == 6)
				{
					j++
				}
			}

			tempDate = addDays(date, j);

			if (tempDate.getDay() == 6)
			{
				return addDays(date, j + 2);
			}
			else if (tempDate.getDay() == 0)
			{
				return addDays(date, j + 1);
			}
			else
			{
				return tempDate;
			}
		}

		public static function getUnixTime(d:Date):String
		{
			return d.getTime().toString();
		}
	}
}