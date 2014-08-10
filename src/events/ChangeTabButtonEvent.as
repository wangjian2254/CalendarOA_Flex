package events
{
	import control.CBorderContainer;
	
	import flash.events.Event;
	
	import uicontrol.CTabButton;
	
	public class ChangeTabButtonEvent extends Event
	{
		public static var Change_TabButton:String="Change_TabButton";
		public var view:CBorderContainer;
		public var btn:CTabButton;
		public function ChangeTabButtonEvent(type:String, v:CBorderContainer,b:CTabButton,bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.view=v;
			this.btn=b;
		}
		override public function clone():Event{
			var e:ChangeTabButtonEvent=new ChangeTabButtonEvent(type,view,btn,bubbles,cancelable);
			return e;
		}
		
		public function getViewBorderContainer():CBorderContainer{
			return view;
		}
		public function getBtn():CTabButton{
			return btn;
		}
	}
}