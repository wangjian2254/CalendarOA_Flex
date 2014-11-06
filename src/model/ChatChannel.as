/**
 * Created by wangjian2254 on 14/11/1.
 */
package model {
import mx.collections.ArrayCollection;

import util.ToolUtil;

public class ChatChannel {

    private var _id:String;
    private var _name:String;
    private var _channel:String;
    private var _author:int;
    private var _unread:int;
    private var _icon:String;
    private var _timeline:int;
    private var _level:int;
    private var _v:int;
    private var _type:String;
    private var _flag:String;
    private var _members:ArrayCollection;
    private var _delable:Boolean = false;



    public function ChatChannel(obj:Object=null) {
        if(obj!=null){
            init(obj);
        }
    }

    public function init(obj:Object):void{
        for(var p:String in obj){
            if(p=='_id'||p=='members'){
//                    channel=obj[p];
            }else{
                if(hasOwnProperty(p)){
                    this[p]=obj[p];
                }

            }
        }
        if(obj.hasOwnProperty("members")){
            setMembers(obj['members']);
        }else{
            _type="p";
        }

        if(obj.hasOwnProperty('_id')){
            channel=obj['_id'];
        }


    }

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    public function get name():String {
        return _name;
    }

    public function set name(value:String):void {
        _name = value;
    }

    public function get channel():String {
        if(_channel==null){
            if (members == null) {
                if (ToolUtil.sessionUser.pid > id) {
                    _channel = id + "p" + ToolUtil.sessionUser.pid;
                } else {
                    _channel = ToolUtil.sessionUser.pid + "p" + id;
                }
            } else {
                _channel = type + id;
            }
        }
        return _channel;
    }

    public function set channel(value:String):void {
        if(value.substr(0,1)=="g"){
            id=value.substr(1, value.length - 1);
            icon='/static/smalloaicon/group.png';
        }
        if(value.substr(0,1)=="t"){
            id=value.substr(1, value.length - 1);
            icon='/static/smalloaicon/group.png';
        }

        if(!isNaN(Number(value.substr(0, 1)))&&value.substr(0,1)!='0'){
            var pid1:int=Number(value.split('p')[0]);
            var pid2:int=Number(value.split('p')[1]);
            if(ToolUtil.sessionUser.pid!=pid1){
                pid1=pid2;
            }
            for each(var p:Object in ToolUtil.memberList){
                if(p.id==pid1){
                    id= p.id.toString();
                    icon= p.icon;
                    name= p.name;
                    break;
                }
            }
        }
        if ('d' == value.substr(0, 1)) {
            id=value.substr(1);
            for each(p in ToolUtil.departMentList) {
                if (p.id == id) {
                    icon= p.icon;
                    name= p.name;
                    flag= p.flag;
                    break;
                }
            }
        }
        _channel = value;
    }

    public function get author():int {
        return _author;
    }

    public function set author(value:int):void {
        _author = value;
    }

    public function get icon():String {
        return _icon;
    }

    public function set icon(value:String):void {
        _icon = value;
    }

    public function get timeline():int {
        return _timeline;
    }

    public function set timeline(value:int):void {
        _timeline = value;
    }

    public function get type():String {
        if(_type==null){
            if (flag!=null) {
                _type = "d";
            } else if (channel==null) {
                _type = "p";
            } else {
                if (channel.substr(0, 1) == 'g') {
                    _type = "g";
                }
                if (channel.substr(0, 1) == 'd') {
                    _type = "d";
                }
                if (channel.substr(0, 1) == 't') {
                    _type = "t";
                }
                if (!isNaN(Number(channel.substr(0, 1)))) {
                    _type = "p";
                }


            }
        }

        return _type;
    }

//    public function set type(value:String):void {
//        _type = value;
//    }

    [Bindable]
    public function get members():ArrayCollection {
        return _members;
    }

    public function getPids():Array{
        var pids:Array = new Array();
        if (members == null) {

            pids.push(id);
            pids.push(ToolUtil.sessionUser.pid);
        } else {
            for each(var p:Object in members) {
                pids.push(p.id);
            }
        }
        return pids;
    }

    public function setMembers(value:Array):void {
        if(value is ArrayCollection){
            _members = value as ArrayCollection;
        }else{
            _members = new ArrayCollection();
            var item:Object;
            for each(var u:Object in value){
                item = null;
                if(u is int){
                    item = ToolUtil.getActivePersonById(u);
                }
                if(u.hasOwnProperty("id")){
                    item = ToolUtil.getActivePersonById(u.id);
                }
                if(item!=null){
                    item['_level'] = 0;
                    item['_unread'] = 0;
                    _members.addItem(item);
                }
            }
        }

    }

    public function get unread():int {
        return _unread;
    }

    public function set unread(value:int):void {
        _unread = value;
    }

    public function get flag():String {
        return _flag;
    }

    public function set flag(value:String):void {
        _flag = value;
    }

    public function get level():int {
        return _level;
    }

    public function set level(value:int):void {
        _level = value;
    }

    public function get v():int {
        return _v;
    }

    public function set v(value:int):void {
        _v = value;
    }

    public function get delable():Boolean {
        return _delable;
    }

    public function set delable(value:Boolean):void {
        _delable = value;
    }
}
}
