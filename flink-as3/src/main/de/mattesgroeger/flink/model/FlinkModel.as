package de.mattesgroeger.flink.model
{
	import de.mattesgroeger.flink.enum.RequestState;
	import de.mattesgroeger.flink.request.FlinkRequest;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	public class FlinkModel
	{
		private var packages:Vector.<Package> = new Vector.<Package>(); // TODO do we need this?
		private var urlPackageUrlMap:Dictionary = new Dictionary();
		private var urlStateMap:Dictionary = new Dictionary();
		private var urlCacheMap:Dictionary = new Dictionary();
		private var urlPendingRequestsMap:Dictionary = new Dictionary(true);

		public function addToCache(url:String, data:ByteArray):void
		{
			urlCacheMap[url] = data;
			setState(url, RequestState.CACHED);
		}

		public function isCached(url:String):Boolean
		{
			return urlCacheMap[url] != null;
		}

		public function getFromCache(url:String):ByteArray
		{
			return urlCacheMap[url];
		}

		public function setState(url:String, state:RequestState):void
		{
			urlStateMap[url] = state;
		}
		
		public function getState(url:String):RequestState
		{
			if (urlStateMap[url] == null)
				return RequestState.NEW;
			
			return urlStateMap[url];
		}

		public function registerPackagedUrl(url:String, pack:Package):void
		{
			if (packages.indexOf(pack) == -1)
				packages.push(pack);
			
			pack.files.push(url);
			
			urlPackageUrlMap[url] = pack;
		}

		public function isPackaged(url:String):Boolean
		{
			return urlPackageUrlMap[url] != null;
		}
		
		public function getPackage(url:String):Package
		{
			return urlPackageUrlMap[url];
		}
		
		public function hasPendingRequests(url:String):Boolean
		{
			return urlPendingRequestsMap[url] != null;
		}

		public function clearPendingRequests(url:String):Vector.<FlinkRequest>
		{
			var pending:Vector.<FlinkRequest> = urlPendingRequestsMap[url];
			
			urlPendingRequestsMap[url] = null;
			delete urlPendingRequestsMap[url];
			
			return pending;
		}
		
		public function addPendingRequest(request:FlinkRequest):void
		{
			if (urlPendingRequestsMap[request.url] == null)
				urlPendingRequestsMap[request.url] = new Vector.<FlinkRequest>();
			
			var requests:Vector.<FlinkRequest> = urlPendingRequestsMap[request.url];
			requests.push(request);
		}
	}
}