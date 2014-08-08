import mx.events.CloseEvent;
import mx.managers.BrowserManager;
import mx.managers.IBrowserManager;

// ActionScript file

public function quite(e:*=null):void {
	
	Alert.show("确定要退出系统吗?","退出系统",3,this,CloseWindow);   
}

public function CloseWindow(event:CloseEvent):void{
	if(event.detail==Alert.YES){//如果按下了确定按钮
		HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/logout", currentUser, "POST").send();
	}
}

public function initFlex():void{
    var br:IBrowserManager = BrowserManager.getInstance();
    br.setTitle("鲤鱼协同系统");
}
