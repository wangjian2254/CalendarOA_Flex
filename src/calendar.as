// ActionScript file
import control.CBorderContainer;
import control.window.AddSocialPanel;
import control.window.ChangePasswordPanel;
import control.window.UserInfoPanel;

import events.ChangeMenuEvent;
import events.ChangeUserEvent;
import events.InitDefaultMemberProjectEvent;
import events.PaoPaoEvent;
import events.QueryScheduleEvent;
import events.QuiteEvent;

import flash.display.DisplayObject;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import spark.components.TitleWindow;

import util.ChatManager;
import util.NotifyTools;
import util.RightClickRegister;
import util.ToolUtil;

public function init():void {
    new RightClickRegister();
    NotifyTools.initNotifyTools();
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
    FlexGlobals.topLevelApplication.addEventListener(MenuEvent.CHANGE,function(event1:MenuEvent):void{
//        	var event1:MenuEvent = new MenuEvent(MenuEvent.CHANGE);
//	var xml1:XML = new XML("<menuitem label='消息' mod='message'></menuitem>");
//	event1.item = xml1;
//	var obj:Object = new Object();
//	obj["messageType"] = "unread";
        onMenuChange(event1);
    });
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
        if(e.justChangeDate){
            ToolUtil.getScheduleByDate(e.start,e.end,ToolUtil.queryScheduleTargetObj.pid,ToolUtil.queryScheduleTargetObj.depart_id,ToolUtil.queryScheduleTargetObj.project_id);
            return;
        }
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
        if(e.pid==-1){
            if(membersDownList.selectedItem!=null){
                e.pid = membersDownList.selectedItem.id;
                e.depart_id = membersDownList.selectedItem.depart_id;
            }


        }
        if(e.depart_id==-1){
            if(membersDownList.selectedItem!=null){
                e.pid = membersDownList.selectedItem.id;
                e.depart_id = membersDownList.selectedItem.depart_id;
            }
        }
        if(e.project_id==-1){
            if(projectDownList.selectedItem!=null){
                e.project_id = projectDownList.selectedItem.id;
            }

        }else{
            if(e.project_id>0){
                e.depart_id = -1;
            }
        }
        ToolUtil.getScheduleByDate(e.start,e.end,e.pid,e.depart_id,e.project_id);
    });
    FlexGlobals.topLevelApplication.addEventListener(ChangeUserEvent.ChangeUser_EventStr,function(event:ChangeUserEvent):void{
        queryMySchedule();
    });
}

public function queryMySchedule():void{
    var calendarBordar:CalendarControl = gongNengStack.selectedChild as CalendarControl;
    if(calendarBordar==null){
        return;
    }
    var parm:Object = calendarBordar.getShowDateRange();
    if(parm==null){
        return;
    }
    ToolUtil.getScheduleByDate(parm.start,parm.end);
    ToolUtil.membersByDepart.removeAll();
    ToolUtil.membersByDepart.addItem({id:ToolUtil.sessionUser.id,name:"我自己"});
    FlexGlobals.topLevelApplication.dispatchEvent(new InitDefaultMemberProjectEvent(InitDefaultMemberProjectEvent.Default_Member_EventStr,true));
    ToolUtil.projectByDepart.removeAll();
    ToolUtil.projectByDepart.addItem({id:-1,name:"我参与的任务"});
    ToolUtil.projectByDepart.addAll(ObjectUtil.clone(ToolUtil.projectList) as ArrayCollection);
    FlexGlobals.topLevelApplication.dispatchEvent(new InitDefaultMemberProjectEvent(InitDefaultMemberProjectEvent.Default_Project_EventStr,true));
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
			openChatManager();

		}
		menuXML.send();
//		ToolUtil.init();
		for (var i:Number = 0; i < gongNengStack.numElements; i++) {
			var c:CBorderContainer = gongNengStack.getElementAt(i) as CBorderContainer;
			c.init(null);
		}
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
		this, UserInfoPanel, true) as TitleWindow);
	PopUpManager.centerPopUp(changepassword);
}

public function logout(e:*=null):void {
    
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
		this, ChangePasswordPanel, true) as TitleWindow);
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

public function reSelectOrg():void{
	ToolUtil.selectOrg.loginNickname = ToolUtil.sessionUser.uname;
	PopUpManager.addPopUp(ToolUtil.selectOrg, FlexGlobals.topLevelApplication as DisplayObject, true);
	return;
}

public function bindSocialUser():void{
    PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,AddSocialPanel,true);
}