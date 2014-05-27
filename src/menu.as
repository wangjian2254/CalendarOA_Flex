import control.CBorderContainer;
import control.CalendarControl;
import control.ContactControl;
import control.GroupControl;
import control.LogPanel;
import control.MessageControl;
import control.PaperControl;
import control.PaperKindControl;
import control.SubjectControl;
import control.SubjectKindControl;
import control.UserPaperControl;

import events.ChangeMenuEvent;

import flash.events.Event;
import flash.events.MouseEvent;

import mx.controls.Alert;
import mx.controls.Menu;
import mx.events.FlexEvent;
import mx.events.MenuEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import spark.components.Button;



public function failMenu(evt:FaultEvent):void {
	Alert.show("获取用户菜单失败。", "提示");
}

private function welcome(result:Object, e:ResultEvent):void {
	var event1:MenuEvent = new MenuEvent(MenuEvent.CHANGE);
	var xml1:XML = new XML("<menuitem label='日程管理' mod='calendar'></menuitem>");
	event1.item = xml1;
	onMenuChange(event1);
}

private function openMessage():void {
	var event1:MenuEvent = new MenuEvent(MenuEvent.CHANGE);
	var xml1:XML = new XML("<menuitem label='站内消息' mod='message'></menuitem>");
	event1.item = xml1;
	var obj:Object = new Object();
	obj["messageType"] = "unread";
	onMenuChange(event1, obj);
}


private var myMenuXML:XML = null;

public function setMenu(evt:ResultEvent):void {
	menuContainer.removeAllElements();
	myMenuXML = new XML(evt.result.toString());
	//				myMenuXML=evt.result as XML;
	var xml:XML;
	if (myMenuXML != null) {
		for each(var xml1:XML in myMenuXML..menu) {
			xml = xml1 as XML;
			var btn:Button = new Button();
			btn.height = 29;
			btn.width = 130;
			btn.styleName = "menuBtn";
			btn.label = xml.attribute('label').toString()
			btn.addEventListener(MouseEvent.MOUSE_OVER, showHandler);
			menuContainer.addElement(btn);
		}
	}
	
	welcome(null, null);
}



private function changeMenu(evt:ChangeMenuEvent):void {
	var event:MenuEvent = new MenuEvent(MenuEvent.CHANGE);
	var label:String;
	var mod:String;
	var xml:XML;
	var xml2:XML;
	for each(var xml1:XML in myMenuXML..menuitem) {
		xml2 = xml1 as XML;
		if (xml2.attribute('mod').toString() == evt.getMenuMod()) {
			xml = xml2 as XML;
			break;
		}
	}
	event.item = xml;
	
	onMenuChange(event, evt.getObj());
}

private var myMenu:Menu = new Menu();
private var menuflag:String;

protected function showHandler(event:MouseEvent):void {
	var btn:Button = event.currentTarget as Button;
	var index:Number = 0;
	var xml:XML;
	for each(var xml1:XML in myMenuXML..menu) {
		xml = xml1 as XML;
		
		if (xml.attribute('label').toString() == btn.label) {
			break;
		}
		index += 1;
	}
	if (myMenu != null) {
		if (menuflag == btn.label) {
			return;
		}
		myMenu.hide();
		myMenu = null;
		menuflag = btn.label;
	}
	
	
	myMenu = Menu.createMenu(null, myMenuXML.menu[index], false);
	myMenu.labelField = "@label";
	myMenu.setStyle('font-family', '黑体');
	myMenu.setStyle('chromeColor', '#dce2e7');
	myMenu.iconFunction = iconFun;
	myMenu.show(menuContainer.left + event.currentTarget.x, menuContainer.top + event.currentTarget.y + event.currentTarget.height);
	myMenu.addEventListener(MouseEvent.CLICK, hideHandler);
	myMenu.addEventListener(FlexEvent.HIDE, hideHandler);
	myMenu.addEventListener(MenuEvent.CHANGE, onMenuChange);
}

protected function hideHandler(event:Event):void {
	//				if(myMenu!=null){
	//
	//					myMenu.hide();
	//					myMenu=null;
	//				}
	menuflag = null;
}

protected function onMenuChange(event:MenuEvent, obj:Object = null):void {
	//				if(obj!=null){
	//					Alert.show(obj['test'],'d');
	//				}
	menuflag = null;
	var xml:XML = event.item as XML;
	var mod:String = xml.attribute('mod').toString();
	var c:CBorderContainer;
	c = cbar.getView(mod);
	if (c == null) {
		switch (mod) {
			
			case 'calendar':
				c = new CalendarControl();
				break;
			case 'contact':
				c = new ContactControl();
				break;
			case 'group':
				c = new GroupControl();
				break;
			case 'message':
				c = new MessageControl();
				break;
			case 'log':
				c = new LogPanel();
				break;
			case 'paper':
				c = new PaperControl();
				break;
			case 'paperkind':
				c = new PaperKindControl();
				break;
			case 'mypaper':
				c = new UserPaperControl();
				break;
			case 'subject':
				c = new SubjectControl();
				break;
			case 'subjectkind':
				c = new SubjectKindControl();
				break;
			
			
		}
	}
	if (c != null) {
		c.label = xml.attribute('label').toString();
		c.flag = mod;
		c.param = obj;
		if (!cbar.setView(mod)) {
			cbar.addView(c);
		}
		website.text = c.label;
	}
	
}

