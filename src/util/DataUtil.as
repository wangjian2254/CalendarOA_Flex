package util
{

	public  class DataUtil
	{
		private static var util:DataUtil= new DataUtil();
		public function DataUtil()
		{
		}
		// 获取表格中有效记录，filterPro指定的是要过滤掉的属性字符串，每个属性以逗号相隔
		public static function getCrectArr(filterPro,arrColl):Array{
			var arr=new Array();
			for(var i=0;i<arrColl.length;i++){//循环每条记录
				for(var p in arrColl[i]){//循环记录中的每个属性
					var index=filterPro.indexOf(p);
					if(index!=-1){//判断记录的属性是否是要过滤的属性
						if(index==0){//索引从零开始匹配
							var subChar=filterPro.substring(p.length,p.length+1);
							if(subChar==","||subChar==""){//判断匹配位置的下位是否为","，若果为逗号就代表匹配上跳过或者如果为空字符串代表匹配上跳过
								continue;
							}
						}else{//索引不从零开始匹配
							if(index+p.length==filterPro.length){//如果索引加上属性长度等于过滤字符串长度，那么最后一项被匹配上跳过
								continue;
							}else{//否则是过滤字符串的中间项被匹配上
								var endSubChar=filterPro.substring(index+p.length,index+p.length+1);
								var startSubChar=filterPro.substring(index-1,index);
								if(endSubChar==","&&startSubChar==","){//中间项被匹配上，如果匹配项的前后都是逗号，那么中间项被匹配跳过
									continue;
								}
							}
						}
					}
					if(arrColl[i][p]!=undefined&&arrColl[i][p]!=null&&arrColl[i][p]!=""){//如果属性有值将被加入到数组
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
		public static function serializationArr(filterPro,property,serializObj,arr):Object{
			for(var i=0;i<arr.length;i++){
				for(var p in arr[i]){
					var index=filterPro.indexOf(p);
					if(index!=-1){
						if(index==0){//索引从零开始匹配
							var subChar=filterPro.substring(p.length,p.length+1);
							if(subChar==","||subChar==""){//判断匹配位置的下位是否为","，若果为逗号就代表匹配上跳过或者如果为空字符串代表匹配上跳过
								continue;
							}
						}else{//索引不从零开始匹配
							if(index+p.length==filterPro.length){//如果索引加上属性长度等于过滤字符串长度，那么最后一项被匹配上跳过
								continue;
							}else{//否则是过滤字符串的中间项被匹配上
								var endSubChar=filterPro.substring(index+p.length,index+p.length+1);
								var startSubChar=filterPro.substring(index-1,index);
								if(endSubChar==","&&startSubChar==","){//中间项被匹配上，如果匹配项的前后都是逗号，那么中间项被匹配跳过
									continue;
								}
							}
						}
					}
//					serializObj[property+"["+i+"]."+p]=arr[i][p];
					serializObj[property+p+"_"+i+""]=arr[i][p];
				}
			}
			return serializObj;
		}
		//工具方法把所有带有子父级关系的json数组拼成树节点结构数据(如果json数据层级嵌套太多并且数据量较大可能会影响性能)
		/**
		 * cIdField:节点数据的唯一标识符与fIdField进行关联required
		 * cArrField:节点当中子节点数组 default value children
		 * arr:将要组成树节点的数据required
		 * 
		 * */
		public static function createNodeDataByJson(cIdField:String,fIdField:String,arr:Array,cArrField:String="children"):Array{
			arr = arr ? arr : [];
			var arr1:Array=arr.slice();
			var isFind:Boolean=false;
			for(var i:int=0;i<arr.length;i++){
				var findObject:Object=arr[i];
				for(var j:int=0;j<arr1.length;j++){
					var targetObject:Object=arr1[j];
					if(findObject[cIdField]==targetObject[cIdField]){ //如果是同一个对象,跳过本次内部循环
						continue;
					}else if(findObject[fIdField]==targetObject[cIdField]){ //如果不是同一对象,迭代对象父id正好等于比较对象的主键
						isFind=true;
						if(targetObject[cArrField] is Array){//比较对象对象有子数组
							targetObject[cArrField].push(findObject);
						}else{ //比较对象没有子数组
							targetObject[cArrField]=[];
							targetObject[cArrField].push(findObject);
						}
						arr1.splice(i,1); //比较对象当中删除找到的元素
						arr1=createNodeDataByJson(cIdField,fIdField,arr1,cArrField);//继续寻找元素
						break;
					}if(targetObject[cArrField] is Array){ //如果迭代对象父id不等于比较对象的主键,判断比较对象是否含有子数组
						var count:int=targetObject[cArrField].unshift(findObject); //将迭代对象放入数组当中
						var arr2:Array=createNodeDataByJson(cIdField,fIdField,targetObject[cArrField],cArrField);//继续寻找元素
						if(arr2.length==count){ //如果没有找到
							targetObject[cArrField].shift();
						}else{
							targetObject[cArrField]=arr2;
							isFind=true;
							arr1.splice(i,1); //比较对象当中删除找到的元素
							arr1=createNodeDataByJson(cIdField,fIdField,arr1,cArrField);//继续寻找元素
							break;
						}
					}else if(false){ //继续循环
						
					}
				}
				if(isFind){
					break;
				}
			}
			return arr1;
		}
	}
}
