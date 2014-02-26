/**
 * IRC Client
 * @author Evgenios Skitsanos
 * @version 1.0.01142008
 */
package com.skitsanos.net.irc
{
	import com.skitsanos.net.irc.events.IrcEvent;
	import com.skitsanos.utils.ByteArrayUtil;
	import com.skitsanos.utils.Strings;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.Socket;

	public class IrcClient extends EventDispatcher
	{
		public var username:String = "as3user";
		public var password:String = "";

		public var nickName:String = "as3irc";
		public var realName:String = "Skitsanos AS3 IRC Client";
		public var quitMessage:String = "See you next time, guys.";
		public var hostName:String = "127.0.0.1";

		public var server:String = "localhost";
		public var port:Number = 6667;

		private var socket:Socket;

		/**
		 * Contructor
		 */
		public function IrcClient():void
		{
			super();

			socket = new Socket();
			socket.addEventListener(ProgressEvent.SOCKET_DATA, __socket_data);
			socket.addEventListener(Event.CONNECT, __socket_connected);
			socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, __socket_SecurityError);
			socket.addEventListener(IOErrorEvent.IO_ERROR, __socket_IoError);
		}

		/**
		 * Connects to IRC server
		 */
		public function connect():void
		{
			socket.connect(server, port);
		}

		/**
		 * Disconnects from IRC server
		 */
		public function disconnect():void
		{
			socket.close();
		}

		/**
		 * Join Channel
		 */
		public function join(channel:String, key:String = ""):void
		{
			if (Strings.startsWith(channel, "#") == false)
			{
				channel = "#" + channel;
			}

			execute("JOIN " + channel + " " + key);
		}

		/**
		 * Leave channel
		 */
		public function leave(channel:String):void
		{
			execute("PART " + channel);
		}

		/**
		 * Change nick name
		 */
		public function nick(newNick:String):void
		{
			execute("NICK " + newNick);
			nickName = newNick;
		}

		/**
		 * Sends user command required on connection
		 */
		private function user():void
		{
			execute("USER " + nickName + " " + server + " " + hostName + " :" + realName)
		}

		/**
		 * Sends message to the channel or to user
		 */
		public function say(channel:String, text:String):void
		{
			execute("PRIVMSG " + channel + " :" + text);
		}

		/**
		 * Send command to IRC server
		 */
		private function execute(command:String):void
		{
			socket.writeBytes(ByteArrayUtil.stringToArray(command + "\r\n"));
			socket.flush();
		}

		/**
		 * Handles connected socket
		 */
		private function __socket_connected(e:Event):void
		{
			if (socket.connected)
			{
				nick(nickName);
				user();

				var stats:Object = new Object();
				stats.nickname = nickName;

				dispatchEvent(new IrcEvent(IrcEvent.CONNECTED, false, false, stats));
			}
			else
			{
				//huston, something fucked
				var errObject:Object = {};
				errObject.message = "Connection failed";
				dispatchEvent(new IrcEvent(IrcEvent.ERROR, false, false, errObject));
			}
		}

		private function __socket_data(e:ProgressEvent):void
		{
			while (socket.bytesAvailable)
			{
				var data:String = socket.readUTFBytes(socket.bytesAvailable);
				trace(data);

				var input:Array = data.split("\n");
				for (var i:Number = 0; i < input.length; i++)
				{
					var tokens:Array = input[i].split(" ");
					if (tokens[0].toString().toUpperCase() == "PING")
					{
						var pongmsg:Array = data.match(/PING\s\:(.+)/);
						execute("PONG :" + pongmsg[1]);
						return;
					} else if (tokens[0].toString().toUpperCase() == "ERROR")
					{
						socket.close();

						var errObject:Object = {};
						errObject.message = ((tokens.slice(1, tokens.length)).join(' ')).substring(1);
						dispatchEvent(new IrcEvent(IrcEvent.ERROR, false, false, errObject));

						return;
					}
					parse_data(input[i]);
				}
			}
		}

		private function parse_data(text:String):void
		{
			trace(text);

			var tokens:Array = text.split(" ");
			if (tokens.length > 1)
			{
				if (isNaN(Number(tokens[1])) == false)
				{
					//numeric codes					
					var statusCode:Number = Number(tokens[1]);
					var statusParser:Array = text.match(/\s\:(.+)/);
					var status:Object = new Object();
					status.code = statusCode;
					status.message = (statusParser != null ) ? statusParser[1] : '';
					dispatchEvent(new IrcEvent(IrcEvent.STATUS, false, false, status));

					switch (statusCode)
					{
						case IrcConstants.RPL_ENDOFMOTD:
							dispatchEvent(new IrcEvent(IrcEvent.READY, false, false, null));
							break;
					}

					if (statusCode >= 200 && statusCode <= 400)
					{

					} else if (statusCode > 400 && statusCode < 600)
					{
						var errObject:Object = {};
						errObject.message = status.message;
						dispatchEvent(new IrcEvent(IrcEvent.ERROR, false, false, errObject));
					}
				}
				else
				{
					//trace("\t"+tokens[1]);
					var parsedCommand:Array = text.match(/\s(\w+)\s/);

					var m:Array = text.match(/\:(.+)\s(\w+)\s(\w+)\s\:(.+)/);
					if (parsedCommand != null)
					{
						switch (parsedCommand[1].toUpperCase())
						{
							case "NOTICE":
								var noticemsg:Array = text.match(/\:(.+)\s(\w+)\s(.+)\s\:(.+)/);
								var notice:Object = {};
								notice.user = getUserFromAddress(noticemsg[1]);
								notice.message = noticemsg[4];
								dispatchEvent(new IrcEvent(IrcEvent.NOTICE, false, false, notice));
								break;

							case "PRIVMSG":
								var ircmsg:Array = text.match(/\:(.+)\s(\w+)\s(.+)\s\:(.+)/);
								var prvmsg:Object = {};
								prvmsg.user = getUserFromAddress(ircmsg[1]);
								prvmsg.channel = ircmsg[3];
								prvmsg.message = ircmsg[4];
								if (Strings.startsWith(prvmsg.channel, "#"))
								{
									dispatchEvent(new IrcEvent(IrcEvent.CHANNEL_MESSAGE, false, false, prvmsg));
								}
								else
								{
									dispatchEvent(new IrcEvent(IrcEvent.PRIVATE_MESSAGE, false, false, prvmsg));
								}
								break;

							case "PART":
								var partmsg:Array = text.match(/\:(.+)\s(\w+)\s(.+)\s\:(\s|\.+)/);
								var part:Object = {};
								part.channel = partmsg[3];
								part.user = getUserFromAddress(partmsg[1]);
								part.message = partmsg[4];
								dispatchEvent(new IrcEvent(IrcEvent.LEAVE, false, false, part));
								break;

							case "MODE":
								trace(text);
								//MODE #grafeio +o as3_bot
								var modemsg:Array = text.match(/\:(.+)\sMODE\s(.+)/);
								var modeobj:Object = new Object();
								modeobj.user = getUserFromAddress(modemsg[1]);
								modeobj.message = modemsg[2];

								//var modeTokens:Array = modemsg[2].split(" ");
								//if (StringUtils.startsWith(modeTokens[0], "#"))
								//{
								//channel mode
								//}

								//modeobj.channel = partmsg[3];								
								//modeobj.mode = partmsg[4];
								//modeobj.operator = partmsg[5];


								dispatchEvent(new IrcEvent(IrcEvent.MODE_CHANGED, false, false, modeobj));
								break;
						}
					}
				}
			}
			tokens = null;
		}

		private function getUserFromAddress(address:String):IrcUser
		{
			var user:IrcUser = new IrcUser();
			var exp:Array = address.match(/(.+?)\!(.+?)\@(.+)/);

			if (exp == null)
			{
				user.nick = address;
				user.ident = user.host = '';
			}
			else
			{
				user.nick = exp[ 1 ];
				user.ident = exp[ 2 ];
				user.host = exp[ 3 ];
			}

			return user;
		}

		private function __socket_SecurityError(e:SecurityErrorEvent):void
		{
			var errObject:Object = {};
			errObject.message = e.text;
			dispatchEvent(new IrcEvent(IrcEvent.ERROR, false, false, errObject));
		}

		private function __socket_IoError(e:IOErrorEvent):void
		{
			var errObject:Object = {};
			errObject.message = e.text;
			dispatchEvent(new IrcEvent(IrcEvent.ERROR, false, false, errObject));
		}
	}
}