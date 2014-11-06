/**
 * Created by wangjian2254 on 14-8-8.
 */
package events {
import flash.events.Event;

import model.ChatChannel;

public class PaoPaoEvent extends Event {
    public var msg:Object;
    public var channel:String;

    public static var CHAT:String = "Chat_Channel";

    public function PaoPaoEvent(type:String ) {
        super(type, true);
    }

    override public function clone():Event {
        var e:PaoPaoEvent = new PaoPaoEvent( type );
        e.msg = msg;
        e.channel = channel;
        return e;
    }
}
}
