/**
 * Skitsanos IRC Client
 * @author Skitsanos.com
 */

package com.skitsanos.net.irc
{
	public class IrcConstants
	{
		//IRC Errors
		public static const ERR_NOSUCHNICK:Number = 401;
		public static const ERR_NOSUCHSERVER:Number = 402;
		public static const ERR_NOSUCHCHANNEL:Number = 403;
		public static const ERR_CANNOTSENDTOCHAN:Number = 404;
		public static const ERR_TOOMANYCHANNELS:Number = 405;
		public static const ERR_WASNOSUCHNICK:Number = 406;

		//IRC Replies
		public static const RPL_UNAWAY:Number = 305;
		public static const RPL_NOWAWAY:Number = 306;
		public static const RPL_WHOISUSER:Number = 311;
		public static const RPL_WHOISSERVER:Number = 312;
		public static const RPL_WHOISOPERATOR:Number = 313;
		public static const RPL_WHOISIDLE:Number = 317;
		public static const RPL_ENDOFWHOIS:Number = 318;
		public static const RPL_WHOISCHANNELS:Number = 319;
		public static const RPL_WHOWASUSER:Number = 314;
		public static const RPL_ENDOFWHOWAS:Number = 369;
		public static const RPL_ENDOFMOTD:Number = 376;

	}
}