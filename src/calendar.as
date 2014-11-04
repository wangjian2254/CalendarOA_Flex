// ActionScript file
import control.CBorderContainer;
import control.window.ChangePasswordPanel;

import control.window.UserInfoPanel;

import events.ChangeMenuEvent;
import events.ChangeUserEvent;
import events.InitDefaultMemberProjectEvent;
import events.QueryScheduleEvent;
import events.QuiteEvent;

import flash.display.DisplayObject;


import model.User;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import org.idream.pomelo.Pomelo;

import spark.components.Button;

import util.ChatManager;

import util.RightClickRegister;
import util.ToolUtil;
import util.ToolUtil;
import util.UserUtil;


public function init():void {
    new RightClickRegister();
    Alert.yesLabel = "是";
    Alert.noLabel = "否";
    Alert.cancelLabel = "取消";

    if(this.hasOwnProperty("initAir")){
        this["initAir"]();
        ChatManager.type="air";
    }
    if(this.hasOwnProperty("initFlex")){
        this["initFlex"]();

    }
	ToolUtil.currentUserFun = currentUser;
	//				ToolUtil.init();
	ToolUtil.sessionUserRefresh(currentUser);
	
	menuXML.send();
	FlexGlobals.topLevelApplication.addEventListener(ChangeMenuEvent.ChangeMenu_EventStr, changeMenu);
	FlexGlobals.topLevelApplication.addEventListener(InitDefaultMemberProjectEvent.Default_Member_EventStr, function(e:InitDefaultMemberProjectEvent):void{
        membersDownList.selectedIndex = 0;
    });
	FlexGlobals.topLevelApplication.addEventListener(InitDefaultMemberProjectEvent.Default_Project_EventStr, function(e:InitDefaultMemberProjectEvent):void{
        projectDownList.selectedIndex = 0;
    });
    FlexGlobals.topLevelApplication.addEventListener(QuiteEvent.Quite,logout);
    FlexGlobals.topLevelApplication.addEventListener(QueryScheduleEvent.QuerySchedule_Str,function(e:QueryScheduleEvent):void{

        if(e.start==null || e.end==null){
            var calendarBordar:CalendarControl = gongNengStack.selectedChild as CalendarControl;
            if(calendarBordar==null){
                return;
            }
            var parm:Object = calendarBordar.getShowDateRange();
            if(parm==null){
                return;
            }
            e.start = parm.start;
            e.end = parm.end;
        }

        if(e.pid > 0){
            ToolUtil.changeProjectByDepart(e.depart_id,e.pid,membersDownList,projectDownList);
        }else{
            if(e.depart_id>0){
                ToolUtil.changeProjectByDepart(e.depart_id,-1,membersDownList,projectDownList);
            }
        }
        if(e.pid==-1&&e.depart_id==-1&&e.project_id==-1){
            if(membersDownList.selectedItem!=null){
                e.pid = membersDownList.selectedItem.id;
            }
            if(projectDownList.selectedItem!=null){
                e.project_id = projectDownList.selectedItem.id;
            }
            if(e.project_id>0){
                e.pid = -1;
            }

        }
        ToolUtil.getScheduleByDate(e.start,e.end,e.pid,e.depart_id,e.project_id);
    });

	
}



private function currentUser(result:Object, e:ResultEvent):void {
	if (result.success) {
		if (!result.result) {
            // 没有登陆成功
			userinfoGroup.visible = false;
			userinfoGroup2.visible = true;
		} else {
            // 成功登陆
			userinfoGroup2.visible = false;
			userinfoGroup.visible = true;
            ChatManager.loginChat();

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
    ToolUtil.sessionUser=new Object();
    Pomelo.getIns().disconnect();
    if(e!=null){
        var evt:QuiteEvent = e as QuiteEvent;
        if(evt!=null){
            if(evt.needTip){
                if(this.hasOwnProperty("quite")){
                    this["quite"]();
                }
            }else{
                quiteNoTip();
            }
            return;
        }
    }
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

public function searcher():void{
    Alert.show("搜索");
}


public function reLogin():void {
	FlexGlobals.topLevelApplication.dispatchEvent(new ChangeUserEvent(ChangeUserEvent.ChangeUser_EventStr, ToolUtil.sessionUser, true));
}