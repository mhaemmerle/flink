package de.mattesgroeger.flink
{
	import de.mattesgroeger.flink.group.RequestGroup;
	import de.mattesgroeger.flink.manifest.ManifestLoader;
	import de.mattesgroeger.flink.model.FlinkModel;
	import de.mattesgroeger.flink.request.FlinkRequest;

	import flash.utils.Dictionary;

	public class Flink
	{
		private var groups:Dictionary = new Dictionary(true);
		private var model:FlinkModel = new FlinkModel();

		public function initialize(manifestUrl:String, callback:Function):void
		{
			var manifestLoader:ManifestLoader = new ManifestLoader();
			manifestLoader.load(manifestUrl, model);
			manifestLoader.completedSignal.addOnce(callback);
		}

		public function start(id:String = null):void
		{
			getGroupById(id).start();
		}

		public function clear(id:String = null):void
		{
			getGroupById(id).clear();
		}

		public function clearAll():void
		{
			for (var groupId:* in groups)
				getGroupById(groupId).clear();
		}

		public function addRequest(request:FlinkRequest, id:String = null):FlinkRequest
		{
			getGroupById(id).addRequest(request);
			
			return request;
		}

//		public function cancelRequest(request:FlinkRequest, id:String = null):FlinkRequest
//		{
//			getGroupById(id).cancelRequest(request);
//			
//			return request;
//		}

		private function getGroupById(id:String = null):RequestGroup
		{
			if (id == null)
				id = "default";

			if (groups[id] == null)
				groups[id] = new RequestGroup(model);

			return groups[id];
		}
	}
}
