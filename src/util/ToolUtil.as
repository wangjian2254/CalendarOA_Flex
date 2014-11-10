package util
{
import control.window.JoinOrgPanel;
import control.window.LoginUserPanel;
import control.window.RegisterUserPanel;
import control.window.SelectOrgPanel;

import events.ChangeScheduleEvent;
import events.ChangeUserEvent;
import events.InitDefaultMemberProjectEvent;
import events.QueryScheduleEvent;

import flash.events.TimerEvent;
import flash.utils.Timer;

import httpcontrol.CHTTPService;
import httpcontrol.HttpServiceUtil;

import model.ChatChannel;
import model.Schedule;

import mx.collections.ArrayCollection;
import mx.core.FlexGlobals;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import spark.components.DropDownList;

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

    public static var projectstatus:ArrayCollection=new ArrayCollection([{id:"unstart",label:"未开始"},{id:"runing",label:"正在进行"},{id:"finished",label:"已完成"},{id:"closed",label:"已关闭"}]);
    public static var taskstatusmap:Object = {"1":"未开始", "2":"正在进行", "3":"待审核", "4":"完成"};
//    public static var taskstatuslist:ArrayCollection=new ArrayCollection([{id:1,label:"未开始"},{id:2,label:"正在进行"},{id:3,label:"待审核"},{id:4,label:"完成"}]);
    public static var taskurgentlist:ArrayCollection=new ArrayCollection([{id:1,label:"普通"},{id:2,label:"优先"},{id:3,label:"紧急"}]);

    public static var currentChannel:String="";
    private static var time:Timer = new Timer(1000*60*5,0);

    public static function getTaskStatus(i:int):String{
        if(taskstatusmap.hasOwnProperty(i.toString())){
            return taskstatusmap[i.toString()];
        }else{
            return "";
        }
    }


    public static function getTaskUrgent(i:int):String{
        for each(var o:Object in taskurgentlist){
            if(o.id==i){
                return o.label;
            }
        }
        return "";
    }

    public static function init():void{

        loginUser = new LoginUserPanel();
        regUser = new RegisterUserPanel();
        selectOrg = new SelectOrgPanel();


        sessionUserRefresh();

//        departMentListRefresh();


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
            projectListRefresh();
            currentOrgRefresh();
            contactsRefresh();
            allProjectListRefresh();
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
    public static var myDepartmentList:ArrayCollection=new ArrayCollection([{id:0,name:"只有我和责任人可见",label:"只有我和责任人可见"}]);;

    [Bindable]
    public static var projectByDepart:ArrayCollection=new ArrayCollection();
    [Bindable]
    public static var membersByDepart:ArrayCollection=new ArrayCollection();


    public static function changeProjectByDepart(depart_id:int,person_id:int,membersDownList:DropDownList,projectDownList:DropDownList):void{
        membersByDepart.removeAll();
        membersByDepart.addItem({id:-1, name:"所有人"});
        for each(var d:Object in departMentList){
            if(d.id == depart_id){
                for each(var i:int in d.members){
                    if(getActivePersonById(i)!=null){
                        membersByDepart.addItem(getActivePersonById(i));
                    }

                }
                if(person_id<0){
                    membersDownList.selectedIndex=0;
                    projectByDepart.removeAll();
                    projectByDepart.addItem({id:-1,name:"所有任务"});
                    for each(var item:Object in ToolUtil.allProjectList){
                        if(item.department==depart_id){
                            projectByDepart.addItem(item);
                        }
                    }
                    projectDownList.selectedIndex=0;
                }else{
                    for each(var person:Object in membersByDepart){
                        if(person.id == person_id){
                            membersDownList.selectedItem = person;
                            initProjectByMember(membersDownList,projectDownList);
                        }
                    }
                }
                break;
            }

        }
    }

    private static function initProjectByMember(membersDownList:DropDownList,projectDownList:DropDownList):void{
        projectByDepart.removeAll();
        projectByDepart.addItem({id:-1,name:membersDownList.selectedItem.name+"参与的项目"});
        for each(var item:Object in ToolUtil.allProjectList){
            if(item.manager==membersDownList.selectedItem.id){
                projectByDepart.addItem(item);
            }
        }
        projectDownList.selectedIndex=0;
    }

    public static function changeProjectByMember(membersDownList:DropDownList,projectDownList:DropDownList):void{

        if(membersDownList.selectedItem!=null){
            initProjectByMember(membersDownList,projectDownList);
            FlexGlobals.topLevelApplication.dispatchEvent(new QueryScheduleEvent(QueryScheduleEvent.QuerySchedule_Str,true));
        }
    }

    public static function changeProject(projectDownList:DropDownList):void{

        if(projectDownList.selectedItem!=null){
            FlexGlobals.topLevelApplication.dispatchEvent(new QueryScheduleEvent(QueryScheduleEvent.QuerySchedule_Str,true));
        }
    }



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
            ArrayTools.createArray(departMentList,result.result.departlist);


            for each(var item2:Object in departMentList) {
                for each(var group:ChatChannel in ToolUtil.groupList){
                    if(group.id==item2.id){
                        group.setMembers(item2.members);
                    }
                }
            }

//            myDepartmentList.removeAll();
            var l:ArrayCollection = ObjectUtil.copy(ToolUtil.departMentList) as ArrayCollection;
            var mydepartlist:ArrayCollection = new ArrayCollection();
            var f:Boolean = false;
            for each(var item2:Object in l) {
                if(item2.flag=='free'){
                    continue;
                }
                f = false;
                for each(var p:int in item2.members) {
                    if (p == ToolUtil.sessionUser.pid) {
                        f = true;
                    }
                }
                if (f) {
                    mydepartlist.addItem(item2);
                }
            }
            var l2:ArrayCollection=getMemberlistByMy(mydepartlist,l);
            if(l2.length>0){
                mydepartlist.addAll(l2);
            }
            // 将有包含关系的部门，排序，形成缩进效果
            if(mydepartlist.length>0){
                var departmentlist:ArrayCollection = initMyDepart(mydepartlist);
            }else{
                var departmentlist:ArrayCollection = new ArrayCollection();
            }
            departmentlist.addItemAt({id:0,name:"只有我和责任人可见",label:"只有我和责任人可见"},0);
            myDepartmentList=departmentlist;
        }
    }

    public static function initMyDepart(mydepartlist:ArrayCollection):ArrayCollection{
        // 将有包含关系的部门，排序，形成缩进效果

        var departmentlist:ArrayCollection=new ArrayCollection();
        var depart:Object = new Object();
        var rootDepart:Object = null;
        for each(var item:Object in mydepartlist) {
            depart['d' + item.id] = item;
            if (!item.father) {
                rootDepart = item;

            }
            item.children = new ArrayCollection();
            var hasFather:Boolean=false;
            for each(var o:Object in mydepartlist){
                if(item.father == o.id){
                    hasFather = true;
                    break;
                }
            }
            if(!hasFather){
                item.level = 0;
                item.space ="";
                item.label = item.space+item.name;
                findDepartByFather(item,mydepartlist);
            }
        }

        for each(item in mydepartlist) {
            if (item.father && depart.hasOwnProperty('d' + item.father)) {
//                item.level = depart['d' + item.father].level + 1;
                if (!depart['d' + item.father].hasOwnProperty('dep_children')) {
                    depart['d' + item.father].dep_children = new ArrayCollection();
                }
                depart['d' + item.father].dep_children.addItem(item);
            }
            for each(var p:int in item.members){
                if(getActivePersonById(p)!=null){
                    item.children.addItem(getActivePersonById(p));
                }
            }

        }
        for each(item in mydepartlist) {
            if (item.flag == 'free') {
                depart['d' + item.father].dep_children.removeItemAt(depart['d' + item.father].dep_children.getItemIndex(item));
                depart['d' + item.father].dep_children.addItem(item);
            }
        }

        if(rootDepart!=null){
            departmentlist.addItem(rootDepart);
            showDepartChildren_handler(rootDepart,departmentlist);
        }
        return departmentlist;
    }

    public static function findDepartByFather(father:Object,mydepartlist:ArrayCollection):void{
        for each(var item:Object in mydepartlist){
            if(item.father==father.id){
                item.level = father.level+1;
                item.space = father.space+" ";
                item.label = item.space+item.name;
                findDepartByFather(item,mydepartlist);
            }
        }
    }

    private static function showDepartChildren_handler(depart:Object,departmentlist:ArrayCollection):void {
        var index:int = 0;
        for (var i:int = 0; i < departmentlist.length; i++) {
            if (depart.id == departmentlist.getItemAt(i).id) {
                index = i;
                break;
            }
        }
        if (depart.hasOwnProperty('dep_children')){
            if (index == departmentlist.length - 1 && departmentlist.length != 1) {
                departmentlist.addAll(depart.dep_children);
            } else {
                departmentlist.addAllAt(depart.dep_children, index + 1);
            }
            for each(var d:Object in depart.dep_children){
                showDepartChildren_handler(d,departmentlist);
            }
        }



    }

    private static function getMemberlistByMy (mydepartlist:ArrayCollection,l0:ArrayCollection):ArrayCollection{
        var l:ArrayCollection=new ArrayCollection();
        var f:Boolean=false;
        for each(var d:Object in l0){
            if(d.flag=='free'){
                continue;
            }
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
            var l2:ArrayCollection=getMemberlistByMy(l,l0);
            l.addAll(l2);
        }
        return l;
    }


    [Bindable]
    public static var groupList:ArrayCollection=new ArrayCollection();

    [Bindable]
    public static var projectList:ArrayCollection=new ArrayCollection();

    public static function projectListRefresh(fun:Function=null):void{

        if(fun==null){
            HttpServiceUtil.getCHTTPServiceAndResult("/ca/get_my_project",resultProjectList,"POST").send();
        }else{
            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/get_my_project",resultProjectList,"POST");
            http.resultFunArr.addItem(fun);
            http.send();

        }

    }
    public static function resultProjectList(result:Object,e:ResultEvent):void{
        if(result.success==true){
            ArrayTools.createArray(projectList,result.result);
            if(membersByDepart.length==0){
                membersByDepart.addItem({id:sessionUser.id,name:"我自己"});
                FlexGlobals.topLevelApplication.dispatchEvent(new InitDefaultMemberProjectEvent(InitDefaultMemberProjectEvent.Default_Member_EventStr,true));
                projectByDepart.addItem({id:-1,name:"我参与的任务"});
                projectByDepart.addAll(ObjectUtil.clone(projectList) as ArrayCollection);

                FlexGlobals.topLevelApplication.dispatchEvent(new InitDefaultMemberProjectEvent(InitDefaultMemberProjectEvent.Default_Project_EventStr,true));
            }



        }
    }

    [Bindable]
    public static var allProjectList:ArrayCollection=new ArrayCollection();

    public static function allProjectListRefresh(fun:Function=null):void{

        if(fun==null){
            HttpServiceUtil.getCHTTPServiceAndResult("/ca/get_all_project",resultAllProjectList,"POST").send();
        }else{
            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/get_all_project",resultAllProjectList,"POST");
            http.resultFunArr.addItem(fun);
            http.send();

        }

    }
    public static function resultAllProjectList(result:Object,e:ResultEvent):void{
        if(result.success==true){
            ArrayTools.createArray(allProjectList,result.result);

        }
    }


    [Bindable]
    public static var memberList:ArrayCollection=new ArrayCollection();

    private static var membersmap:Object=new Object();

    private static function getPersonById(id:*):Object{
        if(membersmap.hasOwnProperty(id)){
            return membersmap[id]
        }
        return new Object();
    }

    public static function getActivePersonById(id:*):Object{
        var p:Object = getPersonById(id);
        if(p.hasOwnProperty('id') && p.is_active){
            return ObjectUtil.copy(p);
        }
        return null;
    }

    public static function getAnyPersonById(id:*):Object{
        var p:Object = getPersonById(id);
        if(p.hasOwnProperty('id') && p.is_active){
            return ObjectUtil.copy(p);
        }else{
            var p2:Object = ObjectUtil.copy(p);
            p2.name=p.name+"[已离职]";
            return p2;
        }
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
            ArrayTools.createArray(memberList,result.result.members);
            membersmap=new Object();
            for each(var p:Object in memberList){
                membersmap[p.id] = p;
            }
            resultAllDepartMent(result, e);

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
            ArrayTools.createArray(contactsList,result.result);


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
    public static var outScheduleMap:Object = {"out_schedule_list":[]};



    public static function getSchedule(id:String):Schedule{
        if(ToolUtil.scheduleMap.hasOwnProperty("schedulemap")&&ToolUtil.scheduleMap.schedulemap.hasOwnProperty(id)){
            return ToolUtil.scheduleMap.schedulemap[id];
        }
		if(ToolUtil.outScheduleMap.hasOwnProperty("schedulemap")&&ToolUtil.outScheduleMap.schedulemap.hasOwnProperty(id)){
			return ToolUtil.outScheduleMap.schedulemap[id];
		}
        return null;
    }



    private static var queryScheduleTargetObj:Object={pid:null,depart_id:null,project_id:null};
    public static function getScheduleByDate(start:String,end:String,pid:int=-1,departid=-1,projectid=-1):void{
        var obj:Object = new Object();
        obj["startdate"] = start;
        obj["enddate"] = end;
        obj["pid"] = pid;
        obj["depart_id"] = departid;
        obj["project_id"] = projectid;

        if(queryScheduleTargetObj.pid!=pid||queryScheduleTargetObj.depart_id!=departid||queryScheduleTargetObj.project_id!=projectid){
            queryScheduleTargetObj.pid = pid;
            queryScheduleTargetObj.depart_id = departid;
            queryScheduleTargetObj.project_id = projectid;
            obj['outoftime'] = true;
        }
        HttpServiceUtil.getCHTTPServiceAndResult("/ca/getScheduleByDate",queryResult,"POST").send(obj);
//        if(fun==null){
//
//        }else{
//            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/getScheduleByDate",queryResult,"POST");
//            http.resultFunArr.addItem(fun);
//            http.send(obj);
//
//        }

    }

    public static function queryResult(result:Object,e:ResultEvent):void{
        if(result.success){
            scheduleMap = new Object();
//            scheduleMap['scheduleall']=new Array();

            scheduleMap['schedulemap']=new Object();
            scheduleMap['schedulelist']=new Object();
            var schedule:Schedule;
            for each(var obj:Object in result.result.schedulelist){
                //schedulelist schedulemap
                schedule = new Schedule(obj);
//                scheduleMap['scheduleall'].push(schedule.id);
                scheduleMap['schedulemap'][schedule.id] = schedule;
                if(schedule.repeat_type != 'none'){
                    if(!scheduleMap['schedulelist'].hasOwnProperty(schedule.date)){
                        scheduleMap['schedulelist'][schedule.date]=new Array();
                    }
                    scheduleMap['schedulelist'][schedule.date].push(schedule.id);
                }else{
                    if(!scheduleMap['schedulelist'].hasOwnProperty(schedule.startdate)){
                        scheduleMap['schedulelist'][schedule.startdate]=new Array();
                    }
                    scheduleMap['schedulelist'][schedule.startdate].push(schedule.id);
                }
                ScheduleUtil.updateSchedulePanel(schedule.id);
            }
            if(result.result.hasOwnProperty("out_schedulelist")){
                outScheduleMap= new Object();
                outScheduleMap['out_schedule_list']=new Array();
                outScheduleMap['schedulemap']=new Object();
                for each(var obj:Object in result.result.out_schedulelist){
                    schedule = new Schedule(obj);
                    outScheduleMap['schedulemap'][schedule.id] = schedule;
                    if(!scheduleMap['schedulemap'].hasOwnProperty(schedule.id)){
                        scheduleMap['schedulemap'][schedule.id] = schedule;
                        ScheduleUtil.updateSchedulePanel(schedule.id);
                    }
                    outScheduleMap['out_schedule_list'].push(schedule.id);
                }
            }

            FlexGlobals.topLevelApplication.dispatchEvent(new ChangeScheduleEvent(true));
        }
    }

    public static function updateSchedul(id:String, schedule:Schedule):void{
        if(schedule){
            scheduleMap['schedulemap'][id] = schedule;
//            scheduleMap['scheduleall']

            ScheduleUtil.updateSchedulePanel(schedule.id);
        }else{
//            if(scheduleMap['scheduleall'].indexOf(id)>=0){
//                scheduleMap['scheduleall'].splice(scheduleMap['scheduleall'].indexOf(id),1);
//            }
            var s:Schedule = scheduleMap['schedulemap'][id];
            if(s.repeat_type == 'none'){
                if(scheduleMap['schedulelist'][s.startdate].indexOf(id)>=0){
                    scheduleMap['schedulelist'][s.startdate].splice(scheduleMap['schedulelist'][s.startdate].indexOf(id),1);
                }
            }else{
                if(scheduleMap['schedulelist'][s.date].indexOf(id)>=0){
                    scheduleMap['schedulelist'][s.date].splice(scheduleMap['schedulelist'][s.date].indexOf(id),1);
                }
            }

            delete scheduleMap['schedulemap'][id];
        }
        FlexGlobals.topLevelApplication.dispatchEvent(new ChangeScheduleEvent(true));
    }



}
}