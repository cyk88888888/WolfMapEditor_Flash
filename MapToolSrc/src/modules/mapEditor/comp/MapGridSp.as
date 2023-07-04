package modules.mapEditor.comp
{
	import flash.display.Sprite;

	/**
	 * 地图格子
	 * @author cyk
	 * 
	 */
	public class MapGridSp extends Sprite
	{
		public function MapGridSp(){}
		
		/**
		 * 绘制矩形
		 * @param _x 绘制位置X
		 * @param _y 绘制位置Y
		 * @param wid 绘制宽度
		 * @param hei 绘制高度
		 * @param color 颜色 
		 */		
		public function drawRect(_x:Number,_y:Number,wid:Number,hei:Number,color:Number):void{
			graphics.beginFill(color,0.5);
			graphics.drawRect(_x, _y, wid, hei);
			graphics.endFill();
		}
		
		/**
		 * 绘制圆
		 * @param _x 绘制位置X
		 * @param _y 绘制位置Y
		 * @param wid radius 绘制半径
		 * @param color 颜色
		 */	
		public function drawCircle(_x:Number,_y:Number,radius:Number,color:Number):void{
			graphics.beginFill(color,0.5);
			graphics.drawCircle(_x, _y,radius);
			graphics.endFill();
		}
		
		public function clear():void{
			graphics.clear();
		}
		
	}
}