/**
 * http://rojored.com/#pure-as3-commands
 */
package com.skitsanos.utils.command
{

	/**
	 *
	 *  $Id: TestCommand.as 52 2008-02-06 02:57:19Z gabriel_montagne $
	 *
	 */
	public class TestCommand extends AbstractCommand
	{

		private var _name:String;

		public function TestCommand(name:String)
		{
			_name = name;
		}

		override public function execute():void
		{

			trace("execute command [" + _name + "]");

			if (Math.random() > 0.5)
			{

				onCommandComplete();

			}
			else
			{

				onCommandFail("Random error #" + Math.floor(Math.random() * 1000));

			}
		}
	}
}
