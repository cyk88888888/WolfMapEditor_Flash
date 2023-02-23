// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.text.BitmapFont

package starling.text
{
    import starling.textures.Texture;
    import flash.utils.Dictionary;
    import starling.display.Image;
    import flash.geom.Rectangle;
    import starling.utils.cleanMasterString;
    import __AS3__.vec.Vector;
    import starling.display.Sprite;
    import starling.display.QuadBatch;

    public class BitmapFont 
    {

        public static const NATIVE_SIZE:int = -1;
        public static const MINI:String = "mini";
        private static const CHAR_SPACE:int = 32;
        private static const CHAR_TAB:int = 9;
        private static const CHAR_NEWLINE:int = 10;
        private static const CHAR_CARRIAGE_RETURN:int = 13;

        private static var sLines:Array = [];

        private var mTexture:Texture;
        private var mChars:Dictionary;
        private var mName:String;
        private var mSize:Number;
        private var mLineHeight:Number;
        private var mBaseline:Number;
        private var mOffsetX:Number;
        private var mOffsetY:Number;
        private var mHelperImage:Image;

        public function BitmapFont(_arg_1:Texture=null, _arg_2:XML=null)
        {
            if (((_arg_1 == null) && (_arg_2 == null)))
            {
                _arg_1 = MiniBitmapFont.texture;
                _arg_2 = MiniBitmapFont.xml;
            }
            else
            {
                if (((!(_arg_1 == null)) && (_arg_2 == null)))
                {
                    throw (new ArgumentError("fontXml cannot be null!"));
                };
            };
            mName = "unknown";
            mLineHeight = (mSize = (mBaseline = 14));
            mOffsetX = (mOffsetY = 0);
            mTexture = _arg_1;
            mChars = new Dictionary();
            mHelperImage = new Image(_arg_1);
            parseFontXml(_arg_2);
        }

        public function dispose():void
        {
            if (mTexture)
            {
                mTexture.dispose();
            };
        }

        private function parseFontXml(_arg_1:XML):void
        {
            var _local_12:int;
            var _local_14:Number;
            var _local_4:Number;
            var _local_7:Number;
            var _local_2:* = null;
            var _local_8:* = null;
            var _local_10:* = null;
            var _local_16:int;
            var _local_5:int;
            var _local_11:Number;
            var _local_3:Number = mTexture.scale;
            var _local_13:Rectangle = mTexture.frame;
            var _local_15:Number = ((_local_13) ? _local_13.x : 0);
            var _local_17:Number = ((_local_13) ? _local_13.y : 0);
            mName = cleanMasterString(_arg_1.info.@face);
            mSize = (parseFloat(_arg_1.info.@size) / _local_3);
            mLineHeight = (parseFloat(_arg_1.common.@lineHeight) / _local_3);
            mBaseline = (parseFloat(_arg_1.common.@base) / _local_3);
            if (_arg_1.info.@smooth.toString() == "0")
            {
                smoothing = "none";
            };
            if (mSize <= 0)
            {
                (trace((("[Starling] Warning: invalid font size in '" + mName) + "' font.")));
                mSize = ((mSize == 0) ? 16 : (mSize * -1));
            };
            for each (var _local_9:XML in _arg_1.chars.char)
            {
                _local_12 = parseInt(_local_9.@id);
                _local_14 = (parseFloat(_local_9.@xoffset) / _local_3);
                _local_4 = (parseFloat(_local_9.@yoffset) / _local_3);
                _local_7 = (parseFloat(_local_9.@xadvance) / _local_3);
                _local_2 = new Rectangle();
                _local_2.x = ((parseFloat(_local_9.@x) / _local_3) + _local_15);
                _local_2.y = ((parseFloat(_local_9.@y) / _local_3) + _local_17);
                _local_2.width = (parseFloat(_local_9.@width) / _local_3);
                _local_2.height = (parseFloat(_local_9.@height) / _local_3);
                _local_8 = Texture.fromTexture(mTexture, _local_2);
                _local_10 = new BitmapChar(_local_12, _local_8, _local_14, _local_4, _local_7);
                addChar(_local_12, _local_10);
            };
            for each (var _local_6:XML in _arg_1.kernings.kerning)
            {
                _local_16 = parseInt(_local_6.@first);
                _local_5 = parseInt(_local_6.@second);
                _local_11 = (parseFloat(_local_6.@amount) / _local_3);
                if ((_local_5 in mChars))
                {
                    getChar(_local_5).addKerning(_local_16, _local_11);
                };
            };
        }

        public function getChar(_arg_1:int):BitmapChar
        {
            return (mChars[_arg_1]);
        }

        public function addChar(_arg_1:int, _arg_2:BitmapChar):void
        {
            mChars[_arg_1] = _arg_2;
        }

        public function getCharIDs(_arg_1:Vector.<int>=null):Vector.<int>
        {
            if (_arg_1 == null)
            {
                _arg_1 = new Vector.<int>(0);
            };
            for (var _local_2:* in mChars)
            {
                _arg_1[_arg_1.length] = _local_2;
            };
            return (_arg_1);
        }

        public function hasChars(_arg_1:String):Boolean
        {
            var _local_3:int;
            var _local_4:int;
            if (_arg_1 == null)
            {
                return (true);
            };
            var _local_2:int = _arg_1.length;
            _local_4 = 0;
            while (_local_4 < _local_2)
            {
                _local_3 = _arg_1.charCodeAt(_local_4);
                if ((((((!(_local_3 == 32)) && (!(_local_3 == 9))) && (!(_local_3 == 10))) && (!(_local_3 == 13))) && (getChar(_local_3) == null)))
                {
                    return (false);
                };
                _local_4++;
            };
            return (true);
        }

        public function createSprite(_arg_1:Number, _arg_2:Number, _arg_3:String, _arg_4:Number=-1, _arg_5:uint=0xFFFFFF, _arg_6:String="center", _arg_7:String="center", _arg_8:Boolean=true, _arg_9:Boolean=true):Sprite
        {
            var _local_14:int;
            var _local_15:* = null;
            var _local_12:* = null;
            var _local_11:Vector.<CharLocation> = arrangeChars(_arg_1, _arg_2, _arg_3, _arg_4, _arg_6, _arg_7, _arg_8, _arg_9);
            var _local_10:int = _local_11.length;
            var _local_13:Sprite = new Sprite();
            _local_14 = 0;
            while (_local_14 < _local_10)
            {
                _local_15 = _local_11[_local_14];
                _local_12 = _local_15.char.createImage();
                _local_12.x = _local_15.x;
                _local_12.y = _local_15.y;
                var _local_16:* = _local_15.scale;
                _local_12.scaleY = _local_16;
                _local_12.scaleX = _local_16;
                _local_12.color = _arg_5;
                _local_13.addChild(_local_12);
                _local_14++;
            };
            CharLocation.rechargePool();
            return (_local_13);
        }

        public function fillQuadBatch(_arg_1:QuadBatch, _arg_2:Number, _arg_3:Number, _arg_4:String, _arg_5:Number=-1, _arg_6:uint=0xFFFFFF, _arg_7:String="center", _arg_8:String="center", _arg_9:Boolean=true, _arg_10:Boolean=true, _arg_11:Number=0):void
        {
            var _local_14:int;
            var _local_15:* = null;
            var _local_13:Vector.<CharLocation> = arrangeChars(_arg_2, _arg_3, _arg_4, _arg_5, _arg_7, _arg_8, _arg_9, _arg_10, _arg_11);
            var _local_12:int = _local_13.length;
            mHelperImage.color = _arg_6;
            _local_14 = 0;
            while (_local_14 < _local_12)
            {
                _local_15 = _local_13[_local_14];
                mHelperImage.texture = _local_15.char.texture;
                mHelperImage.readjustSize();
                mHelperImage.x = _local_15.x;
                mHelperImage.y = _local_15.y;
                var _local_16:* = _local_15.scale;
                mHelperImage.scaleY = _local_16;
                mHelperImage.scaleX = _local_16;
                _arg_1.addImage(mHelperImage);
                _local_14++;
            };
            CharLocation.rechargePool();
        }

        private function arrangeChars(_arg_1:Number, _arg_2:Number, _arg_3:String, _arg_4:Number=-1, _arg_5:String="center", _arg_6:String="center", _arg_7:Boolean=true, _arg_8:Boolean=true, _arg_9:Number=0):Vector.<CharLocation>
        {
            var _local_32:* = null;
            var _local_20:int;
            var _local_14:Number;
            var _local_23:Number;
            var _local_11:Number;
            var _local_10:int;
            var _local_26:int;
            var _local_36:Number;
            var _local_34:Number;
            var _local_30:*;
            var _local_29:int;
            var _local_24:Boolean;
            var _local_18:int;
            var _local_15:* = null;
            var _local_16:int;
            var _local_28:int;
            var _local_35:int;
            var _local_17:*;
            var _local_31:int;
            var _local_27:* = null;
            var _local_19:Number;
            var _local_22:int;
            if (((_arg_3 == null) || (_arg_3.length == 0)))
            {
                return (CharLocation.vectorFromPool());
            };
            if (_arg_4 < 0)
            {
                _arg_4 = (_arg_4 * -(mSize));
            };
            var _local_25:Boolean;
            while (!(_local_25))
            {
                sLines.length = 0;
                _local_11 = (_arg_4 / mSize);
                _local_14 = (_arg_1 / _local_11);
                _local_23 = (_arg_2 / _local_11);
                if (mLineHeight <= _local_23)
                {
                    _local_10 = -1;
                    _local_26 = -1;
                    _local_36 = 0;
                    _local_34 = 0;
                    _local_30 = CharLocation.vectorFromPool();
                    _local_20 = _arg_3.length;
                    _local_29 = 0;
                    while (_local_29 < _local_20)
                    {
                        _local_24 = false;
                        _local_18 = _arg_3.charCodeAt(_local_29);
                        _local_15 = getChar(_local_18);
                        if (((_local_18 == 10) || (_local_18 == 13)))
                        {
                            _local_24 = true;
                        }
                        else
                        {
                            if (_local_15 == null)
                            {
                                (trace(("[Starling] Missing character: " + _local_18)));
                            }
                            else
                            {
                                if (((_local_18 == 32) || (_local_18 == 9)))
                                {
                                    _local_10 = _local_29;
                                };
                                if (_arg_8)
                                {
                                    _local_36 = (_local_36 + _local_15.getKerning(_local_26));
                                };
                                _local_32 = CharLocation.instanceFromPool(_local_15);
                                _local_32.x = (_local_36 + _local_15.xOffset);
                                _local_32.y = (_local_34 + _local_15.yOffset);
                                _local_30[_local_30.length] = _local_32;
                                _local_36 = (_local_36 + _local_15.xAdvance);
                                _local_26 = _local_18;
                                if ((_local_32.x + _local_15.width) > _local_14)
                                {
                                    if (((_arg_7) && (_local_10 == -1))) break;
                                    _local_16 = ((_local_10 == -1) ? 1 : (_local_29 - _local_10));
                                    _local_28 = 0;
                                    while (_local_28 < _local_16)
                                    {
                                        _local_30.pop();
                                        _local_28++;
                                    };
                                    if (_local_30.length == 0) break;
                                    _local_29 = (_local_29 - _local_16);
                                    _local_24 = true;
                                };
                            };
                        };
                        if (_local_29 == (_local_20 - 1))
                        {
                            sLines[sLines.length] = _local_30;
                            _local_25 = true;
                        }
                        else
                        {
                            if (_local_24)
                            {
                                sLines[sLines.length] = _local_30;
                                if (_local_10 == _local_29)
                                {
                                    _local_30.pop();
                                };
                                if (((_local_34 + _arg_9) + (2 * mLineHeight)) <= _local_23)
                                {
                                    _local_30 = CharLocation.vectorFromPool();
                                    _local_36 = 0;
                                    _local_34 = (_local_34 + (mLineHeight + _arg_9));
                                    _local_10 = -1;
                                    _local_26 = -1;
                                }
                                else
                                {
                                    break;
                                };
                            };
                        };
                        _local_29++;
                    };
                };
                if ((((_arg_7) && (!(_local_25))) && (_arg_4 > 3)))
                {
                    _arg_4 = (_arg_4 - 1);
                }
                else
                {
                    _local_25 = true;
                };
            };
            var _local_21:Vector.<CharLocation> = CharLocation.vectorFromPool();
            var _local_13:int = sLines.length;
            var _local_33:Number = (_local_34 + mLineHeight);
            var _local_12:int;
            if (_arg_6 == "bottom")
            {
                _local_12 = (_local_23 - _local_33);
            }
            else
            {
                if (_arg_6 == "center")
                {
                    _local_12 = int(((_local_23 - _local_33) / 2));
                };
            };
            _local_35 = 0;
            while (_local_35 < _local_13)
            {
                _local_17 = sLines[_local_35];
                _local_20 = _local_17.length;
                if (_local_20 != 0)
                {
                    _local_31 = 0;
                    _local_27 = _local_17[(_local_17.length - 1)];
                    _local_19 = ((_local_27.x - _local_27.char.xOffset) + _local_27.char.xAdvance);
                    if (_arg_5 == "right")
                    {
                        _local_31 = (_local_14 - _local_19);
                    }
                    else
                    {
                        if (_arg_5 == "center")
                        {
                            _local_31 = int(((_local_14 - _local_19) / 2));
                        };
                    };
                    _local_22 = 0;
                    while (_local_22 < _local_20)
                    {
                        _local_32 = _local_17[_local_22];
                        _local_32.x = (_local_11 * ((_local_32.x + _local_31) + mOffsetX));
                        _local_32.y = (_local_11 * ((_local_32.y + _local_12) + mOffsetY));
                        _local_32.scale = _local_11;
                        if (((_local_32.char.width > 0) && (_local_32.char.height > 0)))
                        {
                            _local_21[_local_21.length] = _local_32;
                        };
                        _local_22++;
                    };
                };
                _local_35++;
            };
            return (_local_21);
        }

        public function get name():String
        {
            return (mName);
        }

        public function get size():Number
        {
            return (mSize);
        }

        public function get lineHeight():Number
        {
            return (mLineHeight);
        }

        public function set lineHeight(_arg_1:Number):void
        {
            mLineHeight = _arg_1;
        }

        public function get smoothing():String
        {
            return (mHelperImage.smoothing);
        }

        public function set smoothing(_arg_1:String):void
        {
            mHelperImage.smoothing = _arg_1;
        }

        public function get baseline():Number
        {
            return (mBaseline);
        }

        public function set baseline(_arg_1:Number):void
        {
            mBaseline = _arg_1;
        }

        public function get offsetX():Number
        {
            return (mOffsetX);
        }

        public function set offsetX(_arg_1:Number):void
        {
            mOffsetX = _arg_1;
        }

        public function get offsetY():Number
        {
            return (mOffsetY);
        }

        public function set offsetY(_arg_1:Number):void
        {
            mOffsetY = _arg_1;
        }

        public function get texture():Texture
        {
            return (mTexture);
        }


    }
}//package starling.text

