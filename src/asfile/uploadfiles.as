import events.UploadFileEvent;

import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.Loader;
import flash.events.DataEvent;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.events.ProgressEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.utils.ByteArray;

import httpcontrol.CHTTPService;
import httpcontrol.HttpServiceUtil;

import json.JParser;

import mx.controls.Alert;

import spark.components.Image;

import uicontrol.CProgressBar;

import util.ToolUtil;

private var upload_file:FileReference;
private var upload_byteArray:ByteArray;
//private var upload_bitmapData:BitmapData;
private var upload_loader:Loader = new Loader();


private var bar:CProgressBar;

private function uploadFile(filetype:String):void{
	
	upload_file = new FileReference();
	upload_file.addEventListener(Event.SELECT, fileReferenceSelectHandler);
	upload_file.addEventListener(DataEvent.UPLOAD_COMPLETE_DATA, uploadImageResult);
	
	upload_file.browse();
	
}
//
//private function toUpload():void {
//	if (upload_bitmapData == null) {
//		Alert.show("请您先选择要上传的图片");
//	}
//	else {
//		Alert.show("上传 " + upload_file.name + " (共 " + Math.round(upload_file.size) + " 字节)?", "确认上传", Alert.YES | Alert.NO, null, proceedWithUpload);
//	}
//}

//监听文件上传状态
private function onProgress(e:ProgressEvent):void {
	//				lbProgress.text=" 已上传 " + e.bytesLoaded + " 字节，共 " + e.bytesTotal + " 字节";
	var proc:uint = e.bytesLoaded / e.bytesTotal * 100;
	bar.setProgress(proc, 100);
	bar.label = "当前进度: " + " " + proc + "%";

}

private function uploadError(event:IOErrorEvent):void{
	bar.issuccess=false;
	bar.visible = false;
	Alert.show("上传失败，请稍后重新上传。","提示");
	
}

//上传图片到服务器
private function proceedWithUpload(event:UploadFileEvent):void {

	// todo:修改成 从服务器端获取 两个 url，向bcs 提交
//	var param:Object = new Object();
//	param.status = event.data.status;
//	param.filename = event.data.filename;
//	param.ownertype = event.data.ownertype;
//	param.ownerpk = event.data.ownerpk;
//	param.size = upload_file.size;
//	param.name = upload_file.name;
//	HttpServiceUtil.getCHTTPServiceAndResult("/ca/upload_files", function (result:Object, event:ResultEvent):void {
//		ToolUtil.contactsRefresh();
//	}, "POST").send(param);
	//进度监听
	upload_file.addEventListener(ProgressEvent.PROGRESS, onProgress);
	upload_file.addEventListener(IOErrorEvent.IO_ERROR,uploadError );
	var request:URLRequest = new URLRequest(CHTTPService.baseUrl+"/ca/upload_files");
	request.method = URLRequestMethod.POST;
	request.contentType = "multipart/form-data";
	request.data = new URLVariables();
	request.data.status = event.data.status;
	request.data.filename = event.data.filename;
	request.data.pid=ToolUtil.sessionUser.pid;
	request.data.oid = ToolUtil.sessionUser.oid;
	request.data.chatflag = ToolUtil.sessionUser.chatflag;
	request.data.ownertype = event.data.ownertype;
	request.data.ownerpk = event.data.ownerpk;

	bar = event.bar;
	bar.visible = true;
	
	
	try {
		upload_file.upload(request, 'file');
		bar.issuccess=true;
	}
	catch (error:Error) {
		Alert.show("上传失败");
		bar.visible = false;
	}
	
	
}



private function uploadImageResult(e:DataEvent):void {
	try {
		var result:Object = JParser.decode(e.data);
		if (result.success == true) {
			bar.issuccess = true;
			if(ToolUtil.filetypemap[result.result["filetype"]]){
				ToolUtil.imagesList.addItem(result.result);
			}else{
				ToolUtil.filesList.addItem(result.result);
			}
			uploadResult(result);
			Alert.show("上传成功","提示",0x4,this);
		}else{
			bar.issuccess=false;
			Alert.show("上传失败","提示",0x4,this);
		}
		bar.visible = false;
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
//		upload_bitmapData = bitmap.bitmapData;
		showPic(bitmap, upload_file.name);
	}catch(err:Error){
//		showPic("");
	}
	
//	img.source = bitmap;
}

//选择文件动作监听
private function fileReferenceSelectHandler(e:Event):void {
//	upload_file.removeEventListener(ProgressEvent.PROGRESS, onProgress);
	upload_file.addEventListener(Event.COMPLETE,fileReferenceCompleteHandler);
	upload_file.load();
}

