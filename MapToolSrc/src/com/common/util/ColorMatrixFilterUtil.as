// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.common.util.ColorMatrixFilterUtil

package com.common.util
{
    public class ColorMatrixFilterUtil 
    {

        private static const _matrix:Array = [1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0];
        private static const _lumR:Number = 0.212671;
        private static const _lumG:Number = 0.71516;
        private static const _lumB:Number = 0.072169;


        public static function getMatrix(_arg_1:int=0, _arg_2:int=0, _arg_3:int=0, _arg_4:int=0, _arg_5:int=100):Array
        {
            var _local_6:Array = _matrix.concat();
            _local_6 = setAlpha(_local_6, _arg_5);
            _local_6 = setBrightness(_local_6, _arg_1);
            _local_6 = setContrast(_local_6, _arg_2);
            _local_6 = setSaturation(_local_6, _arg_3);
            _local_6 = setHue(_local_6, _arg_4);
            return (_local_6);
        }

        public static function setAlpha(_arg_1:Array, _arg_2:int):Array
        {
            _arg_2 = adjustValue(_arg_2);
            _arg_2 = Math.max(0, _arg_2);
            _arg_1[18] = (_arg_2 / 100);
            return (_arg_1);
        }

        public static function setBrightness(_arg_1:Array, _arg_2:int):Array
        {
            _arg_2 = adjustValue(_arg_2);
            var _local_3:Number = _arg_2;
            return (applyMatrix([1, 0, 0, 0, _local_3, 0, 1, 0, 0, _local_3, 0, 0, 1, 0, _local_3, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], _arg_1));
        }

        public static function setContrast(_arg_1:Array, _arg_2:int):Array
        {
            _arg_2 = adjustValue(_arg_2);
            var _local_3:Number = (1 + (_arg_2 / 100));
            var _local_4:Array = [_local_3, 0, 0, 0, (128 * (1 - _local_3)), 0, _local_3, 0, 0, (128 * (1 - _local_3)), 0, 0, _local_3, 0, (128 * (1 - _local_3)), 0, 0, 0, 1, 0];
            return (applyMatrix(_local_4, _arg_1));
        }

        public static function setSaturation(_arg_1:Array, _arg_2:int):Array
        {
            var _local_8:Number;
            _arg_2 = adjustValue(_arg_2);
            var _local_6:Number = (1 + (_arg_2 / 100));
            _local_8 = (1 - _local_6);
            var _local_5:Number = (_local_8 * 0.212671);
            var _local_3:Number = (_local_8 * 0.71516);
            var _local_4:Number = (_local_8 * 0.072169);
            var _local_7:Array = [(_local_5 + _local_6), _local_3, _local_4, 0, 0, _local_5, (_local_3 + _local_6), _local_4, 0, 0, _local_5, _local_3, (_local_4 + _local_6), 0, 0, 0, 0, 0, 1, 0];
            return (applyMatrix(_local_7, _arg_1));
        }

        public static function setHue(_arg_1:Array, _arg_2:int):Array
        {
            var _local_4:Number;
            _arg_2 = adjustValue(_arg_2);
            var _local_5:Number = (1 + (_arg_2 / 100));
            _local_5 = (_local_5 * (3.14159265358979 / 180));
            _local_4 = Math.cos(_local_5);
            var _local_3:Number = Math.sin(_local_5);
            var _local_6:Array = [((0.212671 + (_local_4 * (1 - 0.212671))) + (_local_3 * -(0.212671))), ((0.71516 + (_local_4 * -(0.71516))) + (_local_3 * -(0.71516))), ((0.072169 + (_local_4 * -(0.072169))) + (_local_3 * (1 - 0.072169))), 0, 0, ((0.212671 + (_local_4 * -(0.212671))) + (_local_3 * 0.143)), ((0.71516 + (_local_4 * (1 - 0.71516))) + (_local_3 * 0.14)), ((0.072169 + (_local_4 * -(0.072169))) + (_local_3 * -0.283)), 0, 0, ((0.212671 + (_local_4 * -(0.212671))) + (_local_3 * -0.787329)), ((0.71516 + (_local_4 * -(0.71516))) + (_local_3 * 0.71516)), ((0.072169 + (_local_4 * (1 - 0.072169))) + (_local_3 * 0.072169)), 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1];
            return (applyMatrix(_local_6, _arg_1));
        }

        private static function applyMatrix(_arg_1:Array, _arg_2:Array):Array
        {
            var _local_5:int;
            var _local_6:int;
            if (((!(_arg_1 is Array)) || (!(_arg_2 is Array))))
            {
                return (_arg_2);
            };
            var _local_3:Array = [];
            var _local_7:int;
            var _local_4:int;
            _local_5 = 0;
            while (_local_5 < 4)
            {
                _local_6 = 0;
                while (_local_6 < 5)
                {
                    _local_4 = ((_local_6 == 4) ? _arg_1[(_local_7 + 4)] : 0);
                    _local_3[(_local_7 + _local_6)] = (((((_arg_1[_local_7] * _arg_2[_local_6]) + (_arg_1[(_local_7 + 1)] * _arg_2[(_local_6 + 5)])) + (_arg_1[(_local_7 + 2)] * _arg_2[(_local_6 + 10)])) + (_arg_1[(_local_7 + 3)] * _arg_2[(_local_6 + 15)])) + _local_4);
                    _local_6 = (_local_6 + 1);
                };
                _local_7 = (_local_7 + 5);
                _local_5 = (_local_5 + 1);
            };
            return (_local_3);
        }

        private static function adjustValue(_arg_1:int):int
        {
            _arg_1 = Math.max(-100, _arg_1);
            return (Math.min(100, _arg_1));
        }


    }
}//package com.common.util

