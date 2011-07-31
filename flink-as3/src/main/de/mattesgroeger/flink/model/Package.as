package de.mattesgroeger.flink.model
{
	public class Package
	{
		public var url:String;
		public var compressed:Boolean;
		public var files:Vector.<String> = new Vector.<String>();

		public function Package(url:String)
		{
			this.url = url;
		}
	}
}