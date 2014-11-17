import airwindow.ChatWindow;

import events.PaoPaoEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.system.Capabilities;

import httpcontrol.CHTTPService;

import mx.events.AIREvent;
import mx.events.CloseEvent;

public function quite(e:*=null):void {
	Alert.show("确定要退出系统吗?","退出系统",3,this,CloseWindow);   
}

public function quiteNoTip():void{
	chatWindow.nativeWindow.close();
    this.nativeWindow.close();//关闭窗体
}

private var chatWindow:ChatWindow;

public function openChatWindow():Object
{
	if(chatWindow!=null){
		chatWindow.nativeWindow.orderToFront();
		chatWindow.nativeWindow.activate();
		return null;
	}
	chatWindow = new ChatWindow();
	
	chatWindow.transparent=true;
//	chatWindow.type=NativeWindowType.UTILITY;
	chatWindow.systemChrome=NativeWindowSystemChrome.NONE;
	chatWindow.addEventListener(CloseEvent.CLOSE,function(e:Event):void{
		chatWindow=null;
	});
	chatWindow.addEventListener(AIREvent.WINDOW_COMPLETE,function(e:Event):void{
		chatWindow.nativeWindow.x = Capabilities.screenResolutionX-chatWindow.width;
		chatWindow.nativeWindow.y = 0;
	});
	chatWindow.open();
	chatWindow.addEventListener(PaoPaoEvent.CHAT, rightMenu);
	return null;
}

public function initAir():void{
    CHTTPService.baseUrl = "http://liyuoa.duapp.com";
	header.addEventListener(MouseEvent.MOUSE_DOWN,pushApp);
	
	callLater(moveCenter);
	
	addSysTrayIcon();
	

//	this.stage.nativeWindow.x=(Capabilities.screenResolutionX=this.nativeWindow.width)/2;
//	this.stage.nativeWindow.y=(Capabilities.screenResolutionY=this.nativeWindow.height)/2;
	
//	this.maximize();
}

public function openChatManager():void{
	
	callLater(openChatWindow);
}

public function moveCenter():void
{
	var window:NativeWindow=stage.nativeWindow;
	window.width = Capabilities.screenResolutionX-230;
	window.height = Capabilities.screenResolutionY;
	window.x = 0;
	window.y = 0;
	maxResize();
	
//	maxResize();
}


public function pushApp(e:MouseEvent):void{
	if(this.nativeWindow.displayState== NativeWindowDisplayState.NORMAL){
		this.nativeWindow.startMove();
	}
}



public function CloseWindow(event:CloseEvent):void{
	if(event.detail==Alert.YES){//如果按下了确定按钮
        quiteNoTip();
	}
}
[Bindable]
public var sizeFlag:Boolean=true;


public function maxResize():void{
	if(sizeFlag){
		this.maximize();
		sizeFlag=false;
		resizeBtn1.label = "恢复";
		resizeBtn2.label = "恢复";
	}else{
		this.restore();
		sizeFlag=true;
		resizeBtn1.label = "最大化";
		resizeBtn2.label = "最大化";
	}
	loginBtnPanel2.invalidateDisplayList();
	loginBtnPanel.invalidateDisplayList();
}
