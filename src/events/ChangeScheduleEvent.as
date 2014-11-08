package events
{
import flash.events.Event;

public class ChangeScheduleEvent extends Event
		
	{
		public static var ChangeSchedule_EventStr:String="Change_Schedule";
		public function ChangeScheduleEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super( ChangeSchedule_EventStr,bubbles, cancelable);
		}
		
		override public function clone():Event{
			var e:ChangeScheduleEvent=new ChangeScheduleEvent(bubbles,cancelable);
			return e;
		}
		
		
		
		
	}
}