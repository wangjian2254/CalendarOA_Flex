package util
{
	import mx.formatters.DateFormatter;

	public class DateUtil
	{
		public function DateUtil()
		{
		}
		
		[Bindable]
		public static var dayNames:Array=["日","一","二","三","四","五","六"];
		[Bindable]
		public static var monthNames:Array=["一月","二月","三月","四月","五月","六月","七月","八月","九月","十月","十一月","十二月"];
	
		public static var myDateFormatter:DateFormatter=new DateFormatter();
		myDateFormatter.formatString="YYYY/MM/DD";
		public static function dateLbl(currentDate:Date):String{
			return myDateFormatter.format(currentDate);
		}
	}
}