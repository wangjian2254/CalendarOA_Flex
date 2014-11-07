/**
 * Created by WangJian on 2014/8/13.
 */
package util {
import events.QuiteEvent;

import flash.display.DisplayObject;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.utils.Timer;

import json.JParser;

import model.ChatChannel;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.events.CollectionEvent;
import mx.events.FlexEvent;
import mx.managers.PopUpManager;

import org.idream.pomelo.Pomelo;
import org.idream.pomelo.PomeloEvent;

import spark.effects.Move;

import uicontrol.NewsPannel;

[Event(name="pStatus", type="org.idream.pomelo.PomeloEvent")]
[Event(name="onChat", type = "org.idream.pomelo.PomeloEvent")]
[Event(name="sys", type = "org.idream.pomelo.PomeloEvent")]

public class ChatManager {
    private static var time:Timer = new Timer(1000*30,1);
    public static var type:String = "flex";

    [Bindable]
    public static var liyuShow:Boolean=false;
    [Bindable]
    public static var liyuunread:Number=0;
    [Bindable]
    public static var liyu:Object={id:0,name:"客服鲤鱼王",icon:'/static/image/liyu2.png',depart_id:-1,level:0,unread:0};// 全局客服


//    liyu['id'] = 0;
//    liyu['name'] = '客服鲤鱼王';
//    liyu['icon'] = '/static/image/liyu2.png';
//    liyu['depart_id'] = -1;
//    liyu['level'] = 0;

//    private static var chatmanage:ChatManager;

//    public static var userStatus:Object=new Object();
    public static var unReadMessage:ArrayCollection = new ArrayCollection();

    public function ChatManager() {
//        unReadMessage.addEventListener(CollectionEvent.COLLECTION_CHANGE, paopaomove_handler);


    }

    public static function paopaomove_handler(e:CollectionEvent):void{
        var p:NewsPannel = null;
        var mve:Move =null;
        var bottomY:int = FlexGlobals.topLevelApplication.height - 70;
        var t_y:int=0;
        for(var index:int = unReadMessage.length-1;index>=0;index--){
            p = unReadMessage.getItemAt(index) as NewsPannel;
            mve = new Move();
            mve.xFrom = p.x;
            mve.yFrom = p.y;
            mve.xTo = p.x;
            t_y=(unReadMessage.length-index-1) * (60+10)+10;
            if(t_y<bottomY){
                mve.yTo = t_y;
            }else{
                mve.yTo = bottomY;
            }
            mve.duration = 500;
            mve.play([p]);
        }
    }

//    static public function clearUser():void{
//        for(var u:String in userStatus){
//            userStatus[u]="off";
//        }
//    }

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
        unReadMessage.addEventListener(CollectionEvent.COLLECTION_CHANGE, paopaomove_handler);
//        for(var u:String in userStatus){
//            userStatus[u]="off";
//        }
        unReadMessage.removeAll();
//        Pomelo.getIns().disconnect();
        if(ToolUtil.sessionUser){
            chatClosedListeing();
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

    [Bindable]
    static public var pomelo_online:Boolean=false;
    static public var pomelo_error:Boolean=false;

    static private function error_handler(e:Event):void{
        if(pomelo_online){
            pomelo_online=false;
            loginChat(null);
        }else{
            if(pomelo_error){
                Alert.show("即时通信服务正在维护中，目前不可使用。");
            }
            time.start();
        }
        pomelo_error = true;
    }
    static private function not_pomelo_handler(e:Event):void{
        pomelo_online=false;
        if(pomelo_error){
            Alert.show("即时通信服务正在维护中，目前不可使用。");
            time.start();
        }
        pomelo_error = true;

    }
    static public function chatClosedListeing():void{
        Pomelo.getIns().addEventListener(Event.CLOSE, error_handler);
        Pomelo.getIns().addEventListener(IOErrorEvent.IO_ERROR, error_handler);
        Pomelo.getIns().addEventListener(SecurityErrorEvent.SECURITY_ERROR, not_pomelo_handler);
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
                    pomelo_online=true;
                    regOrg();
//                    Pomelo.getIns().addEventListener(Event.CLOSE,loginChat);
                    Pomelo.getIns().on("loginOther",function(relogindata:PomeloEvent):void{
                        Alert.show(relogindata.message.msg.message,"警告");
                        var e:QuiteEvent = new QuiteEvent(QuiteEvent.Quite, true);
                        e.needTip = false;
                        FlexGlobals.topLevelApplication.dispatchEvent(e);
                    })
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

//            Pomelo.getIns().addEventListener('pStatus', personChangedHandler);
            Pomelo.getIns().addEventListener('onChat', chatHandler);
            Pomelo.getIns().addEventListener('sys', systemMessageHandler);
            Pomelo.getIns().addEventListener('createChannel', createChannelHandler);
            Pomelo.getIns().addEventListener('updateChannel', updateChannelHandler);
            Pomelo.getIns().addEventListener('removeChannel', removeChannelHandler);
            Pomelo.getIns().addEventListener('quiteChannel', quiteChannelHandler);
            Pomelo.getIns().addEventListener('joinChannel', joinChannelHandler);
//            clearUser();

            var groups:ArrayCollection=new ArrayCollection();
            var channels:Array = new Array();
            var g:ChatChannel;
            for each(var channel:Object in data.channels){
                if ('o' == channel.channel.substr(0, 1)) {
                    continue;
                }
                channels.push({channel:channel.channel, timeline:""+channel.timeline});
                if ('0' == channel.channel.substr(0, 1)) {
                    continue;
                }
                g=new ChatChannel(channel);
                g.delable = true;
                groups.addItem(g);
//                if(channel.channel.substr(0,1)=="g"){
//                    g['id']=channel.channel.substr(1, channel.channel.length - 1);
//                    g['icon']='/static/smalloaicon/group.png';
//                }
//                if(isNaN(channel.channel.substr(0,1))&&channel.channel.substr(0,1)!="g"){
//                    g['id']=Number(channel.channel.substr(1, channel.channel.length - 1));
//                }
//                g['channel']=channel.channel;
//                g['author']=channel.author;
//                g['father']=null;
//                g['name']=channel.name;
//                g['timeline']=channel.timeline;
//                if(!isNaN(channel.channel.substr(0,1))&&channel.channel.substr(0,1)!='0'){
//                    var pid1:int=Number(channel.channel.split('p')[0]);
//                    var pid2:int=Number(channel.channel.split('p')[1]);
//                    if(ToolUtil.sessionUser.pid!=pid1){
//                        pid1=pid2;
//                    }
//                    for each(var p:Object in ToolUtil.memberList){
//                        if(p.id==pid1){
//                            g['id']= p.id;
//                            g['icon']= p.icon;
//                            g['name']= p.name;
//                            break;
//                        }
//                    }
//                }else{
//                    if ('d' == channel.channel.substr(0, 1)) {
//                        for each(p in ToolUtil.departMentList) {
//                            if (p.id == g['id']) {
//                                g['icon']= p.icon;
//                                g['name']= p.name;
//                                g['flag']= p.flag;
//                                break;
//                            }
//                        }
//                    }
//
//                    g['members']=new Array();
//                    for each(var u:Object in channel.members){
//                        for each(var item:Object in ToolUtil.memberList){
//                            if(u.pid==item.id){
//                                item['level'] = 0;
//                                item['unread'] = 0;
//                                g["members"].push(item);
//                                break;
//                            }
//                        }
//                    }
//                }


            }
            ToolUtil.groupList = groups;
            Pomelo.getIns().on("channelCount",function(msg:PomeloEvent):void{
                if(msg.message.channel.substr(0,1)=='0'){
                    liyuunread=msg.message.count;
                    if(liyuunread>0){
                        liyuShow=true;
                    }else{
                        liyuShow=false;
                    }
                }
                for each(var c:ChatChannel in ToolUtil.groupList){
                    if(c.channel==msg.message.channel){
                        c.unread=msg.message.count;
                    }
                }
                if(msg.message.num<=0){
                    ToolUtil.groupList.refresh();
                }
            })
            Pomelo.getIns().request("connector.entryHandler.unreadcount", {channels:channels});

            listenOrg();
        });
    }

    static public function listenOrg():void{
        var route:String = "connector.entryHandler.listenOrg";
        var param:Object = new Object();
        var dids:Array=new Array();
        var f:Boolean = false;
        for each(var item2:Object in ToolUtil.departMentList) {
            f = false;
            for each(var p:int in item2.members) {
                if (p == ToolUtil.sessionUser.pid) {
                    f = true;
                }
            }
            if (f) {
                dids.push("d"+item2.id);
            }
        }
//        for each(var depart:Object in ToolUtil.departMentList){
//            dids.push("d"+depart.id);
//        }
        param['dids']=dids;
        Pomelo.getIns().request(route, param);
    }


//    static public function personChangedHandler(event:PomeloEvent):void{
//        userStatus[event.message.p]=event.message.s;
//        trace("user changed:"+event.message.p+"_"+event.message.s);
//    }
//
//
//    static public function onlineHandler(event:PomeloEvent):void{
//        clearUser();
//        for each(var m:Object in event.message.users){
//            userStatus[m.uid]="on";
//
//
//            trace("online user changed:"+m.uid+"_on");
//        }
//    }
    static public function chatHandler(event:PomeloEvent):void{

        if(event.message.msg.channel!=ToolUtil.currentChannel){
            event.message.msg.unread=true;

            var s:NewsPannel = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,NewsPannel,false) as NewsPannel;
            s.message = event.message.msg;
            s.y = 0 - s.height - 10;
            s.x = FlexGlobals.topLevelApplication.width - s.width-10;
            s.unReadMessage = unReadMessage;
            unReadMessage.addItem(s);
//            unReadMessage.refresh();
        }else{
            if(event.message.msg.c!=type){
                var s:NewsPannel = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,NewsPannel,false) as NewsPannel;
                s.message = event.message.msg;
                s.y = 0 - s.height - 10;
                s.x = FlexGlobals.topLevelApplication.width - s.width-10;
                s.unReadMessage = unReadMessage;
                unReadMessage.addItem(s);
            }
        }

        trace("chat:"+JParser.encode(event.message.msg));
    }
    static public function systemMessageHandler(event:PomeloEvent):void{
        switch (event.message.msg.type){
            case "org_users_changed":
                ToolUtil.currentOrgRefresh();
                break;
            case "join_apply":
                Alert.show(event.message.msg.msg,event.message.msg.type);
                break;
            default :
                Alert.show(event.message.msg.msg,event.message.msg.type);
                break;
        }

    }
    static public function createChannelHandler(event:PomeloEvent):void{
        for each(var org:Object in ToolUtil.groupList){
            if(org.channel==event.message.group.channel){
                return;
            }
        }
        var g:ChatChannel=new ChatChannel();
        g.init(event.message.group);
        ToolUtil.groupList.addItem(g);


    }

    static public function updateChannelHandler(event:PomeloEvent):void{
        if(event.message.group.channel.substr(0,1)=="0"){
            return;
        }
        var g:ChatChannel=new ChatChannel();
        for each(var org:ChatChannel in ToolUtil.groupList){
            if(org.channel==event.message.group.channel){
                g=org;
            }
        }
        g.init(event.message.group);


//        g['channel']=event.message.group.channel;
//        g['name']=event.message.group.name;
//        g['author']=event.message.group.author;
//        if(event.message.group.channel.substr(0,1)=="g"){
//            g['id']=event.message.group.channel.substr(1, event.message.group.channel.length - 1);
//            g['icon']='/static/smalloaicon/group.png';
//        }
//        if(event.message.group.channel.substr(0,1)=="t"){
//            g['id']=event.message.group.channel.substr(1, event.message.group.channel.length - 1);
//            g['icon']='/static/smalloaicon/group.png';
//        }

//        if(!isNaN(event.message.group.channel.substr(0,1))&&event.message.group.channel.substr(0,1)!='0'){
//            var pid1:int=Number(event.message.group.channel.split('p')[0]);
//            var pid2:int=Number(event.message.group.channel.split('p')[1]);
//            if(ToolUtil.sessionUser.pid!=pid1){
//                pid1=pid2;
//            }
//            for each(var p:Object in ToolUtil.memberList){
//                if(p.id==pid1){
//                    g['id']= p.id;
//                    g['icon']= p.icon;
//                    g['name']= p.name;
//                    break;
//                }
//            }
//        }

//        g['timeline']=event.message.group.timeline;
//        g['members'].length=0;
//        for each(var u:Object in event.message.group.members){
//            for each(var item:Object in ToolUtil.memberList){
//                if(u.pid==item.id){
//                    item['level'] = 0;
//                    item['unread'] = 0;
//                    g["members"].push(item);
//                    break;
//                }
//            }
//        }
//        ToolUtil.groupList.addItem(g);


    }


    static public function removeChannelHandler(event:PomeloEvent):void{
        for each(var org:ChatChannel in ToolUtil.groupList){
            if(org.channel==event.message.channel){
                ToolUtil.groupList.removeItemAt(ToolUtil.groupList.getItemIndex(org));
                return;
            }
        }
    }
    static public function quiteChannelHandler(event:PomeloEvent):void{
        for each(var org:ChatChannel in ToolUtil.groupList){
            if(org.channel==event.message.channel){
                for each(var person:Object in org.members){
                    if(person.id==event.message.pid){

                        var i:int=org.members.getItemIndex(person);
                        org.members.removeItemAt(i);
                        return;
                    }
                }
                return;
            }
        }
    }
    static public function joinChannelHandler(event:PomeloEvent):void{
        for each(var org:ChatChannel in ToolUtil.groupList){
            if(org.channel==event.message.channel){
                var f:Boolean = false;
                for each(var person:Object in org.members){
                    if(person.id==event.message.pid){
                        f=true;
                    }
                }
                if(!f){
                    for each(person in ToolUtil.memberList){
                        if(person.id==event.message.pid){
                            org.members.addItem(person);
                            return;
                        }
                    }
                }
                return;
            }
        }
    }

    static public function sendMessageToChannel(t:String,content:Object,callback:Function):void{
        content["f"]=ToolUtil.sessionUser.pid;
        content['c']=type;
        content['channel']=t;
//        content["o"]=to;
        sendMessage('connector.entryHandler.send',content,callback);
//        sendMessage('chat.chatHandler.send',content,callback);
    }

    static public function sendMessageToDeparment(to:Number,t:String,content:Object,callback:Function):void{
        content["f"]=ToolUtil.sessionUser.pid;
        content['c']=type;
        content['channel']=t+to;
//        content["o"]=to;
        sendMessage('connector.entryHandler.send',content,callback);
//        sendMessage('chat.chatHandler.send',content,callback);
    }

    static public function sendMessageToPerson(to:Number,content:Object,callback:Function):void{
        content["f"]=ToolUtil.sessionUser.pid;
        content['c']=type;
        if(content["f"]>to){
            content['channel']=to+"p"+content["f"];
        }else{
            content['channel']=content["f"]+"p"+to;
        }
        content["t"]=to;
//        content["o"]='o'+ToolUtil.sessionUser.oid;
        sendMessage('connector.entryHandler.send',content,callback);
//        sendMessage('connector.entryHandler.send',content,callback);
    }


    static public function sendMessage(route:String,obj:Object, callback:Function):void{
        Pomelo.getIns().request(route, obj, callback);
    }

}
}
