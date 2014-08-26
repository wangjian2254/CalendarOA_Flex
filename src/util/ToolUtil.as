package util
{
import control.window.ApplyOrgPanel;
import control.window.JoinOrgPanel;
import control.Loading;
import control.window.LoginUserPanel;
import control.window.RegisterUserPanel;
import control.window.SelectOrgPanel;

import events.ChangeScheduleEvent;
import events.ChangeUserEvent;

import flash.events.TimerEvent;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.system.System;
import flash.utils.Timer;

import httpcontrol.CHTTPService;
import httpcontrol.HttpServiceUtil;
import httpcontrol.RemoteUtil;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.managers.PopUpManager;
import mx.rpc.AbstractOperation;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import spark.components.Application;

public class ToolUtil
{
    public function ToolUtil()
    {
    }

    [Bindable]
    public static var resultMsg:String="";

    public static var joinOrgFlag:String;

    public static var  currentUserFun:Function=null;
    public static var loginUser:LoginUserPanel= new LoginUserPanel();
    public static var regUser:RegisterUserPanel= new RegisterUserPanel();
    public static var selectOrg:SelectOrgPanel= new SelectOrgPanel();
    public static var searchOrg:JoinOrgPanel= new JoinOrgPanel();

    private static var time:Timer = new Timer(1000*60*5,0);

    public static function init():void{

        loginUser = new LoginUserPanel();
        regUser = new RegisterUserPanel();
        selectOrg = new SelectOrgPanel();


        sessionUserRefresh();
        currentOrgRefresh();
        departMentListRefresh();
        contactsRefresh();
//			taskRefresh();
//        taskUnRefresh();

//        unreadMessageRefresh();
        time.addEventListener(TimerEvent.TIMER,unreadMessageRefresh);
        if(!time.running){
//            time.start();
        }
//			ruleRefresh();
//			ticketRefresh();
//			businessRefresh();
//			kmRefresh();
    }


    [Bindable]
    public static var sessionUser:Object=new Object();


    public static function sessionUserRefresh(fun:Function=null):void{
//			RemoteUtil.getOperationAndResult("getAllUser",resultAllUser).send();
        if(fun==null){
            HttpServiceUtil.getCHTTPServiceAndResult("/ca/currentUser",resultFinduser,"POST").send()
//				RemoteUtil.getOperationAndResult("",resultAllUser,false).send();
        }else{
            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResultAndFault("/ca/currentUser",resultFinduser,failueFinduser,"POST");

            http.resultFunArr.addItem(fun);
            http.send();

        }
    }
    public static function resultFinduser(result:Object,e:ResultEvent):void{
        if(result.success==true){
            if(sessionUser==null||sessionUser["pid"]!=result.result["pid"]){
                FlexGlobals.topLevelApplication.dispatchEvent(new ChangeUserEvent(ChangeUserEvent.ChangeUser_EventStr,result.result,true));
            }
            sessionUser=result.result;

        }else{
            sessionUser=false;
        }
    }

    public static function failueFinduser(e:FaultEvent):void{

    }



    [Bindable]
    public static var unreadMessageNum:String="0未读消息";

    public static function unreadMessageRefresh(fun:*=null):void{
//			RemoteUtil.getOperationAndResult("getAllUser",resultAllUser).send();
        if(fun==null||!(fun is Function)){
            HttpServiceUtil.getCHTTPServiceAndResult("/oamessage/getUnReadCount",resultUnReadMessageRefresh,"POST").send()
//				RemoteUtil.getOperationAndResult("",resultAllUser,false).send();
        }else{
            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/oamessage/getUnReadCount",resultUnReadMessageRefresh,"POST");
            http.resultFunArr.addItem(fun);
            http.send();
        }
    }
    public static function resultUnReadMessageRefresh(result:Object,e:ResultEvent):void{
        if(result.success==true){
            unreadMessageNum = result.result+"未读消息";
        }
    }

    [Bindable]
    public static var departMentList:ArrayCollection=new ArrayCollection();
    [Bindable]
    public static var myDepartmentList:ArrayCollection=new ArrayCollection();;



    public static function departMentListRefresh(fun:Function=null):void{

        if(fun==null){
            HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/getAllDepart",resultAllDepartMent,"POST").send();
        }else{
            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/getAllDepart",resultAllDepartMent,"POST");
            http.resultFunArr.addItem(fun);
            http.send();

        }

    }
    public static function resultAllDepartMent(result:Object,e:ResultEvent):void{
        if(result.success==true){
            departMentList=new ArrayCollection(result.result as Array);

            var dobj:Object=new Object();
            for each(var item2:Object in departMentList) {
                for each(var group:Object in ToolUtil.groupList){
                    if(group.id==item2.id){
                        group.members=item2.members;
                    }
                }

            }

//            myDepartmentList.removeAll();
            var mydepartlist:ArrayCollection = new ArrayCollection();
            var f:Boolean = false;
            for each(var item2:Object in departMentList) {
                f = false;
                for each(var p:Object in item2.members) {
                    if (p.id == ToolUtil.sessionUser.pid) {
                        f = true;
                    }
                }
                if (f) {
                    mydepartlist.addItem(item2);
                }
            }
            var l2:ArrayCollection=getMemberlistByMy(mydepartlist);
            if(l2.length>0){
                mydepartlist.addAll(l2);
            }
            myDepartmentList=mydepartlist;


        }
    }

    private static function getMemberlistByMy (mydepartlist:ArrayCollection):ArrayCollection{
        var l:ArrayCollection=new ArrayCollection();
        var f:Boolean=false;
        for each(var d:Object in departMentList){
            f=true;
            for each(var m:Object in mydepartlist){
                if(d.father==m.id){
                    for each(var m2:Object in mydepartlist){
                        if(m2.id==d.id){
                            f=false;
                        }
                    }
                    if(f){
                        l.addItem(d);
                    }

                }
            }
        }
        if(l.length>0){
            var l2:ArrayCollection=getMemberlistByMy(l);
            l.addAll(l2);
        }
        return l;
    }


    [Bindable]
    public static var groupList:ArrayCollection=new ArrayCollection();

    [Bindable]
    public static var projectList:ArrayCollection=new ArrayCollection();


    [Bindable]
    public static var memberList:ArrayCollection=new ArrayCollection();

    public static function getPersonById(id:*):Object{
        for each(var item:Object in memberList){
            if(item.id == id){
                return item;
            }
        }
        return new Object();
    }

    [Bindable]
    public static var org:Object = null;

    public static function currentOrgRefresh(fun:Function=null):void{

        if(fun==null){
            HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/getCurrentOrg",resultCurrentOrg,"POST").send();
        }else{
            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/getCurrentOrg",resultCurrentOrg,"POST");
            http.resultFunArr.addItem(fun);
            http.send();

        }

    }
    public static function resultCurrentOrg(result:Object,e:ResultEvent):void{
        if(result.success==true){
            org = result.result.org
            memberList.removeAll();
            memberList.addAll(new ArrayCollection(result.result.members as Array));

        }
    }

    [Bindable]
    public static var contactsList:ArrayCollection=new ArrayCollection();

    public static function contactsRefresh(fun:*=null,e:*=null):void{

        if(!(fun is Function)){
            HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/getContacts",resultAllContacts,"POST").send();
        }else{
            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/riliusers/getContacts",resultAllContacts,"POST");
            http.resultFunArr.addItem(fun);
            http.send();

        }

    }
    public static function resultAllContacts(result:Object,e:ResultEvent):void{
        if(result.success==true){
            contactsList.removeAll();
            if(result.result){
                contactsList.addAll(new ArrayCollection(result.result as Array));
            }

        }
    }
//    [Bindable]
//    public static var taskUnList:ArrayCollection=new ArrayCollection();
//
//    public static function taskUnRefresh(fun:*=null,e:*=null):void{
//        var obj:Object=new Object();
//        obj["status"]=false;
//        if(!(fun is Function)){
//            HttpServiceUtil.getCHTTPServiceAndResult("/ca/getTaskByStatus",resultAllUnTask,"POST").send(obj);
//        }else{
//            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/getTaskByStatus",resultAllUnTask,"POST");
//            http.resultFunArr.addItem(fun);
//            http.send(obj);
//
//        }
//
//    }
//    public static function resultAllUnTask(result:Object,e:ResultEvent):void{
//        if(result.success==true){
//            taskUnList.removeAll();
//            if(result.result){
//                taskUnList.addAll(new ArrayCollection(result.result as Array));
//            }
//
//        }
//    }
//    [Bindable]
//    public static var taskList:ArrayCollection=new ArrayCollection();
//
//    public static function getTask(id:String):Object{
//        for each(var item:Object in taskUnList){
//            if(item.id==id){
//                return item;
//            }
//        }
//        for each(item in taskList){
//            if(item.id==id){
//                return item;
//            }
//        }
//        return null;
//    }
//
//    public static function taskRefresh(fun:*=null,e:*=null):void{
//        var obj:Object=new Object();
//        obj["status"]=true;
//        if(!(fun is Function)){
//            HttpServiceUtil.getCHTTPServiceAndResult("/ca/getTaskByStatus",resultAllTask,"POST").send(obj);
//        }else{
//            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/getTaskByStatus",resultAllTask,"POST");
//            http.resultFunArr.addItem(fun);
//            http.send(obj);
//
//        }
//
//    }
//    public static function resultAllTask(result:Object,e:ResultEvent):void{
//        if(result.success==true){
//            taskList.removeAll();
//            if(result.result){
//                taskList.addAll(new ArrayCollection(result.result as Array));
//            }
//
//        }
//    }

    public static var scheduleMap:Object = new Object();



    public static function getSchedule(id:String):Object{
        if(ToolUtil.scheduleMap.hasOwnProperty("schedulemap")&&ToolUtil.scheduleMap.schedulemap.hasOwnProperty(id)){
            return ToolUtil.scheduleMap.schedulemap[id];
        }
        return null;
    }



    public static function getScheduleByDate(start:String,end:String,fun:Function=null):void{
        var obj:Object = new Object();
        obj["startdate"] = start;
        obj["enddate"] = end;

        if(fun==null){
            HttpServiceUtil.getCHTTPServiceAndResult("/ca/getScheduleByDate",queryResult,"POST").send(obj);
        }else{
            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/getScheduleByDate",queryResult,"POST");
            http.resultFunArr.addItem(fun);
            http.send(obj);

        }

    }

    public static function queryResult(result:Object,e:ResultEvent):void{
        if(result.success){
            if(result.result){
                scheduleMap=result.result;

                if(ToolUtil.scheduleMap.hasOwnProperty("schedulemap")){
                    for(var sid:String in scheduleMap.schedulemap){
                        ScheduleUtil.updateSchedulePanel(sid);
                    }
                }
            }

            FlexGlobals.topLevelApplication.dispatchEvent(new ChangeScheduleEvent(true));
        }

    }



}
}