/**
 * http://rojored.com/#pure-as3-commands
 */
package com.skitsanos.utils.command
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	/**
	 *
	 *  $Id: AbstractCommand.as 52 2008-02-06 02:57:19Z gabriel_montagne $
	 *
	 */
	public class AbstractCommand extends EventDispatcher implements ICommand
	{

		public function execute():void
		{
			trace("AbstractCommand: execute method not implemented");
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
