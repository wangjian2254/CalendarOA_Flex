package uicontrol
{
	import events.GridEditPosition;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.collections.ArrayCollection;
	import mx.controls.AdvancedDataGrid;
	import mx.controls.TextInput;
	import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
	import mx.events.AdvancedDataGridEvent;
	import mx.events.ListEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.UIDUtil;
	
	[Event(name="gridEditPositionEvent",type="flex.events.GridEditPosition")]
	public class MarkAdvancedDataGrid extends AdvancedDataGrid
	{
		public function MarkAdvancedDataGrid()
		{
			super();
			addEventListener("creationComplete",init); 
			this.setStyle('borderColor','#9aa4aa');
			this.styleFunction=styleHandler;
			this.addEventListener(KeyboardEvent.KEY_DOWN,keydownDataGrid);
			this.sortableColumns=false;//默认把排序去掉
			this.doubleClickEnabled=true;//默认接收双击事件
			this.draggableColumns=false;//默认列不能拖动
			this.addEventListener(AdvancedDataGridEvent.ITEM_EDIT_BEGINNING,cellClick);
			this.addEventListener(ListEvent.ITEM_DOUBLE_CLICK,cellDbClick);
//			this.addEventListener(Event.ADDED,addNewItemFun);
			
			
		}
		public var newItem:Object;//新增数据
		public var isNewAdd:Boolean=false;//hotkey没有下一个的时候是否新加
//		public var tabColumn:Array=null;//跳转列编号
		
		private function getNextColumnIndex(i:int):int{
			var column:AdvancedDataGridColumn;
			var index:int=i+1;
			var flag:Boolean=false;
			for(;index<this.columns.length;index++){
				column=this.columns[index];
				if(column.editable){
					return index;
				}
			}
			for(var num:int=1;num<this.columns.length;num++){
				column=this.columns[num];
				if(column.editable){
					return num;
				}
			}
			return i+1;
		}
		private function getNextColumnIndexFromHead():int{
			var column:AdvancedDataGridColumn;
			var flag:Boolean=false;
			for(var num:int=1;num<this.columns.length;num++){
				column=this.columns[num];
				if(column.editable){
					return num;
				}
			}
			return 1;
		}
		private function isLastColumn(i:int):Boolean{
			var column:AdvancedDataGridColumn;
			for(var index:int=i+1;index<this.columns.length;index++){
				column=this.columns[index];
				if(column.editable){
					return false;
				}
			}
			return true;
		}
		private function getPreColumnIndex(i:int):int{
			var column:AdvancedDataGridColumn;
			var index:int=i-1;
			for(;index>=1;index--){
				column=this.columns[index];
				if(column.editable){
					return index;
				}
			}
			for(var num:int=this.columns.length-1;num>=1;num--){
				column=this.columns[num];
				if(column.editable){
					return num;
				}
			}
			return i+1;
		}
		private function getPreColumnIndexFromBottom():int{
			var column:AdvancedDataGridColumn;
			var flag:Boolean=false;
			for(var num:int=this.columns.length-1;num>=1;num--){
				column=this.columns[num];
				if(column.editable){
					return num;
				}
			}
			return 1;
		}
		private function isFirstColumn(i:int):Boolean{
			var column:AdvancedDataGridColumn;
			var index:int=i-1;
			for(;index>=1;index--){
				column=this.columns[index];
				if(column.editable){
					return false;
				}
			}
			return true;
		}
		//////datagrid 的回车和tab切换事件
		private function keydownDataGrid(evt:KeyboardEvent):void{
			try{
				var v:Object = this.editedItemPosition;
				if(v!=null  &&v.rowIndex==this.dataProvider.length-1){
					this.addNewItem();
				}
				if(evt.keyCode==Keyboard.ENTER||evt.keyCode==Keyboard.TAB){
					if(!evt.shiftKey){
//						if(v!=null  && v.columnIndex<this.columns.length-1){
//							v.columnIndex ++;
//							this.editedItemPosition = v;
//						}else{
//						if(v!=null  && v.columnIndex==this.columns.length-1){
//							if(this.isNewAdd&&this.newItem!=null){
//								
//								v.rowIndex ++;
//							}else{
//								
//							}
//							v.columnIndex=1;
//							this.editedItemPosition = v;
//						}
//						}
						if(v!=null ){
							if(isLastColumn(v.columnIndex)){
								v.rowIndex++;
								v.columnIndex=getNextColumnIndexFromHead();
							}else{
								v.columnIndex=getNextColumnIndex(v.columnIndex);
							}
							this.editedItemPosition = v;
							
						}
						
					}else{
//						if(v!=null  && v.columnIndex>1){
//							v.columnIndex --;
//							this.editedItemPosition = v;
//						}else{
//							
//						if(v!=null  && v.columnIndex==1){
//							if(v.rowIndex>0){
//								v.rowIndex --;
//							}
//							v.columnIndex=this.columns.length-1;
//							this.editedItemPosition = v;
//						}
//						}
						if(v!=null ){
							
							if(isFirstColumn(v.columnIndex)){
								if(v.rowIndex==0){
									return;
								}
								v.rowIndex--;
								v.columnIndex=getPreColumnIndexFromBottom();
							}else{
								v.columnIndex=getPreColumnIndex(v.columnIndex);
							}
							this.editedItemPosition = v;
							
						}
					}
				}
				if(v!=null){
					var evtObj:GridEditPosition=new GridEditPosition('gridEditPositionEvent',v);
					dispatchEvent(evtObj);
				}
				
				
			} catch(e:Error) {
				trace(e.message);
			}
		}
		
		public function addNewItem():void{
			if(this.isNewAdd&&this.newItem!=null){
				if(this.dataProvider is ArrayCollection){
					var item:Object=new Object();
					for(var l:String in newItem){
						item[l]=newItem[l];
					}
					item.mx_internal_uid = UIDUtil.createUID(); 
					this.dataProvider.addItem(item);
//					dispatchEvent(this.dataProvider.);
				}
			}
		}
		//给每一个数据设置一个原始数据，当控件创建完成时触发！
		public function init(evt:Event):void{
			// 增加一条空记录 start
//			addNewItemFun(null);
			//增加一条记录end
			for each(var item:Object in dataProvider){
				var oldData:Object = {};
				var classInfo:Object = ObjectUtil.getClassInfo(item);
				var properties:Array = classInfo["properties"];
				for (var i:int = 0; i < properties.length; i++)
				{
					var property:String = properties[i];
					oldData[property] = item[property];
				}
				//oldData属性中，记录的是原object
				item.oldData = oldData;
			}
			var recordObj:Object=new Object();
			for(var j:int=0;j<this.headerInfos.length;j++){
				var field:String= this.headerInfos[j].column.dataTipField ? this.headerInfos[j].column.dataTipField : this.headerInfos[j].column.dataField;
				recordObj[field]="";
			};
			if(recordObj.hasOwnProperty("selected")){
				recordObj.selected=false;
			}
			recordObj['isModfy']=true;
			this.newItem=recordObj;
			addNewItem();
		}
		public function addNewItemFun(arr:ArrayCollection):void{
//			var adGrid:MarkAdvancedDataGrid=e.target as MarkAdvancedDataGrid;
			var recordObj:Object=new Object();
			for(var j:int=0;j<this.headerInfos.length;j++){
				var field:String= this.headerInfos[j].column.dataTipField ? this.headerInfos[j].column.dataTipField : this.headerInfos[j].column.dataField;
				recordObj[field]="";
			};
			this.newItem=recordObj;
			if(arr==null&&dataProvider.length<=0){
				dataProvider.addItemAt(recordObj,dataProvider.length);
			}else{
				dataProvider.addAll(arr);
				dataProvider.addItemAt(recordObj,dataProvider.length);
			}
		}
		//按照当前值和原始值的关系，决定字体颜色
		/**
		 * data 为当前行数据
		 * dolumn 为当前列
		 * */
		private function styleHandler(data:Object, column:AdvancedDataGridColumn):Object
		{
			if (!data.hasOwnProperty("oldData"))
				return {color: 0x0055cc, textSelectedColor: 0x0055cc, textRollOverColor: 0x0055cc};
			//值没有做修改的情况
			if (data[column.dataField] == data.oldData[column.dataField])
				return {color: 0x000000, textSelectedColor: 0x000000, textRollOverColor: 0x000000};
			//值有被修改
			if(column.dataField!='selected'){
				data['isModfy']=true;
			}
			return {color: 0xFF0000, textSelectedColor: 0xFF0000, textRollOverColor: 0xFF0000};
		}
		// 单击时结束编辑事件
		private function cellClick(e:AdvancedDataGridEvent):void{
			//由于第一列是删除chexbox
			if(e.columnIndex!=0){
				e.stopImmediatePropagation();
			}
		}
		// 双击时打开编辑单元格
		private function cellDbClick(e:ListEvent):void{
			var co:AdvancedDataGridColumn=this.columns[e.columnIndex];
			if(co.editable==false){
				return;
			}
			var o:Object=new Object();
			o.columnIndex=e.columnIndex;
			o.rowIndex=e.rowIndex;
			this.editedItemPosition=o;
			if(e.rowIndex==this.dataProvider.length-1){//编辑时，如果发现是最后一行，就添加一行
				addNewItem();
			}
			var evtObj:GridEditPosition=new GridEditPosition('gridEditPositionEvent',o);
			dispatchEvent(evtObj);
		}
	}
}