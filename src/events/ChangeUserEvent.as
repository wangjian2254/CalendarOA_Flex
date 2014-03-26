package events
{
	import control.CBorderContainer;
	
	import flash.events.Event;
	
	import uicontrol.CTabButton;
	
	public class ChangeUserEvent extends Event
		
	{
		public static var ChangeUser_EventStr:String="Change_User";
		private var object:Object;
		public function ChangeUserEvent(type:String, obj:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.object=obj;
		}
		
		override public function clone():Event{
			var e:ChangeUserEvent=new ChangeUserEvent(type,object,bubbles,cancelable);
			return e;
		}
		
		
		public function getObj():Object{
			return object;
		}
		
	}
}