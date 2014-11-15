import control.IMControl;

import flash.external.ExternalInterface;

import httpcontrol.HttpServiceUtil;

import mx.controls.Alert;
import mx.events.CloseEvent;

import util.ToolUtil;

public function quite(e:*=null):void {

	Alert.show("确定要退出系统吗?","退出系统",3,this,CloseWindow);   
}

public function quiteNoTip():void{
    HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/logout", currentUser, "POST").send();
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
}
