package events
{
import flash.events.Event;

public class InitDefaultMemberProjectEvent extends Event
		
	{
		public static var Default_Member_EventStr:String="InitDefaultMember";
		public static var Default_Project_EventStr:String="InitDefaultMember";
		public function InitDefaultMemberProjectEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			var e:InitDefaultMemberProjectEvent=new InitDefaultMemberProjectEvent(type,bubbles,cancelable);
			return e;
		}

	}
}