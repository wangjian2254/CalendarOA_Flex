import airwindow.ChatWindow;

import flash.display.NativeWindowSystemChrome;
import flash.display.NativeWindowType;
import flash.display.Stage;
import flash.events.MouseEvent;
import flash.system.Capabilities;

import httpcontrol.CHTTPService;

import mx.core.FlexGlobals;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;

public function quite(e:*=null):void {
	Alert.show("确定要退出系统吗?","退出系统",3,this,CloseWindow);   
}

public function quiteNoTip():void{
    this.nativeWindow.close();//关闭窗体
}

private var chatWindow:ChatWindow;

public function openChatWindow():Object
{
	if(chatWindow!=null){
		return null;
	}
	chatWindow = new ChatWindow();
	chatWindow.transparent=true;
	chatWindow.type=NativeWindowType.UTILITY;
	chatWindow.systemChrome=NativeWindowSystemChrome.NONE;
	chatWindow.addEventListener(CloseEvent.CLOSE,function(e:CloseEvent):void{
		chatWindow=null;
	});
	chatWindow.open();
	return null;
}

public function initAir():void{
    CHTTPService.baseUrl = "http://192.168.101.18:8000";
	header.addEventListener(MouseEvent.MOUSE_DOWN,pushApp);
	
	callLater(moveCenter);
	callLater(openChatWindow);
//	this.stage.nativeWindow.x=(Capabilities.screenResolutionX=this.nativeWindow.width)/2;
//	this.stage.nativeWindow.y=(Capabilities.screenResolutionY=this.nativeWindow.height)/2;
	
//	this.maximize();
}

public function moveCenter():void
{
	var window:NativeWindow=stage.nativeWindow;
	window.width = (Capabilities.screenResolutionX/5)*4;
	window.height = (Capabilities.screenResolutionY/5)*4;
	window.x = (Capabilities.screenResolutionX - window.width) / 2;
	window.y = (Capabilities.screenResolutionY - window.height) / 2;
	
	maxResize();
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
