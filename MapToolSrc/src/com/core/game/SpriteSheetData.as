// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.game.SpriteSheetData

package com.core.game
{
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import core.utils.DbgUtil;
    import __AS3__.vec.Vector;
    import com.common.util.ArrayUtils;

    public class SpriteSheetData 
    {

        private static var _instance:SpriteSheetData;

        private var _sheetsPos:Dictionary = new Dictionary();
        private var _allSheetBytes:ByteArray;
        private var multipack:Dictionary = new Dictionary();
        private var datas:Dictionary = new Dictionary();

        public function SpriteSheetData(_arg_1:SingletonEnforcer)
        {
        }

        public static function getInstance():SpriteSheetData
        {
            if (!_instance)
            {
                _instance = new SpriteSheetData(new SingletonEnforcer());
            };
            return (_instance);
        }


        public function init(_arg_1:ByteArray):void
        {
            var _local_3:* = null;
            var _local_4:*;
            var _local_5:uint;
            var _local_2:RegExp = /(.*\/.*_[0-9])\$([0-9]+)\.atf/;
            while (_arg_1.bytesAvailable != 0)
            {
                _local_3 = _arg_1.readUTF();
                if (_local_3.indexOf("$") != -1)
                {
                    _local_4 = _local_2.exec(_local_3);
                    if (_local_4)
                    {
                        initMultiPackInfo(_local_4);
                    };
                };
                _local_5 = _arg_1.readUnsignedShort();
                _sheetsPos[_local_3] = _arg_1.position;
                _arg_1.position = (_arg_1.position + _local_5);
            };
            _allSheetBytes = _arg_1;
        }

        public function setSheetData(_arg_1:String, _arg_2:SeqAniVo):void
        {
            datas[_arg_1] = _arg_2;
        }

        public function getSheetData(_arg_1:String):SeqAniVo
        {
            var _local_3:*;
            var _local_4:int = _arg_1.lastIndexOf(".");
            if (_local_4 == -1)
            {
                _arg_1 = (_arg_1 + ".atf");
            };
            if (_arg_1 == "swf/body/male001/idle_2.atf")
            {
                DbgUtil.nop();
            };
            var _local_2:SeqAniVo = datas[_arg_1];
            if (_local_2 == null)
            {
                if (_sheetsPos[_arg_1] == null)
                {
                    _local_3 = multipack[_arg_1];
                    if (_local_3 != null)
                    {
                        _local_2 = parseAndMerge(_arg_1, _local_3);
                        datas[_arg_1] = _local_2;
                    }
                    else
                    {
                        return (null);
                    };
                }
                else
                {
                    _local_2 = justParseFromByteArray(_arg_1);
                    datas[_arg_1] = _local_2;
                };
            };
            return (_local_2);
        }

        private function justParseFromByteArray(_arg_1:String):SeqAniVo
        {
            var _local_6:uint = _sheetsPos[_arg_1];
            var _local_2:ByteArray = _allSheetBytes;
            if (_local_2 == null)
            {
                return (null);
            };
            _local_2.position = _local_6;
            var _local_4:SeqAniVo = SeqAniVo.parse(_local_2, _arg_1);
            delete _sheetsPos[_arg_1];
            var _local_3:Boolean;
            for (var _local_5:* in _sheetsPos)
            {
                _local_3 = true;
                break;
            };
            if (!_local_3)
            {
                _allSheetBytes = null;
                _sheetsPos = null;
            };
            return (_local_4);
        }

        private function initMultiPackInfo(_arg_1:*):void
        {
            var _local_2:String = (_arg_1[1] + ".atf");
            var _local_3:uint;
            if (multipack[_local_2] == null)
            {
                multipack[_local_2] = _local_3;
            };
            var _local_4:uint = parseInt(_arg_1[2]);
            if (_local_4 > _local_3)
            {
                multipack[_local_2] = _local_4;
            };
        }

        private function parseAndMerge(_arg_1:String, _arg_2:*):SeqAniVo
        {
            var _local_8:int;
            var _local_6:* = null;
            var _local_5:* = null;
            var _local_7:String = _arg_1.substring(0, _arg_1.lastIndexOf(".atf"));
            var _local_3:SeqAniVo;
            var _local_4:Vector.<SeqAniVo> = new Vector.<SeqAniVo>();
            _local_8 = 0;
            while (_local_8 < (_arg_2 + 1))
            {
                _local_6 = (((_local_7 + "$") + _local_8) + ".atf");
                _local_5 = justParseFromByteArray(_local_6);
                _local_4.push(_local_5);
                if (_local_3 == null)
                {
                    _local_3 = new SeqAniVo();
                    _local_3.url = _arg_1;
                    _local_3.frameRate = _local_5.frameRate;
                    _local_3.blendMode = _local_5.blendMode;
                    _local_3.origX = _local_5.origX;
                    _local_3.origY = _local_5.origY;
                    _local_3.subTexInfos = [];
                };
                ArrayUtils.append(_local_3.subTexInfos, _local_5.subTexInfos);
                _local_8++;
            };
            _local_3.parts = _local_4;
            _local_3.isMultiPack = true;
            return (_local_3);
        }


    }
}//package com.core.game

class SingletonEnforcer 
{


}


