package de.mattesgroeger.flink.loader.impl
{
	import de.mattesgroeger.flink.enum.RequestState;
	import de.mattesgroeger.flink.group.RequestGroup;
	import de.mattesgroeger.flink.loader.FlinkLoader;
	import de.mattesgroeger.flink.model.FlinkModel;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;



	public class BinaryLoader implements FlinkLoader
	{
		private var _requestGroup:RequestGroup;
		private var _model:FlinkModel;
		private var _url:String;
		private var _loader:URLLoader;
		private var _data:ByteArray;
		private var _completed:Signal = new Signal(ByteArray);
		
		public function BinaryLoader(requestGroup:RequestGroup, url:String)
		{
			_requestGroup = requestGroup;
			_model = requestGroup.model;
			_model.setState(url, RequestState.INITIAL_LOADING);
			
			_url = url;
		}

		public function load():void
		{
			trace("load " + _url + " initially");
			
			_loader = new URLLoader();
			_loader.dataFormat = URLLoaderDataFormat.BINARY;
			_loader.addEventListener(Event.COMPLETE, handleComplete);
			_loader.load(new URLRequest(_url));
		}

		private function handleComplete(event:Event):void
		{
			_loader.removeEventListener(Event.COMPLETE, handleComplete);
			
			_data = _loader.data as ByteArray;
			_model.addToCache(_url, _data);
			
			_requestGroup.loadPendingRequests(_url);
			
			_completed.dispatch(_data);
		}

		public function get isComplete():Boolean
		{
			return (_data != null);
		}

		public function get data():ByteArray
		{
			return _data;
		}

		public function get completed():ISignal
		{
			return _completed;
		}

		public function cancel():Boolean
		{
			if (_completed)
				return false;
			
			_loader.removeEventListener(Event.COMPLETE, handleComplete);
			_loader.close();
			
			return true;
		}
	}
}