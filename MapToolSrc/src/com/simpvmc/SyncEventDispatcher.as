// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.simpvmc.SyncEventDispatcher

package com.simpvmc
{
    import com.common.util.ArrayUtils;

    public class SyncEventDispatcher 
    {

        private static var _temp:Array = [];

        private var _typeListeners:Object = {};


        private static function cloneArr(_arg_1:Array):Array
        {
            var _local_4:int;
            var _local_3:int;
            var _local_2:Array = getTempArr();
            _local_4 = 0;
            _local_3 = _arg_1.length;
            while (_local_4 < _local_3)
            {
                _local_2[_local_4] = _arg_1[_local_4];
                _local_4++;
            };
            return (_local_2);
        }

        private static function getTempArr():Array
        {
            if (_temp.length)
            {
                return (_temp.pop());
            };
            return ([]);
        }

        private static function pushTempArr(_arg_1:Array):void
        {
            _arg_1.length = 0;
            if (_temp.length < 50)
            {
                _temp.push(_arg_1);
            };
        }


        public function addEventListener(_arg_1:String, _arg_2:Function):void
        {
            if (_typeListeners[_arg_1] == null)
            {
                _typeListeners[_arg_1] = [];
            };
            var _local_3:Array = _typeListeners[_arg_1];
            if (_local_3.indexOf(_arg_2) > -1)
            {
                return;
            };
            _local_3.push(_arg_2);
        }

        private function getTypeListerners(_arg_1:String):Array
        {
            return (_typeListeners[_arg_1]);
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function):void
        {
            var _local_4:Array = _typeListeners[_arg_1];
            if (_local_4 == null)
            {
                return;
            };
            var _local_3:int = _local_4.indexOf(_arg_2);
            if (_local_3 < 0)
            {
                return;
            };
            ArrayUtils.removeAt(_local_4, _local_3);
        }

        public function dispatch(_arg_1:String):void
        {
            dispatchEvent(new SEvent(_arg_1));
        }

        public function dispatchEvent(_arg_1:SEvent, _arg_2:Object=null):Boolean
        {
            if (_arg_1.target == null)
            {
                _arg_1.target = _arg_2;
            };
            var _local_5:String = _arg_1.type;
            if (_typeListeners[_local_5] == null)
            {
                return (false);
            };
            var _local_4:Array = cloneArr(_typeListeners[_local_5]);
            for each (var _local_3:Function in _local_4)
            {
                if (_local_3 != null)
                {
                    (_local_3(_arg_1));
                };
            };
            pushTempArr(_local_4);
            return (false);
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            if (_typeListeners[_arg_1] == null)
            {
                return (false);
            };
            var _local_2:Array = _typeListeners[_arg_1];
            if (_local_2.length == 0)
            {
                return (false);
            };
            return (true);
        }


    }
}//package com.simpvmc

