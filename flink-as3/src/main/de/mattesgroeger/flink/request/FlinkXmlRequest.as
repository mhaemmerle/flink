package de.mattesgroeger.flink.request
{
	import org.osflash.signals.ISignal;
	import org.osflash.signals.Signal;

	import flash.utils.ByteArray;

	public class FlinkXmlRequest implements FlinkRequest
	{
		private var _url:String;
		private var _completed:Signal = new Signal(XML);
		private var _xml:XML;

		public function FlinkXmlRequest(url:String)
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
		
		public function get xml():XML
		{
			return _xml;
		}

		public function handleResult(data:ByteArray):void
		{
			var content:String = data.readUTFBytes(data.length);
			
			_xml = new XML(content);
			
			_completed.dispatch(_xml);
		}
	}
}