package events
{
import flash.events.Event;

public class PageChangeEvent extends Event
		
	{
		public static var PageChange_EventStr:String="Page_Change";
		public var PageIndex:int=0;
		
		public var PageSize:int=0;
		public function PageChangeEvent(type:String, pageindex:int,pagesize:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			PageIndex= pageindex;
			
			PageSize =pagesize;
		}
		
		override public function clone():Event{
			var e:PageChangeEvent=new PageChangeEvent(type,PageIndex,PageSize,bubbles,cancelable);
			return e;
		}
		
	}
}