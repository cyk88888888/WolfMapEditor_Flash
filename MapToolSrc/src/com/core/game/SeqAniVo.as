// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.game.SeqAniVo

package com.core.game
{
    import __AS3__.vec.Vector;
    import starling.textures.Texture;
    import starling.ext.TextureAtlasExt;
    import com.core.NBlendMode;
    import com.core.base.TexAreaInfo;
    import flash.utils.ByteArray;
    import flash.geom.Rectangle;
    import core.utils.DbgUtil;

    public class SeqAniVo 
    {

        public var origX:int;
        public var origY:int;
        public var frameRate:int = 15;
        public var blendMode:String = "normal";
        public var subTexInfos:Array;
        public var url:String;
        public var parts:Vector.<SeqAniVo>;
        public var isMultiPack:Boolean = false;
        private var _concreteTexture:Texture;
        private var _textureAtlasExt:TextureAtlasExt;
        private var _textures:Vector.<Texture>;
        private var mSubTextureNames:Vector.<String>;
        private var _expandKeyFrameNames:Vector.<String>;


        public static function parse1(_arg_1:ByteArray, _arg_2:String):SeqAniVo
        {
            var _local_4:uint;
            var _local_8:int;
            var _local_7:* = null;
            var _local_5:SeqAniVo = new (SeqAniVo)();
            _local_5.url = _arg_2;
            _local_5.origX = -(_arg_1.readInt());
            _local_5.origY = -(_arg_1.readInt());
            var _local_6:int = _arg_1.readUnsignedInt();
            if ((_local_6 & 0x80000000))
            {
                _arg_1.readInt();
                _arg_1.readInt();
                _local_6 = (_local_6 & (~(0x80000000)));
            };
            if ((_local_6 & 0x40000000))
            {
                _local_5.frameRate = _arg_1.readUnsignedInt();
                _local_6 = (_local_6 & (~(0x40000000)));
            };
            if ((_local_6 & 0x20000000))
            {
                _local_4 = _arg_1.readUnsignedInt();
                _local_5.blendMode = NBlendMode.getBlendMode(_local_4);
                _local_6 = (_local_6 & (~(0x20000000)));
            };
            _local_5.subTexInfos = [];
            var _local_3:Array = _local_5.subTexInfos;
            _local_8 = 0;
            while (_local_8 < _local_6)
            {
                _local_7 = new TexAreaInfo();
                _local_7.name = _arg_1.readUTF();
                _local_7.x = _arg_1.readInt();
                _local_7.y = _arg_1.readInt();
                _local_7.width = _arg_1.readInt();
                _local_7.height = _arg_1.readInt();
                _local_7.frameX = _arg_1.readInt();
                _local_7.frameY = _arg_1.readInt();
                _local_7.frameWidth = _arg_1.readInt();
                _local_7.frameHeight = _arg_1.readInt();
                _local_3.push(_local_7);
                _local_8++;
            };
            return (_local_5);
        }

        public static function parse(_arg_1:ByteArray, _arg_2:String):SeqAniVo
        {
            var _local_6:uint;
            var _local_11:int;
            var _local_9:* = null;
            var _local_3:uint = _arg_1.position;
            var _local_5:int = _arg_1.readShort();
            if (17238 != _local_5)
            {
                _arg_1.position = _local_3;
                return (parse1(_arg_1, _arg_2));
            };
            var _local_7:SeqAniVo = new (SeqAniVo)();
            _local_7.url = _arg_2;
            var _local_10:int = _arg_1.readByte();
            _local_7.origX = _arg_1.readShort();
            _local_7.origY = _arg_1.readShort();
            var _local_8:int = _arg_1.readUnsignedInt();
            if ((_local_8 & 0x40000000))
            {
                _local_7.frameRate = _arg_1.readByte();
                _local_8 = (_local_8 & (~(0x40000000)));
            };
            if ((_local_8 & 0x20000000))
            {
                _local_6 = _arg_1.readByte();
                _local_7.blendMode = NBlendMode.getBlendMode(_local_6);
                _local_8 = (_local_8 & (~(0x20000000)));
            };
            _local_7.subTexInfos = [];
            var _local_4:Array = _local_7.subTexInfos;
            _local_11 = 0;
            while (_local_11 < _local_8)
            {
                _local_9 = new TexAreaInfo();
                SheetUtil.readFrame(_local_9, _arg_1);
                _local_4.push(_local_9);
                _local_11++;
            };
            return (_local_7);
        }

        public static function parseTextureAtlasNames(_arg_1:Array):Vector.<String>
        {
            var _local_2:int;
            var _local_4:* = null;
            var _local_3:Vector.<String> = new Vector.<String>();
            _local_2 = 0;
            while (_local_2 < _arg_1.length)
            {
                _local_4 = _arg_1[_local_2];
                if (((_local_4.frameWidth > 0) && (_local_4.frameHeight > 0)))
                {
                    _local_3[_local_3.length] = _local_4.name;
                }
                else
                {
                    _local_3[_local_3.length] = _local_4.name;
                };
                _local_2++;
            };
            return (_local_3);
        }

        public static function parseTextureAtlas(_arg_1:TextureAtlasExt, _arg_2:Array):TextureAtlasExt
        {
            var _local_4:int;
            var _local_6:* = null;
            var _local_3:Rectangle = new Rectangle();
            var _local_5:Rectangle = new Rectangle();
            _local_4 = 0;
            while (_local_4 < _arg_2.length)
            {
                _local_6 = _arg_2[_local_4];
                _local_3.setTo(_local_6.x, _local_6.y, _local_6.width, _local_6.height);
                _local_5.setTo(_local_6.frameX, _local_6.frameY, _local_6.frameWidth, _local_6.frameHeight);
                if (((_local_6.frameWidth > 0) && (_local_6.frameHeight > 0)))
                {
                    _arg_1.addRegion(_local_6.name, _local_3, _local_5);
                }
                else
                {
                    _arg_1.addRegion(_local_6.name, _local_3, null);
                };
                _local_4++;
            };
            return (_arg_1);
        }


        public function get textureAtlas():TextureAtlasExt
        {
            return (_textureAtlasExt);
        }

        public function get textures():Vector.<Texture>
        {
            return (_textures);
        }

        public function createSubTexture(_arg_1:Texture):Vector.<Texture>
        {
            var _local_3:* = null;
            var _local_2:int;
            if (isMultiPack)
            {
                if (_textureAtlasExt == null)
                {
                    _textureAtlasExt = new TextureAtlasExt(null);
                };
                _textureAtlasExt.atlasTexture = _arg_1;
                _local_3 = null;
                _local_2 = 0;
                while (_local_2 < parts.length)
                {
                    _local_3 = parts[_local_2];
                    if (_local_3.url == _arg_1.url) break;
                    _local_2++;
                };
                parseTextureAtlas(_textureAtlasExt, _local_3.subTexInfos);
                return (null);
            };
            if (_textures == null)
            {
                _concreteTexture = _arg_1;
                _textureAtlasExt = new TextureAtlasExt(_arg_1);
                parseTextureAtlas(_textureAtlasExt, this.subTexInfos);
                fetchTextures();
            }
            else
            {
                if (_concreteTexture != _arg_1)
                {
                    DbgUtil.assert(((false) || ((_concreteTexture.url + " Duplcate texture uploaded ") + _arg_1.url)));
                };
            };
            return (_textures);
        }

        public function fetchTextures():void
        {
            _textures = _textureAtlasExt.getTexturesByPrefix();
        }

        public function disposeTexture():void
        {
            var _local_2:int;
            var _local_1:* = null;
            if (_textures)
            {
                _local_2 = 0;
                while (_local_2 < _textures.length)
                {
                    _local_1 = _textures[_local_2];
                    _local_1.dispose();
                    _local_2++;
                };
            };
            _textures = null;
            _concreteTexture = null;
            _textureAtlasExt = null;
        }

        private function keyFrameNames():Vector.<String>
        {
            if (mSubTextureNames == null)
            {
                mSubTextureNames = parseTextureAtlasNames(this.subTexInfos);
            };
            return (mSubTextureNames);
        }

        public function createExpandKeyFrameNames(_arg_1:Vector.<String>=null):Vector.<String>
        {
            var _local_4:int;
            var _local_2:* = null;
            var _local_5:uint;
            var _local_6:uint;
            if (_arg_1 == null)
            {
                _arg_1 = new Vector.<String>(0);
            };
            var _local_3:int = -1;
            var _local_7:Vector.<String> = keyFrameNames();
            _local_4 = (_local_7.length - 1);
            while (_local_4 >= 0)
            {
                _local_2 = _local_7[_local_4];
                _local_5 = parseInt(_local_2);
                if (_local_3 == -1)
                {
                    _arg_1[_arg_1.length] = _local_2;
                }
                else
                {
                    _local_6 = _local_5;
                    while (_local_6 < _local_3)
                    {
                        _arg_1[_arg_1.length] = _local_2;
                        _local_6++;
                    };
                };
                _local_3 = _local_5;
                _local_4--;
            };
            return (_arg_1.reverse());
        }

        public function expandKeyFrames():Vector.<String>
        {
            if (_expandKeyFrameNames == null)
            {
                _expandKeyFrameNames = createExpandKeyFrameNames();
            };
            return (_expandKeyFrameNames);
        }


    }
}//package com.core.game

