package modules.mapEditor.comp
{
	import com.greensock.TweenMax;
	
	import flash.display.Sprite;
	

	/**
	 * 场景物件选中框 
	 * @author cyk
	 * 
	 */
	public class MapThingSelectSp extends Sprite
	{
		public var curX:Number;
		public var curY:Number;
		public var isShow:Boolean;
		public function MapThingSelectSp()
		{
		}
		
		/**
		 * 开始绘制矩形线条框 
		 * @param _x 绘制位置X
		 * @param _y 绘制位置Y
		 * @param wid 绘制宽度
		 * @param hei 绘制高度
		 * 
		 */		
		public function drawRectLine(_x:Number,_y:Number,wid:Number,hei:Number):void{
			graphics.clear();
			graphics.lineStyle(2,0xffffff);
			graphics.moveTo(_x, _y);
			graphics.lineTo(_x + wid,_y);
			graphics.lineTo(_x+wid,_y+hei);
			graphics.lineTo(_x,_y+hei);
			graphics.lineTo(_x,_y);
			curX = _x;
			curY = _y;
			isShow = true;
		}
		
		public function doAlphaTween():void{
			TweenMax.killTweensOf(this);
			this.alpha = 0.2;
			TweenMax.to(this, 0.1, {alpha:1,repeat:6,yoyo:true});
		}
		
		public function rmSelf():void{
			if(this.parent) this.parent.removeChild(this);
			TweenMax.killTweensOf(this);
			isShow = false;
		}
	}
}