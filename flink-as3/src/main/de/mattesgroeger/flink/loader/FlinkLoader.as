package de.mattesgroeger.flink.loader
{
	import org.osflash.signals.ISignal;

	import flash.utils.ByteArray;

	public interface FlinkLoader
	{
		function load():void;

		function cancel():Boolean;

		function get isComplete():Boolean;
		
		function get completed():ISignal;
		
		function get data():ByteArray;
	}
}