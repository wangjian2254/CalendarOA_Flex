package events
{
	import flash.events.Event;
	
	public class ChatTimelineEvent extends Event
	{	
		static public const Channel:String="ChatChannel";
        public var channel:String="";
        public var flag:String="";
		public function ChatTimelineEvent(type:String="ChatChannel", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}