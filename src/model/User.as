package model
{
	import mx.collections.ArrayCollection;

	public class User
	{
		private var _username:String;
		private var _id:int;
		private var _fullname:String="";
		private var _user_permissions:ArrayCollection;
		private var _groups:ArrayCollection;
		
		
		public function User()
		{
		}
		
		public function get groups():ArrayCollection
		{
			return _groups;
		}

		public function set groups(value:ArrayCollection):void
		{
			_groups = value;
		}

		public function get user_permissions():ArrayCollection
		{
			return _user_permissions;
		}

		public function set user_permissions(value:ArrayCollection):void
		{
			_user_permissions = value;
		}

		[Bindable]
		public function get fullname():String
		{
			return _fullname;
		}

		public function set fullname(value:String):void
		{
			_fullname = value;
		}

		public function get id():int
		{
			return _id;
		}

		public function set id(value:int):void
		{
			_id = value;
		}

		[Bindable]
		public function get username():String
		{
			return _username;
		}

		public function set username(value:String):void
		{
			_username = value;
		}

	}
}