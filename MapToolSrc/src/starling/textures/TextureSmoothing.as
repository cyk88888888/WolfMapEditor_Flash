// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.textures.TextureSmoothing

package starling.textures
{
    import starling.errors.AbstractClassError;

    public class TextureSmoothing 
    {

        public static const NONE:String = "none";
        public static const BILINEAR:String = "bilinear";
        public static const TRILINEAR:String = "trilinear";

        public function TextureSmoothing()
        {
            throw (new AbstractClassError());
        }

        public static function isValid(_arg_1:String):Boolean
        {
            return (((_arg_1 == "none") || (_arg_1 == "bilinear")) || (_arg_1 == "trilinear"));
        }


    }
}//package starling.textures

