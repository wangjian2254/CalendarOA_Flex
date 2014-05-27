// ActionScript file
import control.CBorderContainer;
import control.CalendarControl;
import control.ChangePasswordPanel;
import control.ContactControl;
import control.GroupControl;
import control.Loading;
import control.LogPanel;
import control.LoginUserPanel;
import control.MessageControl;
import control.PaperControl;
import control.PaperKindControl;
import control.RegisterUserPanel;
import control.SubjectControl;
import control.SubjectKindControl;
import control.UserInfoPanel;
import control.UserPaperControl;

import events.ChangeMenuEvent;
import events.ChangeUserEvent;

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
import util.ToolUtil;
import util.UserUtil;


public function init():void {
	if (this is Application) {
		loginBtnPanel2.removeElement(closeAppBtn2);
		loginBtnPanel.removeElement(closeAppBtn1);
		loginBtnPanel2.removeElement(closeAppLine2);
		loginBtnPanel.removeElement(closeAppLine1);
		loginBtnPanel.invalidateSize();
		loginBtnPanel.invalidateDisplayList();
		loginBtnPanel2.invalidateSize();
		loginBtnPanel2.invalidateDisplayList();
	}

    if(this.hasOwnProperty("initAir")){
        this["initAir"]();

    }
	ToolUtil.currentUserFun = currentUser;
	//				ToolUtil.init();
	ToolUtil.sessionUserRefresh(currentUser);
	
	menuXML.send();
	FlexGlobals.topLevelApplication.addEventListener(ChangeMenuEvent.ChangeMenu_EventStr, changeMenu);
	
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
	var changepassword:RegisterUserPanel = RegisterUserPanel(PopUpManager.createPopUp(
		this, RegisterUserPanel, true) as spark.components.TitleWindow);
	PopUpManager.centerPopUp(changepassword);
}

public function updateinfo():void {
	var changepassword:UserInfoPanel = UserInfoPanel(PopUpManager.createPopUp(
		this, UserInfoPanel, true) as spark.components.TitleWindow);
	PopUpManager.centerPopUp(changepassword);
}

public function logout():void {
	HttpServiceUtil.getCHTTPServiceAndResult("/ca/logout", currentUser, "POST").send();
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