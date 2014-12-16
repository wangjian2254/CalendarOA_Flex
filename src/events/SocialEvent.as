/**
 * Created by wangjian2254 on 14-8-8.
 */
package events {
import flash.events.Event;

public class SocialEvent extends Event {
    public var url:String;

    public static var SOCIAL:String = "SOCIAL_URL";

    public function SocialEvent(type:String, uri:String ) {
        this.url = uri;
        super(type, true);
    }

    override public function clone():Event {
        var e:SocialEvent = new SocialEvent( type , url);
        return e;
    }
}
}
