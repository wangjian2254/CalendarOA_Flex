/**
 * Created by wangjian2254 on 14-7-30.
 */
package uicontrol.conobj {
import uicontrol.DepartmentItem;

public class DepartmentSelectArray {
    public function DepartmentSelectArray() {
    }

    private var iconButtons:Array = new Array();

    public function addArr(iconButton:DepartmentItem):void{
        if(iconButtons.indexOf(iconButton)<0){
            iconButtons.push(iconButton);
        }
    }

    public function selectedById(id:*):DepartmentItem{
        if(!id){
            return null;
        }
        var d:DepartmentItem=getById(id);
        if(d){
            d.selectDepart();
            return d;
        }
        return null;
    }
    public function getById(id:*):DepartmentItem{
        if(!id){
            return null;
        }
        var d:DepartmentItem=null;
        for(var i:int =0 ;i<iconButtons.length;i++){
            d = iconButtons[i];
            if(d.department && d.department.id == id){
                return d;
            }
        }
        return null;
    }

    public function selectedButtons():DepartmentItem{
        for(var i:int =0 ;i<iconButtons.length;i++){
            if(iconButtons[i].isSelected()){
                return iconButtons[i];
            }
        }
        return null;
    }

    public function clear():void{
        iconButtons = new Array();
    }

}
}
