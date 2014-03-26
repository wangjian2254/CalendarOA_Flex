package events
{
	import control.CBorderContainer;
	
	import flash.events.Event;
	
	import uicontrol.CTabButton;
	
	public class ChangeJoinUserEvent extends Event
		
	{
		public static var ChangeUser_EventStr:String="Change_Join_User";
//		private var object:Object;
		public function ChangeJoinUserEvent(  bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(ChangeUser_EventStr, bubbles, cancelable);
//			this.object=obj;
		}
		
		override public function clone():Event{
			var e:ChangeJoinUserEvent=new ChangeJoinUserEvent(bubbles,cancelable);
			return e;
		}
		
		
		
		
	}
}