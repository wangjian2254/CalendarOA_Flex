/**
 * Created by wangjian2254 on 14-8-8.
 */
package events {
import flash.events.Event;

public class MembersEvent extends Event {
    public var data:Object;

    public static var MEMBERS:String = "Members";
    public static var REMOVE_MEMBERS:String = "Remove_Members";

    public function MembersEvent(type:String, value:Object ) {
        super(type, true);
        this.data = value;
    }

    override public function clone():Event {
        return new MembersEvent( type, data );
    }
}
}
