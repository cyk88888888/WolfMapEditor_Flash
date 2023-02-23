// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.NetStatistics

package com.core.loader
{
    import flash.utils.Dictionary;

    public class NetStatistics 
    {

        public static var loadedBytes:Dictionary = new Dictionary();


        public static function setLoadedBytes(_arg_1:String, _arg_2:uint):void
        {
            loadedBytes[_arg_1] = _arg_2;
        }

        public static function getLoadedBytes():uint
        {
            var _local_1:uint;
            for each (var _local_2:uint in loadedBytes)
            {
                _local_1 = (_local_1 + _local_2);
            };
            return (_local_1);
        }


    }
}//package com.core.loader

