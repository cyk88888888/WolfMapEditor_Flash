// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.HAlign

package starling.utils
{
    import starling.errors.AbstractClassError;

    public final class HAlign 
    {

        public static const LEFT:String = "left";
        public static const CENTER:String = "center";
        public static const RIGHT:String = "right";

        public function HAlign()
        {
            throw (new AbstractClassError());
        }

        public static function isValid(_arg_1:String):Boolean
        {
            return (((_arg_1 == "left") || (_arg_1 == "center")) || (_arg_1 == "right"));
        }


    }
}//package starling.utils

