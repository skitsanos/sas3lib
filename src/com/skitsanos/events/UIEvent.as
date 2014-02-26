package com.skitsanos.events
{
	import flash.events.Event;

	public class UIEvent extends Event
	{
		public static const RESIZE:String = "uiEventResize";
		public static const SELECT:String = "uiEventSelect";
		public static const CLOSE:String = "uiEventClose";
		public static const ERROR:String = "uiEventError";
		public static const CHANGED:String = "uiEventChanged";

		public var result:Object;

		public function UIEvent(type:String, result:Object = null, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.result = result;
		}

	}
}