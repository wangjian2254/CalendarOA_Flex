/**
 * Created by WangJian on 2014/10/29.
 */
package util {
import mx.collections.ArrayCollection;

public class ArrayTools {
    public function ArrayTools() {
    }

    public static function createArray(list:ArrayCollection, arr:Array):void{
        if(arr==null){
            list.removeAll();
            return;
        }
        if(list.filterFunction!=null){
            var filter:Function = list.filterFunction;
            list.filterFunction = null;
            list.refresh();
        }
        list.removeAll();
        list.addAll(new ArrayCollection(arr as Array));
        list.filterFunction = filter;
        list.refresh();

    }
}
}
