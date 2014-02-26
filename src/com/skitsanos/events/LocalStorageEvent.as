package com.skitsanos.events
{
	import flash.events.Event;

	public class LocalStorageEvent extends Event
	{
		public static const SUCCESS:String = "loscalStorageSuccess";
		public static const ERROR:String = "loscalStorageFailed";

		public var message:String;
		public var data:Object;

		public function LocalStorageEvent(type:String, message:String = null, data:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
			this.message = message;
		}

	}
}