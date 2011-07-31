package de.mattesgroeger.flink.loader.impl
{
	import de.mattesgroeger.flink.enum.RequestState;
	import de.mattesgroeger.flink.group.RequestGroup;
	import de.mattesgroeger.flink.loader.FlinkLoader;
	import de.mattesgroeger.flink.model.FlinkModel;
	import de.mattesgroeger.flink.model.Package;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;



	public class PackageLoader implements FlinkLoader
	{
		private var requestGroup:RequestGroup;
		private var model:FlinkModel;
		private var url:String;
		private var pack:Package;
		
		private var loader:URLLoader;
		private var _data:ByteArray;
		private var _completed:Signal = new Signal(ByteArray);

		public function PackageLoader(requestGroup:RequestGroup, fileUrl:String)
		{
			this.requestGroup = requestGroup;
			this.model = requestGroup.model;
			this.url = fileUrl;
			this.pack = model.getPackage(fileUrl);
			
			setFileStates(RequestState.INITIAL_LOADING);
		}

		public function load():void
		{
			trace("load pack " + pack.url + " to get " + url);
			
			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, handleComplete);
			loader.load(new URLRequest(pack.url));
		}

		private function handleComplete(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, handleComplete);
			var bytes:ByteArray = loader.data as ByteArray;

			var counter:int = 0;
			var fileAmount:int = bytes.readInt();
			pack.compressed = bytes.readBoolean();
			
			while (counter++ < fileAmount)
				readContent(bytes);
			
			_data = model.getFromCache(url);
			
			_completed.dispatch(_data);
			
			for each (var fileUrl:String in pack.files)
				requestGroup.loadPendingRequests(fileUrl);
		}

		private function readContent(bytes:ByteArray):void
		{
			var sizeFilename:int = bytes.readInt();
			var fileName:String = bytes.readUTFBytes(sizeFilename);
			var sizeContent:int = bytes.readInt();
			
			var buffer:ByteArray = new ByteArray();
			bytes.readBytes(buffer, buffer.position, sizeContent);
			
			if (pack.compressed)
				buffer.uncompress();
			
			model.addToCache(fileName, buffer);
		}

		private function setFileStates(state:RequestState):void
		{
			for each (var fileUrl:String in pack.files)
				model.setState(fileUrl, state);
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
			
			loader.removeEventListener(Event.COMPLETE, handleComplete);
			loader.close();
			
			return true;
		}
	}
}