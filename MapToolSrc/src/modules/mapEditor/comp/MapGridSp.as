// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.mapEditor.comp.MapGridSp

package modules.mapEditor.comp
{
    import flash.display.Sprite;

    public class MapGridSp extends Sprite 
    {


        public function drawRect(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number):void
        {
            graphics.clear();
            graphics.beginFill(_arg_5, 0.5);
            graphics.drawRect(_arg_1, _arg_2, _arg_3, _arg_4);
            graphics.endFill();
        }

        public function drawCircle(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            graphics.clear();
            graphics.beginFill(_arg_4, 0.5);
            graphics.drawCircle(_arg_1, _arg_2, _arg_3);
            graphics.endFill();
        }


    }
}//package modules.mapEditor.comp

