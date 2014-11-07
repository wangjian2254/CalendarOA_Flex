/**
 * Created by wangjian2254 on 14-8-8.
 */
package uicontrol {
import model.ChatChannel;

import spark.components.List;

[Event(name="listItemClick",type="events.ListClickEvent")]
[Event(name="listItemZhanKai",type="events.ListClickEvent")]
public class AddressList extends List{
    private var _chatChannel:ChatChannel;
    public function AddressList() {
        super ();
    }

    public function get chatChannel():ChatChannel {
        return _chatChannel;
    }

    public function set chatChannel(value:ChatChannel):void {
        _chatChannel = value;
    }
}
}
