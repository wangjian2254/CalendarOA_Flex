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
        public static var myDateFormatter1:DateFormatter=new DateFormatter();
		myDateFormatter1.formatString="YYYYMMDD";
        public static var myDateFormatter2:DateFormatter=new DateFormatter();
        myDateFormatter2.formatString="YYYY/MM/DD HH:NN:SS";
		public static function dateLblChat(currentDate:Date):String{
			return myDateFormatter2.format(currentDate);
		}

        public static function dateLbl(currentDate:Date):String{
            return myDateFormatter.format(currentDate);
        }
        public static function dateLbl1(currentDate:Date):String{
            return myDateFormatter1.format(currentDate);
        }
        public static function parseLblDate(value:String):Date{
            if (!value){
                return new Date();
            }
            var year:Number;

            var month:Number;

            var date:Number;

            var h:Number = 0;

            var m:Number = 0;

            var s:Number = 0;

            var ms:Number = 0;

            if(isNaN(Number(value)) && value.length <=19){

                year = Number(value.substr(0, 4));

                month = Number(value.substr(5, 2)) -1;

                date = Number(value.substr(8, 2));

                if(value.length>=13)

                    h = Number(value.substr(11, 2));

                if(value.length>=15)

                    m = Number(value.substr(14, 2));

                if(value.length>=18)

                    s = Number(value.substr(17, 2));



                return new Date(year, month, date,h,m,s,ms);

            }else{
                return new Date();
            }
        }
		public static function parseDate(value:String):Date{
			if (!value){
				return new Date();
			}
			var year:Number;
			
			var month:Number;
			
			var date:Number;
			
			var h:Number = 0;
			
			var m:Number = 0;
			
			var s:Number = 0;
			
			var ms:Number = 0;
			
			if(!isNaN(Number(value)) && value.length >= 8){
				
				year = Number(value.substr(0, 4));
				
				month = Number(value.substr(4, 2)) -1;
				
				date = Number(value.substr(6, 2));
				
				if(value.length>=10)
					
					h = Number(value.substr(8, 2));
				
				if(value.length>=12)
					
					m = Number(value.substr(10, 2));
				
				if(value.length>=14)
					
					s = Number(value.substr(12, 2));
				
				
				
				return new Date(year, month, date,h,m,s,ms);
				
			}else{
				return new Date();
			}
	}
	}
}