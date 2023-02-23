// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.adobe.crypto.MD5

package com.adobe.crypto
{
    import flash.utils.ByteArray;
    import com.adobe.utils.IntUtil;

    public class MD5 
    {

        public static var digest:ByteArray;
        public static var ba:ByteArray = new ByteArray();


        public static function hash(_arg_1:String, _arg_2:Boolean=false):String
        {
            var _local_3:* = 0;
            ba.position = _local_3;
            ba.length = _local_3;
            ba.writeUTFBytes(_arg_1);
            return (hashBinary(ba, _arg_2));
        }

        public static function hashBinary(_arg_1:ByteArray, _arg_2:Boolean=false):String
        {
            var _local_11:int;
            var _local_13:int;
            var _local_15:int;
            var _local_10:int;
            var _local_9:int;
            var _local_3:* = null;
            var _local_12:* = null;
            var _local_7:* = 1732584193;
            var _local_5:* = -271733879;
            var _local_6:* = -1732584194;
            var _local_4:* = 271733878;
            var _local_17:Array = createBlocks(_arg_1);
            var _local_8:int = _local_17.length;
            _local_9 = 0;
            while (_local_9 < _local_8)
            {
                _local_11 = _local_7;
                _local_13 = _local_5;
                _local_15 = _local_6;
                _local_10 = _local_4;
                _local_7 = ff(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 0)], 7, -680876936);
                _local_4 = ff(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 1)], 12, -389564586);
                _local_6 = ff(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 2)], 17, 606105819);
                _local_5 = ff(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 3)], 22, -1044525330);
                _local_7 = ff(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 4)], 7, -176418897);
                _local_4 = ff(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 5)], 12, 1200080426);
                _local_6 = ff(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 6)], 17, -1473231341);
                _local_5 = ff(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 7)], 22, -45705983);
                _local_7 = ff(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 8)], 7, 1770035416);
                _local_4 = ff(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 9)], 12, -1958414417);
                _local_6 = ff(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 10)], 17, -42063);
                _local_5 = ff(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 11)], 22, -1990404162);
                _local_7 = ff(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 12)], 7, 1804603682);
                _local_4 = ff(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 13)], 12, -40341101);
                _local_6 = ff(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 14)], 17, -1502002290);
                _local_5 = ff(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 15)], 22, 1236535329);
                _local_7 = gg(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 1)], 5, -165796510);
                _local_4 = gg(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 6)], 9, -1069501632);
                _local_6 = gg(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 11)], 14, 643717713);
                _local_5 = gg(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 0)], 20, -373897302);
                _local_7 = gg(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 5)], 5, -701558691);
                _local_4 = gg(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 10)], 9, 38016083);
                _local_6 = gg(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 15)], 14, -660478335);
                _local_5 = gg(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 4)], 20, -405537848);
                _local_7 = gg(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 9)], 5, 568446438);
                _local_4 = gg(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 14)], 9, -1019803690);
                _local_6 = gg(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 3)], 14, -187363961);
                _local_5 = gg(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 8)], 20, 1163531501);
                _local_7 = gg(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 13)], 5, -1444681467);
                _local_4 = gg(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 2)], 9, -51403784);
                _local_6 = gg(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 7)], 14, 1735328473);
                _local_5 = gg(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 12)], 20, -1926607734);
                _local_7 = hh(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 5)], 4, -378558);
                _local_4 = hh(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 8)], 11, -2022574463);
                _local_6 = hh(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 11)], 16, 1839030562);
                _local_5 = hh(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 14)], 23, -35309556);
                _local_7 = hh(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 1)], 4, -1530992060);
                _local_4 = hh(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 4)], 11, 1272893353);
                _local_6 = hh(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 7)], 16, -155497632);
                _local_5 = hh(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 10)], 23, -1094730640);
                _local_7 = hh(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 13)], 4, 681279174);
                _local_4 = hh(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 0)], 11, -358537222);
                _local_6 = hh(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 3)], 16, -722521979);
                _local_5 = hh(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 6)], 23, 76029189);
                _local_7 = hh(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 9)], 4, -640364487);
                _local_4 = hh(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 12)], 11, -421815835);
                _local_6 = hh(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 15)], 16, 530742520);
                _local_5 = hh(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 2)], 23, -995338651);
                _local_7 = ii(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 0)], 6, -198630844);
                _local_4 = ii(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 7)], 10, 1126891415);
                _local_6 = ii(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 14)], 15, -1416354905);
                _local_5 = ii(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 5)], 21, -57434055);
                _local_7 = ii(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 12)], 6, 1700485571);
                _local_4 = ii(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 3)], 10, -1894986606);
                _local_6 = ii(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 10)], 15, -1051523);
                _local_5 = ii(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 1)], 21, -2054922799);
                _local_7 = ii(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 8)], 6, 1873313359);
                _local_4 = ii(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 15)], 10, -30611744);
                _local_6 = ii(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 6)], 15, -1560198380);
                _local_5 = ii(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 13)], 21, 1309151649);
                _local_7 = ii(_local_7, _local_5, _local_6, _local_4, _local_17[(_local_9 + 4)], 6, -145523070);
                _local_4 = ii(_local_4, _local_7, _local_5, _local_6, _local_17[(_local_9 + 11)], 10, -1120210379);
                _local_6 = ii(_local_6, _local_4, _local_7, _local_5, _local_17[(_local_9 + 2)], 15, 718787259);
                _local_5 = ii(_local_5, _local_6, _local_4, _local_7, _local_17[(_local_9 + 9)], 21, -343485551);
                _local_7 = (_local_7 + _local_11);
                _local_5 = (_local_5 + _local_13);
                _local_6 = (_local_6 + _local_15);
                _local_4 = (_local_4 + _local_10);
                _local_9 = (_local_9 + 16);
            };
            if (!digest)
            {
                digest = new ByteArray();
            };
            digest.writeInt(_local_7);
            digest.writeInt(_local_5);
            digest.writeInt(_local_6);
            digest.writeInt(_local_4);
            digest.position = 0;
            var _local_14:String = IntUtil.toHex(_local_5);
            var _local_16:String = IntUtil.toHex(_local_6);
            if (_arg_2)
            {
                return (_local_14 + _local_16);
            };
            _local_3 = IntUtil.toHex(_local_7);
            _local_12 = IntUtil.toHex(_local_4);
            return (((_local_3 + _local_14) + _local_16) + _local_12);
        }

        private static function f(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            return ((_arg_1 & _arg_2) | ((~(_arg_1)) & _arg_3));
        }

        private static function g(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            return ((_arg_1 & _arg_3) | (_arg_2 & (~(_arg_3))));
        }

        private static function h(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            return ((_arg_1 ^ _arg_2) ^ _arg_3);
        }

        private static function i(_arg_1:int, _arg_2:int, _arg_3:int):int
        {
            return (_arg_2 ^ (_arg_1 | (~(_arg_3))));
        }

        private static function transform(_arg_1:Function, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int, _arg_8:int):int
        {
            var _local_9:int = (((_arg_2 + _arg_1(_arg_3, _arg_4, _arg_5)) + _arg_6) + _arg_8);
            return (IntUtil.rol(_local_9, _arg_7) + _arg_3);
        }

        private static function ff(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int):int
        {
            return (transform(f, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7));
        }

        private static function gg(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int):int
        {
            return (transform(g, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7));
        }

        private static function hh(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int):int
        {
            return (transform(h, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7));
        }

        private static function ii(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int, _arg_6:int, _arg_7:int):int
        {
            return (transform(i, _arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, _arg_7));
        }

        private static function createBlocks(_arg_1:ByteArray):Array
        {
            var _local_5:int;
            var _local_4:Array = [];
            var _local_3:int = (_arg_1.length * 8);
            var _local_2:* = 0xFF;
            _local_5 = 0;
            while (_local_5 < _local_3)
            {
                var _local_6:* = (_local_5 >> 5);
                var _local_7:* = (_local_4[_local_6] | ((_arg_1[(_local_5 / 8)] & _local_2) << (_local_5 % 32)));
                _local_4[_local_6] = _local_7;
                _local_5 = (_local_5 + 8);
            };
            _local_7 = (_local_3 >> 5);
            _local_6 = (_local_4[_local_7] | (128 << (_local_3 % 32)));
            _local_4[_local_7] = _local_6;
            _local_4[((((_local_3 + 64) >>> 9) << 4) + 14)] = _local_3;
            return (_local_4);
        }


    }
}//package com.adobe.crypto

