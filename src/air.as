import airwindow.ChatWindow;

import events.PaoPaoEvent;

import flash.events.Event;
import flash.events.MouseEvent;
import flash.system.Capabilities;

import httpcontrol.CHTTPService;

import mx.events.AIREvent;
import mx.events.CloseEvent;

import org.idream.pomelo.Pomelo;

import util.ToolUtil;

public function quite(e:*=null):void {
	Alert.show("确定要退出系统吗?","退出系统",3,this,CloseWindow);   
}

public function quiteNoTip():void{
	this.nativeWindow.close();//关闭窗体
	ToolUtil.sessionUser=new Object();
	Pomelo.getIns().disconnect();
	chatWindow.nativeWindow.close();
    
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
	updater.initialize()

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


import air.update.events.DownloadErrorEvent;
import air.update.events.StatusUpdateEvent;
import air.update.events.UpdateEvent;

import mx.controls.Alert;
import flash.events.ErrorEvent;

[Bindable]
protected var downlaoding:Boolean = false;

protected function isNewerFunction(currentVersion:String, updateVersion:String):Boolean
{
	// Example of custom isNewerFunction function, it can be omitted if one doesn't want
	// to implement it's own version comparison logic. Be default it does simple string
	// comparison.
	return true;
}

protected function updater_errorHandler(event:ErrorEvent):void
{
	Alert.show(event.text);
	airprogress.visible= false;
}


protected function updater_initializedHandler(event:UpdateEvent):void
{
	// When NativeApplicationUpdater is initialized you can call checkNow function
	updater.checkNow();
}

protected function updater_updateStatusHandler(event:StatusUpdateEvent):void
{
	if (event.available)
	{
		// In case update is available prevent default behavior of checkNow() function 
		// and switch to the view that gives the user ability to decide if he wants to
		// install new version of the application.
		event.preventDefault();
		
		downlaoding = true;
		airprogress.visible= true;
		updater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, updater_downloadErrorHandler);
		updater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, updater_downloadCompleteHandler);
		updater.downloadUpdate();
	}
	else
	{
		Alert.show("Your application is up to date!");
	}
}


private function updater_downloadCompleteHandler(event:UpdateEvent):void
{
	airprogress.visible= false;
	// When update is downloaded install it.
	updater.installUpdate();
}

private function updater_downloadErrorHandler(event:DownloadErrorEvent):void
{
	airprogress.visible= false;
	Alert.show("Error downloading update file, try again later.");
}


