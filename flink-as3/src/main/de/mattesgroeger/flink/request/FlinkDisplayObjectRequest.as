package de.mattesgroeger.flink.request
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;
	import org.osflash.signals.natives.NativeSignal;

	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.utils.ByteArray;

	public class FlinkDisplayObjectRequest implements FlinkRequest
	{
		private var _url:String;
		private var _completed:Signal = new Signal(DisplayObject);
		private var _urlLoader:Loader;
		private var _displayObject:DisplayObject;

		public function FlinkDisplayObjectRequest(url:String)
		{
			_url = url;
		}

		public function get url():String
		{
			return _url;
		}

		public function get completed():ISignal
		{
			return _completed;
		}

		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		
		public function handleResult(data:ByteArray):void
		{
			_urlLoader = new Loader();
			_urlLoader.loadBytes(data);
			
			new NativeSignal(_urlLoader.contentLoaderInfo, Event.COMPLETE, Event).addOnce(handleBytesLoaded);
		}

		private function handleBytesLoaded(event:Event):void
		{
			_displayObject = _urlLoader.content;
			_completed.dispatch(_displayObject);
		}
	}
}