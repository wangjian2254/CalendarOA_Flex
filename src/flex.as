import control.IMControl;

import events.ScheduleNotifyEvent;

import flash.display.DisplayObject;

import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import httpcontrol.HttpServiceUtil;

import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.events.CloseEvent;
import mx.managers.PopUpManager;

import org.idream.pomelo.Pomelo;

import uicontrol.NewsPannel;

import util.ChatManager;

import util.ToolUtil;

public function quite(e:*=null):void {

	Alert.show("确定要退出系统吗?","退出系统",3,this,CloseWindow);   
}

public function quiteNoTip():void{
	ToolUtil.sessionUser=new Object();
	Pomelo.getIns().disconnect();
    HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/logout", function(result:Object,e:ResultEvent):void{
		ToolUtil.sessionUser=new Object();
		currentUser(result,e);
	}, "POST").send();
}

public function CloseWindow(event:CloseEvent):void{
	if(event.detail==Alert.YES){//如果按下了确定按钮
        quiteNoTip();

	}
}

public function openChatWindow():Object
{
	return new IMControl();
}

public function openChatManager():void{
	ChatManager.loginChat();
}

public function initFlex():void{
    styleManager.loadStyleDeclarations('styleflex.swf',true,false, ApplicationDomain.currentDomain)
    var url:String = ExternalInterface.call('window.location.href.toString');
    if(url.indexOf("addPerson?flag=")>0){
        for each(var u:String in url.split('?')){
            for each(var r:String in u.split('&')){
                if(r.split('=')[0]=='flag'){
                    ToolUtil.joinOrgFlag = r.split('=')[1];
                }
            }

        }

    }
    FlexGlobals.topLevelApplication.addEventListener(ScheduleNotifyEvent.SCHEDULE_NOTIFY, scheduleNotify);
//    ExternalInterface.call("notify_permission");
}

public function scheduleNotify(e:ScheduleNotifyEvent):void{

    ExternalInterface.call("notify","/static/swf/assets/login_icon.png", "任务提醒", e.s.title);
    var s:NewsPannel = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,NewsPannel,false) as NewsPannel;
    s.message = e.s;
    s.y = 0 - s.height - 10;
    s.x = FlexGlobals.topLevelApplication.width - s.width-10;
    s.unReadMessage = ChatManager.unReadMessage;
    ChatManager.unReadMessage.addItem(s);
}

private function downloadAir():void{
    navigateToURL(new URLRequest("/ca/downloadair"),"_blank");
}
