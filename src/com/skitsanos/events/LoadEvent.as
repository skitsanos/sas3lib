package com.skitsanos.events
{
	import flash.events.Event;

	public class LoadEvent extends Event
	{
		public static const DOWNLOAD_INPROGRESS:String = "progress";
		public static const DOWNLOAD_COMPLETE:String = "complete";

		public function LoadEvent(type:String)
		{
			super(type, true);
		}
	}
}