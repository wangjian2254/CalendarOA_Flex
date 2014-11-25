// ActionScript file
import events.UploadFileEvent;

import flash.events.Event;

public var imagedata:Bitmap = null;
public var imagesrc:String = null;

[Bindable]
public var editfilename:Boolean=true;

public var filestatus:int=1;

[Bindable]
public var imgname:String = "";





private function save():void{
	dispatchEvent(new UploadFileEvent(UploadFileEvent.UPLOAD,{filename:filename.text,status:statusRadio.selectedValue},bar));
}
private function closeimg():void{
	dispatchEvent(new UploadFileEvent(UploadFileEvent.CLOSED,null,null));
	closePannel();
}