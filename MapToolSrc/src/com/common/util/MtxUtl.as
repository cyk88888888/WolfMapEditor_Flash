// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.common.util.MtxUtl

package com.common.util
{
    import flash.geom.Matrix;

    public class MtxUtl 
    {

        private static var tmp:Matrix = new Matrix();


        public static function setTr(_arg_1:Matrix, _arg_2:Number, _arg_3:Number):Matrix
        {
            _arg_1.tx = _arg_2;
            _arg_1.ty = _arg_3;
            return (_arg_1);
        }

        public static function New(_arg_1:Number=1, _arg_2:Number=0, _arg_3:Number=0, _arg_4:Number=1, _arg_5:Number=0, _arg_6:Number=0):Matrix
        {
            tmp.a = _arg_1;
            tmp.b = _arg_2;
            tmp.c = _arg_3;
            tmp.d = _arg_4;
            tmp.tx = _arg_5;
            tmp.ty = _arg_6;
            return (tmp);
        }


    }
}//package com.common.util