import __AS3__.vec.Vector;
import starling.text.BitmapChar;

class CharLocation 
{

    /*private*/ static var sInstancePool:Vector.<CharLocation> = new Vector.<CharLocation>(0);
    /*private*/ static var sVectorPool:Array = [];
    /*private*/ static var sInstanceLoan:Vector.<CharLocation> = new Vector.<CharLocation>(0);
    /*private*/ static var sVectorLoan:Array = [];

    public var char:BitmapChar;
    public var scale:Number;
    public var x:Number;
    public var y:Number;

    public function CharLocation(_arg_1:BitmapChar)
    {
        reset(_arg_1);
    }

    public static function instanceFromPool(_arg_1:BitmapChar):CharLocation
    {
        var _local_2:CharLocation = ((sInstancePool.length > 0) ? sInstancePool.pop() : new CharLocation(_arg_1));
        _local_2.reset(_arg_1);
        sInstanceLoan[sInstanceLoan.length] = _local_2;
        return (_local_2);
    }

    public static function vectorFromPool():Vector.<CharLocation>
    {
        var _local_1:Vector.<CharLocation> = ((sVectorPool.length > 0) ? sVectorPool.pop() : new Vector.<CharLocation>(0));
        _local_1.length = 0;
        sVectorLoan[sVectorLoan.length] = _local_1;
        return (_local_1);
    }

    public static function rechargePool():void
    {
        var _local_2:* = null;
        var _local_1:*;
        while (sInstanceLoan.length > 0)
        {
            _local_2 = sInstanceLoan.pop();
            _local_2.char = null;
            sInstancePool[sInstancePool.length] = _local_2;
        };
        while (sVectorLoan.length > 0)
        {
            _local_1 = sVectorLoan.pop();
            _local_1.length = 0;
            sVectorPool[sVectorPool.length] = _local_1;
        };
    }


    /*private*/ function reset(_arg_1:BitmapChar):CharLocation
    {
        this.char = _arg_1;
        return (this);
    }


}


