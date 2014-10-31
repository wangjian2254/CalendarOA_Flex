package util
{
	import control.window.SchedulePanel;
	import control.ScheduleShow;
	
	import flash.display.DisplayObject;

import model.Schedule;

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
                newSchedule.schedulData=null;
                if(startdate!=null&&enddate!=null){
                    newSchedule.startDateValue = startdate;
                    newSchedule.endDateValue = enddate;
                }else{
                    newSchedule.startDateValue = new Date();
                    newSchedule.endDateValue = new Date();
                }
                PopUpManager.bringToFront(newSchedule);
            }else{
                PopUpManager.bringToFront(newSchedule);
                newSchedule.showAnimation2(null);
            }


				

//			PopUpManager.centerPopUp(newSchedule);
		}
		
		public static function clearNewSchedule():void{
			newSchedule=null;
		}
		
		public static function closeSchedulePanel(scheduleId:String):void{
			if(showSchedule.hasOwnProperty(scheduleId)){
				delete showSchedule[scheduleId] ;
				
			}
		}



        public static function rememberSchedulePanel(scheduleId:String, panel:Object):void{
            showSchedule[scheduleId] = panel;

        }
		
		public static function updateSchedulePanel(scheduleId:String):void{
			var scheduleData:Schedule = ToolUtil.getSchedule(scheduleId);
			
			if(showSchedule.hasOwnProperty(scheduleId)){
				showSchedule[scheduleId].schedulData = scheduleData;
                showSchedule[scheduleId].init();
			}
		}
		
		public static function showSchedulePanel(scheduleId:String):void{
			var scheduleData:Schedule = ToolUtil.getSchedule(scheduleId);
				
			if(showSchedule.hasOwnProperty(scheduleId)){
				showSchedule[scheduleId].schedulData = scheduleData;
                showSchedule[scheduleId].init();
				PopUpManager.bringToFront(showSchedule[scheduleId]);
                showSchedule[scheduleId].showAnimation2(null);
			}else{
                var s:SchedulePanel = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,SchedulePanel,false) as SchedulePanel;
                showSchedule[scheduleId]=s;
                s.schedulData = scheduleData;
                PopUpManager.bringToFront(showSchedule[scheduleId]);
			}
		}
	}
}