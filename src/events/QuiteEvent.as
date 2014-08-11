package events
{
	import flash.events.Event;
	
	public class QuiteEvent extends Event
	{	
		static public const Quite:String="quiteUser";
		public function QuiteEvent(type:String="quiteUser", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}