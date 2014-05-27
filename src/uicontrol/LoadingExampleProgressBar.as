package uicontrol
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.getTimer;
	
	import mx.events.RSLEvent;
	import mx.preloaders.SparkDownloadProgressBar;
	
	public class LoadingExampleProgressBar extends SparkDownloadProgressBar
	{
		private var _displayStartCount:uint = 0; 
		private var _initProgressCount:uint = 0;
		private var _showingDisplay:Boolean = false;
		private var _startTime:int;
		private var preloaderDisplay:PreloaderDisplay;
		private var perloaderLine:Line;
		private var rslBaseText:String = "正在准备下载 :";
		private var numberRslTotal:Number = 1;
		private var numberRslCurrent:Number = -1;
		
		private var logo:Loader;
		private var progressText:TextField;
		
		public function LoadingExampleProgressBar()    
		{    
			
			logo = new Loader();    
			logo.load(new URLRequest("assets/waitlogo.png"));    
			logo.x = 40;    
			logo.y = 20; 
			
//			showPercentage=false;             //显示上载百分数
//			
//			
			var style:TextFormat = new TextFormat(null,20,0xFFFFFF,null,null,null,null,null,"center");    
			
			progressText = new TextField(); 
			progressText.width = 400;
			progressText.height = 40;
			progressText.defaultTextFormat=style;
			
			
//			
//			// Configure the TextField for the final message.
//			msgText = new TextField();
//			msgText.width = 400;
//			msgText.height = 40;
//			msgText.defaultTextFormat=style;
//			
//			
//			addChild(msgText);
			super();    
		}
		

		/**
		 *  Event listener for the <code>FlexEvent.INIT_COMPLETE</code> event.
		 *  NOTE: This event can be commented out to stop preloader from completing during testing
		 */
		override protected function initCompleteHandler(event:Event):void
		{
			dispatchEvent(new Event(Event.COMPLETE)); 
		}
		
		/**
		 *  Creates the subcomponents of the display.
		 */
		override protected function createChildren():void
		{    
			if (!preloaderDisplay) {
				preloaderDisplay = new PreloaderDisplay();
				
//				var startX:Number = Math.round((stageWidth - preloaderDisplay.width) / 2);
//				var startY:Number = Math.round((stageHeight - preloaderDisplay.height) / 2);
				
				preloaderDisplay.x = 0;
				preloaderDisplay.y = 0;
				preloaderDisplay.width =stageWidth;
				preloaderDisplay.height = stageHeight;
				addChild(preloaderDisplay);
				graphics.clear();    
				graphics.beginFill(0x333333);    
				graphics.drawRect(0,0,stage.stageWidth,stage.stageHeight);    
				graphics.endFill();  
				progressText.x=(stageWidth-400)/2;
				progressText.y=(stageHeight-40)/2;
				perloaderLine = new Line();
				
				perloaderLine.x=(stageWidth)/2;
				perloaderLine.y=progressText.y+60;
				addChild(progressText);
				addChild(logo);  
				addChild(perloaderLine);  
			}
			
		}
		
		
		/**
		 * Event listener for the <code>ProgressEvent.PROGRESS event</code> event. 
		 * Download of the first SWF app
		 **/
		override protected function progressHandler(evt:ProgressEvent):void {
			if(!preloaderDisplay){
				if(numberRslCurrent==-1){
					rslBaseText = "正在下载应用 …… "+Math.round((evt.bytesLoaded/evt.bytesTotal)*100)+"%";
					setDownloadProgress(evt.bytesLoaded,evt.bytesTotal);
					//				var progressRsl:Number = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
					
					//				preloaderDisplay.setDownloadRSLProgress(Math.round( (numberRslCurrent-1)*100/numberRslTotal + progressRsl/numberRslTotal));
					
					setPreloaderLoadingText(rslBaseText);
				}else{
					show();
				}
			}
		}
		
		/**
		 * Event listener for the <code>RSLEvent.RSL_PROGRESS</code> event. 
		 **/
		override protected function rslProgressHandler(evt:RSLEvent):void {
			if (evt.rslIndex && evt.rslTotal) {
				
				numberRslTotal = evt.rslTotal;
				numberRslCurrent = evt.rslIndex;
				
				rslBaseText = "正在加载资源 : (" + evt.rslIndex + " of " + evt.rslTotal + ") ";
				setDownloadProgress(numberRslCurrent*100.0, numberRslTotal*100.0);
//				var progressRsl:Number = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
				
//				preloaderDisplay.setDownloadRSLProgress(Math.round( (numberRslCurrent-1)*100/numberRslTotal + progressRsl/numberRslTotal));
				
				setPreloaderLoadingText(rslBaseText);
			}
		}
		
		/** 
		 *  indicate download progress.
		 */
		override protected function setDownloadProgress(completed:Number, total:Number):void {
			if (preloaderDisplay) {
				//useless class in my case. I manage the display changes directly in the Progress handlers         
//				preloaderDisplay.num=(completed/total);
				if(completed>total){
					completed=total;
				}
				
				perloaderLine.top_line.width=(completed/total)*404;
			}
		}
		
		/** 
		 *  Updates the inner portion of the download progress bar to
		 *  indicate initialization progress.
		 */
		override protected function setInitProgress(completed:Number, total:Number):void {
			if (preloaderDisplay) {
				//set the initialization progress : red square fades out
//				preloaderDisplay.setInitAppProgress(Math.round((completed/total)*100));
				if(completed>total){
					completed=total;
				}
				setDownloadProgress(completed, total);
				
				if (completed > total) {
					setPreloaderLoadingText("加载完成！");
				} else {
					setPreloaderLoadingText("正在下载…… " +int(completed/total*100)+"%");
				}
			}
		} 
		
		
		/**
		 *  Event listener for the <code>FlexEvent.INIT_PROGRESS</code> event. 
		 *  This implementation updates the progress bar
		 *  each time the event is dispatched. 
		 */
		override protected function initProgressHandler(event:Event):void {
			var elapsedTime:int = getTimer() - _startTime;
			_initProgressCount++;
			
			if (!_showingDisplay &&    showDisplayForInit(elapsedTime, _initProgressCount)) {
				_displayStartCount = _initProgressCount;
				show();
				// If we are showing the progress for the first time here, we need to call setDownloadProgress() once to set the progress bar background.
				setInitProgress(0, 100);
			}
			
			if (_showingDisplay) {
				
				setInitProgress(_initProgressCount, initProgressTotal);
			}
		}
		
		private function show():void
		{
			// swfobject reports 0 sometimes at startup
			// if we get zero, wait and try on next attempt
			if (stageWidth == 0 && stageHeight == 0)
			{
				try
				{
					stageWidth = stage.stageWidth;
					stageHeight = stage.stageHeight
				}
				catch (e:Error)
				{
					stageWidth = loaderInfo.width;
					stageHeight = loaderInfo.height;
				}
				if (stageWidth == 0 && stageHeight == 0)
					return;
			}
			_showingDisplay = true;
			createChildren();
			rslBaseText = "正在准备下载应用……";
			setDownloadProgress(20,100);
			//				var progressRsl:Number = Math.round((evt.bytesLoaded/evt.bytesTotal)*100);
			
			//				preloaderDisplay.setDownloadRSLProgress(Math.round( (numberRslCurrent-1)*100/numberRslTotal + progressRsl/numberRslTotal));
			
			setPreloaderLoadingText(rslBaseText);
		}
		
		private function setPreloaderLoadingText(value:String):void {
			//set the text display in the flash SWC
			progressText.text = value;
		}
	}
}