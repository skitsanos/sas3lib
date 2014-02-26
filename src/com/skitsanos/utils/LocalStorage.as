/**
 * Application Local Data Store
 * @author Evgenios Skitsanos
 * @version 1.2
 */
package com.skitsanos.utils
{
	import com.skitsanos.events.LocalStorageEvent;

	import flash.events.EventDispatcher;
	import flash.events.NetStatusEvent;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;

	public class LocalStorage extends EventDispatcher
	{
		public var applicationName:String = "Default";
		public var list:Object;

		private var so:SharedObject;

		public function LocalStorage()
		{
			this.list = SharedObject.getLocal(applicationName, "/").data;
		}

		/**
		 * Saves object with given name into storage
		 */
		public function save(name:String, obj:Object):void
		{
			so = SharedObject.getLocal(applicationName, "/");
			remove(name); //remove old content before storing new one			
			so.data[name] = obj; //store new object content

			var flushStatus:String = null;
			try
			{
				flushStatus = so.flush();
			}
			catch (error:Error)
			{
				dispatchEvent(new LocalStorageEvent(LocalStorageEvent.ERROR, "Could not write SharedObject to disk", obj));
			}

			if (flushStatus != null)
			{
				switch (flushStatus)
				{
					case SharedObjectFlushStatus.PENDING:
						//Requesting permission to save object...\n
						so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
						break;

					case SharedObjectFlushStatus.FLUSHED:
						var resource:Object = new Object();
						resource.name = name;
						resource.content = obj;

						dispatchEvent(new LocalStorageEvent(LocalStorageEvent.SUCCESS, null, resource));
						break;
				}
			}
		}

		/**
		 * Loads object with given name from storage
		 */
		public function load(name:String):Object
		{
			so = SharedObject.getLocal(applicationName, "/");
			return so.data[name];
		}

		/**
		 * Deletes object with given name from storage
		 */
		public function remove(name:String):void
		{
			so = SharedObject.getLocal(applicationName, "/");
			delete so.data[name];
		}

		/**
		 * Handels FlusStatus Event
		 */
		private function onFlushStatus(event:NetStatusEvent):void
		{
			//User closed permission dialog...
			switch (event.info.code)
			{
				case "SharedObject.Flush.Success":
					//User granted permission -- value saved.
					break;

				case "SharedObject.Flush.Failed":
					dispatchEvent(new LocalStorageEvent(LocalStorageEvent.ERROR, "User denied permission -- value not saved"));
					break;
			}
			so.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
		}
	}
}