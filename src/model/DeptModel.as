package model
{
	public class DeptModel
	{
		private var _id:String;
		private var _deptname:String;
		public function DeptModel()
		{
		}

		public function get deptname():String
		{
			return _deptname;
		}

		public function set deptname(value:String):void
		{
			_deptname = value;
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