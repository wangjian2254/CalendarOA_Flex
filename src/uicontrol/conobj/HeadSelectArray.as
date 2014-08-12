/**
 * Created by wangjian2254 on 14-7-30.
 */
package uicontrol.conobj {
import uicontrol.IconButton;

public class HeadSelectArray {
    public function HeadSelectArray() {
    }

    private var iconButtons:Array = new Array();

    public function addArr(iconButton:IconButton):void{
        if(iconButtons.indexOf(iconButton)<0){
            iconButtons.push(iconButton);
        }
    }

    public function selectedButtons():IconButton{
        for(var i:int =0 ;i<iconButtons.length;i++){
            if(iconButtons[i].isSelected()){
                return iconButtons[i];
            }
        }
        return null;
    }

    public function selectedIcon():String{
        for(var i:int =0 ;i<iconButtons.length;i++){
            if(iconButtons[i].isSelected()){
                return iconButtons[i].iconurl;
            }
        }
        return "";
    }


    public function selectedIconByIcon(url:String):void{
        for(var i:int =0 ;i<iconButtons.length;i++){
            if(iconButtons[i].iconurl == url){
                iconButtons[i].click_image();
            }
        }
    }
}
}
