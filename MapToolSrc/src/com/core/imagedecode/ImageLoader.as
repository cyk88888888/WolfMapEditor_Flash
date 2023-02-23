// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.imagedecode.ImageLoader

package com.core.imagedecode
{
    import flash.display.Loader;
    import flash.utils.ByteArray;

    public class ImageLoader extends Loader 
    {

        public var bytes:ByteArray;

        public function ImageLoader(_arg_1:ByteArray)
        {
            this.bytes = _arg_1;
            super();
        }

    }
}//package com.core.imagedecode

