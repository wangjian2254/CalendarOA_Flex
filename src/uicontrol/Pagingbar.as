package uicontrol
{
	import flash.display.DisplayObject;
	import flash.events.MouseEvent;
	
	import spark.components.Button;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;

	public class Pagingbar extends SkinnableComponent  
	{
		[SkinPart(required="true")]  
		public var fstButton:Button;
		[SkinPart(required="true")]  
		public var preButton:Button;
		[SkinPart(required="true")]  
		public var netButton:Button;
		[SkinPart(required="true")]  
		public var lstButton:Button;
		[SkinPart(required="true")]  
		public var freButton:Button;
		[SkinPart(required="true")]  
		public var pageNumb:TextInput;
		public function Pagingbar()
		{
			
		}
		import httpcontrol.CHTTPService;
		import httpcontrol.HttpServiceUtil;
		
		import mx.collections.ArrayCollection;
		import mx.rpc.events.ResultEvent;
		[Bindable]
		public var url:String="";
		public var source:ArrayCollection;
		public var limitProperty:String="limit";
		public var startProperty:String="start";
		public var totalProperty:String="count";
		public var rootProperty:String="";
		private var _currentPage:Number=1;
		private var _limit:Number=10;
		private var _pageCount:Number=0;
		[Bindable]
		public function get limit():Number
		{
			return _limit;
		}
		public function set limit(value:Number):void
		{
			_limit = value;
		}

		[Bindable]
		public function get pageCount():Number
		{
			return _pageCount;
		}
		public function set pageCount(value:Number):void
		{
			_pageCount = value;
		}

		[Bindable]
		public function get currentPage():Number
		{
			return _currentPage;
		}
		public function set currentPage(value:Number):void
		{
			_currentPage = value;
		}

		public function handlerData(e:ResultEvent):Object{
			return e.result;
		}
		private function success(e:ResultEvent):void{
			var data:Object=handlerData(e);
			if(rootProperty!=""){
				source=new ArrayCollection(data[rootProperty] as Array);
				pageCount=Math.ceil(Number(data[totalProperty])/limit);
			}
		}
		private function loadData(o:Object):void{
			var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult(url,success,"POST");
			http.send(o);
			
		}
		private function beforeLoad(o:Object):Object{
			return o;
		}
		public function getPara(flag:String):void{
			var o:Object={};
			switch(flag){
				case "first":
					o[startProperty]=(currentPage=1)*limit;
					o[limitProperty]=limit;
					fstButton.enabled=false;
					preButton.enabled=false;
					netButton.enabled=true;
					lstButton.enabled=true;
					loadData(o);
					break;
				case "previous":
					o[startProperty]=(currentPage = (currentPage-=1)<=0 ? 1:currentPage) *limit;
					o[limitProperty]=limit;
					if(currentPage==1){
						fstButton.enabled=false;
						preButton.enabled=false;
						netButton.enabled=true;
						lstButton.enabled=true;
					}
					loadData(o);
					break;
				case "next":
					o[startProperty]=(currentPage = (currentPage+=1)>pageCount ? pageCount:currentPage) *limit;
					o[limitProperty]=limit;
					if(currentPage==pageCount){
						fstButton.enabled=true;
						preButton.enabled=true;
						netButton.enabled=false;
						lstButton.enabled=false;
					}
					loadData(o);
					break;
				case "last":
					o[startProperty]=(currentPage=pageCount)*limit;
					o[limitProperty]=limit;
					fstButton.enabled=true;
					preButton.enabled=true;
					netButton.enabled=false;
					lstButton.enabled=false;
					loadData(o);
					break;
				case "goto":
					o[startProperty]=(currentPage= currentPage==0 ? 1: (currentPage >pageCount) ? pageCount : currentPage)*limit;
					o[limitProperty]=limit;
					currentPage=currentPage;
					if(currentPage==1){
						fstButton.enabled=false;
						preButton.enabled=false;
						netButton.enabled=true;
						lstButton.enabled=true;
					}
					if(currentPage==pageCount){
						fstButton.enabled=true;
						preButton.enabled=true;
						netButton.enabled=false;
						lstButton.enabled=false;
					}
					loadData(o);
					break;
				case "fresh":
					o[startProperty]=currentPage*limit;
					o[limitProperty]=limit;
					loadData(o);
					break;
			}
		}
		override protected function partAdded(partName:String, instance:Object):void  
		{  
			super.partAdded(partName, instance);  
		
//			if (instance == fstButton)  
//			{  
//				fstButton.addEventListener(MouseEvent.CLICK, getPara);  
//			}  
//			if (instance == fstButton)  
//			{  
//				preButton.addEventListener(MouseEvent.CLICK, getPara);  
//			}  
//			if (instance == fstButton)  
//			{  
//				netButton.addEventListener(MouseEvent.CLICK, getPara);  
//			}
//			if (instance == fstButton)  
//			{  
//				lstButton.addEventListener(MouseEvent.CLICK, getPara);  
//			}
//			if (instance == fstButton)  
//			{  
//				fstButton.addEventListener(MouseEvent.CLICK, getPara);  
//			}
		} 
	}
}