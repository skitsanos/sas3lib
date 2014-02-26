package com.skitsanos.events
{
	import flash.events.Event;

	public class WindowEvent extends Event
	{
		public static const CLOSING:String = "closing";
		public static const MAXIMIZING:String = "maximizing";
		public static const MINIMIZING:String = "minimizing";
		public static const RESTORING:String = "restoring";

		public static const CLOSED:String = "closed";
		public static const MAXIMIZED:String = "maximized";
		public static const MINIMIZED:String = "minimized";
		public static const RESTORED:String = "restored";

		public static const RESIZE_START:String = "resizeStart";
		public static const RESIZING:String = "resizing";
		public static const RESIZE_END:String = "resizeEnd";

		public function WindowEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
		}

		override public function clone():Event
		{
			return new WindowEvent(type, bubbles, cancelable);
		}
	}
}