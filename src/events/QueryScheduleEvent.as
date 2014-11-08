package events
{
import flash.events.Event;

public class QueryScheduleEvent extends Event
		
	{
		public static var QuerySchedule_Str:String="QuerySchedule";
        public var pid:int=-1;
        public var person:Object;
        public var depart_id:int=-1;
        public var depart:Object;
        public var project_id:int=-1;
        public var start:String;
        public var end:String;
		public function QueryScheduleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
		
		override public function clone():Event{
			var e:QueryScheduleEvent=new QueryScheduleEvent(type,bubbles,cancelable);
			return e;
		}

	}
}