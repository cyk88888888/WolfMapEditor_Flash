// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.IResLoaderHandler

package com.core.loader
{
    import flash.utils.ByteArray;

    public /*dynamic*/ interface IResLoaderHandler 
    {

        function onStreamLoadComplete(_arg_1:String, _arg_2:ByteArray):void;
        function onProgress(_arg_1:String, _arg_2:Number, _arg_3:Number):void;
        function onError(_arg_1:String, _arg_2:Boolean, _arg_3:Boolean=true):void;
        function retryLoad(_arg_1:String, _arg_2:Boolean=true):void;

    }
}//package com.core.loader

