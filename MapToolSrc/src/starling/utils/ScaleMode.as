// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.ScaleMode

package starling.utils
{
    import starling.errors.AbstractClassError;

    public class ScaleMode 
    {

        public static const NONE:String = "none";
        public static const NO_BORDER:String = "noBorder";
        public static const SHOW_ALL:String = "showAll";

        public function ScaleMode()
        {
            throw (new AbstractClassError());
        }

        public static function isValid(_arg_1:String):Boolean
        {
            return (((_arg_1 == "none") || (_arg_1 == "noBorder")) || (_arg_1 == "showAll"));
        }


    }
}//package starling.utils

