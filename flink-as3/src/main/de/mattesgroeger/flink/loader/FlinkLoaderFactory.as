package de.mattesgroeger.flink.loader
{
	import de.mattesgroeger.flink.group.RequestGroup;
	import de.mattesgroeger.flink.loader.impl.BinaryLoader;
	import de.mattesgroeger.flink.loader.impl.CacheLoader;
	import de.mattesgroeger.flink.loader.impl.PackageLoader;
	import de.mattesgroeger.flink.request.FlinkRequest;

	public class FlinkLoaderFactory
	{
		private var requestGroup:RequestGroup;

		public function FlinkLoaderFactory(requestGroup:RequestGroup)
		{
			this.requestGroup = requestGroup;
		}

		public function create(request:FlinkRequest):FlinkLoader
		{
			var url:String = request.url;
			
			if (requestGroup.model.isCached(url))
			{
				return new CacheLoader(requestGroup.model.getFromCache(url));
			}
			else
			{
				if (requestGroup.model.isPackaged(url))
				{
					return new PackageLoader(requestGroup, url);
				}
				else
				{
					return new BinaryLoader(requestGroup, url);
				}
			}
		}
	}
}
