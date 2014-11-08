package events
{
import flash.events.Event;

public class ChangeDepartmentEvent extends Event
		
	{
		public static var ChangeDepartment_EventStr:String="Change_Department";
        private var _depart:Object;
		public function ChangeDepartmentEvent(bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super( ChangeDepartment_EventStr,bubbles, cancelable);
		}
		
		override public function clone():Event{
			var e:ChangeDepartmentEvent=new ChangeDepartmentEvent(bubbles,cancelable);
            e.depart=_depart;
			return e;
		}


        public function get depart():Object {
            return _depart;
        }

        public function set depart(value:Object):void {
            _depart = value;
        }
    }
}