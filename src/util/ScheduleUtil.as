package util
{
import control.window.SchedulePanel;

import flash.display.DisplayObject;

import httpcontrol.HttpServiceUtil;

import model.Schedule;

import mx.core.FlexGlobals;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

public class ScheduleUtil
	{
		public function ScheduleUtil()
		{
		}
		
		private static var newSchedule:SchedulePanel=null;
		private static var showSchedule:Object=new Object();
		
		public static function createSchedule(startdate:Date=null,enddate:Date=null,create:Boolean=false,department:int=-1,project:int=-1,checker:int=-1,user:int=-1,content:String=null):void{
            if(newSchedule==null||create){
                newSchedule  = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,SchedulePanel,false) as SchedulePanel;
                newSchedule.schedulData=null;
				newSchedule.default_checker = checker;
				newSchedule.default_department = department;
				newSchedule.default_project = project;
				newSchedule.default_users = user;
				newSchedule.default_content = content;
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
		
		public static function clearNewSchedule(s:SchedulePanel=null):void{
			if(s==null){
				if(newSchedule!=null){
					newSchedule.closeWin();
				}
				return
			}
			if(s==newSchedule){
				newSchedule=null;
			}

		}
		
		public static function closeSchedulePanel(scheduleId:String):void{
			if(showSchedule.hasOwnProperty(scheduleId)){
				delete showSchedule[scheduleId] ;
				
			}
		}

		public static function hiddenAllSchedulePanel():void{
			for(var scheduleId:String in showSchedule){
				if(showSchedule[scheduleId]){
					showSchedule[scheduleId].closeWin();
				}

			}
		}

        public static function rememberSchedulePanel(scheduleId:String, panel:Object):void{
            showSchedule[scheduleId] = panel;

        }
		
		public static function updateSchedulePanel(scheduleId:String):void{
			var scheduleData:Schedule = ToolUtil.getSchedule(scheduleId);
			
			if(showSchedule.hasOwnProperty(scheduleId)){
				showSchedule[scheduleId].schedulData = scheduleData;
				if(showSchedule[scheduleId].inited){
					showSchedule[scheduleId].init();
				}

			}
		}

		public static function delSchedulePanel(scheduleId:String):void{
			if(showSchedule.hasOwnProperty(scheduleId)){
				showSchedule[scheduleId].delSchedule();
			}
		}

		public static function refreshScheduleById(scheduleId:String):void{
			var obj:Object = new Object();
			obj['id'] = scheduleId;
			HttpServiceUtil.getCHTTPServiceAndResult("/ca/getScheduleById", function (result:Object, e:ResultEvent):void {
				if (result.success) {
					var schedulData:Schedule = new Schedule(result.result);
					ToolUtil.updateSchedul(schedulData.id, schedulData);
				}
			}, "POST").send(obj);
		}
		
		public static function showSchedulePanel(scheduleId:String, refresh:Boolean=false):void{
			var scheduleData:Schedule = ToolUtil.getSchedule(scheduleId);
			if(scheduleData==null||refresh){
				var obj:Object = new Object();
				obj['id'] = scheduleId;
				HttpServiceUtil.getCHTTPServiceAndResult("/ca/getScheduleById", function (result:Object, e:ResultEvent):void {
					if (result.success) {
						var schedulData:Schedule = new Schedule(result.result);
						ToolUtil.updateSchedul(schedulData.id, schedulData);
						ScheduleUtil.showSchedulePanel(schedulData.id);
					}
				}, "POST").send(obj);
				return;
			}
			if(showSchedule.hasOwnProperty(scheduleId)){
				showSchedule[scheduleId].schedulData = scheduleData;
				if(showSchedule[scheduleId].inited){
					showSchedule[scheduleId].init();
				}
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