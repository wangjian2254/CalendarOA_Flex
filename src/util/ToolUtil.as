package util
{
	import control.Loading;
	import control.LoginUser;
	
	import events.ChangeScheduleEvent;
	import events.ChangeUserEvent;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
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
	
	import spark.components.Application;

	public class ToolUtil
	{
		public function ToolUtil()
		{
		}
		
		[Bindable]
		public static var resultMsg:String="";
		
		public static var  currentUserFun:Function=null;
		public static var loginUser:LoginUser= new LoginUser();
		public static function init():void{
//			hyRefresh();
//			kjkmRefresh();
//			bbRefresh();
//			userRefresh();
			sessionUserRefresh();
			groupRefresh();
			contactsRefresh();
//			taskRefresh();
			taskUnRefresh();
			
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
				if(sessionUser["id"]!=result.result["id"]){
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
		public static var userList:ArrayCollection=new ArrayCollection();
		
		public static function userRefresh(fun:Function=null):void{
//			RemoteUtil.getOperationAndResult("getAllUser",resultAllUser).send();
			if(fun==null){
				HttpServiceUtil.getCHTTPServiceAndResult("_100_BaseInfosAction_findall.action",resultAllUser,"POST").send()
//				RemoteUtil.getOperationAndResult("",resultAllUser,false).send();
			}else{
				var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("_100_BaseInfosAction_findall.action",resultAllUser,"POST");
				http.resultFunArr.addItem(fun);
				http.send();
				
			}
		}
		public static function resultAllUser(result:Object,e:ResultEvent):void{
			if(result.message.success==true){
				userList.removeAll();
				userList.addAll(new ArrayCollection(result.userslist as Array));
			}
		}
		[Bindable]
		public static var deptList:ArrayCollection=new ArrayCollection();
		
		public static function deptRefresh(fun:Function=null):void{
			
			if(fun==null){
				HttpServiceUtil.getCHTTPServiceAndResult("_100_BaseInfosAction_finddeptall.action",resultAllDept,"POST").send();
//				RemoteUtil.getOperationAndResult("getAllDept",resultAllDept,false).send();
			}else{
				var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("_100_BaseInfosAction_finddeptall.action",resultAllDept,"POST");
				http.resultFunArr.addItem(fun);
				http.send();
				
			}
			
		}
		public static function resultAllDept(result:Object,e:ResultEvent):void{
			if(result.message.success==true){
				deptList.removeAll();
				deptList.addAll(new ArrayCollection(result.deptvolist as Array));
			}
		}
		[Bindable]
		public static var areaList:ArrayCollection=new ArrayCollection();
		
		public static function areaRefresh(fun:Function=null):void{
			
			if(fun==null){
				HttpServiceUtil.getCHTTPServiceAndResult("_100_BaseInfosAction_findareaall.action",resultAllArea,"POST").send();
//				RemoteUtil.getOperationAndResult("getAllDept",resultAllDept,false).send();
			}else{
				var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("_100_BaseInfosAction_findareaall.action",resultAllArea,"POST");
				http.resultFunArr.addItem(fun);
				http.send();
				
			}
			
		}
		public static function resultAllArea(result:Object,e:ResultEvent):void{
			if(result.message.success==true){
				areaList.removeAll();
				areaList.addAll(new ArrayCollection(result.areapointvolist as Array));
			}
		}
		
		[Bindable]
		public static var groupList:ArrayCollection=new ArrayCollection();
		[Bindable]
		public static var groupColor:Object=new Object();
		
		public static function groupRefresh(fun:Function=null):void{
			
			if(fun==null){
				HttpServiceUtil.getCHTTPServiceAndResult("/ca/getMyGroup",resultAllGroup,"POST").send();
			}else{
				var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/getMyGroup",resultAllGroup,"POST");
				http.resultFunArr.addItem(fun);
				http.send();
				
			}
			
		}
		public static function resultAllGroup(result:Object,e:ResultEvent):void{
			if(result.success==true){
				groupList.removeAll();
				groupList.addAll(new ArrayCollection(result.result as Array));
				for each(var item:Object in groupList){
					groupColor[""+item.id]=item.color;
				}
			}
		}
		[Bindable]
		public static var contactsList:ArrayCollection=new ArrayCollection();
		
		public static function contactsRefresh(fun:*=null,e:*=null):void{
			
			if(!(fun is Function)){
				HttpServiceUtil.getCHTTPServiceAndResult("/ca/getContacts",resultAllContacts,"POST").send();
			}else{
				var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/getContacts",resultAllContacts,"POST");
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
		[Bindable]
		public static var taskUnList:ArrayCollection=new ArrayCollection();
		
		public static function taskUnRefresh(fun:*=null,e:*=null):void{
			var obj:Object=new Object();
			obj["status"]=false;
			if(!(fun is Function)){
				HttpServiceUtil.getCHTTPServiceAndResult("/ca/getTaskByStatus",resultAllUnTask,"POST").send(obj);
			}else{
				var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/getTaskByStatus",resultAllUnTask,"POST");
				http.resultFunArr.addItem(fun);
				http.send(obj);
				
			}
			
		}
		public static function resultAllUnTask(result:Object,e:ResultEvent):void{
			if(result.success==true){
				taskUnList.removeAll();
				if(result.result){
					taskUnList.addAll(new ArrayCollection(result.result as Array));
				}
			}
		}
		[Bindable]
		public static var taskList:ArrayCollection=new ArrayCollection();
		
		public static function getTask(id:String):Object{
			for each(var item:Object in taskUnList){
				if(item.id==id){
					return item;
				}
			}
			for each(item in taskList){
				if(item.id==id){
					return item;
				}
			}
			return null;
		}
		
		public static function taskRefresh(fun:*=null,e:*=null):void{
			var obj:Object=new Object();
			obj["status"]=true;
			if(!(fun is Function)){
				HttpServiceUtil.getCHTTPServiceAndResult("/ca/getTaskByStatus",resultAllTask,"POST").send(obj);
			}else{
				var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/getTaskByStatus",resultAllTask,"POST");
				http.resultFunArr.addItem(fun);
				http.send(obj);
				
			}
			
		}
		public static function resultAllTask(result:Object,e:ResultEvent):void{
			if(result.success==true){
				taskList.removeAll();
				if(result.result){
					taskList.addAll(new ArrayCollection(result.result as Array));
				}
			}
		}
		
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