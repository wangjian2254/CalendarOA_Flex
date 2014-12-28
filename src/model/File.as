package model
{
import mx.collections.ArrayCollection;

public class File
	{
	private var _id:int;
	private var _name:String;
	private var _create_time:String;
	private var _shareurl:String;
	private var _fileurl:String;
	private var _filetype:String;
	private var _size:int;
	private var _status:int;
	private var _file_status:Boolean;
	private var _ownertype:String;
	private var _ownerpk:String;
	private var _author:int;
	public function File(o:Object)
	{
		for(var p:String in o){
			this[p]=o[p];
		}
	}


	public function get id():int {
		return _id;
	}

	public function set id(value:int):void {
		_id = value;
	}

	public function get name():String {
		return _name;
	}

	public function set name(value:String):void {
		_name = value;
	}

	public function get create_time():String {
		return _create_time;
	}

	public function set create_time(value:String):void {
		_create_time = value;
	}

	public function get shareurl():String {
		return _shareurl;
	}

	public function set shareurl(value:String):void {
		_shareurl = value;
	}

	public function get fileurl():String {
		return _fileurl;
	}

	public function set fileurl(value:String):void {
		_fileurl = value;
	}

	public function get filetype():String {
		return _filetype;
	}

	public function set filetype(value:String):void {
		_filetype = value;
	}

	public function get size():int {
		return _size;
	}

	public function set size(value:int):void {
		_size = value;
	}

	public function get status():int {
		return _status;
	}

	public function set status(value:int):void {
		_status = value;
	}

	public function get file_status():Boolean {
		return _file_status;
	}

	public function set file_status(value:Boolean):void {
		_file_status = value;
	}

	public function get ownertype():String {
		return _ownertype;
	}

	public function set ownertype(value:String):void {
		_ownertype = value;
	}

	public function get ownerpk():String {
		return _ownerpk;
	}

	public function set ownerpk(value:String):void {
		_ownerpk = value;
	}

	public function get author():int {
		return _author;
	}

	public function set author(value:int):void {
		_author = value;
	}
}
}