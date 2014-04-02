package util
{
	import control.SchedulePanel;
	import control.ScheduleShow;
	
	import flash.display.DisplayObject;
	
	import mx.core.FlexGlobals;
	import mx.managers.PopUpManager;

	public class ScheduleUtil
	{
		public function ScheduleUtil()
		{
		}
		
		private static var newSchedule:SchedulePanel=null;
		private static var showSchedule:Object=new Object();
		
		public static function createSchedule(startdate:Date=null,enddate:Date=null):void{
			if(newSchedule==null){
				newSchedule  = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,SchedulePanel,false) as SchedulePanel;
				
			}
			newSchedule.schedulData=null;
			if(startdate!=null&&enddate!=null){
				newSchedule.startDateValue = startdate;
				newSchedule.endDateValue = enddate;
			}else{
				newSchedule.startDateValue = new Date();
				newSchedule.endDateValue = new Date();
				
			}
			if(newSchedule.isinit){
				newSchedule.init();
			}
				
			PopUpManager.bringToFront(newSchedule);
			PopUpManager.centerPopUp(newSchedule);
		}
		
		public static function clearNewSchedule():void{
			newSchedule=null;
		}
		
		public static function closeSchedulePanel(scheduleId:String):void{
			if(showSchedule.hasOwnProperty(scheduleId)){
				delete showSchedule[scheduleId] ;
				
			}
		}
		
		
		
		public static function updateSchedulePanel(scheduleId:String):void{
			var scheduleData:Object = ToolUtil.getSchedule(scheduleId);
			
			if(showSchedule.hasOwnProperty(scheduleId)){
				showSchedule[scheduleId].schedulData = scheduleData;
				if(showSchedule[scheduleId].isinit){
					showSchedule[scheduleId].init();
				}
//				PopUpManager.bringToFront(showSchedule[scheduleId]);
//				PopUpManager.centerPopUp(showSchedule[scheduleId]);
			}
		}
		
		public static function showSchedulePanel(scheduleId:String):void{
			var scheduleData:Object = ToolUtil.getSchedule(scheduleId);
				
			if(showSchedule.hasOwnProperty(scheduleId)){
				showSchedule[scheduleId].schedulData = scheduleData;
				if(showSchedule[scheduleId].isinit){
					showSchedule[scheduleId].init();
				}
				PopUpManager.bringToFront(showSchedule[scheduleId]);
				PopUpManager.centerPopUp(showSchedule[scheduleId]);
			}else{
				var b:Boolean=false;
				for each(var obj:Object in ToolUtil.groupList){
					if(obj.id==scheduleData.group){
						if(obj.pem!="look"){
							b=true;
						}
						break;
					}
				}
				if(b){
					var s:SchedulePanel = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,SchedulePanel,false) as SchedulePanel;
					showSchedule[scheduleId]=s;
					s.schedulData = scheduleData;
					PopUpManager.bringToFront(showSchedule[scheduleId]);
					PopUpManager.centerPopUp(showSchedule[scheduleId]);
					
				}else{
					var show:ScheduleShow = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,ScheduleShow,false) as ScheduleShow;
					showSchedule[scheduleId]=show;
					show.schedulData = scheduleData;
					PopUpManager.bringToFront(showSchedule[scheduleId]);
					PopUpManager.centerPopUp(showSchedule[scheduleId]);
					
				}
			}
		}
	}
}