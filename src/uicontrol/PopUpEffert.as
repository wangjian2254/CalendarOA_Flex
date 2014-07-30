package uicontrol
{
	import flash.display.DisplayObject;
	import flash.system.Capabilities;
	
	import mx.core.IFlexDisplayObject;
	import mx.core.UIComponent;
	import mx.effects.Move;
	import mx.events.TweenEvent;
	import mx.managers.PopUpManager;

	public class PopUpEffert
	{
		static private var move:Move=new Move();
		public function PopUpEffert()
		{
			move.addEventListener(TweenEvent.TWEEN_END,removePopUpEnd);
		}
		
		public static function addPopUp(window:IFlexDisplayObject,parent:DisplayObject,modal:Boolean):void{
			PopUpManager.addPopUp(window,parent,modal);
			//浏览器的分辨率
			var wx:Number=Capabilities.screenResolutionX;
			var wy:Number=Capabilities.screenResolutionY;
			
			move.duration=1000;
			move.yFrom=wy;
			move.yTo=wy-window.height*2+35;
			move.play([window]);
		}
		public static function removePopUp(window:IFlexDisplayObject):void{
			//浏览器的分辨率
			var wx:Number=Capabilities.screenResolutionX;
			var wy:Number=Capabilities.screenResolutionY;
			
			move.duration=1000;
			move.yFrom=wy-window.height*2+35;
			move.yTo=wy;
			move.play([window]);
		}
		private static function removePopUpEnd(e:TweenEvent):void{
			PopUpManager.removePopUp(e.target.target as UIComponent);
		}
	}
}
