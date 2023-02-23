// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.textures.ConcreteVideoTexture

package starling.textures
{
    import starling.textures.ConcreteTexture;
    import flash.utils.getQualifiedClassName;
    import flash.display3D.textures.TextureBase;
    import starling.textures.*;

    internal class ConcreteVideoTexture extends ConcreteTexture 
    {

        public function ConcreteVideoTexture(_arg_1:TextureBase, _arg_2:Number=1)
        {
            var _local_5:String = "bgra";
            var _local_4:Number = (("videoWidth" in _arg_1) ? _arg_1["videoWidth"] : 0);
            var _local_3:Number = (("videoHeight" in _arg_1) ? _arg_1["videoHeight"] : 0);
            super(_arg_1, _local_5, _local_4, _local_3, false, false, false, _arg_2, false);
            if (getQualifiedClassName(_arg_1) != "flash.display3D.textures::VideoTexture")
            {
                throw (new ArgumentError("'base' must be VideoTexture"));
            };
        }

        override public function get nativeWidth():Number
        {
            return (base["videoWidth"]);
        }

        override public function get nativeHeight():Number
        {
            return (base["videoHeight"]);
        }

        override public function get width():Number
        {
            return (nativeWidth / scale);
        }

        override public function get height():Number
        {
            return (nativeHeight / scale);
        }


    }
}//package starling.textures

