/**
 * Created by wangjian2254 on 14-8-8.
 */
package events {
import flash.events.Event;

public class ListClickEvent extends Event {
    public var data:Object;

    public static var CHATUSER:String = "ChatUser";

    public function ListClickEvent(type:String, value:Object ) {
        super(type, true);
        this.data = value;
    }

    override public function clone():Event {
        return new ListClickEvent( type, data );
    }
}
}
