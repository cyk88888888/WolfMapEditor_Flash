package modules.mapEditor.joystick
{
	import com.greensock.TweenMax;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import fairygui.GObject;
	import fairygui.event.GTouchEvent;
	import framework.base.BaseUT;
	import framework.base.Global;
	import framework.ui.UILayer;
	import modules.base.GameEvent;
	import modules.mapEditor.conctoller.MapMgr;
	/**
	 * 摇杆界面
	 * @author cyk
	 * 
	 */
	public class JoystickLayer extends UILayer
	{
		protected override function get pkgName():String
		{
			return "MapEditor";
		}
		
		private var radius:int;
		private var _InitX:Number;
		private var _InitY:Number;
		private var _startStageX:Number;
		private var _startStageY:Number;
		private var _touchArea:GObject;
		private var _thumb:GObject;
		private var _center:GObject;
		public var curDegree:Number;
		public var vector:Point;//摇杆当前位置
		private var _isMouseDown:Boolean;
		protected override function onEnter():void
		{
			MapMgr.inst.joystick = this;
			
			radius = 100;
			_thumb = view.getChild("thumb");
			_touchArea = view.getChild("joystick_touch");
			_center = view.getChild("joystick_center");
			
			_InitX = _center.x;
			_InitY = _center.y;
			_touchArea.addEventListener(MouseEvent.MOUSE_DOWN, onTapBegin);
			_touchArea.addEventListener(MouseEvent.MOUSE_UP, onTapEnd);
			_touchArea.addEventListener(MouseEvent.MOUSE_MOVE,onTapMove);
		}
		
		/**摇杆是否处于移动中**/
		public function isMoving():Boolean{
			return vector && vector.x != 0 && vector.y != 0;
		}
		
		private function onTapBegin(evt:MouseEvent): void
		{
			TweenMax.killTweensOf(_thumb);
			_startStageX = Global.stage.mouseX;
			_startStageY = Global.stage.mouseY;
			_isMouseDown = true;
			_thumb.visible = _center.visible = true;
			vector = new Point(0,0);
			_center.setXY(_startStageX, _startStageY);
			_thumb.setXY(_startStageX, _startStageY);
			
			var deltaX:Number = _startStageX - _InitX;
			var deltaY:Number = _startStageY - _InitY;
			var degree:Number = curDegree = BaseUT.radian_to_angle(Math.atan2(deltaY, deltaX));
			_thumb.rotation = degree + 90;
		}
		
		protected function onTapEnd(event:MouseEvent):void
		{
			vector = new Point(0,0);
			_isMouseDown= false;
			_thumb.rotation = _thumb.rotation + 180;
			_center.visible = false;
			TweenMax.to(_thumb,0.3,{x:_InitX,y:_InitY,onComplete:function():void{
				_thumb.visible = false;
				_thumb.rotation = 0;
				_center.visible = true;
				_center.setXY(_InitX, _InitY);
			}})
		}
		
		protected function onTapMove(evt:MouseEvent):void
		{
			if(!_isMouseDown) return;
			var pt:Point = new Point(Global.stage.mouseX, Global.stage.mouseY);
			
			var rad:Number = Math.atan2(pt.y - _startStageY, pt.x - _startStageX);
			var degree:Number = curDegree = BaseUT.radian_to_angle(rad);
			
			_thumb.rotation = degree + 90;
			var buttonVec:Point = new Point();
			var distance:Number = Point.distance(pt,new Point(_startStageX, _startStageY));
			if (distance > radius)
			{
				buttonVec.x = _startStageX + radius * Math.cos(rad);
				buttonVec.y = _startStageY + radius * Math.sin(rad);
			}
			else
			{
				buttonVec.x = pt.x;
				buttonVec.y = pt.y;
			}
			_thumb.setXY(buttonVec.x,buttonVec.y);
			vector = new Point(pt.x * (pt.x > _startStageX ? 1 : -1), pt.y * (pt.y > _startStageY ? 1 : -1))
		}
		
		public function _tap_btn_close(evt:GTouchEvent):void{
			close();
		}
		
		protected override function onExit():void
		{
			MapMgr.inst.joystick = null;
			_touchArea.removeEventListener(MouseEvent.MOUSE_DOWN, onTapBegin);
			_touchArea.removeEventListener(MouseEvent.MOUSE_UP, onTapEnd);
			_touchArea.removeEventListener(MouseEvent.MOUSE_MOVE,onTapMove);
			TweenMax.killTweensOf(_thumb);
			emit(GameEvent.CloseDemo);
		}
	}
}