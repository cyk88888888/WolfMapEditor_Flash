package modules.mapEditor.comp
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	/**
	 * 地图裁剪提示框 
	 * @author cyk
	 * 
	 */
	public class MapRemindSp extends Sprite
	{
		public function MapRemindSp()
		{
		}
		
		/**
		 * 开始绘制矩形
		 * @param _x 绘制位置X
		 * @param _y 绘制位置Y
		 * @param wid 绘制宽度
		 * @param hei 绘制高度
		 * 
		 */		
		public function drawRect(_x:Number,_y:Number,wid:Number,hei:Number):void{
			graphics.beginFill(0xFF0000, 0.8);
			graphics.drawRect(_x, _y, wid, hei);
			graphics.endFill();
			this.alpha = 0;
			doAlphaTween();
		}
		
		private function  doAlphaTween():void{
			TweenMax.to(this, 0.4, {alpha:1,repeat:4,yoyo:true,onComplete:rmSelf});
		}
		
		public function rmSelf():void{
			if(this.parent) this.parent.removeChild(this);
			TweenMax.killTweensOf(this);
		}
	}
}