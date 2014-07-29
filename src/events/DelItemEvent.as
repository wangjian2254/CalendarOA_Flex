package events
{
	import flash.events.Event;
	
	public class DelItemEvent extends Event
	{	
		static public const Delelte:String="delete";
		public function DelItemEvent(type:String="delete", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}