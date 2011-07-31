package de.mattesgroeger.flink.manifest
{
	import org.osflash.signals.Signal;
	import org.osflash.signals.ISignal;

	import de.mattesgroeger.flink.model.Package;
	import de.mattesgroeger.flink.model.FlinkModel;

	import flash.utils.ByteArray;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	public class ManifestLoader
	{
		private var model:FlinkModel;
		private var loader:URLLoader;

		private var _completedSignal:Signal = new Signal();

		public function load(manifestUrl:String, model:FlinkModel):void
		{
			this.model = model;

			loader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, handleComplete);
			loader.load(new URLRequest(manifestUrl));
		}

		private function handleComplete(event:Event):void
		{
			loader.removeEventListener(Event.COMPLETE, handleComplete);

			var bytes:ByteArray = loader.data as ByteArray;
			bytes.uncompress();
			bytes.position = 0;

			readContent(bytes.readUTFBytes(bytes.length));
		}

		private function readContent(content:String):void
		{
			var lines:Array = content.split("\r\n");
			var currentPack:Package;

			for each (var line:String in lines)
			{
				if (line.indexOf("\%\%") == 0)
					currentPack = new Package(line.replace("%%", ""));
				else if (line.length > 0)
					model.registerPackagedUrl(line, currentPack);
			}

			_completedSignal.dispatch();
		}

		public function get completedSignal():ISignal
		{
			return _completedSignal;
		}
	}
}
