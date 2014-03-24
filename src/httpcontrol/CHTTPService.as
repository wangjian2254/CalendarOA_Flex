package httpcontrol
{
	import control.Loading;
	
	import json.JParser;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	import util.LoadingUtil;
	
	public class CHTTPService extends HTTPService
	{
		public function CHTTPService(rootURL:String=null, destination:String=null)
		{
			super(rootURL, destination);
			this.addEventListener(ResultEvent.RESULT,resultEvent);
			this.addEventListener(FaultEvent.FAULT,faultEvent);
		}
		
		private var _loading:Loading;

		public function get loading():Loading
		{
			if(LoadingUtil.loading==null){
				throw "没有遮罩层……";
			}
			return LoadingUtil.loading;
//			return _loading;
		}
		
		override public function send(parameters:Object = null):AsyncToken
		{
			try{
				this.loading.showIn();
				if(this.url.indexOf("?")!=-1){
					this.url+="&requesttimestr="+(new Date()).toString();
				}else{
					this.url+="?requesttimestr="+(new Date()).toString();
				}
				return super.send(parameters);
			}catch(e:Error){
				this.loading.showOut();
				throw e;
			}
			
			return null;
			
		}
		
		public function faultEvent(e:FaultEvent):void{
			this.loading.showOut();
		}
		
		public function resultEvent(e:ResultEvent):void{
			if(this.resultFormat=="text"){
				try{
					var result:Object=JParser.decode(e.result.toString());
					if(result.success==true){
						var  f:Function=null;
						for(var i:int=0;i<resultFunArr.length;i++){
							f=resultFunArr.getItemAt(i) as Function;
							if(f!=null){
								f(result,e);
							}
						}
						
						
					}
				}catch(error:Error){
					
					Alert.show(e.result.toString,"警告");
					Alert.show("系统错误","警告");
				}
					
				
			}
				
			this.loading.showOut();
		}
//		public var resultFun:Function;
		public var resultFunArr:ArrayCollection=new ArrayCollection();

	}
}