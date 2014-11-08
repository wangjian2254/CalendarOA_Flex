package events
{
import flash.events.Event;

public class GridEditPosition extends Event
	{
		private var editCell:Object;
		public function GridEditPosition(type:String,editCell:Object, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.editCell=editCell;
		}
		
		override public function clone():Event{
			return new GridEditPosition(type,editCell,bubbles,cancelable);
		}
		
		public function getEditColumnIndex():int{
			return editCell.columnIndex;
		}
	}
}