/**
 * Created by WangJian on 2014/10/29.
 */
package util {
import httpcontrol.CHTTPService;
import httpcontrol.HttpServiceUtil;

import mx.collections.ArrayCollection;
import mx.events.CollectionEvent;
import mx.rpc.events.ResultEvent;

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

    public static function allUnreadNotifyRefresh(fun:*=null):void{
        if(fun==null||!(fun is Function)){
            HttpServiceUtil.getCHTTPServiceAndResult("/ca/get_unread_notify",resultAllUnreadNotifyRefresh,"POST").send()
        }else{
            var http:CHTTPService=HttpServiceUtil.getCHTTPServiceAndResult("/ca/get_unread_notify",resultAllUnreadNotifyRefresh,"POST");
            http.resultFunArr.addItem(fun);
            http.send();
        }
    }
    public static function resultAllUnreadNotifyRefresh(result:Object,e:ResultEvent):void{
        if(result.success==true){
            ArrayTools.createArray(notifylist,result.result.notifylist);
        }
    }

    public static function allReadNotify():void{
        if(NotifyTools.notifylist.length==0){
            return;
        }
        var obj:Object = new Object();
        obj["id"]=NotifyTools.notifylist.getItemAt(NotifyTools.notifylist.length-1)._id;
        HttpServiceUtil.getCHTTPServiceAndResult("/ca/change_all_notify_status", function(result:Object, e:ResultEvent):void{
            for each(var item:Object in NotifyTools.notifylist){
                if(item.status==false){
                    item.status=true;
                }
            }
            NotifyTools.notifylist.refresh();
        }, "POST").send(obj);
    }
}
}
