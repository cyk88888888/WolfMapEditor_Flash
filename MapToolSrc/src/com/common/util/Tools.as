// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.common.util.Tools

package com.common.util
{
    import flash.geom.Point;
    import flash.utils.ByteArray;

    public class Tools 
    {


        public static function order_array(_arg_1:int, _arg_2:int=0, _arg_3:Number=1):Array
        {
            var _local_5:int;
            var _local_4:Array = new Array(_arg_1);
            _local_5 = 0;
            while (_local_5 < _arg_1)
            {
                _local_4[_local_5] = (_arg_2 + (_local_5 * _arg_3));
                _local_5++;
            };
            return (_local_4);
        }

        public static function random_array(_arg_1:int, _arg_2:int, _arg_3:int=0, _arg_4:Boolean=true):Array
        {
            var _local_6:* = null;
            var _local_5:Array = [];
            if (_arg_4)
            {
                _local_6 = order_array((_arg_2 - _arg_3), _arg_3);
                while (_local_5.length < _arg_1)
                {
                    _local_5.push(_local_6.splice((Math.random() * _local_6.length), 1)[0]);
                };
            }
            else
            {
                while (_local_5.length < _arg_1)
                {
                    _local_5.push((int((Math.random() * (_arg_2 - _arg_3))) + _arg_3));
                };
            };
            return (_local_5);
        }

        public static function fmt_str(_arg_1:int, _arg_2:int):String
        {
            if (_arg_1.toString().length > _arg_2)
            {
                return (_arg_1.toString().substr(0, _arg_2));
            };
            return (new Array((_arg_2 - _arg_1.toString().length)).join("0") + _arg_1);
        }

        public static function formatNum(_arg_1:Number, _arg_2:int=2):int
        {
            var _local_3:int = Math.pow(10, _arg_2);
            return ((_arg_1 * _local_3) / _local_3);
        }

        public static function getRate(_arg_1:String):Number
        {
            if (!_arg_1)
            {
                return (0);
            };
            var _local_2:Array = _arg_1.split("/");
            if (_local_2.length == 2)
            {
                return (formatNum(((_local_2[0] / _local_2[1]) * 100)));
            };
            if (isNaN(_local_2[2]))
            {
                return (0);
            };
            return (formatNum((((_local_2[1] - _local_2[0]) / (_local_2[2] - _local_2[0])) * 100)));
        }

        public static function getPointByDir(_arg_1:int, _arg_2:int, _arg_3:int):Point
        {
            switch (_arg_3)
            {
                case 0:
                    _arg_2--;
                    break;
                case 1:
                    _arg_1++;
                    _arg_2--;
                    break;
                case 2:
                    _arg_1++;
                    break;
                case 3:
                    _arg_1++;
                    _arg_2++;
                    break;
                case 4:
                    _arg_2++;
                    break;
                case 5:
                    _arg_1--;
                    _arg_2++;
                    break;
                case 6:
                    _arg_1--;
                    break;
                case 7:
                    _arg_1--;
                    _arg_2--;
                default:
            };
            return (new Point(_arg_1, _arg_2));
        }

        public static function isNearPos(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):Boolean
        {
            return ((Math.abs(((_arg_1 % _arg_4) - (_arg_2 % _arg_4))) <= _arg_3) && (Math.abs((int((_arg_1 / _arg_4)) - int((_arg_2 / _arg_4)))) <= _arg_3));
        }

        public static function getMaxDis(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):uint
        {
            var _local_6:int = (_arg_1 - _arg_3);
            ((_local_6 < 0) ? _local_6 = -(_local_6) : 0);
            var _local_5:int = (_arg_2 - _arg_4);
            ((_local_5 < 0) ? _local_5 = -(_local_5) : 0);
            return ((_local_6 > _local_5) ? _local_6 : _local_5);
        }

        public static function isLimits(_arg_1:int, _arg_2:int, _arg_3:int):Boolean
        {
            return ((_arg_1 >= Math.min(_arg_2, _arg_3)) && (_arg_1 <= Math.max(_arg_2, _arg_3)));
        }

        public static function getPosByPoint(_arg_1:Point, _arg_2:int, _arg_3:int=1, _arg_4:int=1):int
        {
            return (int((_arg_1.x / _arg_3)) + (int((_arg_1.y / _arg_4)) * _arg_2));
        }

        public static function getPointByPos(_arg_1:int, _arg_2:int, _arg_3:int=1, _arg_4:int=1):Point
        {
            return (new Point(((_arg_1 % _arg_2) * _arg_3), (int((_arg_1 / _arg_2)) * _arg_4)));
        }

        public static function readByteArray(_arg_1:ByteArray, _arg_2:ByteArray=null):ByteArray
        {
            if (_arg_2 == null)
            {
                _arg_2 = new ByteArray();
            };
            var _local_3:uint = _arg_1.readUnsignedInt();
            _arg_1.readBytes(_arg_2, 0, _local_3);
            return (_arg_2);
        }

        public static function writeByteArray(_arg_1:ByteArray, _arg_2:ByteArray):uint
        {
            var _local_3:uint = _arg_2.length;
            _arg_1.writeUnsignedInt(_local_3);
            _arg_1.writeBytes(_arg_2);
            return (_local_3);
        }


    }
}//package com.common.util

