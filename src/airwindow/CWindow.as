package airwindow
{
	import events.ChangeUserEvent;
	import events.CloseContainerEvent;
	
	import mx.events.FlexEvent;
	import mx.events.ResizeEvent;
	
	import spark.components.Window;
	
	public class CWindow extends Window
	{
		private var _label:String;
		private var _flag:String;
		private var _icon:Class;
		private var _closeEnable:Boolean=true;
		private var _param:Object;//附带的参数
		
		public function CWindow()
		{
			super();
		}
		
		public function get flag():String
		{
			return _flag;
		}
		
		public function set flag(value:String):void
		{
			_flag = value;
		}
		
		public function init(e:FlexEvent):void{
		}
		public function changeCurrentUser(e:ChangeUserEvent):void{
			//			throw new Error("CBorderContainer 的子类必须重写 init(e:FlexEvent) 方法。");
		}
		
		public function showThis():void{
			
		}
		
		[Bindable]
		public function get closeEnable():Boolean
		{
			return _closeEnable;
		}
		
		public function set closeEnable(value:Boolean):void
		{
			_closeEnable = value;
		}
		
		[Bindable("iconChanged")]
		public function get icon():Class
		{
			return _icon;
		}
		
		public function set icon(value:Class):void
		{
			_icon = value;
		}
		
		public function get label():String
		{
			return _label;
		}
		
		public function set label(value:String):void
		{
			_label = value;
		}
		
		
		public function closeContainer(e:CloseContainerEvent):void{
//			throw new Error("CBorderContainer 的子类必须重写 closeContainer(e:CloseContainerEvent) 方法。在方法中触发 CloseEvent 事件。");
		}
		
		/**
		 * 本方法 专用于 移除对外界对象的监听。 防止内存溢出。
		 */
		public function releaseListener():void{
			throw new Error("CBorderContainer 的子类必须重写 releaseListener() 方法。在方法中移除监听外界对象的事件。");
		}
		
		public function get param():Object
		{
			return _param;
		}
		
		public function set param(value:Object):void
		{
			_param = value;
		}
		
		public function reloadParamData(e:FlexEvent):void{
			param=null;
		}
		public function resizeContainer(e:ResizeEvent):void{
			
		}
	}
}