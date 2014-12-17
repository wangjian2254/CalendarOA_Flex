/**
 * Created by WangJian on 2014/10/29.
 */
package util {
import mx.collections.ArrayCollection;
import mx.events.CollectionEvent;

public class NotifyTools {
    public function NotifyTools() {
    }

    [Bindable]
    public static var notifylist:ArrayCollection=new ArrayCollection();

//

    public static function initNotifyTools():void{
        notifylist.addEventListener(CollectionEvent.COLLECTION_CHANGE, notify_num_change);
    }

    [Bindable]
    public static var notifyunreadnum:Number=0;

    public static function notify_num_change(e:CollectionEvent):void{
        var num:Number=0;
        for each(var item:Object in notifylist){
            if(item.status==false){
                num+=1;
            }
        }
        notifyunreadnum = num;
    }
}
}
