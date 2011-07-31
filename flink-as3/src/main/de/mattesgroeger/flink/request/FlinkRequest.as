package de.mattesgroeger.flink.request
{
	import org.osflash.signals.ISignal;
	import flash.utils.ByteArray;

	public interface FlinkRequest
	{
		function get url():String;
		
		function get completed():ISignal;
		
		function handleResult(result:ByteArray):void;
	}
}