package events
{
import control.CBorderContainer;

import flash.events.Event;

public class CloseContainerEvent extends Event
		
	{
		public static var Close_EventStr:String="Close_Container";
		public var view:CBorderContainer;

		public function CloseContainerEvent(type:String, v:CBorderContainer, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.view=v;
		}
		
		override public function clone():Event{
			var e:CloseContainerEvent=new CloseContainerEvent(type,view,bubbles,cancelable);
			return e;
		}
		
		public function getView():CBorderContainer{
			return view;
		}

	}
}