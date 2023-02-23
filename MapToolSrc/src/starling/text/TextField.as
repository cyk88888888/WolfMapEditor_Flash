// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.text.TextField

package starling.text
{
    import starling.display.DisplayObjectContainer;
    import flash.display3D.Context3DTextureFormat;
    import flash.geom.Matrix;
    import flash.text.TextField;
    import flash.utils.Dictionary;
    import flash.geom.Rectangle;
    import starling.display.Image;
    import starling.display.QuadBatch;
    import starling.core.Starling;
    import starling.core.RenderSupport;
    import flash.display.BitmapData;
    import starling.textures.Texture;
    import flash.text.TextFormat;
    import flash.geom.Point;
    import flash.filters.BitmapFilter;
    import starling.utils.deg2rad;
    import starling.display.Quad;
    import starling.utils.RectangleUtil;
    import starling.display.DisplayObject;
    import starling.utils.HAlign;
    import starling.utils.VAlign;
    import starling.display.Sprite;

    public class TextField extends DisplayObjectContainer 
    {

        private static const BITMAP_FONT_DATA_NAME:String = "starling.display.TextField.BitmapFonts";

        private static var sDefaultTextureFormat:String = (("BGRA_PACKED" in Context3DTextureFormat) ? "bgraPacked4444" : "bgra");
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sNativeTextField:flash.text.TextField = new flash.text.TextField();
        private static var sStringCache:Dictionary = new Dictionary();

        private var mFontSize:Number;
        private var mColor:uint;
        private var mText:String;
        private var mFontName:String;
        private var mHAlign:String;
        private var mVAlign:String;
        private var mBold:Boolean;
        private var mItalic:Boolean;
        private var mUnderline:Boolean;
        private var mAutoScale:Boolean;
        private var mAutoSize:String;
        private var mKerning:Boolean;
        private var mLeading:Number;
        private var mNativeFilters:Array;
        private var mRequiresRedraw:Boolean;
        private var mIsHtmlText:Boolean;
        private var mTextBounds:Rectangle;
        private var mBatchable:Boolean;
        private var mHitArea:Rectangle;
        private var mBorder:DisplayObjectContainer;
        private var mImage:Image;
        private var mQuadBatch:QuadBatch;

        public function TextField(_arg_1:int, _arg_2:int, _arg_3:String, _arg_4:String="Verdana", _arg_5:Number=12, _arg_6:uint=0, _arg_7:Boolean=false)
        {
            mText = ((_arg_3) ? _arg_3 : "");
            mFontSize = _arg_5;
            mColor = _arg_6;
            mHAlign = "center";
            mVAlign = "center";
            mBorder = null;
            mKerning = true;
            mLeading = 0;
            mBold = _arg_7;
            mAutoSize = "none";
            mHitArea = new Rectangle(0, 0, _arg_1, _arg_2);
            this.fontName = _arg_4;
            addEventListener("flatten", onFlatten);
        }

        public static function get defaultTextureFormat():String
        {
            return (sDefaultTextureFormat);
        }

        public static function set defaultTextureFormat(_arg_1:String):void
        {
            sDefaultTextureFormat = _arg_1;
        }

        public static function registerBitmapFont(_arg_1:BitmapFont, _arg_2:String=null):String
        {
            if (_arg_2 == null)
            {
                _arg_2 = _arg_1.name;
            };
            bitmapFonts[convertToLowerCase(_arg_2)] = _arg_1;
            return (_arg_2);
        }

        public static function unregisterBitmapFont(_arg_1:String, _arg_2:Boolean=true):void
        {
            _arg_1 = convertToLowerCase(_arg_1);
            if (((_arg_2) && (!(bitmapFonts[_arg_1] == undefined))))
            {
                bitmapFonts[_arg_1].dispose();
            };
            delete bitmapFonts[_arg_1]; //not popped
        }

        public static function getBitmapFont(_arg_1:String):BitmapFont
        {
            return (bitmapFonts[convertToLowerCase(_arg_1)]);
        }

        private static function get bitmapFonts():Dictionary
        {
            var _local_1:Dictionary = (Starling.current.contextData["starling.display.TextField.BitmapFonts"] as Dictionary);
            if (_local_1 == null)
            {
                _local_1 = new Dictionary();
                Starling.current.contextData["starling.display.TextField.BitmapFonts"] = _local_1;
            };
            return (_local_1);
        }

        private static function convertToLowerCase(_arg_1:String):String
        {
            var _local_2:String = sStringCache[_arg_1];
            if (_local_2 == null)
            {
                _local_2 = _arg_1.toLowerCase();
                sStringCache[_arg_1] = _local_2;
            };
            return (_local_2);
        }


        override public function dispose():void
        {
            removeEventListener("flatten", onFlatten);
            if (mImage)
            {
                mImage.texture.dispose();
            };
            if (mQuadBatch)
            {
                mQuadBatch.dispose();
            };
            super.dispose();
        }

        private function onFlatten():void
        {
            if (mRequiresRedraw)
            {
                redraw();
            };
        }

        override public function render(_arg_1:RenderSupport, _arg_2:Number):void
        {
            if (mRequiresRedraw)
            {
                redraw();
            };
            super.render(_arg_1, _arg_2);
        }

        public function redraw():void
        {
            if (mRequiresRedraw)
            {
                if (getBitmapFont(mFontName))
                {
                    createComposedContents();
                }
                else
                {
                    createRenderedContents();
                };
                updateBorder();
                mRequiresRedraw = false;
            };
        }

        private function createRenderedContents():void
        {
            if (mQuadBatch)
            {
                mQuadBatch.removeFromParent(true);
                mQuadBatch = null;
            };
            if (mTextBounds == null)
            {
                mTextBounds = new Rectangle();
            };
            var scale:Number = Starling.contentScaleFactor;
            var bitmapData:BitmapData = renderText(scale, mTextBounds);
            var format:String = sDefaultTextureFormat;
            var maxTextureSize:int = Texture.maxSize;
            var shrinkHelper:Number = 0;
            while (((bitmapData.width > maxTextureSize) || (bitmapData.height > maxTextureSize)))
            {
                scale = (scale * Math.min(((maxTextureSize - shrinkHelper) / bitmapData.width), ((maxTextureSize - shrinkHelper) / bitmapData.height)));
                bitmapData.dispose();
                bitmapData = renderText(scale, mTextBounds);
                shrinkHelper = (shrinkHelper + 1);
            };
            mHitArea.width = (bitmapData.width / scale);
            mHitArea.height = (bitmapData.height / scale);
            var texture:Texture = Texture.fromBitmapData(bitmapData, false, false, scale, format);
            texture.root.onRestore = function ():void
            {
                if (mTextBounds == null)
                {
                    mTextBounds = new Rectangle();
                };
                bitmapData = renderText(scale, mTextBounds);
                texture.root.uploadBitmapData(bitmapData);
                bitmapData.dispose();
                bitmapData = null;
            };
            bitmapData.dispose();
            bitmapData = null;
            if (mImage == null)
            {
                mImage = new Image(texture);
                mImage.touchable = false;
                addChild(mImage);
            }
            else
            {
                mImage.texture.dispose();
                mImage.texture = texture;
                mImage.readjustSize();
            };
        }

        protected function formatText(_arg_1:flash.text.TextField, _arg_2:TextFormat):void
        {
        }

        final protected function requireRedraw():void
        {
            mRequiresRedraw = true;
        }

        private function renderText(_arg_1:Number, _arg_2:Rectangle):BitmapData
        {
            var _local_5:Number = (mHitArea.width * _arg_1);
            var _local_11:Number = (mHitArea.height * _arg_1);
            var _local_6:String = mHAlign;
            var _local_4:String = mVAlign;
            if (isHorizontalAutoSize)
            {
                _local_5 = 2147483647;
                _local_6 = "left";
            };
            if (isVerticalAutoSize)
            {
                _local_11 = 2147483647;
                _local_4 = "top";
            };
            var _local_12:TextFormat = new TextFormat(mFontName, (mFontSize * _arg_1), mColor, mBold, mItalic, mUnderline, null, null, _local_6);
            _local_12.kerning = mKerning;
            _local_12.leading = mLeading;
            sNativeTextField.defaultTextFormat = _local_12;
            sNativeTextField.width = _local_5;
            sNativeTextField.height = _local_11;
            sNativeTextField.antiAliasType = "advanced";
            sNativeTextField.selectable = false;
            sNativeTextField.multiline = true;
            sNativeTextField.wordWrap = true;
            if (mIsHtmlText)
            {
                sNativeTextField.htmlText = mText;
            }
            else
            {
                sNativeTextField.text = mText;
            };
            sNativeTextField.embedFonts = true;
            sNativeTextField.filters = mNativeFilters;
            if (((sNativeTextField.textWidth == 0) || (sNativeTextField.textHeight == 0)))
            {
                sNativeTextField.embedFonts = false;
            };
            formatText(sNativeTextField, _local_12);
            if (mAutoScale)
            {
                autoScaleNativeTextField(sNativeTextField);
            };
            var _local_10:Number = sNativeTextField.textWidth;
            var _local_3:Number = sNativeTextField.textHeight;
            if (isHorizontalAutoSize)
            {
                _local_5 = Math.ceil((_local_10 + 5));
                sNativeTextField.width = _local_5;
            };
            if (isVerticalAutoSize)
            {
                _local_11 = Math.ceil((_local_3 + 4));
                sNativeTextField.height = _local_11;
            };
            if (_local_5 < 1)
            {
                _local_5 = 1;
            };
            if (_local_11 < 1)
            {
                _local_11 = 1;
            };
            var _local_7:* = 0;
            if (_local_6 == "left")
            {
                _local_7 = 2;
            }
            else
            {
                if (_local_6 == "center")
                {
                    _local_7 = ((_local_5 - _local_10) / 2);
                }
                else
                {
                    if (_local_6 == "right")
                    {
                        _local_7 = ((_local_5 - _local_10) - 2);
                    };
                };
            };
            var _local_8:* = 0;
            if (_local_4 == "top")
            {
                _local_8 = 2;
            }
            else
            {
                if (_local_4 == "center")
                {
                    _local_8 = ((_local_11 - _local_3) / 2);
                }
                else
                {
                    if (_local_4 == "bottom")
                    {
                        _local_8 = ((_local_11 - _local_3) - 2);
                    };
                };
            };
            var _local_15:Point = calculateFilterOffset(sNativeTextField, _local_6, _local_4);
            var _local_13:BitmapData = new BitmapData(_local_5, _local_11, true, 0);
            var _local_14:Matrix = new Matrix(1, 0, 0, 1, _local_15.x, ((_local_15.y + _local_8) - 2));
            var _local_9:Function = (("drawWithQuality" in _local_13) ? _local_13["drawWithQuality"] : null);
            if ((_local_9 is Function))
            {
                _local_9.call(_local_13, sNativeTextField, _local_14, null, null, null, false, "medium");
            }
            else
            {
                _local_13.draw(sNativeTextField, _local_14);
            };
            sNativeTextField.text = "";
            _arg_2.setTo(((_local_7 + _local_15.x) / _arg_1), ((_local_8 + _local_15.y) / _arg_1), (_local_10 / _arg_1), (_local_3 / _arg_1));
            return (_local_13);
        }

        private function autoScaleNativeTextField(_arg_1:flash.text.TextField):void
        {
            var _local_4:* = null;
            var _local_5:Number = Number(_arg_1.defaultTextFormat.size);
            var _local_3:int = (_arg_1.height - 4);
            var _local_2:int = (_arg_1.width - 4);
            while (((_arg_1.textWidth > _local_2) || (_arg_1.textHeight > _local_3)))
            {
                if (_local_5 <= 4) break;
                _local_4 = _arg_1.defaultTextFormat;
                _local_4.size = _local_5--;
                _arg_1.defaultTextFormat = _local_4;
                if (mIsHtmlText)
                {
                    _arg_1.htmlText = mText;
                }
                else
                {
                    _arg_1.text = mText;
                };
            };
        }

        private function calculateFilterOffset(_arg_1:flash.text.TextField, _arg_2:String, _arg_3:String):Point
        {
            var _local_9:Number;
            var _local_4:Number;
            var _local_11:* = null;
            var _local_5:Number;
            var _local_6:Number;
            var _local_14:Number;
            var _local_13:Number;
            var _local_10:Number;
            var _local_19:Number;
            var _local_16:Number;
            var _local_8:Number;
            var _local_7:Number;
            var _local_15:* = null;
            var _local_12:Point = new Point();
            var _local_17:Array = _arg_1.filters;
            if (((!(_local_17 == null)) && (_local_17.length > 0)))
            {
                _local_9 = _arg_1.textWidth;
                _local_4 = _arg_1.textHeight;
                _local_11 = new Rectangle();
                for each (var _local_18:BitmapFilter in _local_17)
                {
                    _local_5 = (("blurX" in _local_18) ? _local_18["blurX"] : 0);
                    _local_6 = (("blurY" in _local_18) ? _local_18["blurY"] : 0);
                    _local_14 = (("angle" in _local_18) ? _local_18["angle"] : 0);
                    _local_13 = (("distance" in _local_18) ? _local_18["distance"] : 0);
                    _local_10 = deg2rad(_local_14);
                    _local_19 = (_local_5 * 1.33);
                    _local_16 = (_local_6 * 1.33);
                    _local_8 = ((Math.cos(_local_10) * _local_13) - (_local_19 / 2));
                    _local_7 = ((Math.sin(_local_10) * _local_13) - (_local_16 / 2));
                    _local_15 = new Rectangle(_local_8, _local_7, (_local_9 + _local_19), (_local_4 + _local_16));
                    _local_11 = _local_11.union(_local_15);
                };
                if (((_arg_2 == "left") && (_local_11.x < 0)))
                {
                    _local_12.x = -(_local_11.x);
                }
                else
                {
                    if (((_arg_2 == "right") && (_local_11.y > 0)))
                    {
                        _local_12.x = -(_local_11.right - _local_9);
                    };
                };
                if (((_arg_3 == "top") && (_local_11.y < 0)))
                {
                    _local_12.y = -(_local_11.y);
                }
                else
                {
                    if (((_arg_3 == "bottom") && (_local_11.y > 0)))
                    {
                        _local_12.y = -(_local_11.bottom - _local_4);
                    };
                };
            };
            return (_local_12);
        }

        private function createComposedContents():void
        {
            if (mImage)
            {
                mImage.removeFromParent(true);
                mImage.texture.dispose();
                mImage = null;
            };
            if (mQuadBatch == null)
            {
                mQuadBatch = new QuadBatch();
                mQuadBatch.touchable = false;
                addChild(mQuadBatch);
            }
            else
            {
                mQuadBatch.reset();
            };
            var _local_5:BitmapFont = getBitmapFont(mFontName);
            if (_local_5 == null)
            {
                throw (new Error(("Bitmap font not registered: " + mFontName)));
            };
            var _local_4:Number = mHitArea.width;
            var _local_1:Number = mHitArea.height;
            var _local_3:String = mHAlign;
            var _local_2:String = mVAlign;
            if (isHorizontalAutoSize)
            {
                _local_4 = 2147483647;
                _local_3 = "left";
            };
            if (isVerticalAutoSize)
            {
                _local_1 = 2147483647;
                _local_2 = "top";
            };
            _local_5.fillQuadBatch(mQuadBatch, _local_4, _local_1, mText, mFontSize, mColor, _local_3, _local_2, mAutoScale, mKerning, mLeading);
            mQuadBatch.batchable = mBatchable;
            if (mAutoSize != "none")
            {
                mTextBounds = mQuadBatch.getBounds(mQuadBatch, mTextBounds);
                if (isHorizontalAutoSize)
                {
                    mHitArea.width = (mTextBounds.x + mTextBounds.width);
                };
                if (isVerticalAutoSize)
                {
                    mHitArea.height = (mTextBounds.y + mTextBounds.height);
                };
            }
            else
            {
                mTextBounds = null;
            };
        }

        private function updateBorder():void
        {
            if (mBorder == null)
            {
                return;
            };
            var _local_3:Number = mHitArea.width;
            var _local_2:Number = mHitArea.height;
            var _local_1:Quad = (mBorder.getChildAt(0) as Quad);
            var _local_6:Quad = (mBorder.getChildAt(1) as Quad);
            var _local_4:Quad = (mBorder.getChildAt(2) as Quad);
            var _local_5:Quad = (mBorder.getChildAt(3) as Quad);
            _local_1.width = _local_3;
            _local_1.height = 1;
            _local_4.width = _local_3;
            _local_4.height = 1;
            _local_5.width = 1;
            _local_5.height = _local_2;
            _local_6.width = 1;
            _local_6.height = _local_2;
            _local_6.x = (_local_3 - 1);
            _local_4.y = (_local_2 - 1);
            var _local_7:* = mColor;
            _local_5.color = _local_7;
            _local_4.color = _local_7;
            _local_6.color = _local_7;
            _local_1.color = _local_7;
        }

        private function get isHorizontalAutoSize():Boolean
        {
            return ((mAutoSize == "horizontal") || (mAutoSize == "bothDirections"));
        }

        private function get isVerticalAutoSize():Boolean
        {
            return ((mAutoSize == "vertical") || (mAutoSize == "bothDirections"));
        }

        public function get textBounds():Rectangle
        {
            if (mRequiresRedraw)
            {
                redraw();
            };
            if (mTextBounds == null)
            {
                mTextBounds = mQuadBatch.getBounds(mQuadBatch);
            };
            return (mTextBounds.clone());
        }

        override public function getBounds(_arg_1:DisplayObject, _arg_2:Rectangle=null):Rectangle
        {
            if (mRequiresRedraw)
            {
                redraw();
            };
            getTransformationMatrix(_arg_1, sHelperMatrix);
            return (RectangleUtil.getBounds(mHitArea, sHelperMatrix, _arg_2));
        }

        override public function hitTest(_arg_1:Point, _arg_2:Boolean=false):DisplayObject
        {
            if (((_arg_2) && ((!(visible)) || (!(touchable)))))
            {
                return (null);
            };
            if (((mHitArea.containsPoint(_arg_1)) && (hitTestMask(_arg_1))))
            {
                return (this);
            };
            return (null);
        }

        override public function set width(_arg_1:Number):void
        {
            mHitArea.width = _arg_1;
            mRequiresRedraw = true;
        }

        override public function set height(_arg_1:Number):void
        {
            mHitArea.height = _arg_1;
            mRequiresRedraw = true;
        }

        public function get text():String
        {
            return (mText);
        }

        public function set text(_arg_1:String):void
        {
            if (_arg_1 == null)
            {
                _arg_1 = "";
            };
            if (mText != _arg_1)
            {
                mText = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get fontName():String
        {
            return (mFontName);
        }

        public function set fontName(_arg_1:String):void
        {
            if (mFontName != _arg_1)
            {
                if (((_arg_1 == "mini") && (bitmapFonts[_arg_1] == undefined)))
                {
                    registerBitmapFont(new BitmapFont());
                };
                mFontName = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get fontSize():Number
        {
            return (mFontSize);
        }

        public function set fontSize(_arg_1:Number):void
        {
            if (mFontSize != _arg_1)
            {
                mFontSize = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get color():uint
        {
            return (mColor);
        }

        public function set color(_arg_1:uint):void
        {
            if (mColor != _arg_1)
            {
                mColor = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get hAlign():String
        {
            return (mHAlign);
        }

        public function set hAlign(_arg_1:String):void
        {
            if (!HAlign.isValid(_arg_1))
            {
                throw (new ArgumentError(("Invalid horizontal align: " + _arg_1)));
            };
            if (mHAlign != _arg_1)
            {
                mHAlign = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get vAlign():String
        {
            return (mVAlign);
        }

        public function set vAlign(_arg_1:String):void
        {
            if (!VAlign.isValid(_arg_1))
            {
                throw (new ArgumentError(("Invalid vertical align: " + _arg_1)));
            };
            if (mVAlign != _arg_1)
            {
                mVAlign = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get border():Boolean
        {
            return (!(mBorder == null));
        }

        public function set border(_arg_1:Boolean):void
        {
            var _local_2:int;
            if (((_arg_1) && (mBorder == null)))
            {
                mBorder = new Sprite();
                addChild(mBorder);
                _local_2 = 0;
                while (_local_2 < 4)
                {
                    mBorder.addChild(new Quad(1, 1));
                    _local_2++;
                };
                updateBorder();
            }
            else
            {
                if (((!(_arg_1)) && (!(mBorder == null))))
                {
                    mBorder.removeFromParent(true);
                    mBorder = null;
                };
            };
        }

        public function get bold():Boolean
        {
            return (mBold);
        }

        public function set bold(_arg_1:Boolean):void
        {
            if (mBold != _arg_1)
            {
                mBold = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get italic():Boolean
        {
            return (mItalic);
        }

        public function set italic(_arg_1:Boolean):void
        {
            if (mItalic != _arg_1)
            {
                mItalic = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get underline():Boolean
        {
            return (mUnderline);
        }

        public function set underline(_arg_1:Boolean):void
        {
            if (mUnderline != _arg_1)
            {
                mUnderline = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get kerning():Boolean
        {
            return (mKerning);
        }

        public function set kerning(_arg_1:Boolean):void
        {
            if (mKerning != _arg_1)
            {
                mKerning = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get autoScale():Boolean
        {
            return (mAutoScale);
        }

        public function set autoScale(_arg_1:Boolean):void
        {
            if (mAutoScale != _arg_1)
            {
                mAutoScale = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get autoSize():String
        {
            return (mAutoSize);
        }

        public function set autoSize(_arg_1:String):void
        {
            if (mAutoSize != _arg_1)
            {
                mAutoSize = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get batchable():Boolean
        {
            return (mBatchable);
        }

        public function set batchable(_arg_1:Boolean):void
        {
            mBatchable = _arg_1;
            if (mQuadBatch)
            {
                mQuadBatch.batchable = _arg_1;
            };
        }

        public function get nativeFilters():Array
        {
            return (mNativeFilters);
        }

        public function set nativeFilters(_arg_1:Array):void
        {
            mNativeFilters = _arg_1.concat();
            mRequiresRedraw = true;
        }

        public function get isHtmlText():Boolean
        {
            return (mIsHtmlText);
        }

        public function set isHtmlText(_arg_1:Boolean):void
        {
            if (mIsHtmlText != _arg_1)
            {
                mIsHtmlText = _arg_1;
                mRequiresRedraw = true;
            };
        }

        public function get leading():Number
        {
            return (mLeading);
        }

        public function set leading(_arg_1:Number):void
        {
            if (mLeading != _arg_1)
            {
                mLeading = _arg_1;
                mRequiresRedraw = true;
            };
        }


    }
}//package starling.text

