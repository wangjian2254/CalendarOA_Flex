package model
{
	public class UserModel
	{
		private var _id:String;
		private var _username:String;
		private var _truename:String;
		private var _pwd:String;
		private var _bm:String;
		private var _tel:String;
		public function UserModel()
		{
			
		}

		public function get tel():String
		{
			return _tel;
		}

		public function set tel(value:String):void
		{
			_tel = value;
		}

		public function get bm():String
		{
			return _bm;
		}

		public function set bm(value:String):void
		{
			_bm = value;
		}

		public function get pwd():String
		{
			return _pwd;
		}

		public function set pwd(value:String):void
		{
			_pwd = value;
		}

		public function get truename():String
		{
			return _truename;
		}

		public function set truename(value:String):void
		{
			_truename = value;
		}

		public function get username():String
		{
			return _username;
		}

		public function set username(value:String):void
		{
			_username = value;
		}

		public function get id():String
		{
			return _id;
		}

		public function set id(value:String):void
		{
			_id = value;
		}

	}
}