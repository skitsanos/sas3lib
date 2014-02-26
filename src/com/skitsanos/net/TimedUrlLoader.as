package com.skitsanos.net
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;

	/*
	 *	Class that adds an option to automatically have the data reloaded at
	 *	specified intervals.
	 */
	public class TimedUrlLoader extends URLLoader
	{
		private var _refreshInterval:Number = 0;
		private var timer:Timer;
		private var lastRequest:URLRequest;

		//make this public
		private var _callIsActive:Boolean = false;

		/*
		 Constructor
		 */
		public function TimedUrlLoader(request:URLRequest = null)
		{
			//store last request used
			lastRequest = request;

			//register for events 
			addListeners();

			//call base class constructor
			super(request);
		}

		/*
		 Refresh interval in milliseconds.

		 If equal to or less than 0, data will not be reloaded.

		 note: currently refresh timer starts from the time that the request
		 goes to the server, not from when the request changes. Should this
		 change?
		 */
		public function set refreshInterval(value:Number):void
		{
			_refreshInterval = value;
		}

		public function get refreshInterval():Number
		{
			return _refreshInterval;
		}

		//read only, whether the class is currently in process of loading data
		//from server
		public function get callIsActive():Boolean
		{
			return _callIsActive;
		}

		/************* public methods ***************/

		//overriden load method
		public override function load(request:URLRequest):void
		{
			//might need to listen for some of the status codes
			stopTimer();

			//store the last request so we can reuse it
			lastRequest = request;

			//call load to make the request
			super.load(request);

			//start the timer for the reload
			startTimer();

			//set that the class is in the process of communicating with the server
			_callIsActive = true;
		}

		//overriden close method
		public override function close():void
		{
			stopTimer();
			_callIsActive = false;
			super.close();
		}

		//private api to stop the timer
		private function stopTimer():void
		{
			if (timer != null)
			{
				//clear the timer. We need to do this instead of reuse it
				//in case the refreshInterval  changes the next time we use it.
				//although we could potentially check that when we start the
				//timer
				timer.stop();
				timer = null;
			}
		}

		//private api to start the timer
		private function startTimer():void
		{
			//make sure the timer is stopped firest
			stopTimer();

			//if call to server is active, then dont refresh
			//should we queue this up?
			//if refresh interval is less than or equal to zero dont refresh
			if (_refreshInterval <= 0 || _callIsActive)
			{
				return;
			}

			//create new timer instance
			//note, we could check if the existing timer instance can be used
			timer = new Timer(_refreshInterval);
			timer.addEventListener(TimerEvent.TIMER, onTimer);

			//start the timer
			timer.start();
		}

		//adds listeners for loading events
		private function addListeners():void
		{
			addEventListener(Event.COMPLETE, onComplete);
			addEventListener(IOErrorEvent.IO_ERROR, onIOError);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
		}

		/*********** private event handlers ******************/

		//event hander when timer interval is fired
		private function onTimer(e:TimerEvent):void
		{
			//callIsActive should never be true here, but should we check it
			//anyways?

			//load the last request
			load(lastRequest);
		}

		//called when data is succesfully loaded
		private function onComplete(e:Event):void
		{
			_callIsActive = false;
			startTimer();
		}

		//called if there is an error loading data
		private function onIOError(e:IOErrorEvent):void
		{
			_callIsActive = false;
			startTimer();
		}

		//called if there is a security error loading data
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			_callIsActive = false;
			startTimer();
		}
	}
}