package uicontrol
{
	import mx.core.IFactory;
	import mx.core.mx_internal;
	
	public class ItemRender implements IFactory
	{
		private var o:*;
		public function ItemRender()
		{
		}
		public function newInstance():*
		{	
			if(this.o is Function){
				return this.o();
			}
			if(this.o is Class){
				return new this.o();
			}
			return this.o;
		}
		public function setInstance(value:*):void{
			this.o=value;
		}
	}
}