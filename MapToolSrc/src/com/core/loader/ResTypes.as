// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.ResTypes

package com.core.loader
{
    import flash.utils.Dictionary;
    import com.core.loader.task.BMPTask;
    import com.core.loader.task.SSPTask;
    import com.core.loader.task.SWFTask;

    public class ResTypes 
    {

        public static var _resTypeMap:Dictionary = new Dictionary();
        private static var _resTaskMap:Object = {};


        public static function regResParser(_arg_1:String, _arg_2:Class):void
        {
            _arg_1 = _arg_1.toLowerCase();
            if (((_resTypeMap.hasOwnProperty(_arg_1)) && (!(_resTypeMap[_arg_1] == _arg_2))))
            {
                throw (new Error((("重复为" + _arg_1) + "注册不同类型资源解析器")));
            };
            _resTypeMap[_arg_1] = _arg_2;
        }

        public static function getType(_arg_1:String):Class
        {
            var _local_2:String = _arg_1.substring((_arg_1.lastIndexOf(".") + 1)).toLowerCase();
            if (_local_2.indexOf("?") > -1)
            {
                _local_2 = _local_2.substring(0, _local_2.indexOf("?"));
            };
            return (_resTypeMap[_local_2]);
        }

        public static function regResTypes():void
        {
            regResTask("jpeg", BMPTask);
            regResTask("jpg", BMPTask);
            regResTask("png", BMPTask);
            regResTask("ssp", SSPTask);
            regResTask("swf", SWFTask);
        }

        public static function regResTask(_arg_1:String, _arg_2:Class):void
        {
            _arg_1 = _arg_1.toLowerCase();
            if (((_resTaskMap.hasOwnProperty(_arg_1)) && (!(_resTaskMap[_arg_1] == _arg_2))))
            {
                throw (new Error((("重复为" + _arg_1) + "注册不同类型资源解析器")));
            };
            _resTaskMap[_arg_1] = _arg_2;
        }

        public static function getTask(_arg_1:String):Class
        {
            var _local_2:String = _arg_1.substring((_arg_1.lastIndexOf(".") + 1)).toLowerCase();
            if (_local_2.indexOf("?") > -1)
            {
                _local_2 = _local_2.substring(0, _local_2.indexOf("?"));
            };
            return (_resTaskMap[_local_2]);
        }


    }
}//package com.core.loader

