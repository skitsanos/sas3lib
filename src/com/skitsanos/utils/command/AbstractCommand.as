/**
 * http://rojored.com/#pure-as3-commands
 */
package com.skitsanos.utils.command
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class AbstractCommand extends EventDispatcher implements ICommand
	{

		public var data:Object = null;

		public function execute():void
		{
			//trace("AbstractCommand: execute method not implemented");
		}

		protected function onCommandComplete():void
		{
			dispatchEvent(new Event(Event.COMPLETE, true, true));
		}

		protected function onCommandFail(errorMessage:String = null):void
		{
			dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true, true, errorMessage));
		}
	}
}
