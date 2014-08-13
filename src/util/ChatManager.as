/**
 * Created by WangJian on 2014/8/13.
 */
package util {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import mx.collections.ArrayCollection;

import org.idream.pomelo.Pomelo;
import org.idream.pomelo.PomeloEvent;

[Event(name="pStatus", type="org.idream.pomelo.PomeloEvent")]
[Event(name="onChat", type = "org.idream.pomelo.PomeloEvent")]
[Event(name="sys", type = "org.idream.pomelo.PomeloEvent")]

public class ChatManager {
    private static var time:Timer = new Timer(1000*30,1);
    public static var type:String = "flex";

    public static var userStatus:Object=new Object();
    public static var unReadMessage:ArrayCollection = new ArrayCollection();

    public function ChatManager() {
        time.addEventListener(TimerEvent.TIMER,loginChat);

    }

    static public function loginChat(e:Event=null):void{
        for(var u:String in userStatus){
            userStatus[u]="off";
        }
        unReadMessage.removeAll();
        Pomelo.getIns().disconnect();
        if(ToolUtil.sessionUser){

            Pomelo.getIns().init(ToolUtil.sessionUser.chathost,ToolUtil.sessionUser.chatport,null,loginResult,1000*30);
        }else{
            time.start();
        }

    }

    static public function loginResult(response:Object):void{
        if (response.code == 200) {
            time.stop();
            init();
        }else{
            time.start();
        }
    }

    static public function init():void{

        Pomelo.getIns().request("gate.gateHandler.queryEntry",  {"pid":ToolUtil.sessionUser.pid}, function (response:Object):void {
            trace("response host:", response.host, " port:", response.port);
            if (response.code == '500') {
                time.start();
                return;
            }
            Pomelo.getIns().init(response.host, response.port, null, function (response:Object):void {
                if (response.code == 200) {
                    time.stop();
                    regOrg();
                }else{
                    time.start();
                }

            });
        });
    }

    static public function regOrg():void{
        var p:Object = new Object();
        p.pid = ToolUtil.sessionUser.pid;
        p.flag = ToolUtil.sessionUser.chatflag;
        p.type = type;
        var route:String = "connector.entryHandler.enter";
        Pomelo.getIns().request(route, p, function (data:Object):void {

            Pomelo.getIns().addEventListener('pStatus', personChangedHandler);
            Pomelo.getIns().addEventListener('onChat', chatHandler);
            Pomelo.getIns().addEventListener('onLine', onlineHandler);
            Pomelo.getIns().addEventListener('sys', systemMessageHandler);
            listenOrg();
        });
    }

    static public function listenOrg():void{
        var route:String = "connector.entryHandler.listenOrg";
        var param:Object = new Object();
        var dids:Array=new Array();
        for each(var depart:Object in ToolUtil.departMentList){
            dids.push(depart.id);
        }
        param['dids']=dids;
        Pomelo.getIns().request(route, param);
    }


    static public function personChangedHandler(event:PomeloEvent):void{
        userStatus[event.message.p]=event.message.s;
    }


    static public function onlineHandler(event:PomeloEvent):void{
        for each(var m:Object in event.message.users){
            userStatus[m.p]=m.s;
        }
    }
    static public function chatHandler(event:PomeloEvent):void{
        unReadMessage.addItem(event.message);
    }
    static public function systemMessageHandler(event:PomeloEvent):void{

    }

    static public function sendMessageToDeparment(to:Number,content:Object,callback:Function):void{
        content["f"]=ToolUtil.sessionUser.pid;
        content['c']=type;
        content["o"]=to;
        sendMessage('chat.chatHandler.send',content,callback);
    }

    static public function sendMessageToPerson(to:Number,content:Object,callback:Function):void{
        content["f"]=ToolUtil.sessionUser.pid;
        content['c']=type;
        content["t"]=to;
        sendMessage('connector.entryHandler.send',content,callback);
    }

    static public function sendMessage(route:String,obj:Object, callback:Function):void{
        Pomelo.getIns().request(route, obj, callback);
    }

}
}
