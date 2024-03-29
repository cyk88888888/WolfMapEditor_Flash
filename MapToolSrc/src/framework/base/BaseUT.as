package framework.base
{
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	import fairygui.GComponent;
	import fairygui.GRoot;

	/**
	 * 框架工具类 
	 * @author cyk
	 */
	public class BaseUT
	{
		public static var scaleMode: ScaleMode;
		/**根据类名创建实例**/
		public static function createClassByName(targetClass:Class):*{
			var targetClassName:String = getQualifiedClassName(targetClass);
			var typeClss:* = getDefinitionByName(targetClassName);
			return new typeClss();
		}
		
		/** 根据类对象获取类名**/
		public static function getClassNameByObj(targetClass:*):String{
			var targetClassName:String = getQualifiedClassName(targetClass);
			return targetClassName.split("::")[1];
		}
		/**根据屏幕尺寸自适应宽高**/
		public static function setFitSize(comp: GComponent):Point
		{
			var designHeight:Number = GRoot.inst.height < scaleMode.designHeight_max ? GRoot.inst.height : scaleMode.designHeight_max;
			comp.setSize(scaleMode.designWidth, designHeight);
			return new Point(scaleMode.designWidth, designHeight);
		}
		
		/** 获取字典长度**/
		public static function getDictionaryCount(dic:Dictionary):int{
			var count:int = 0;
			for(var key:Object in dic){
				count++;
			}
			return count;
		}
		
		/** 角度转向量**/
		public static function angle_to_vector(angle:Number):Point
		{
			var radian:Number = angle_to_radian(angle);
			var cos:Number = Math.cos(radian);
			var sin:Number = Math.sin(radian);
			var vec:Point = normalize(new Point(cos, sin));
			return vec;
		}
		
		/** 角度转弧度**/ 
		public static function angle_to_radian(angle:Number):Number
		{
			var radian:Number = Math.PI / 180 * angle;
			return radian;
		}
		
		/** 弧度转角度**/ 
		public static function radian_to_angle(radian:Number):Number {
			var angle:Number = 180 / Math.PI * radian;
			return angle;
		}
		
		/** 向量归一化**/
		public static function normalize(point: Point): Point {
			var x:Number = point.x;
			var y:Number = point.y;
			var len:Number = x * x + y * y;
			if (len > 0) {
				len = 1 / Math.sqrt(len);
				x *= len;
				y *= len;
			}
			return new Point(x, y);
		}
		
		public static function checkIsPngOrJpg(url:String):Boolean{
			return url.indexOf(".png")>-1 || url.indexOf(".jpg")>-1;
		}
		
		/**拷贝数据**/
		public static function clone(sourceObj:*):Object{
			if(!sourceObj) return null;
			var b:ByteArray = new ByteArray();
			b.writeObject(sourceObj);
			b.position = 0;
			return b.readObject();
		}
		
		/**
		 *  获取两点间的距离
		 * @param {number} x1
		 * @param {number} y1
		 * @param {number} x2
		 * @param {number} y2
		 * @returns {number}
		 */
		public static function distance(x1: Number, y1: Number, x2: Number, y2: Number):Number {
			var dx:Number = x1 - x2;
			var dy:Number = y1 - y2;
			return Math.sqrt(dx * dx + dy * dy);
		}
	}
}