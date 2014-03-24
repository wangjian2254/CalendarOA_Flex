package util
{
	import control.Loading;
	
	import httpcontrol.RemoteUtil;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.AbstractOperation;
	import mx.rpc.events.ResultEvent;

	public class InfoUtil
	{
		public function InfoUtil()
		{
		}
		
		public static function init():void{
			userRefresh();
			deptRefresh();
			
		}
		
		
		[Bindable]
		public static var userList:ArrayCollection=new ArrayCollection();
		
		public static function userRefresh(fun:Function=null):void{
//			RemoteUtil.getOperationAndResult("getAllUser",resultAllUser).send();
			if(fun==null){
				RemoteUtil.getOperationAndResult("getAllUser",resultAllUser,false).send();
			}else{
				var operation:AbstractOperation=RemoteUtil.getOperation("getAllUser")
				operation.addEventListener(ResultEvent.RESULT, resultAllUser);
				operation.addEventListener(ResultEvent.RESULT, fun);
				operation.send();
				
			}
		}
		public static function resultAllUser(e:ResultEvent):void{
			var result:Object=e.result;
			if(result.success==true){
				userList.removeAll();
				userList.addAll(new ArrayCollection(result.result as Array));
			}
		}
		[Bindable]
		public static var deptList:ArrayCollection=new ArrayCollection();
		
		public static function deptRefresh(fun:Function=null):void{
			
			if(fun==null){
				RemoteUtil.getOperationAndResult("getAllDept",resultAllDept,false).send();
			}else{
				var operation:AbstractOperation=RemoteUtil.getOperation("getAllDept")
				operation.addEventListener(ResultEvent.RESULT, resultAllDept);
				operation.addEventListener(ResultEvent.RESULT, fun);
				operation.send();
				
			}
			
		}
		public static function resultAllDept(e:ResultEvent):void{
			var result:Object=e.result;
			if(result.success==true){
				deptList.removeAll();
				deptList.addAll(new ArrayCollection(result.result as Array));
			}
		}
		

		
	}
}