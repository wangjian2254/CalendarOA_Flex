import airwindow.ChatWindow;
import airwindow.NoticeWindow;
import airwindow.SocialWindow;

import events.PaoPaoEvent;
import events.ScheduleNotifyEvent;
import events.SocialEvent;

import flash.desktop.NativeApplication;
import flash.display.NativeWindowSystemChrome;
import flash.display.NativeWindowType;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.system.Capabilities;

import httpcontrol.CHTTPService;

import mx.core.FlexGlobals;
import mx.events.AIREvent;
import mx.events.CloseEvent;

import org.idream.pomelo.Pomelo;

import util.ChatManager;
import util.ToolUtil;

public function quite(e:*=null):void {
	Alert.show("确定要退出系统吗?","退出系统",3,this,CloseWindow);   
}

public function quiteNoTip():void{
	this.nativeWindow.close();//关闭窗体
	ToolUtil.sessionUser=new Object();
	Pomelo.getIns().disconnect();
	if(chatWindow!=null){
		chatWindow.nativeWindow.close();
	}
	
    
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
		chatWindow.nativeWindow.y = 30;
	});
	chatWindow.open();
	chatWindow.addEventListener(PaoPaoEvent.CHAT, rightMenu);
	return null;
}

public function initAir():void{
//    CHTTPService.baseUrl = "http://192.168.101.18:8000";
    CHTTPService.baseUrl = "http://liyuoa.duapp.com";
	header.addEventListener(MouseEvent.MOUSE_DOWN,pushApp);
	
	callLater(moveCenter);
	
	addSysTrayIcon();
	updater.initialize()
	startAtLogin();
//	this.stage.nativeWindow.x=(Capabilities.screenResolutionX=this.nativeWindow.width)/2;
//	this.stage.nativeWindow.y=(Capabilities.screenResolutionY=this.nativeWindow.height)/2;
	
//	this.maximize();
	FlexGlobals.topLevelApplication.addEventListener(ScheduleNotifyEvent.SCHEDULE_NOTIFY, scheduleNotify);
	FlexGlobals.topLevelApplication.addEventListener(SocialEvent.SOCIAL, social_window);
	
}

public function social_window(e:SocialEvent):void{
	var notice:SocialWindow = new SocialWindow();
	notice.transparent = true;
//	notice.type = NativeWindowType.UTILITY;
	notice.systemChrome = NativeWindowSystemChrome.NONE;
	notice.social_url = e.url;
	notice.open();
}

public function scheduleNotify(e:ScheduleNotifyEvent):void{
	
	var notice:NoticeWindow = new NoticeWindow();
	notice.transparent = true;
	notice.type = NativeWindowType.UTILITY;
	notice.systemChrome = NativeWindowSystemChrome.NONE;
	notice.message = e.s;
	notice.open();
}
public function openChatManager():void{
	
	callLater(openChatWindow);
	if(chatWindow!=null){
		chatWindow.init();
	}
}

public function moveCenter():void
{
	var window:NativeWindow=stage.nativeWindow;
	window.width = (Capabilities.screenResolutionX-230)*0.9;
	window.height = (Capabilities.screenResolutionY)*0.9;
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


private function startAtLogin():void{
	
	if(NativeApplication.supportsStartAtLogin==true){
		try{
			NativeApplication.nativeApplication.startAtLogin = true;
		}catch(e:Error){
			
		}
		
	}
}

import air.update.events.DownloadErrorEvent;
import air.update.events.StatusUpdateEvent;
import air.update.events.UpdateEvent;

import mx.controls.Alert;
import flash.events.ErrorEvent;


protected function updater_errorHandler(event:ErrorEvent):void
{
	return;
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
		Alert.show("检测到有新版本程序发布，是否下载安装？", "提示", Alert.YES | Alert.CANCEL, null, function (e:CloseEvent):void {
			if (e.detail == Alert.YES) {
				updater.addEventListener(DownloadErrorEvent.DOWNLOAD_ERROR, updater_downloadErrorHandler);
				updater.addEventListener(UpdateEvent.DOWNLOAD_COMPLETE, updater_downloadCompleteHandler);
				updater.downloadUpdate();
			}
		});
		
	}
	else
	{
		return;
	}
}


private function updater_downloadCompleteHandler(event:UpdateEvent):void
{
	// When update is downloaded install it.
	Alert.show("已下载了新版本程序，是否安装？", "提示", Alert.YES | Alert.CANCEL, null, function (e:CloseEvent):void {
		if (e.detail == Alert.YES) {
			updater.installUpdate();
		}
	});
	
}

private function updater_downloadErrorHandler(event:DownloadErrorEvent):void
{
	return;
}


