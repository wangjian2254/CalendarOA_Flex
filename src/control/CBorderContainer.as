package control
{
	import events.ChangeTabButtonEvent;
	import events.CloseEvent;
	
	import mx.core.INavigatorContent;
	import mx.events.FlexEvent;
	
	import spark.components.BorderContainer;
	
	public class CBorderContainer extends BorderContainer implements INavigatorContent
	{
		private var _label:String;
		private var _flag:String;
		private var _icon:Class;
		private var _closeEnable:Boolean=true;
		private var _param:Object;//附带的参数
		
		[Bindable]
		[Embed("assets/img/toolbg.png")]
		public static var toolbgimg:Class;
		[Bindable]
		[Embed("assets/img/save.png")]
		public static var saveimg:Class;
		[Bindable]
		[Embed("assets/img/add.png")]
		public static var addimg:Class;
		[Bindable]
		[Embed("assets/img/del.png")]
		public static var delimg:Class;
		[Bindable]
		[Embed("assets/img/refresh.png")]
		public  static var refreshimg:Class;
		[Bindable]
		[Embed("assets/img/wx.png")]
		public  static var wximg:Class;
		
		public function CBorderContainer()
		{
			super();
			this.setStyle("borderVisible",false);
			this.addEventListener(FlexEvent.CREATION_COMPLETE,init);
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
			throw new Error("CBorderContainer 的子类必须重写 init(e:FlexEvent) 方法。");
		}
		
		public function showThis():void{
			var e:ChangeTabButtonEvent=new ChangeTabButtonEvent(ChangeTabButtonEvent.Change_TabButton,this,null,true);
			dispatchEvent(e);
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
		
		
		public function closeContainer(e:CloseEvent):void{
			throw new Error("CBorderContainer 的子类必须重写 closeContainer(e:CloseEvent) 方法。在方法中触发 CloseEvent 事件。");
		}

		public function get param():Object
		{
			return _param;
		}

		public function set param(value:Object):void
		{
			_param = value;
		}
		
		

	}
}