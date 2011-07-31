package de.mattesgroeger.flink.enum
{
	public class RequestState
	{
		public static const NEW:RequestState = new RequestState("new");
		public static const INITIAL_LOADING:RequestState = new RequestState("initial_loading");
		public static const CACHED:RequestState = new RequestState("cached");
		
		private var state:String;

		public function RequestState(state:String)
		{
			this.state = state;
		}

		public function toString():String
		{
			return state;
		}
	}
}