package util
{
import control.window.TaskPanel;

import flash.display.DisplayObject;

import mx.core.FlexGlobals;
import mx.managers.PopUpManager;

import uicontrol.TaskItem;

public class TaskUtil
	{
		public function TaskUtil()
		{
		}
		
		private static var newTask:TaskPanel=null;
		private static var showTask:Object=new Object();
		
		public static function createTask(startdate:Date=null,enddate:Date=null):void{
			if(newTask==null){
				newTask  = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,TaskPanel,false) as TaskPanel;
				
			}
			newTask.taskData=null;
			if(startdate!=null&&enddate!=null){
				newTask.startDateValue = startdate;
				newTask.endDateValue = enddate;
			}else{
				newTask.startDateValue = new Date();
				newTask.endDateValue = new Date();
				
			}
			if(newTask.isinit){
				newTask.init();
			}
				
			PopUpManager.bringToFront(newTask);
//			PopUpManager.centerPopUp(newTask);
		}
		
		public static function clearNewTask():void{
			newTask=null;
		}
		
		public static function closeTaskPanel(scheduleId:String):void{
			if(showTask.hasOwnProperty(scheduleId)){
				delete showTask[scheduleId] ;
				
			}
		}
		
		
		
		public static function updateTaskPanel(scheduleId:String):void{
//			var scheduleData:Object = ToolUtil.getTask(scheduleId);
			
			if(showTask.hasOwnProperty(scheduleId)){
//				showTask[scheduleId].scheduleData = scheduleData;
				if(showTask[scheduleId].isinit){
					showTask[scheduleId].init(false);
				}
//				PopUpManager.bringToFront(showTask[scheduleId]);
//				PopUpManager.centerPopUp(showTask[scheduleId]);
			}
		}
		
		public static function showTaskPanel(scheduleId:String,taskItem:TaskItem=null):void{
//			var taskData:Object = ToolUtil.getTask(scheduleId);
				
			if(showTask.hasOwnProperty(scheduleId)){
//				showTask[scheduleId].taskData = taskData;
				if(showTask[scheduleId].isinit){
					showTask[scheduleId].init();
				}
				PopUpManager.bringToFront(showTask[scheduleId]);
//				PopUpManager.centerPopUp(showTask[scheduleId]);
			}else{
				
					var s:TaskPanel = PopUpManager.createPopUp(FlexGlobals.topLevelApplication as DisplayObject,TaskPanel,false) as TaskPanel;
					showTask[scheduleId]=s;
//					s.taskData = taskData;
					PopUpManager.bringToFront(showTask[scheduleId]);
//					PopUpManager.centerPopUp(showTask[scheduleId]);
					
			}
			showTask[scheduleId].taskItem=taskItem;
		}
	}
}