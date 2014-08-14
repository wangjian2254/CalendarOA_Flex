/**
 * Created by WangJian on 2014/8/13.
 */
package util {
import flash.events.Event;
import flash.events.TimerEvent;
import flash.utils.Timer;

import json.JParser;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.events.CollectionEvent;

import org.idream.pomelo.Pomelo;
import org.idream.pomelo.PomeloEvent;

[Event(name="pStatus", type="org.idream.pomelo.PomeloEvent")]
[Event(name="onChat", type = "org.idream.pomelo.PomeloEvent")]
[Event(name="sys", type = "org.idream.pomelo.PomeloEvent")]

public class ChatManager {
    private static var time:Timer = new Timer(1000*30,1);
    public static var type:String = "flex";
//    private static var chatmanage:ChatManager;

    public static var userStatus:Object=new Object();
    public static var unReadMessage:ArrayCollection = new ArrayCollection();

    public function ChatManager() {


    }

    static public function clearUser():void{
        for(var u:String in userStatus){
            userStatus[u]="off";
        }
    }

    static public function unReadChanged(e:CollectionEvent):void{
        var n:int=0;
        for each(var chat:Object in ChatManager.unReadMessage){
                if(chat.unread){
                    n+=1;
                }

        }
        ToolUtil.unreadMessageNum=n+"未读消息";
    }

    static public function loginChat(e:Event=null):void{
        time.addEventListener(TimerEvent.TIMER,loginChat);
        unReadMessage.addEventListener(CollectionEvent.COLLECTION_CHANGE, unReadChanged);
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
        p.oid = 'o'+ToolUtil.sessionUser.oid;
        p.flag = ToolUtil.sessionUser.chatflag;
        p.type = type;
        var route:String = "connector.entryHandler.enter";
        Pomelo.getIns().request(route, p, function (data:Object):void {
            trace("登录成功");

            Pomelo.getIns().addEventListener('pStatus', personChangedHandler);
            Pomelo.getIns().addEventListener('onChat', chatHandler);
            Pomelo.getIns().addEventListener('onLine', onlineHandler);
            Pomelo.getIns().addEventListener('sys', systemMessageHandler);
            clearUser();

            for each(var m:String in data.users){
                userStatus[m]="on";
            }
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
        trace("user changed:"+event.message.p+"_"+event.message.s);
    }


    static public function onlineHandler(event:PomeloEvent):void{
        clearUser();
        for each(var m:Object in event.message.users){
            userStatus[m.uid]="on";


            trace("online user changed:"+m.uid+"_on");
        }
    }
    static public function chatHandler(event:PomeloEvent):void{

        if(event.message.msg.f!=ToolUtil.sessionUser.pid){
            event.message.msg.unread=true;
            unReadMessage.addItem(event.message.msg);
        }else{
            if(event.message.msg.c!=type){
                unReadMessage.addItem(event.message.msg);
            }
        }

        trace("chat:"+JParser.encode(event.message.msg));
    }
    static public function systemMessageHandler(event:PomeloEvent):void{
        switch (event.message.msg.type){
            case "org_users_changed":
                ToolUtil.departMentListRefresh();
                break;
            case "join_apply":
                Alert.show(event.message.msg.msg,event.message.msg.type);
                break;
            default :
                Alert.show(event.message.msg.msg,event.message.msg.type);
                break;
        }

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
        content["o"]='o'+ToolUtil.sessionUser.oid;
        sendMessage('chat.chatHandler.send',content,callback);
//        sendMessage('connector.entryHandler.send',content,callback);
    }

    static public function sendMessage(route:String,obj:Object, callback:Function):void{
        Pomelo.getIns().request(route, obj, callback);
    }

}
}
