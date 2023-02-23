// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.imagedecode.DecodeItem

package com.core.imagedecode
{
    import core.utils.ObjectPoolList;
    import flash.utils.ByteArray;
    import flash.display.LoaderInfo;

    public class DecodeItem 
    {

        public static var ObjectPool:ObjectPoolList;

        public var bytes:ByteArray;
        public var joinAppDomain:Boolean;
        public var callBack:Function;
        public var dbgInfo:String;
        private var _priority:int;


        public static function NEW():DecodeItem
        {
            if (!ObjectPool)
            {
                ObjectPool = new ObjectPoolList(DecodeItem);
            };
            return (ObjectPool.Alloc(DecodeItem));
        }

        public static function FREE(_arg_1:DecodeItem):void
        {
            _arg_1.dispose();
            ObjectPool.Release(_arg_1);
        }


        public function dispose():void
        {
            bytes = null;
            joinAppDomain = false;
            callBack = null;
            dbgInfo = null;
        }

        public function init(_arg_1:ByteArray, _arg_2:Boolean, _arg_3:Function, _arg_4:String):void
        {
            this.bytes = _arg_1;
            this.joinAppDomain = _arg_2;
            this.callBack = _arg_3;
            this.dbgInfo = _arg_4;
        }

        public function complete(_arg_1:LoaderInfo):void
        {
            this.callBack(_arg_1, this.bytes);
        }

        public function set priority(_arg_1:int):void
        {
            _priority = _arg_1;
        }

        public function get priority():int
        {
            return (_priority);
        }


    }
}//package com.core.imagedecode

