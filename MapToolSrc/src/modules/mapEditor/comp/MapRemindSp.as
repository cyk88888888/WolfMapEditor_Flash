// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.mapEditor.comp.MapRemindSp

package modules.mapEditor.comp
{
    import flash.display.Sprite;
    import com.greensock.TweenMax;

    public class MapRemindSp extends Sprite 
    {


        public function drawRect(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            graphics.beginFill(0xFF0000, 0.8);
            graphics.drawRect(_arg_1, _arg_2, _arg_3, _arg_4);
            graphics.endFill();
            this.alpha = 0;
            doAlphaTween();
        }

        private function doAlphaTween():void
        {
            TweenMax.to(this, 0.4, {
                "alpha":1,
                "repeat":4,
                "yoyo":true,
                "onComplete":rmSelf
            });
        }

        public function rmSelf():void
        {
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
            TweenMax.killTweensOf(this);
        }


    }
}//package modules.mapEditor.comp

