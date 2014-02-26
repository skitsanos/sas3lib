/**
 * @author Evgenios Skitsanos
 */
package com.skitsanos.net.irc.events
{
	import flash.events.Event;

	public class IrcEvent extends Event
	{
		public static const CONSOLE:String = "ircConsole";
		public static const STATUS:String = "ircStatus";
		public static const CONNECTED:String = "ircConnected";
		public static const READY:String = "ircReady";
		public static const ERROR:String = "ircError";
		public static const INVITE:String = "ircInvite";
		public static const JOIN:String = "ircJoin";
		public static const KICK:String = "ircKick";
		public static const LEAVE:String = "ircLeave";
		public static const CHANNEL_MESSAGE:String = "ircChannelMessage";
		public static const PRIVATE_MESSAGE:String = "ircPrivateMessage";
		public static const NOTICE:String = "ircNotice";
		public static const MODE_CHANGED:String = "ircModeChanged";

		public var ircData:Object

		public function IrcEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, ircData:Object = null)
		{
			super(type, bubbles, cancelable);
			this.ircData = ircData;
		}

		public override function clone():Event
		{
			return new IrcEvent(type, bubbles, cancelable, ircData);
		}

	}
}