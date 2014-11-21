// ActionScript file
import events.UploadFileEvent;

public var imagedata:Bitmap = null;

[Bindable]
public var imgname:String = "";


private function init():void{
	addEventListener(MouseEvent.MOUSE_DOWN,pushApp);
	var w:int=imagedata.width;
	var scalex:Number=1;
	var scaley:Number=1;
	var scale:Number=1;
	if(Capabilities.screenResolutionX < imagedata.width){
		w = Capabilities.screenResolutionX;
		
		scalex = w / imagedata.width;
	}
	
	var h:int = imagedata.height;
	if(Capabilities.screenResolutionY < imagedata.height+29){
		h = Capabilities.screenResolutionY - 29;
		scaley = h / imagedata.height;
	}
	
	if(scaley>scalex){
		scale = scalex;
	}else{
		scale = scaley;
	}
	
	imagedata.width *= scale;
	imagedata.height *= scale;
	if(imagedata.width>600){
		this.width = imagedata.width;
	}
	if(imagedata.height>270){
		this.height  = imagedata.height+29;
	}


	img.source = imagedata;
	
}



private function save():void{
	dispatchEvent(new UploadFileEvent(UploadFileEvent.UPLOAD,{filename:filename.text,status:statusRadio.selectedValue},bar));
}
private function closeimg():void{
	dispatchEvent(new UploadFileEvent(UploadFileEvent.CLOSED,null,null));
	closePannel();
}