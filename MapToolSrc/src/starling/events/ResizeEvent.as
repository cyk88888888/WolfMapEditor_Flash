// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.events.ResizeEvent

package starling.events
{
    import flash.geom.Point;

    public class ResizeEvent extends Event 
    {

        public static const RESIZE:String = "resize";

        public function ResizeEvent(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_4, new Point(_arg_2, _arg_3));
        }

        public function get width():int
        {
            return ((data as Point).x);
        }

        public function get height():int
        {
            return ((data as Point).y);
        }


    }
}//package starling.events

