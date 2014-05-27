import flash.events.MouseEvent;

import httpcontrol.CHTTPService;

// ActionScript file

public function quite(e:*=null):void {
	
}



public function initAir(){
    CHTTPService.baseUrl = "http://calendaroa.zxxsbook.com";
    closeAppBtn1.addEventListener(MouseEvent.CLICK,quite);
    closeAppBtn2.addEventListener(MouseEvent.CLICK,quite);
}