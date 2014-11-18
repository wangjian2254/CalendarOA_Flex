import events.ListClickEvent;

import flash.display.BitmapData;
import flash.display.Loader;
import flash.display.NativeMenu;
import flash.display.NativeMenuItem;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.utils.Timer;

import httpcontrol.CHTTPService;

import model.ChatChannel;

[Embed(source='/assets/logo_icon.png')]
private var logoicon:Class;

[Embed(source='/assets/logo_icon2.png')]
private var logoicon2:Class;

private var icon1:Loader = new Loader();
private var logo_1:BitmapData;
private var icon2:Loader = new Loader();
private var logo_2:BitmapData;

private var icontimer:Timer=new Timer(500,0);
private var iconflag:Boolean = true;
private function addSysTrayIcon():void{
	//icon16是一个图片文件，大小为16*16
	this.nativeApplication.icon.bitmaps = [new logoicon()];
	if(NativeApplication.supportsSystemTrayIcon){
		icon1.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoadComplete1);
		icon1.load(new URLRequest(CHTTPService.baseUrl+"/static/swf/assets/logo_icon.png"));
		icon2.contentLoaderInfo.addEventListener(Event.COMPLETE, iconLoadComplete2);
		icon2.load(new URLRequest(CHTTPService.baseUrl+"/static/swf/assets/logo_icon2.png"));
		
		var sti:SystemTrayIcon = SystemTrayIcon(this.nativeApplication.icon);
		//创建菜单列表
//		sti.menu = createSysTrayMenu();
		//单击系统托盘图标时恢复窗口
		sti.addEventListener(MouseEvent.CLICK,undockHandler);
		
//		sti.addEventListener(MouseEvent.RIGHT_CLICK,rightMenu);
//		sti.addEventListener(MouseEvent.MOUSE_OVER,rightMenu);
		
		icontimer.addEventListener(TimerEvent.TIMER, iconShan);
		icontimer.start();
	}
}
private function iconLoadComplete1(event:Event):void
{
	logo_1 = event.target.content.bitmapData;
}
private function iconLoadComplete2(event:Event):void
{
	logo_2 = event.target.content.bitmapData;
}

private function iconShan(e:TimerEvent):void{
	if(logo_1==null||logo_2==null){
		return;
	}
	var hasMessage:Boolean = false;
	if(chatWindow!=null){
		for each(var obj:ChatChannel in chatWindow.unread_messagelist){
			hasMessage = true;
			break;
		}
	}
	if(iconflag && hasMessage){
		this.nativeApplication.icon.bitmaps = [logo_2];
		iconflag= false;
	}else{
		this.nativeApplication.icon.bitmaps = [logo_1];
		iconflag = true;
	}
}

private function rightMenu(e:Event):void{
	if(NativeApplication.supportsSystemTrayIcon){
		var sti:SystemTrayIcon = SystemTrayIcon(this.nativeApplication.icon);
		//创建菜单列表
		sti.menu = createSysTrayMenu();
//		sti.menu.display(this.stage,e.stageX,e.stageY);
		

	}
}

private function createSysTrayMenu():NativeMenu{
	var menu:NativeMenu = new NativeMenu();
	if(chatWindow!=null){
		for each(var obj:ChatChannel in chatWindow.unread_messagelist){
			
			var menuItem:NativeMenuItem = new NativeMenuItem( obj.name+"("+obj.unread+")",false);
			menuItem.name = obj.channel;
			menuItem.addEventListener(Event.SELECT,chatMenuHandler );//菜单处理事件
			menu.addItem( menuItem );  
		}
		if(menu.numItems>0){
			menuItem = new NativeMenuItem( obj.name,true);
			menu.addItem( menuItem ); 
		}
		 
	}
	
	
	var labels:Array = ["退出程序"];
	var names:Array = ["mnuExit"];
	for (var i:int = 0;i<labels.length;i++){
		//如果标签为空的话，就认为是分隔符
		menuItem = new NativeMenuItem( labels[i],false);
		menuItem.name = names[i];
		menuItem.addEventListener(Event.SELECT,sysTrayMenuHandler );//菜单处理事件
		menu.addItem( menuItem );               
	}
	
	return menu;
}

private function chatMenuHandler(e:Event):void{
	var chatChannel:ChatChannel = chatWindow.unread_messagelist[e.target.name];
	if (chatChannel != null) {
		var event:ListClickEvent = new ListClickEvent("chat", chatChannel);
		chatWindow.listItemClick_handler(event);
	}
	
}

private function sysTrayMenuHandler(event:Event):void{
	switch(event.target.name){
		case "mnuOpen"://打开菜单
			undockHandler();
			break;
		case "mnuExit"://退出菜单
			exitHandler();
			break;
	}
	
}

private function undockHandler(e:Event=null):void{
	this.nativeWindow.visible = true;
	//窗口提到最前面
	this.nativeWindow.orderToFront();
	//激活当前窗口
	this.activate();
	openChatWindow();
}

private function exitHandler():void{
	this.quiteNoTip();
	
}