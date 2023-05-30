// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//common.util.StrUtils

package common.util
{
    import flash.utils.ByteArray;

    public class StrUtils 
    {

        private static var _byte:ByteArray;
        public static var patterns:Array = [];


        public static function trim(_arg_1:String):String
        {
            if (_arg_1 == null)
            {
                return ("");
            };
            var _local_2:int;
            while (isWhitespace(_arg_1.charAt(_local_2)))
            {
                _local_2++;
            };
            var _local_3:int = (_arg_1.length - 1);
            while (isWhitespace(_arg_1.charAt(_local_3)))
            {
                _local_3--;
            };
            if (_local_3 >= _local_2)
            {
                return (_arg_1.slice(_local_2, (_local_3 + 1)));
            };
            return ("");
        }

        public static function trimArrayElements(_arg_1:String, _arg_2:String):String
        {
            var _local_3:* = null;
            var _local_4:int;
            var _local_5:int;
            if (((!(_arg_1 == "")) && (!(_arg_1 == null))))
            {
                _local_3 = _arg_1.split(_arg_2);
                _local_4 = _local_3.length;
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    _local_3[_local_5] = StrUtils.trim(_local_3[_local_5]);
                    _local_5++;
                };
                if (_local_4 > 0)
                {
                    _arg_1 = _local_3.join(_arg_2);
                };
            };
            return (_arg_1);
        }

        public static function isWhitespace(_arg_1:String):Boolean
        {
            switch (_arg_1)
            {
                case " ":
                case "\t":
                case "\r":
                case "\n":
                case "\f":
                    return (true);
                default:
                    return (false);
            };
        }

        public static function repeat(_arg_1:String, _arg_2:int):String
        {
            var _local_4:int;
            if (_arg_2 == 0)
            {
                return ("");
            };
            var _local_3:* = _arg_1;
            _local_4 = 1;
            while (_local_4 < _arg_2)
            {
                _local_3 = (_local_3 + _arg_1);
                _local_4++;
            };
            return (_local_3);
        }

        public static function restrict(_arg_1:String, _arg_2:String):String
        {
            var _local_6:int;
            var _local_5:uint;
            if (_arg_2 == null)
            {
                return (_arg_1);
            };
            if (_arg_2 == "")
            {
                return ("");
            };
            var _local_3:Array = [];
            var _local_4:int = _arg_1.length;
            _local_6 = 0;
            while (_local_6 < _local_4)
            {
                _local_5 = _arg_1.charCodeAt(_local_6);
                if (testCharacter(_local_5, _arg_2))
                {
                    _local_3.push(_local_5);
                };
                _local_6++;
            };
            return (String.fromCharCode.apply(null, _local_3));
        }

        public static function isValidStr(_arg_1:String):Boolean
        {
            if ((((!(_arg_1 == null)) && (!(_arg_1 == ""))) && (!(_arg_1 == "null"))))
            {
                return (true);
            };
            return (false);
        }

        public static function padString(_arg_1:String, _arg_2:int, _arg_3:String="0"):String
        {
            var _local_5:int;
            if (_arg_3 == null)
            {
                return (_arg_1);
            };
            var _local_4:Array = [];
            _local_5 = 0;
            while (_local_5 < (Math.abs(_arg_2) - _arg_1.length))
            {
                _local_4.push(_arg_3);
                _local_5++;
            };
            if (_arg_2 < 0)
            {
                _local_4.unshift(_arg_1);
            }
            else
            {
                _local_4.push(_arg_1);
            };
            return (_local_4.join(""));
        }

        public static function substitute(_arg_1:String, ... _args):String
        {
            var _local_6:*;
            var _local_3:int;
            var _local_4:* = null;
            if (_arg_1 == null)
            {
                return ("");
            };
            var _local_5:uint = _args.length;
            if (((_local_5 == 1) && (_args[0] is Array)))
            {
                _args = (_args[0] as Array);
                _local_5 = _args.length;
            };
            while (_local_3 < _local_5)
            {
                _local_4 = ((patterns[_local_3]) || ((_local_6 = new RegExp((("\\{" + _local_3) + "\\}"), "g")), (patterns[_local_3] = new RegExp((("\\{" + _local_3) + "\\}"), "g")), _local_6));
                _arg_1 = _arg_1.replace(_local_4, _args[_local_3]);
                _local_3++;
            };
            return (_arg_1);
        }

        public static function replaceAll(_arg_1:String, _arg_2:String, _arg_3:String):String
        {
            return (_arg_1.split(_arg_2).join(_arg_3));
        }

        public static function toUpperFirstChar(_arg_1:String):String
        {
            var str = _arg_1;
            return (str.replace(/(\w)/, function (_arg_1:*):*
            {
                return (_arg_1.toUpperCase());
            }));
        }

        public static function toLowerFirstChar(_arg_1:String):String
        {
            var str = _arg_1;
            return (str.replace(/(\w)/, function (_arg_1:*):*
            {
                return (_arg_1.toLocaleLowerCase());
            }));
        }

        private static function testCharacter(_arg_1:uint, _arg_2:String):Boolean
        {
            var _local_8:uint;
            var _local_11:int;
            var _local_5:Boolean;
            var _local_4:Boolean;
            var _local_10:Boolean;
            var _local_7:Boolean;
            var _local_3:Boolean = true;
            var _local_9:uint;
            var _local_6:int = _arg_2.length;
            if (_local_6 > 0)
            {
                _local_8 = _arg_2.charCodeAt(0);
                if (_local_8 == 94)
                {
                    _local_4 = true;
                };
            };
            _local_11 = 0;
            while (_local_11 < _local_6)
            {
                _local_8 = _arg_2.charCodeAt(_local_11);
                _local_5 = false;
                if (!_local_10)
                {
                    if (_local_8 == 45)
                    {
                        _local_7 = true;
                    }
                    else
                    {
                        if (_local_8 == 94)
                        {
                            _local_3 = (!(_local_3));
                        }
                        else
                        {
                            if (_local_8 == 92)
                            {
                                _local_10 = true;
                            }
                            else
                            {
                                _local_5 = true;
                            };
                        };
                    };
                }
                else
                {
                    _local_5 = true;
                    _local_10 = false;
                };
                if (_local_5)
                {
                    if (_local_7)
                    {
                        if (((_local_9 <= _arg_1) && (_arg_1 <= _local_8)))
                        {
                            _local_4 = _local_3;
                        };
                        _local_7 = false;
                        _local_9 = 0;
                    }
                    else
                    {
                        if (_arg_1 == _local_8)
                        {
                            _local_4 = _local_3;
                        };
                        _local_9 = _local_8;
                    };
                };
                _local_11++;
            };
            return (_local_4);
        }

        public static function getGBKLen(_arg_1:String):int
        {
            if (!_byte)
            {
                _byte = new ByteArray();
            };
            _byte.clear();
            _byte.writeMultiByte(_arg_1, "GBK");
            return (_byte.length);
        }

        public static function getGbkStr(_arg_1:String, _arg_2:int):String
        {
            var _local_3:uint;
            var _local_5:uint;
            var _local_4:uint = getGBKLen(_arg_1);
            if (_local_4 > _arg_2)
            {
                while (_local_3 <= _arg_2)
                {
                    _local_3 = (_local_3 + getGBKLen(_arg_1.charAt(_local_5)));
                    if (_local_5 > _arg_1.length) break;
                    _local_5++;
                };
                _arg_1 = _arg_1.substr(0, (_local_5 - 1));
            };
            return (_arg_1);
        }

        public static function getCharNum(_arg_1:String):int
        {
            var _local_4:int;
            var _local_3:Number;
            var _local_2:int;
            _local_4 = 0;
            while (_local_4 < _arg_1.length)
            {
                _local_3 = _arg_1.charCodeAt(_local_4);
                if (((((_local_3 >= 48) && (_local_3 <= 57)) || ((_local_3 >= 65) && (_local_3 <= 90))) || ((_local_3 >= 97) && (_local_3 <= 122))))
                {
                    _local_2 = (_local_2 + 1);
                }
                else
                {
                    if (((_local_3 >= 0x4E00) && (_local_3 <= 40869)))
                    {
                        _local_2 = (_local_2 + 3);
                    };
                };
                _local_4++;
            };
            return (_local_2);
        }


    }
}//package common.util

