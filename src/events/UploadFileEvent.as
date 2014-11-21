/**
 * Created by wangjian2254 on 14-8-8.
 */
package events {
import flash.events.Event;

import uicontrol.CProgressBar;

public class UploadFileEvent extends Event {
    public var data:Object;

    public static var UPLOAD:String = "upload_file";
    public static var CLOSED:String = "closed_file_upload";
	
	public var bar:CProgressBar=null;

    public function UploadFileEvent(type:String, value:Object, b:CProgressBar ) {
        super(type, true);
        this.data = value;
		this.bar = b;
    }

    override public function clone():Event {
        return new UploadFileEvent( type, data, bar );
    }
}
}
