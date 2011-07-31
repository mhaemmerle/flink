package de.mattesgroeger.flink.group
{
	import de.mattesgroeger.flink.enum.RequestState;
	import de.mattesgroeger.flink.loader.FlinkLoader;
	import de.mattesgroeger.flink.loader.FlinkLoaderFactory;
	import de.mattesgroeger.flink.model.FlinkModel;
	import de.mattesgroeger.flink.request.FlinkRequest;
	import flash.utils.ByteArray;


	public class RequestGroup
	{
		public var model:FlinkModel;
		
		private var loaderFactory:FlinkLoaderFactory;
		private var started:Boolean;
		
		public function RequestGroup(model:FlinkModel)
		{
			this.model = model;
			this.loaderFactory = new FlinkLoaderFactory(this);
		}

		public function start():void
		{
			started = true;
		}

		public function clear():void
		{
			// TODO cancel/remove all requests
		}

		public function addRequest(request:FlinkRequest):void
		{
			switch (model.getState(request.url))
			{
				case RequestState.NEW:
				case RequestState.CACHED:
					load(request);
					break;
					
				case RequestState.INITIAL_LOADING:
					model.addPendingRequest(request);
					break;
			}
		}

		private function load(request:FlinkRequest):void
		{
			var loader:FlinkLoader = loaderFactory.create(request);
			
			loader.load(); // TODO incorporate the start() method, queue the requests before
			
			if (loader.isComplete)
				handleBytes(loader.data);
			else
				loader.completed.addOnce(handleBytes);
	
			function handleBytes(data:ByteArray):void
			{
				request.handleResult(data);
			}
		}
		
		public function loadPendingRequests(url:String):void
		{
			if (model.hasPendingRequests(url))
			{
				var pending:Vector.<FlinkRequest> = model.clearPendingRequests(url);
				
				for each (var request:FlinkRequest in pending)
					load(request);
			}
		}
	}
}