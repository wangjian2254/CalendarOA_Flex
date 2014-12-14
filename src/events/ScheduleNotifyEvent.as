/**
 * Created by wangjian2254 on 14-8-8.
 */
package events {
import flash.events.Event;

import model.Schedule;

public class ScheduleNotifyEvent extends Event {
    public var s:Schedule;

    public static var SCHEDULE_NOTIFY:String = "schedule_notify";

    public function ScheduleNotifyEvent(type:String, schedule:Schedule ) {
        super(type, true);
        this.s=schedule;
    }

    override public function clone():Event {
        var e:ScheduleNotifyEvent = new ScheduleNotifyEvent( type,s );
        return e;
    }
}
}
