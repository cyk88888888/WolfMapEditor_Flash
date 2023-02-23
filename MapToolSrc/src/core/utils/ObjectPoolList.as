// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//core.utils.ObjectPoolList

package core.utils
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;

    public final class ObjectPoolList 
    {

        public static var dic:Dictionary = new Dictionary();
        public static var DBG:Boolean = false;

        private var _type:Class;
        private var _pool:Vector.<Object> = new Vector.<Object>();
        public var allocCount:uint = 0;
        public var obj_using:Vector.<Object> = new Vector.<Object>();

        public function ObjectPoolList(_arg_1:Class):void
        {
            _type = _arg_1;
            dic[_arg_1] = this;
        }

        public static function debugOut():void
        {
            var _local_3:* = null;
            var _local_1:uint;
            var _local_2:int;
            var _local_6:* = null;
            var _local_8:int;
            var _local_5:* = null;
            traceInl1("======");
            var _local_4:Array = [];
            for (var _local_7:* in dic)
            {
                _local_3 = dic[_local_7];
                _local_1 = _local_3.allocCount;
                _local_2 = (_local_1 - _local_3._pool.length);
                _local_6 = ((((("Pool:" + _local_2) + "/") + _local_1) + "  ") + _local_7);
                _local_4.push({
                    "using":_local_2,
                    "msg":_local_6
                });
            };
            _local_4.sortOn("using", 16);
            _local_8 = 0;
            while (_local_8 < _local_4.length)
            {
                _local_5 = _local_4[_local_8];
                traceInl1(_local_5.msg);
                _local_8++;
            };
        }


        public function Alloc(_arg_1:Class=null, _arg_2:Boolean=false):*
        {
            var _local_3:* = null;
            if (_pool.length == 0)
            {
                allocCount++;
                _local_3 = new _type();
            }
            else
            {
                _local_3 = _pool.pop();
            };
            if (((DBG) || (_arg_2)))
            {
                obj_using.push(_local_3);
            };
            return (_local_3);
        }

        public function Release(_arg_1:*, _arg_2:Boolean=false):void
        {
            if (((DBG) || (_arg_2)))
            {
                obj_using.splice(obj_using.indexOf(_arg_1), 1);
            };
            DbgUtil.assert(((_pool.indexOf(_arg_1) == -1) || ("obj already in pool")));
            _pool.push(_arg_1);
        }


    }
}//package core.utils

