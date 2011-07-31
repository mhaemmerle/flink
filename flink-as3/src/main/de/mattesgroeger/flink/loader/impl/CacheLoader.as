package de.mattesgroeger.flink.loader.impl
{
	import de.mattesgroeger.flink.loader.FlinkLoader;

	import org.osflash.signals.ISignal;

	import flash.errors.IllegalOperationError;
	import flash.utils.ByteArray;

	public class CacheLoader implements FlinkLoader
	{
		private var _data:ByteArray;

		public function CacheLoader(data:ByteArray)
		{
			_data = data;
		}

		public function load():void
		{
			trace("load data from cache");
		}

		public function get isComplete():Boolean
		{
			return true;
		}

		public function get data():ByteArray
		{
			return _data;
		}

		public function get completed():ISignal
		{
			throw new IllegalOperationError("Already completed. Check the isCompleted property!");
		}

		public function cancel():Boolean
		{
			return false;
		}
	}
}