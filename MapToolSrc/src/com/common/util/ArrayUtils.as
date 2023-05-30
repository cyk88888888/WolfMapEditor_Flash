// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.common.util.ArrayUtils

package com.common.util
{
    import flash.utils.Dictionary;

    public class ArrayUtils 
    {

        private static var supportAPI708Checked:Boolean = false;
        private static var supportAPI708:Boolean = false;


        public static function unique(_arg_1:Array):Array
        {
            var _local_3:Array = [];
            var _local_2:Object = {};
            for each (var _local_4:* in _arg_1)
            {
                if (!_local_2[_local_4])
                {
                    _local_3.push(_local_4);
                    _local_2[_local_4] = true;
                };
            };
            return (_local_3);
        }

        public static function append(_arg_1:Array, _arg_2:Array, _arg_3:Boolean=false):void
        {
            var _local_5:int;
            var _local_4:*;
            _local_5 = 0;
            while (_local_5 < _arg_2.length)
            {
                _local_4 = _arg_2[_local_5];
                if (((!(_arg_3)) || (_arg_1.indexOf(_local_4) == -1)))
                {
                    _arg_1.push(_local_4);
                };
                _local_5++;
            };
        }

        public static function merge2(_arg_1:Array, _arg_2:Array):void
        {
            var _local_4:int;
            var _local_3:*;
            _local_4 = 0;
            while (_local_4 < _arg_2.length)
            {
                _local_3 = _arg_2[_local_4][0];
                if (_arg_1.indexOf(_local_3) == -1)
                {
                    _arg_1.push(_local_3);
                };
                _local_4++;
            };
        }

        public static function isIndex(_arg_1:Array, _arg_2:*, ... _args):int
        {
            var _local_6:* = null;
            var _local_9:*;
            var _local_5:Number;
            var _local_7:Number;
            var _local_4:int = -1;
            var _local_8:* = _args;
            _local_5 = 0;
            while (_local_5 < _arg_1.length)
            {
                _local_6 = _arg_1[_local_5];
                _local_7 = 0;
                while (_local_7 < _local_8.length)
                {
                    if (_local_8.length != (_local_7 + 1))
                    {
                        _local_6 = _local_6[_local_8[_local_7]];
                    }
                    else
                    {
                        _local_9 = _local_6[_local_8[_local_7]];
                    };
                    _local_7++;
                };
                switch (true)
                {
                    case (_arg_2 is Array):
                        if (_arg_2.toString() == _local_9.toString())
                        {
                            _local_4 = _local_5;
                        };
                        break;
                    default:
                        if (_arg_2 == _local_9)
                        {
                            _local_4 = _local_5;
                        };
                };
                if (-1 != _local_4) break;
                _local_5++;
            };
            return (_local_4);
        }

        public static function toArray(_arg_1:*):Array
        {
            var _local_3:Array = [];
            for each (var _local_2:Object in _arg_1)
            {
                _local_3.push(_local_2);
            };
            return (_local_3);
        }

        public static function vector2ary(_arg_1:Object):Array
        {
            var _local_3:int;
            var _local_2:Array = [];
            _local_3 = 0;
            while (_local_3 < _arg_1.length)
            {
                _local_2.push(_arg_1[_local_3]);
                _local_3++;
            };
            return (_local_2);
        }

        public static function arrayToVector(_arg_1:Array, _arg_2:*):*
        {
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < _arg_1.length)
            {
                _arg_2.push(_arg_1[_local_3]);
                _local_3++;
            };
            return (_arg_2);
        }

        public static function filterWrapper(prop:String, value:*, eq:Boolean=true):Function
        {
            var rslt:Function = function (_arg_1:Object, _arg_2:int, _arg_3:Array):Boolean
            {
                var _local_4:* = (_arg_1[prop] == value);
                return (_local_4 == eq);
            };
            return (rslt);
        }

        public static function isInContainer(_arg_1:Object, _arg_2:*):Boolean
        {
            for each (var _local_3:Object in _arg_1)
            {
                if (_local_3 == _arg_2)
                {
                    return (true);
                };
            };
            return (false);
        }

        public static function setVal(_arg_1:Array, _arg_2:String, _arg_3:*):void
        {
            var _local_5:int;
            var _local_4:* = null;
            _local_5 = 0;
            while (_local_5 < _arg_1.length)
            {
                _local_4 = _arg_1[_local_5];
                if (_local_4[_arg_2] == _arg_3[_arg_2])
                {
                    _arg_1.splice(_local_5, 1);
                };
                _local_5++;
            };
            _arg_1.push(_arg_3);
        }

        public static function findInContainer(_arg_1:Object, _arg_2:String, _arg_3:*):Object
        {
            for each (var _local_4:Object in _arg_1)
            {
                if (_local_4[_arg_2] == _arg_3)
                {
                    return (_local_4);
                };
            };
            return (null);
        }

        public static function isInArray(_arg_1:Array, _arg_2:String, _arg_3:*):*
        {
            var _local_5:* = null;
            var _local_4:int;
            while (_local_4 < _arg_1.length)
            {
                _local_5 = _arg_1[_local_4];
                if (_local_5 != null)
                {
                    if (_local_5.hasOwnProperty(_arg_2))
                    {
                        if (_local_5[_arg_2] == _arg_3)
                        {
                            return (_local_5);
                        };
                    }
                    else
                    {
                        if (_local_5 == _arg_3)
                        {
                            return (_local_5);
                        };
                    };
                };
                _local_4++;
            };
            return (null);
        }

        public static function indexOf(_arg_1:Object, _arg_2:String, _arg_3:Object):int
        {
            var _local_5:int;
            var _local_4:*;
            if (_arg_1 == null)
            {
                return (-1);
            };
            _local_5 = 0;
            while (_local_5 < _arg_1["length"])
            {
                _local_4 = _arg_1[_local_5];
                if (_local_4[_arg_2] == _arg_3)
                {
                    return (_local_5);
                };
                _local_5++;
            };
            return (-1);
        }

        public static function isArrayEqual(_arg_1:Array, _arg_2:Array):Boolean
        {
            var _local_4:int;
            var _local_3:Boolean = true;
            if (_arg_1.length == _arg_2.length)
            {
                _local_4 = 0;
                while (_local_4 < _arg_1.length)
                {
                    if (_arg_1[_local_4] != _arg_2[_local_4])
                    {
                        _local_3 = false;
                        break;
                    };
                    _local_4++;
                };
            }
            else
            {
                _local_3 = false;
            };
            return (_local_3);
        }

        public static function createArithmeticalProgression(_arg_1:int, _arg_2:int, _arg_3:int=1):Array
        {
            var _local_6:int;
            var _local_5:Array = [];
            var _local_4:* = _arg_1;
            _local_6 = 0;
            while (_local_6 < _arg_2)
            {
                _local_5.push(_local_4);
                _local_4 = (_local_4 + _arg_3);
                _local_6++;
            };
            return (_local_5);
        }

        public static function randomExtract(_arg_1:Array):*
        {
            var _local_2:Number = randArrayIdx(_arg_1);
            return (_arg_1[_local_2]);
        }

        public static function randArrayIdx(_arg_1:Array):uint
        {
            return (uint(Math.floor((Math.random() * _arg_1.length))));
        }

        public static function randomArray(_arg_1:Array):void
        {
            var _local_4:int;
            var _local_2:int;
            var _local_3:int = _arg_1.length;
            _local_4 = 0;
            while (_local_4 < _local_3)
            {
                _local_2 = ((Math.random() * _local_3) >> 0);
                swapElement(_arg_1, _local_4, _local_2);
                _local_4 = (_local_4 + 1);
            };
        }

        private static function swapElement(_arg_1:Array, _arg_2:int, _arg_3:int):void
        {
            var _local_4:Object = _arg_1[_arg_2];
            _arg_1[_arg_2] = _arg_1[_arg_3];
            _arg_1[_arg_3] = _local_4;
        }

        public static function pushToArrayInDic(_arg_1:Dictionary, _arg_2:Object, _arg_3:Object):void
        {
            var _local_4:Array = _arg_1[_arg_2];
            if (_local_4.indexOf(_arg_3) == -1)
            {
                _local_4.push(_arg_3);
            };
        }

        public static function removeFromArrayInDic(_arg_1:Dictionary, _arg_2:int, _arg_3:Function):void
        {
            var _local_5:Array = _arg_1[_arg_2];
            if (_local_5 == null)
            {
                return;
            };
            var _local_4:int = _local_5.indexOf(_arg_3);
            if (_local_4 == -1)
            {
                return;
            };
            _local_5.splice(_local_4, 1);
        }

        public static function lengthOfDic(_arg_1:Dictionary):uint
        {
            var _local_2:uint;
            for each (var _local_3:Object in _arg_1)
            {
                _local_2++;
            };
            return (_local_2);
        }

        public static function dic2ary(_arg_1:Dictionary, _arg_2:String=null, _arg_3:Object=null):Array
        {
            var _local_4:Array = [];
            for each (var _local_5:Object in _arg_1)
            {
                if (_arg_2 != null)
                {
                    if (_local_5[_arg_2] != _arg_3) continue;
                };
                _local_4.push(_local_5);
            };
            return (_local_4);
        }

        public static function clear(_arg_1:Object):void
        {
            if (!_arg_1)
            {
                return;
            };
            for (var _local_2:Object in _arg_1)
            {
                _arg_1[_local_2] = null;
                delete _arg_1[_local_2];
            };
        }

        public static function analyzeStrToArrByGap(_arg_1:String, _arg_2:uint):Array
        {
            var _local_7:uint;
            var _local_8:uint;
            var _local_3:* = null;
            var _local_4:Array = [];
            if (((_arg_1 == "") || (_arg_1 == null)))
            {
                return (_local_4);
            };
            var _local_5:Array = _arg_1.split(",");
            var _local_6:uint = uint((_local_5.length / _arg_2));
            _local_8 = 0;
            while (_local_8 < _local_6)
            {
                _local_3 = [];
                _local_7 = 0;
                while (_local_7 < _arg_2)
                {
                    _local_3.push(_local_5[((_local_8 * _arg_2) + _local_7)]);
                    _local_7++;
                };
                _local_4.push(_local_3);
                _local_8++;
            };
            return (_local_4);
        }

        public static function removeAt(_arg_1:Object, _arg_2:uint):*
        {
            if (!supportAPI708Checked)
            {
                if (_arg_1.hasOwnProperty("removeAt"))
                {
                    supportAPI708 = true;
                };
                supportAPI708Checked = true;
            };
            var _local_3:* = _arg_1[_arg_2];
            if (supportAPI708)
            {
                _arg_1.removeAt(_arg_2);
            }
            else
            {
                _arg_1.splice(_arg_2, 1);
            };
            return (_local_3);
        }

        public static function ePush(_arg_1:*, _arg_2:*):void
        {
            var _local_4:*;
            var _local_3:Number = _arg_1.indexOf(null);
            ((_local_3 == -1) ? _arg_1.push(_arg_2) : ((_local_4 = _arg_2), (_arg_1[_local_3] = _local_4), _local_4)); //not popped
        }

        public static function ePop(_arg_1:*):*
        {
            var _local_2:*;
            var _local_3:int;
            _local_3 = (_arg_1.length - 1);
            while (_local_3 >= 0)
            {
                if (_arg_1[_local_3] != null)
                {
                    _local_2 = _arg_1[_local_3];
                    _arg_1[_local_3] = null;
                    return (_local_2);
                };
                _local_3--;
            };
            return (null);
        }

        public static function eClear(_arg_1:*):void
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < _arg_1.length)
            {
                _arg_1[_local_2] = null;
                _local_2++;
            };
        }

        public static function eRemove(_arg_1:*, _arg_2:*):void
        {
            var _local_3:int = _arg_1.indexOf(_arg_2);
            if (_local_3 > -1)
            {
                _arg_1[_local_3] = null;
            };
        }

        public static function eLen(_arg_1:*):uint
        {
            var _local_4:int;
            var _local_3:*;
            var _local_2:uint;
            _local_4 = 0;
            while (_local_4 < _arg_1.length)
            {
                _local_3 = _arg_1[_local_4];
                if (_local_3 != null)
                {
                    _local_2++;
                };
                _local_4++;
            };
            return (_local_2);
        }

        public static function randRange(_arg_1:Number, _arg_2:Number):Number
        {
            return (Math.floor((Math.random() * ((_arg_2 - _arg_1) + 1))) + _arg_1);
        }

        public static function getPageArr(_arg_1:int, _arg_2:int, _arg_3:Array):Array
        {
            var _local_6:int;
            var _local_4:uint = ((_arg_1 - 1) * _arg_2);
            var _local_5:Array = [];
            _local_6 = 0;
            while (_local_6 < _arg_2)
            {
                if ((_local_4 + _local_6) <= (_arg_3.length - 1))
                {
                    _local_5.push(_arg_3[(_local_4 + _local_6)]);
                };
                _local_6++;
            };
            return (_local_5);
        }

        public static function shiftArray(_arg_1:Array, _arg_2:int=1):Array
        {
            if (((!(_arg_1)) || (!(_arg_1.length))))
            {
                return (_arg_1);
            };
            return (_arg_1.slice(_arg_2));
        }


    }
}//package com.common.util

