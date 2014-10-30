/**
 * Created by WangJian on 2014/10/30.
 */
package model {
import util.ToolUtil;

public class Schedule {

    private var _id:String;
    private var _title:String;
    private var _startdate:String;
    private var _enddate:String;
    private var _is_all_day:Boolean;
    private var _time_start:String;
    private var _time_end:String;
    private var _repeat_type:String;
    private var _repeat_date:Array;
    private var _color:uint;
    private var _department:int;
    private var _project:int;
    private var _users:Array;
    private var _need_check:Boolean;
    private var _checker:int;
    private var _level:int;
    private var _urgent:int;
    private var _status:int;
    private var _org:int;
    private var _group:String;
    private var _date:String;



    public function Schedule(obj:Object=null) {
        if(obj!=null){
            for(var p:String in obj){
                if(p=='_id'){
                    this['id']=obj[p];
                }else{
                    if(hasOwnProperty(p)){
                        this[p]=obj[p];
                    }

                }
            }
//            id = obj._id;
//            title = obj.title;
//            startdate = obj.startdate;
//            enddate = obj.enddate;
//            is_all_day = obj.is_all_day;
//            time_start = obj.time_start;
//            time_end = obj.time_end;
//            repeat_type = obj.repeat_type;

        }
    }
    private var _desc:String = null;
    public function getDesc():String{
        if(_desc==null){
            var desc:String = "";
            if(!is_all_day){
                desc +="时间："+showTime() +"\n";
            }
            desc += "日期："+showDate()+"\n";

            desc +="状态：";
            switch (status){
                case 1:
                    desc +="未开始\n";
                    break;
                case 2:
                    desc +="正在进行\n";
                    break;
                case 3:
                    desc +="已完成，等待审核\n";
                    break;
                case 4:
                    desc +="已结束\n";
                    break;
            }
            desc += "内容："+title+"\n";

            _desc = desc;
        }
        return _desc;
    }

    public function showDate():String{
        if(startdate==enddate){
            return startdate.substr(0,4)+"-"+startdate.substr(4,2)+"-"+startdate.substr(6,2);
        }else{
            return startdate.substr(0,4)+"-"+startdate.substr(4,2)+"-"+startdate.substr(6,2)+" / "+enddate.substr(0,4)+"-"+enddate.substr(4,2)+"-"+enddate.substr(6,2);
        }
    }
    public function showTime():String{
        if(!is_all_day){
            return time_start.substr(0,2)+":"+time_start.substr(2,2)+"-"+time_end.substr(0,2)+":"+time_end.substr(2,2);
        }
        return "";
    }

    public function isUser(pid:int):Boolean{
        for each(var i:int in users){
            if(i==pid){
                return true;
            }
        }
        return false;
    }

    public function isCheck(pid:int):Boolean{
        if(checker==pid){
            return true;
        }
        return false;
    }

    public function isDelPower(pid:int):Boolean{
        if(checker==pid){
            return true;
        }
        for each(var d:Object in ToolUtil.departMentList){
            if(d.id == department){
                for each(var p:int in d.manager){
                    if(p==pid){
                        return true;
                    }
                }
            }
        }
        for each(var d:Object in ToolUtil.projectList){
            if(d.id == project){
                if(d.manager==pid){
                    return true;
                }
            }
        }
        return false;
    }

    public function get id():String {
        return _id;
    }

    public function set id(value:String):void {
        _id = value;
    }

    public function get title():String {
        return _title;
    }

    public function set title(value:String):void {
        _title = value;
    }

    public function get startdate():String {
        return _startdate;
    }

    public function set startdate(value:String):void {
        _startdate = value;
    }

    public function get enddate():String {
        return _enddate;
    }

    public function set enddate(value:String):void {
        _enddate = value;
    }

    public function get is_all_day():Boolean {
        return _is_all_day;
    }

    public function set is_all_day(value:Boolean):void {
        _is_all_day = value;
    }

    public function get time_start():String {
        return _time_start;
    }

    public function set time_start(value:String):void {
        _time_start = value;
    }

    public function get time_end():String {
        return _time_end;
    }

    public function set time_end(value:String):void {
        _time_end = value;
    }

    public function get repeat_type():String {
        return _repeat_type;
    }

    public function set repeat_type(value:String):void {
        _repeat_type = value;
    }

    public function get repeat_date():Array {
        return _repeat_date;
    }

    public function set repeat_date(value:Array):void {
        _repeat_date = value;
    }

    public function get color():uint {
        return _color;
    }

    public function set color(value:uint):void {
        _color = value;
    }

    public function get department():int {
        return _department;
    }

    public function set department(value:int):void {
        _department = value;
    }

    public function get project():int {
        return _project;
    }

    public function set project(value:int):void {
        _project = value;
    }

    public function get users():Array {
        return _users;
    }

    public function set users(value:Array):void {
        _users = value;
    }

    public function get need_check():Boolean {
        return _need_check;
    }

    public function set need_check(value:Boolean):void {
        _need_check = value;
    }

    public function get checker():int {
        return _checker;
    }

    public function set checker(value:int):void {
        _checker = value;
    }

    public function get level():int {
        return _level;
    }

    public function set level(value:int):void {
        _level = value;
    }

    public function get urgent():int {
        return _urgent;
    }

    public function set urgent(value:int):void {
        _urgent = value;
    }

    public function get status():int {
        return _status;
    }

    public function set status(value:int):void {
        _status = value;
    }

    public function get org():int {
        return _org;
    }

    public function set org(value:int):void {
        _org = value;
    }

    public function get group():String {
        return _group;
    }

    public function set group(value:String):void {
        _group = value;
    }

    public function get date():String {
        return _date;
    }

    public function set date(value:String):void {
        _date = value;
    }
}
}
