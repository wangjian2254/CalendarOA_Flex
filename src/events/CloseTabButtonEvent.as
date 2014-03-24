package events
{
	import control.CBorderContainer;
	
	import flash.events.Event;
	
	import uicontrol.CTabButton;
	
	public class CloseTabButtonEvent extends Event
	{
		public static var Close_TabButton:String="Close_TabButton";
		public var view:CBorderContainer;
		public var btn:CTabButton;
		public function CloseTabButtonEvent(type:String, v:CBorderContainer,b:CTabButton,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.view=v;
			this.btn=b;
		}
		override public function clone():Event{
			var e:CloseTabButtonEvent=new CloseTabButtonEvent(type,view,btn,bubbles,cancelable);
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