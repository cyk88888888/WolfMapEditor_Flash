// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.mapEditor.joystick.JoystickLayer

package modules.mapEditor.joystick
{
    import framework.ui.UILayer;
    import fairygui.GObject;
    import flash.geom.Point;
    import modules.mapEditor.conctoller.MapMgr;
    import com.greensock.TweenMax;
    import framework.base.Global;
    import framework.base.BaseUT;
    import flash.events.MouseEvent;
    import fairygui.event.GTouchEvent;
    import modules.base.GameEvent;

    public class JoystickLayer extends UILayer 
    {

        private var radius:int;
        private var _InitX:Number;
        private var _InitY:Number;
        private var _startStageX:Number;
        private var _startStageY:Number;
        private var _touchArea:GObject;
        private var _thumb:GObject;
        private var _center:GObject;
        public var curDegree:Number;
        public var vector:Point;
        private var _isMouseDown:Boolean;


        override protected function get pkgName():String
        {
            return ("MapEditor");
        }

        override protected function onEnter():void
        {
            MapMgr.inst.joystick = this;
            radius = 100;
            _thumb = view.getChild("thumb");
            _touchArea = view.getChild("joystick_touch");
            _center = view.getChild("joystick_center");
            _InitX = _center.x;
            _InitY = _center.y;
            _touchArea.addEventListener("mouseDown", onTapBegin);
            _touchArea.addEventListener("mouseUp", onTapEnd);
            _touchArea.addEventListener("mouseMove", onTapMove);
        }

        public function isMoving():Boolean
        {
            return (((vector) && (!(vector.x == 0))) && (!(vector.y == 0)));
        }

        private function onTapBegin(_arg_1:MouseEvent):void
        {
            TweenMax.killTweensOf(_thumb);
            _startStageX = Global.stage.mouseX;
            _startStageY = Global.stage.mouseY;
            _isMouseDown = true;
            var _local_5:* = true;
            _center.visible = _local_5;
            _thumb.visible = _local_5;
            vector = new Point(0, 0);
            _center.setXY(_startStageX, _startStageY);
            _thumb.setXY(_startStageX, _startStageY);
            var _local_3:Number = (_startStageX - _InitX);
            var _local_4:Number = (_startStageY - _InitY);
            var _local_2:Number = (curDegree = BaseUT.radian_to_angle(Math.atan2(_local_4, _local_3)));
            _thumb.rotation = (_local_2 + 90);
        }

        protected function onTapEnd(event:MouseEvent):void
        {
            vector = new Point(0, 0);
            _isMouseDown = false;
            _thumb.rotation = (_thumb.rotation + 180);
            _center.visible = false;
            TweenMax.to(_thumb, 0.3, {
                "x":_InitX,
                "y":_InitY,
                "onComplete":function ():void
                {
                    _thumb.visible = false;
                    _thumb.rotation = 0;
                    _center.visible = true;
                    _center.setXY(_InitX, _InitY);
                }
            });
        }

        protected function onTapMove(_arg_1:MouseEvent):void
        {
            if (!_isMouseDown)
            {
                return;
            };
            var _local_5:Point = new Point(Global.stage.mouseX, Global.stage.mouseY);
            var _local_6:Number = Math.atan2((_local_5.y - _startStageY), (_local_5.x - _startStageX));
            var _local_4:Number = (curDegree = BaseUT.radian_to_angle(_local_6));
            _thumb.rotation = (_local_4 + 90);
            var _local_2:Point = new Point();
            var _local_3:Number = Point.distance(_local_5, new Point(_startStageX, _startStageY));
            if (_local_3 > radius)
            {
                _local_2.x = (_startStageX + (radius * Math.cos(_local_6)));
                _local_2.y = (_startStageY + (radius * Math.sin(_local_6)));
            }
            else
            {
                _local_2.x = _local_5.x;
                _local_2.y = _local_5.y;
            };
            _thumb.setXY(_local_2.x, _local_2.y);
            vector = new Point((_local_5.x * ((_local_5.x > _startStageX) ? 1 : -1)), (_local_5.y * ((_local_5.y > _startStageY) ? 1 : -1)));
        }

        public function _tap_btn_close(_arg_1:GTouchEvent):void
        {
            close();
        }

        override protected function onExit():void
        {
            MapMgr.inst.joystick = null;
            _touchArea.removeEventListener("mouseDown", onTapBegin);
            _touchArea.removeEventListener("mouseUp", onTapEnd);
            _touchArea.removeEventListener("mouseMove", onTapMove);
            TweenMax.killTweensOf(_thumb);
            emit(GameEvent.CloseDemo);
        }


    }
}//package modules.mapEditor.joystick

