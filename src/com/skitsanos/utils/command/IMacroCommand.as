/**
 * http://rojored.com/#pure-as3-commands
 */
package com.skitsanos.utils.command
{

	/**
	 *
	 *  $Id: IMacroCommand.as 52 2008-02-06 02:57:19Z gabriel_montagne $
	 *
	 */
	public interface IMacroCommand extends ICommand
	{
		function addCommand(command:ICommand, ...commands):void;

		function removeCommand(command:ICommand, ...commands):void;
	}

}
