// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.mapEditor.comp.MapThingSelectSp

package modules.mapEditor.comp
{
    import flash.display.Sprite;
    import com.greensock.TweenMax;

    public class MapThingSelectSp extends Sprite 
    {

        public var curX:Number;
        public var curY:Number;
        private var _isInPlaying:Boolean;
        public var isShow:Boolean;


        public function drawRectLine(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            graphics.clear();
            graphics.lineStyle(2, 0xFF0000);
            graphics.moveTo(_arg_1, _arg_2);
            graphics.lineTo((_arg_1 + _arg_3), _arg_2);
            graphics.lineTo((_arg_1 + _arg_3), (_arg_2 + _arg_4));
            graphics.lineTo(_arg_1, (_arg_2 + _arg_4));
            graphics.lineTo(_arg_1, _arg_2);
            curX = _arg_1;
            curY = _arg_2;
            isShow = true;
            if (!_isInPlaying)
            {
                _isInPlaying = true;
                TweenMax.killTweensOf(this);
                this.alpha = 0.2;
                doAlphaTween();
            };
        }

        private function doAlphaTween():void
        {
            TweenMax.to(this, 0.5, {
                "alpha":1,
                "repeat":-1,
                "yoyo":true
            });
        }

        public function rmSelf():void
        {
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            TweenMax.killTweensOf(this);
            _isInPlaying = false;
            isShow = false;
        }


    }
}//package modules.mapEditor.comp

