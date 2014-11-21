import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;

import httpcontrol.CHTTPService;

import json.JParser;

import mx.controls.Alert;
import mx.managers.CursorManager;

import spark.components.Image;

private var upload_file:FileReference;
private var upload_byteArray:ByteArray;
private var upload_bitmapData:BitmapData;
private var upload_loader:Loader = new Loader();


private function uploadFile(filetype:String):void{
	
	upload_file = new FileReference();
	upload_file.addEventListener(Event.SELECT, fileReferenceSelectHandler);
	upload_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadImageResult);
	
	upload_file.browse();
	
}

private function toUpload():void {
	if (upload_bitmapData == null) {
		Alert.show("请您先选择要上传的图片");
	}
	else {
		Alert.show("上传 " + upload_file.name + " (共 " + Math.round(upload_file.size) + " 字节)?", "确认上传", Alert.YES | Alert.NO, null, proceedWithUpload);
	}
}

//监听文件上传状态
private function onProgress(e:ProgressEvent):void {
	//				lbProgress.text=" 已上传 " + e.bytesLoaded + " 字节，共 " + e.bytesTotal + " 字节";
	var proc:uint = e.bytesLoaded / e.bytesTotal * 100;
//	bar.setProgress(proc, 100);
//	bar.label = "当前进度: " + " " + proc + "%";
	if (e.bytesLoaded == e.bytesTotal) {
		CursorManager.removeBusyCursor();
	}
}

//上传图片到服务器
private function proceedWithUpload():void {
	
	//进度监听
	upload_file.addEventListener(ProgressEvent.PROGRESS, onProgress);
	var request:URLRequest = new URLRequest(CHTTPService.baseUrl+"/ca/upload_files");
	request.method = URLRequestMethod.POST;
	
	request.contentType = "multipart/form-data";
	request.data = new URLVariables();
	
	
	
//	bar.visible = true;
	
	
	//设置鼠标忙状态
	CursorManager.setBusyCursor();
	try {
		upload_file.upload(request, 'file', true);
		
	}
	catch (error:Error) {
		Alert.show("上传失败");
//		bar.visible = false;
	}
	
	
}

//上传完成调用
private function completeHandle(event:Event):void {
	upload_byteArray = null;
//	bar.visible = false;
//	img.source = null;
	
}

private function uploadImageResult(e:DataEvent):void {
	try {
		var result:Object = JParser.decode(e.data);
		if (result.success == true) {
			
			
			
		}
	} catch (error:Error) {
		
		var i:Number = 1;
	}
}

//载入本地图片
private function fileReferenceCompleteHandler(e:Event):void {
	upload_file.removeEventListener(Event.COMPLETE,fileReferenceCompleteHandler);
//	upload_byteArray = ;
	upload_loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loaderCompleteHandler);
	upload_loader.loadBytes(upload_file.data);
	
}

//图片载入完成显示在预览框中
private function loaderCompleteHandler(e:Event):void {
	try{
		var bitmap:Bitmap = Bitmap(upload_loader.content);
		upload_bitmapData = bitmap.bitmapData;
		showPic(upload_bitmapData);
	}catch(err:Error){
		
	}
	
//	img.source = bitmap;
}

//选择文件动作监听
private function fileReferenceSelectHandler(e:Event):void {
//	upload_file.removeEventListener(ProgressEvent.PROGRESS, onProgress);
	upload_file.addEventListener(Event.COMPLETE,fileReferenceCompleteHandler);
	upload_file.load();
}

private function bigImage(event:MouseEvent):void {
	if (event.currentTarget is Image) {
		//					Alert.show(event.currentTarget.source,"图片地址");
//		var s:BigImage = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject, BigImage, true) as BigImage;
//		s.imgurl = event.currentTarget.source;
	}
	
	
}
