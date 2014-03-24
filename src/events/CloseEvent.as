package events
{
	import control.CBorderContainer;
	
	import flash.events.Event;
	
	import uicontrol.CTabButton;
	
	public class CloseEvent extends Event
		
	{
		public static var Close_EventStr:String="Close_Container";
		public var view:CBorderContainer;
		public var btn:CTabButton;
		
		public function CloseEvent(type:String, v:CBorderContainer,b:CTabButton, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.view=v;
			this.btn=b;
		}
		
		override public function clone():Event{
			var e:CloseEvent=new CloseEvent(type,view,btn,bubbles,cancelable);
			return e;
		}
		
		public function getView():CBorderContainer{
			return view;
		}
		public function getBtn():CTabButton{
			return btn;
		}
	}
}