package events
{
	import control.CBorderContainer;
	
	import flash.events.Event;
	
	import uicontrol.CTabButton;
	
	public class ChangeMenuEvent extends Event
		
	{
		public static var ChangeMenu_EventStr:String="Change_Menu";
		private var object:Object;
		private var menu_mod:String;
		public function ChangeMenuEvent(type:String, menu_mod:String,obj:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.object=obj;
			this.menu_mod=menu_mod;
		}
		
		override public function clone():Event{
			var e:ChangeMenuEvent=new ChangeMenuEvent(type,menu_mod,object,bubbles,cancelable);
			return e;
		}
		
		
		public function getObj():Object{
			return object;
		}
		public function getMenuMod():String{
			return menu_mod;
		}
	}
}