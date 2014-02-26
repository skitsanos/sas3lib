/**
 * http://rojored.com/#pure-as3-commands
 */
package com.skitsanos.utils.command
{
	public class MacroCommand extends AbstractCommand
	{

		protected var _commandList:Array;

		/**
		 *
		 *  $Id: MacroCommand.as 56 2008-02-06 04:39:10Z gabriel_montagne $
		 *
		 */
		public function MacroCommand()
		{
			_commandList = [];
		}

		public function addCommand(command:ICommand, ...commands):void
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

		public override function execute():void
		{
			for (var i:int = 0; i < _commandList.length; i++)
			{
				(_commandList[i] as ICommand).execute();
			}
			onCommandComplete();
		}
	}
}
