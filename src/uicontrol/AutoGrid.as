package uicontrol
{
import events.AutoGridEvent;

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.DataGrid;
import mx.controls.Label;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.UIComponent;
import mx.events.CollectionEvent;
import mx.events.DataGridEvent;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.events.ResizeEvent;

[Event(name="autoDelete",type="events.AutoGridEvent")]
	[Event(name="autoAdd",type="events.AutoGridEvent")]
	public class AutoGrid extends DataGrid
	{
		public function AutoGrid()
		{
			super();
			this.addEventListener(FlexEvent.PREINITIALIZE,preinitializeHandler);
			this.addEventListener(ResizeEvent.RESIZE,resizeHandler);
			this.addEventListener(ListEvent.ITEM_CLICK,itemClick);
			this.addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING,itemEdit);
		}
		override public function set dataProvider(value:Object):void{
			super.dataProvider=value;
			var data:ArrayCollection=dataProvider as ArrayCollection;
			if(data){
				data.removeEventListener(CollectionEvent.COLLECTION_CHANGE,initRow);
				data.removeEventListener("sortChanged",sortChangedHandler);
				
				data.addEventListener(CollectionEvent.COLLECTION_CHANGE,initRow);
				data.addEventListener("sortChanged",sortChangedHandler);
				if(data.length<=0){
					data.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
				}
			}
			if(!value){
				data.dispatchEvent(new CollectionEvent(CollectionEvent.COLLECTION_CHANGE));
			}
		}
		private function sortChangedHandler(e:Event):void{
			var data:ArrayCollection=dataProvider as ArrayCollection;
			data.sort.compareFunction=defaultSortCompare;
		}
		private function defaultSortCompare(a:Object,b:Object,fields:Array):int{
			var result:int=0;
			var isCompared:Boolean=false;
			if(a==lastRow){
				isCompared=true;
				result=1;
				if(a==b){
					result=0;
				}
			}
			if(b==lastRow&&!isCompared){
				isCompared=true;
				result=-1;
				if(a==b){
					result=0;
				}
			}
			if(!isCompared){
				for(var i:int=0;i<fields.length;i++){
					var f:String= fields[i];
					if(a[f]>b[f]){
						result=1;
						break;
					}
					if(a[f]<b[f]){
						result=-1;
						break;
					}
					if(a[f]==b[f]){
						continue;
					}
				}
			}
			return result;
		}
		private function initRow(e:CollectionEvent):void{
			var o:Object=createRow();
			var data:ArrayCollection=dataProvider as ArrayCollection;
			if(!lastRow){
				insertLastRow();
			}else if(data.getItemIndex(lastRow)==-1){
				data.addItemAt(lastRow,data.length);
			}
		}
		private function insertLastRow():void{
			var o:Object=createRow();
			var data:ArrayCollection=dataProvider as ArrayCollection;
			lastRow=o;
			data.addItemAt(o,data.length);
		}
		private function itemEdit(e:DataGridEvent):void{
			var col:DataGridColumn=columns[e.columnIndex] as DataGridColumn;
			if(e.rowIndex==dataProvider.length-1){
				insertLastRow();
			}
		}
		private function itemClick(e:ListEvent):void{
			var col:DataGridColumn=columns[e.columnIndex] as DataGridColumn;
			var data:ArrayCollection=dataProvider as ArrayCollection;
			if(e.rowIndex==data.length-1){
				insertLastRow();
			}
			var lab:Label=e.itemRenderer as Label;
			if(lab){
				var o:Object={};
				o["rowIndex"]=e.rowIndex;
				o["columnIndex"]=e.columnIndex;
				o["item"]=data.getItemAt(e.rowIndex);
				var evn:AutoGridEvent;
				if(lab.text==delText){
					evn=new AutoGridEvent(o);
				}
				if(lab.text==addText){
					evn=new AutoGridEvent(o,AutoGridEvent.ADD);
				}
				if(evn){
					dispatchEvent(evn);
				}
			}
		}
		private function createRow():Object{
			var o:Object={};
			for(var i:int=0;i<this.columns.length;i++){
				var dataColumn:DataGridColumn= this.columns[i];
				if(dataColumn.dataField==optionHeaderText){
					continue;
				}
				o[dataColumn.dataField]="";
			}
			return o;
		}
		private var addText:String="新增";
		private var delText:String="删除";
		private var lastRow:Object; 
		private function refreshItemRender(e:FlexEvent):void{
			var lab:Label=e.target as Label;
			var arr:ArrayCollection=this.dataProvider as ArrayCollection;
			var index:int=arr.getItemIndex(lab.data);
			if(index==arr.length-1){
				lab.text=addText;
			}else{
				lab.text=delText;
			}
		}
		public var optionHeaderText:String="操作";
		private function createOptionColumn():void{
			var column:DataGridColumn=new DataGridColumn(optionHeaderText);
			column.editable=false;
			column.sortable=false;
			var labText:Label=new Label();
			var colWidth:int=UIComponent(this).measureText(optionHeaderText).width;
			column.width=colWidth+10;
			var itemRender:ItemRender=new ItemRender();
			itemRender.setInstance(function():*{
				var lab:Label=new Label();
				lab.setStyle("textDecoration","underline");
				lab.buttonMode=true;
				lab.useHandCursor=true;
				lab.mouseChildren=false;
				lab.addEventListener(FlexEvent.DATA_CHANGE,refreshItemRender);
				return lab;
			});
			column.itemRenderer=itemRender;
			var cls:Array=[];
			cls.push(column);
			for(var i:int=0;i<this.columns.length;i++){
				cls.push(this.columns[i]);
			}
			var a1:Array=columns;
			a1.unshift(column);
			this.columns=a1;
		}
		private function preinitializeHandler(e:FlexEvent):void{
			createOptionColumn();
		}
		private function resizeHandler(e:ResizeEvent):void{
			updateDisplayList(this.width,this.height);
		}
		override protected function updateDisplayList(unscaledWidth:Number,unscaledHeight:Number):void{
			if(unscaledWidth<=0){
				return;
			}
			super.updateDisplayList(unscaledWidth,unscaledHeight);
		}
	}
}