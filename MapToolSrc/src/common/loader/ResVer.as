// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//common.loader.ResVer

package common.loader
{
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import com.common.util.MD5Hash16;
    import com.carlcalderon.arthropod.Debug;
    import common.util.StrUtils;
    import core.utils.DbgUtil;

    public class ResVer 
    {

        public static const NOT_INIT:String = "?rUnknown";
        public static const NONE_EXIST:String = null;

        public static var err:Dictionary = new Dictionary();
        public static var ignoreCheck:Boolean;
        public static var vers:Dictionary;
        public static var debugV:String = null;
        public static var resRoot:String = "";


        public static function parseVsBin(_arg_1:ByteArray):Dictionary
        {
            var _local_3:* = null;
            var _local_4:uint;
            var _local_6:uint;
            var _local_5:Dictionary = new Dictionary();
            var _local_2:uint = _arg_1.readUnsignedInt();
            while (_arg_1.bytesAvailable)
            {
                _local_3 = _arg_1.readUTF();
                _local_4 = _arg_1.readUnsignedInt();
                _local_6 = _arg_1.readUnsignedInt();
                _local_5[_local_3] = {
                    "ver":_local_4,
                    "size":_local_6
                };
            };
            return (_local_5);
        }

        public static function getFileSize(_arg_1:String):uint
        {
            if (vers == null)
            {
                return (0);
            };
            var _local_2:Object = getFileInfo(_arg_1);
            if (_local_2 == null)
            {
                return (0);
            };
            return (_local_2.size);
        }

        private static function getFileInfo(_arg_1:String):Object
        {
            var _local_2:String = MD5Hash16.eval(_arg_1);
            var _local_3:Object = vers[_local_2];
            if (_local_3 == null)
            {
                if (((trace_load) && (err[_arg_1] == undefined)))
                {
                    Debug.error(("fileNotExist:" + _arg_1));
                    err[_arg_1] = 1;
                };
            };
            return (_local_3);
        }

        public static function isFileExist(_arg_1:String):Boolean
        {
            if (vers == null)
            {
                return (true);
            };
            return (!(getFileInfo(_arg_1) == null));
        }

        public static function getVer(_arg_1:String):String
        {
            if (debugV != null)
            {
                return (debugV);
            };
            if (ignoreCheck)
            {
                return ("?rUnknown");
            };
            if (vers == null)
            {
                return ("?rUnknown");
            };
            var _local_2:Object = getFileInfo(_arg_1);
            if (_local_2)
            {
                return ("?v=" + _local_2.ver);
            };
            return (null);
        }

        public static function format(_arg_1:String):String
        {
            if (_arg_1.indexOf("\\") == -1)
            {
                return (_arg_1);
            };
            return (_arg_1.replace(/\\/g, "/"));
        }

        public static function prependResRoot(_arg_1:String):String
        {
            var _local_2:String = toRelativeUrl(_arg_1);
            return (resRoot + _local_2);
        }

        public static function toRelativeUrl(_arg_1:String):String
        {
            var _local_2:* = _arg_1;
            if (((StrUtils.isValidStr(resRoot)) && (!(_local_2.indexOf(resRoot) == -1))))
            {
                DbgUtil.assert("必须相对路径");
                _local_2 = _local_2.replace(resRoot, "");
            };
            return (_local_2);
        }


    }
}//package common.loader

