/**
 * Data uploading over HTTP
 * @author Skitsanos.com
 * @version 1.0
 */

package com.skitsanos.net.http
{
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class Uploader
	{
		/**
		 * Uploads binary data into specified location
		 */
		static public function sendBytes(url:String, data:ByteArray, compress:Boolean = false, uploadComplete:Function = null):void
		{
			if (compress)
			{
				data.compress();
			}

			var request:URLRequest = new URLRequest(url);
			request.method = "POST";
			request.contentType = "application/octet-stream";
			request.data = data;

			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, uploadComplete);

			loader.load(request);
		}
	}
}