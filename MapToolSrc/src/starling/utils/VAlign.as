// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.VAlign

package starling.utils
{
    import starling.errors.AbstractClassError;

    public final class VAlign 
    {

        public static const TOP:String = "top";
        public static const CENTER:String = "center";
        public static const BOTTOM:String = "bottom";

        public function VAlign()
        {
            throw (new AbstractClassError());
        }

        public static function isValid(_arg_1:String):Boolean
        {
            return (((_arg_1 == "top") || (_arg_1 == "center")) || (_arg_1 == "bottom"));
        }


    }
}//package starling.utils

