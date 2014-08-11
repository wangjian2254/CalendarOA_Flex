// ActionScript file
import control.CBorderContainer;
import control.CalendarControl;
import control.window.ChangePasswordPanel;
import control.ContactControl;
import control.GroupControl;
import control.Loading;
import control.window.LogPanel;
import control.window.LoginUserPanel;
import control.MessageControl;
import control.PaperControl;
import control.PaperKindControl;
import control.window.RegisterUserPanel;
import control.SubjectControl;
import control.SubjectKindControl;
import control.window.UserInfoPanel;
import control.UserPaperControl;

import events.ChangeMenuEvent;
import events.ChangeUserEvent;
import events.QuiteEvent;

import flash.display.DisplayObject;

import httpcontrol.HttpServiceUtil;
import httpcontrol.RemoteUtil;

import model.User;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.Menu;
import mx.core.FlexGlobals;
import mx.events.FlexEvent;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;
import mx.messaging.ChannelSet;
import mx.messaging.channels.AMFChannel;
import mx.rpc.AbstractOperation;
import mx.rpc.AsyncResponder;
import mx.rpc.AsyncToken;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;

import spark.components.Application;
import spark.components.Button;

import util.InfoUtil;
import util.LoadingUtil;
import util.RightClickRegister;
import util.ToolUtil;
import util.UserUtil;


public function init():void {
    new RightClickRegister();


    if(this.hasOwnProperty("initAir")){
        this["initAir"]();

    }
    if(this.hasOwnProperty("initFlex")){
        this["initFlex"]();

    }
	ToolUtil.currentUserFun = currentUser;
	//				ToolUtil.init();
	ToolUtil.sessionUserRefresh(currentUser);
	
	menuXML.send();
	FlexGlobals.topLevelApplication.addEventListener(ChangeMenuEvent.ChangeMenu_EventStr, changeMenu);
    FlexGlobals.topLevelApplication.addEventListener(QuiteEvent.Quite,logout);

	
}



private function currentUser(result:Object, e:ResultEvent):void {
	if (result.success) {
		if (!result.result) {
			userinfoGroup.visible = false;
			userinfoGroup2.visible = true;
		} else {
			userinfoGroup2.visible = false;
			userinfoGroup.visible = true;
			
		}
		menuXML.send();
		ToolUtil.init();
		for (var i:Number = 0; i < gongNengStack.numElements; i++) {
			var c:CBorderContainer = gongNengStack.getElementAt(i) as CBorderContainer;
			c.init(null);
		}
	}
}


private function resultUser(evt:ResultEvent, token:Object = null):void {
	if (evt.result.success == true) {
		var user:User = new User();
		user.id = evt.result.result.id;
		user.username = evt.result.result.username;
		user.fullname = evt.result.result.last_name + evt.result.result.first_name;
		user.user_permissions = new ArrayCollection(evt.result.result.user_permissions as Array);
		user.groups = new ArrayCollection(evt.result.result.groups as Array);
		UserUtil.user = user;
	}
	
}


private function iconFun(item:Object):Class {
	var xml:XML = item as XML;
	switch (xml.attribute('mod').toString()) {
		
		//					case 'guanLi3':
		//						return this.imgcz;
		//						break;
	}
	return null;
}

public function login():void {
	PopUpManager.addPopUp(ToolUtil.loginUser, FlexGlobals.topLevelApplication as DisplayObject, true);
	
}

public function reg():void {
    PopUpManager.addPopUp(ToolUtil.regUser, FlexGlobals.topLevelApplication as DisplayObject, true);
}

public function updateinfo():void {
	var changepassword:UserInfoPanel = UserInfoPanel(PopUpManager.createPopUp(
		this, UserInfoPanel, true) as spark.components.TitleWindow);
	PopUpManager.centerPopUp(changepassword);
}

public function logout(e:*=null):void {
	if(this.hasOwnProperty("quite")){
		this["quite"]();
	}
	
}


public function repassword():void {
	var changepassword:ChangePasswordPanel = ChangePasswordPanel(PopUpManager.createPopUp(
		this, ChangePasswordPanel, true) as spark.components.TitleWindow);
	PopUpManager.centerPopUp(changepassword);
	//				changepassword.x=(this.width-changepassword.width)/2;
	//				changepassword.y=(this.height-changepassword.height)/2;
}


public function reLogin():void {
	FlexGlobals.topLevelApplication.dispatchEvent(new ChangeUserEvent(ChangeUserEvent.ChangeUser_EventStr, ToolUtil.sessionUser, true));
}