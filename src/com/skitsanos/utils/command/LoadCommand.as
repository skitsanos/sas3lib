/**
 * http://rojored.com/#pure-as3-commands
 */
package com.skitsanos.utils.command
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;

	/**
	 *
	 *  $Id: LoadCommand.as 52 2008-02-06 02:57:19Z gabriel_montagne $
	 *
	 */
	public class LoadCommand extends AbstractCommand
	{

		private var _url:String;
		private var _loader:Loader;

		public function LoadCommand(url:String = null, loader:Loader = null)
		{

			_url = url;
			_loader = loader;

		}

		override public function execute():void
		{

			if ((_loader == null) || (_url == null))
			{

				onCommandFail("Cannot execute load command: " + (!_loader ? " Loader not defined. " : "") + (!_url ? " Url not speficied." : ""));
				return;

			}

			_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);

			_loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadComplete);

			_loader.load(new URLRequest(_url));

		}

		private function onLoadComplete(event:Event):void
		{

			_loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);

			_loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadComplete);

			switch (event.type)
			{

				case Event.COMPLETE:
					onCommandComplete();
					break;

				case IOErrorEvent.IO_ERROR:
					onCommandFail((event as IOErrorEvent).text);
					break;
			}
		}

		// ------- getters and setters -------
		public function set url(value:String):void
		{
			_url = value;
		}

		public function get url():String
		{
			return _url;
		}

		public function set loader(value:Loader):void
		{
			_loader = value;
		}

		public function get loader():Loader
		{
			return _loader;
		}
	}
}
