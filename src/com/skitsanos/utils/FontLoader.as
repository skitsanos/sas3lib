/**
 * Font Loading Utility
 * @author Skitsanos, http://www.skitsanos.com/
 */

package com.skitsanos.utils
{
	import com.skitsanos.io.Path;

	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLRequest;
	import flash.text.Font;

	public class FontLoader extends EventDispatcher
	{

		public function FontLoader()
		{
			super();
		}

		/**
		 * Loads font from selected location
		 */
		public function load(url:String):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, _font_loaded);
			loader.load(new URLRequest(url));
		}

		/**
		 * Handles event fired when font is loaded
		 */
		private function _font_loaded(e:Event):void
		{
			var fontName:String = Strings.capitalize(Path.getFileNameWithoutExtension(e.currentTarget.url));

			var fontLoaded:Class = e.target.applicationDomain.getDefinition(fontName) as Class;

			Font.registerFont(fontLoaded[fontName]);

			dispatchEvent(new Event(Event.COMPLETE));
		}
	}
}