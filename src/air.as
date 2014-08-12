
import flash.display.NativeWindowDisplayState;
import flash.events.Event;
import flash.events.MouseEvent;

import httpcontrol.CHTTPService;

import mx.core.FlexGlobals;
import mx.events.CloseEvent;
import mx.events.ResizeEvent;

public function quite(e:*=null):void {
	Alert.show("确定要退出系统吗?","退出系统",3,this,CloseWindow);   
}

public function quiteNoTip():void{
    this.nativeWindow.close();//关闭窗体
}



public function initAir():void{
    CHTTPService.baseUrl = "http://127.0.0.1:8000";
	header.addEventListener(MouseEvent.MOUSE_DOWN,pushApp);
	
	
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
