package events
{
	import flash.events.Event;
	
	public class AutoGridEvent extends Event
	{
		public static const DELETE:String="delete";
		public static const ADD:String="add";
		public var data:Object;
		public function AutoGridEvent(data:Object,type:String="delete", bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data=data;
		}
		override public function clone():Event{
			return new AutoGridEvent(data,type,bubbles,cancelable);
		}
	}
}