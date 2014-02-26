/**
 * Queue progress event
 * @author Skitsanos
 */
package com.skitsanos.utils.command
{
	import flash.events.Event;

	public class CommandQueueEvent extends Event
	{
		public static const PROGRESS:String = "commandQueueProgressEvent";
		public var index:int = 0;
		public var total:int = 0;

		public function CommandQueueEvent(type:String, index:int, total:int, bubbles:Boolean = false, cancelable:Boolean = false)
		{
			super(type, bubbles, cancelable);
			this.index = index;
			this.total = total;
		}

	}
}