package util
{
	import control.Loading;
	import control.LoginUser;
	
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	
	import httpcontrol.CHTTPService;
	import httpcontrol.HttpServiceUtil;
	import httpcontrol.RemoteUtil;
	
	import mx.collections.ArrayCollection;
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
		public static var  currentUserFun:Function=null;
		public static var loginUser:LoginUser= new LoginUser();
		public static function init():void{
//			hyRefresh();
//			kjkmRefresh();
//			bbRefresh();
//			userRefresh();
			sessionUserRefresh();
			groupRefresh();
			
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
			}
		}
		
		
		

		
	}
}