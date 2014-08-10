/**
 * Created by wangjian2254 on 14-8-8.
 */
package uicontrol {
import spark.components.List;

[Event(name="listItemClick",type="events.ListClickEvent")]
[Event(name="listItemZhanKai",type="events.ListClickEvent")]
public class AddressList extends List{
    public function AddressList() {
        super ();
    }
}
}
