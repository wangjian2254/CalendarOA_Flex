package util {
import mx.collections.ArrayCollection;

public class DataUtil {
//    private static var util:DataUtil = new DataUtil();

    public function DataUtil() {
    }

    // 获取表格中有效记录，filterPro指定的是要过滤掉的属性字符串，每个属性以逗号相隔
    public static function getCrectArr(filterPro:String, arrColl:ArrayCollection):Array {
        var arr:Array = new Array();
        for (var i:Number = 0; i < arrColl.length; i++) {//循环每条记录
            for (var p:String in arrColl[i]) {//循环记录中的每个属性
                var index:Number = filterPro.indexOf(p);
                if (index != -1) {//判断记录的属性是否是要过滤的属性
                    if (index == 0) {//索引从零开始匹配
                        var subChar:String = filterPro.substring(p.length, p.length + 1);
                        if (subChar == "," || subChar == "") {//判断匹配位置的下位是否为","，若果为逗号就代表匹配上跳过或者如果为空字符串代表匹配上跳过
                            continue;
                        }
                    } else {//索引不从零开始匹配
                        if (index + p.length == filterPro.length) {//如果索引加上属性长度等于过滤字符串长度，那么最后一项被匹配上跳过
                            continue;
                        } else {//否则是过滤字符串的中间项被匹配上
                            var endSubChar:String = filterPro.substring(index + p.length, index + p.length + 1);
                            var startSubChar:String = filterPro.substring(index - 1, index);
                            if (endSubChar == "," && startSubChar == ",") {//中间项被匹配上，如果匹配项的前后都是逗号，那么中间项被匹配跳过
                                continue;
                            }
                        }
                    }
                }
                if (arrColl[i][p] != undefined && arrColl[i][p] != null && arrColl[i][p] != "") {//如果属性有值将被加入到数组
                    arr.push(arrColl[i]);
                    break;
                }
            }
        }
        return arr;
    }

    /**
     *序列化数组的函数
     *filterPro:将会被跳过的属性字符串("isModfy,mx_internal_uid,selected,oldData")多个属性用逗号隔开
     *property:新的序列化数组属性
     *serializObj：序列化完成后生成的对象
     *arr:将被序列化的数据源数组
     */
    public static function serializationArr(filterPro:String, property:String, serializObj:Object, arr:Array):Object {
        for (var i:Number = 0; i < arr.length; i++) {
            for (var p:String in arr[i]) {
                var index:Number = filterPro.indexOf(p);
                if (index != -1) {
                    if (index == 0) {//索引从零开始匹配
                        var subChar:String = filterPro.substring(p.length, p.length + 1);
                        if (subChar == "," || subChar == "") {//判断匹配位置的下位是否为","，若果为逗号就代表匹配上跳过或者如果为空字符串代表匹配上跳过
                            continue;
                        }
                    } else {//索引不从零开始匹配
                        if (index + p.length == filterPro.length) {//如果索引加上属性长度等于过滤字符串长度，那么最后一项被匹配上跳过
                            continue;
                        } else {//否则是过滤字符串的中间项被匹配上
                            var endSubChar:String = filterPro.substring(index + p.length, index + p.length + 1);
                            var startSubChar:String = filterPro.substring(index - 1, index);
                            if (endSubChar == "," && startSubChar == ",") {//中间项被匹配上，如果匹配项的前后都是逗号，那么中间项被匹配跳过
                                continue;
                            }
                        }
                    }
                }
//					serializObj[property+"["+i+"]."+p]=arr[i][p];
                serializObj[property + p + "_" + i + ""] = arr[i][p];
            }
        }
        return serializObj;
    }
}
}