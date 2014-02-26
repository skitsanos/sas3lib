/**
 * http://rojored.com/#pure-as3-commands
 */
package com.skitsanos.utils.command
{
	import flash.events.ErrorEvent;
	import flash.events.Event;

	/**
	 *
	 *  $Id: CommandQueue.as 52 2008-02-06 02:57:19Z gabriel_montagne $
	 *
	 */
	public class CommandQueue extends AbstractCommand
	{

		private var _commandList:Array;
		private var _currentCommandIndex:int = 0;
		private var _currentCommand:AbstractCommand;
		private var _abortOnFail:Boolean;

		public function CommandQueue(abortOnFail:Boolean = true)
		{
			_abortOnFail = abortOnFail;
			_commandList = [];
		}

		override public function execute():void
		{
			if (_currentCommandIndex >= _commandList.length)
			{
				onCommandComplete();
			}
			else
			{
				_currentCommand = _commandList[_currentCommandIndex++];
				_currentCommand.addEventListener(Event.COMPLETE, onCurrentCommandExecuted);
				_currentCommand.addEventListener(ErrorEvent.ERROR, onCurrentCommandExecuted);
				_currentCommand.execute();

				dispatchEvent(new CommandQueueEvent(CommandQueueEvent.PROGRESS, _currentCommandIndex, _commandList.length));
			}
		}

		public function addCommand(command:AbstractCommand, ...commands):void
		{
			_commandList = _commandList.concat([command].concat(commands));
		}

		public function removeCommand(command:ICommand, ...commands):void
		{
			commands.unshift(command);
			for (var i:int = 0; i < commands.length; i++)
			{
				for (var j:int = 0; j < _commandList.length; j++)
				{
					if (_commandList[j] === commands[i])
					{
						_commandList.splice(i, 1);
						break;
					}
				}
			}
		}

		private function onCurrentCommandExecuted(event:Event):void
		{

			_currentCommand.removeEventListener(Event.COMPLETE, onCurrentCommandExecuted);

			_currentCommand.removeEventListener(ErrorEvent.ERROR, onCurrentCommandExecuted);

			_currentCommand = null;

			switch (event.type)
			{

				case Event.COMPLETE:

					execute();

					break;

				case ErrorEvent.ERROR:

					if (_abortOnFail)
					{
						onCommandFail((event as ErrorEvent
								).text);
					}
					else
					{
						execute();
					}

					break;

			}
		}
	}
}
