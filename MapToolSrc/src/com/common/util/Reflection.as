// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.common.util.Reflection

package com.common.util
{
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;
    import flash.utils.describeType;
    import flash.net.registerClassAlias;
    import flash.utils.getDefinitionByName;
    import flash.utils.ByteArray;

    public class Reflection 
    {

        public static var dicEnum2Name:Dictionary = new Dictionary();


        public static function getObjCls(_arg_1:Object):Class
        {
            if (_arg_1 == null)
            {
                return (null);
            };
            return (Object(_arg_1).constructor);
        }

        public static function getObjClsName(_arg_1:Object):String
        {
            var _local_4:String = getQualifiedClassName(_arg_1);
            var _local_3:int = _local_4.lastIndexOf("::");
            if (_local_3 == -1)
            {
                return (_local_4);
            };
            return (_local_4.substr((_local_3 + 2)));
        }

        public static function staticVal2FieldName(_arg_1:Class, _arg_2:RegExp=null):Dictionary
        {
            var _local_7:* = null;
            var _local_3:int;
            var _local_5:*;
            if (dicEnum2Name[_arg_1])
            {
                return (dicEnum2Name[_arg_1]);
            };
            var _local_4:Dictionary = new Dictionary();
            var _local_8:XMLList = describeType(_arg_1).child("constant");
            for each (var _local_6:XML in _local_8)
            {
                _local_7 = _local_6.attribute("name");
                if (_arg_2)
                {
                    _local_5 = _arg_2.exec(_local_7);
                    if (_local_5 == null)
                    {
                        doTrace(("staticFieldName:" + _local_7));
                        continue;
                    };
                };
                _local_3 = _arg_1[_local_7];
                if (_local_4[_local_3] != null)
                {
                    var _local_9:* = _local_3;
                    var _local_10:* = (_local_4[_local_9] + ("|" + _local_7));
                    _local_4[_local_9] = _local_10;
                }
                else
                {
                    _local_4[_local_3] = _local_7;
                };
            };
            dicEnum2Name[_arg_1] = _local_4;
            return (_local_4);
        }

        public static function copyObject(_arg_1:*):*
        {
            (registerClassAlias(getQualifiedClassName(_arg_1), (getDefinitionByName(getQualifiedClassName(_arg_1)) as Class)));
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeObject(_arg_1);
            _local_2.position = 0;
            return (_local_2.readObject());
        }


    }
}//package com.common.util

