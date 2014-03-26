package httpcontrol
{
	import control.Loading;
	
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import mx.controls.Alert;
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;
	import mx.managers.PopUpManagerChildList;
	import mx.messaging.ChannelSet;
	import mx.messaging.channels.AMFChannel;
	import mx.rpc.AbstractOperation;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.remoting.Operation;
	import mx.rpc.remoting.RemoteObject;
	
	import util.LoadingUtil;
	import util.ToolUtil;

	public class HttpServiceUtil
	{
		public function HttpServiceUtil()
		{
			
		}
		
		public static function init():void{
		}
		
		
		private static var time:Timer = new Timer(5000,1);
		
		private static function createRemote():CHTTPService{
			time.addEventListener(TimerEvent.TIMER,hideResultMsg);
			var httpservice:CHTTPService=new CHTTPService();
			httpservice.addEventListener(FaultEvent.FAULT, faultEvent);
			httpservice.addEventListener(ResultEvent.RESULT,resultEvent);
			return httpservice;
		}
		
		
		public static function getCHTTPServiceAndResult(url:String,resultFn:Function,method:String="GET",resultFromate:String="text"):CHTTPService{
			return getCHTTPServiceAndResultAndFault(url,resultFn,null,method);
		}
		public static function getCHTTPServiceAndResultAndFault(url:String,resultFn:Function,faultFn:Function,method:String="GET",resultFromate:String="text"):CHTTPService{
			
			var op:CHTTPService=createRemote();
			if(resultFn!=null){
				op.resultFunArr.addItem(resultFn);
//				op.resultFun=resultFn;
			}
			if(faultFn!=null){
				op.addEventListener(FaultEvent.FAULT,faultFn);
			}
			op.url=url;
			op.method=method.toUpperCase();
			op.resultFormat=resultFromate;
			
			return op;
		}
		
		
		public static function faultEvent(e:FaultEvent):void{
			Alert.show(e.fault.toString(),"警告");
			
//			Alert.show("系统错误。","警告");
		}
		
		public static function resultEvent(e:ResultEvent):void{
//			trace(e.result.toString());
			var result:Object=e.result;
			var o:Object=JSON.parse(result as String);
			if(o.success==false&&o.status_code==400){
				if(ToolUtil.loginUser.parent==null){
					PopUpManager.addPopUp(ToolUtil.loginUser,FlexGlobals.topLevelApplication as DisplayObject,true);
				}
				//PopUpManager.removePopUp(ToolUtil.loginUser);
				return;
			}
			if(o.success==false){
				Alert.show(o.message,"警告");
			}else{
				if(o.message){
					ToolUtil.resultMsg = o.message;
					time.reset();
					time.start();
				}
			}
		}
		
		public static function hideResultMsg(e:TimerEvent):void{
			if(LoadingUtil.loading.parent==null){
				ToolUtil.resultMsg="";
			}else{
				time.reset();
				time.start();
			}
		}
		
		
	}
}