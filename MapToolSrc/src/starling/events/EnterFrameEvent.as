// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.events.EnterFrameEvent

package starling.events
{
    public class EnterFrameEvent extends Event 
    {

        public static const ENTER_FRAME:String = "enterFrame";

        public function EnterFrameEvent(_arg_1:String, _arg_2:Number, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_2);
        }

        public function get passedTime():Number
        {
            return (data as Number);
        }


    }
}//package starling.events

