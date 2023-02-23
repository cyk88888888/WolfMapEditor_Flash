// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//common.def.TimeConst

package common.def
{
    public class TimeConst 
    {

        public static const MSEL:uint = 1000;
        public static const FPS:uint = 60;
        public static const UI_FRAME_RATE:uint = 60;
        public static const MS_PER_FRAME:Number = 16.6666666666667;
        public static const MINUTES:uint = 60000;

        public static var REL_TIME_MS:Number = new Date(2016, 3, 11).time;


        public static function convertTime(_arg_1:uint):Number
        {
            return (REL_TIME_MS + (_arg_1 * 100));
        }

        public static function getMSTimeDiff(_arg_1:uint, _arg_2:uint):uint
        {
            if (_arg_2 > _arg_1)
            {
                return (((~(_arg_2)) + _arg_1) + 1);
            };
            return (_arg_1 - _arg_2);
        }


    }
}//package common.def

