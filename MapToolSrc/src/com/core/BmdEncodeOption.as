// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.BmdEncodeOption

package com.core
{
    import flash.display.JPEGXREncoderOptions;
    import flash.display.PNGEncoderOptions;

    public class BmdEncodeOption 
    {

        public static var quality:int = 85;
        public static var jpegxrEncoderOptions:JPEGXREncoderOptions = new JPEGXREncoderOptions((100 - quality));
        public static var pngEncoderOptions:PNGEncoderOptions = new PNGEncoderOptions();


    }
}//package com.core

