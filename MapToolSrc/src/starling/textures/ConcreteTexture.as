// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.textures.ConcreteTexture

package starling.textures
{
    import flash.geom.Point;
    import flash.display3D.textures.TextureBase;
    import __AS3__.vec.Vector;
    import starling.display.DisplayObject;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display3D.textures.Texture;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.utils.ByteArray;
    import flash.net.NetStream;
    import flash.media.Camera;
    import flash.utils.getQualifiedClassName;
    import starling.utils.execute;
    import starling.core.starling_internal;
    import starling.core.Starling;
    import flash.display3D.Context3D;
    import starling.errors.NotSupportedError;
    import starling.errors.MissingContextError;
    import starling.utils.Color;
    import starling.core.RenderSupport;

    use namespace starling_internal;

    public class ConcreteTexture extends starling.textures.Texture 
    {

        private static const TEXTURE_READY:String = "textureReady";

        private static var sOrigin:Point = new Point();
        public static var texCount:uint = 0;
        public static var checkRefDsp:Boolean = false;

        private var mBase:TextureBase;
        private var mFormat:String;
        private var mWidth:int;
        private var mHeight:int;
        private var mMipMapping:Boolean;
        private var mPremultipliedAlpha:Boolean;
        private var mOptimizedForRenderTexture:Boolean;
        private var mScale:Number;
        private var mRepeat:Boolean;
        private var mOnRestore:Function;
        private var mDataUploaded:Boolean;
        private var mTextureReadyCallback:Function;
        private var _data:*;
        public var textureBytes:uint = 0;
        public var dbgVector:Vector.<DisplayObject>;
        private var _refCount:int = 0;
        public var texItem:*;
        public var onRefChange:*;

        public function ConcreteTexture(_arg_1:TextureBase, _arg_2:String, _arg_3:int, _arg_4:int, _arg_5:Boolean, _arg_6:Boolean, _arg_7:Boolean=false, _arg_8:Number=1, _arg_9:Boolean=false)
        {
            mScale = ((_arg_8 <= 0) ? 1 : _arg_8);
            mBase = _arg_1;
            mFormat = _arg_2;
            mWidth = _arg_3;
            mHeight = _arg_4;
            mMipMapping = _arg_5;
            mPremultipliedAlpha = _arg_6;
            mOptimizedForRenderTexture = _arg_7;
            mRepeat = _arg_9;
            mOnRestore = null;
            mDataUploaded = false;
            mTextureReadyCallback = null;
            texCount++;
        }

        override public function dispose():void
        {
            if (((dbgVector) && (dbgVector.length > 0)))
            {
                throw (new Error(("还有显示对象引用这个贴图:" + this.url)));
            };
            if ("embed/range.atf" == this.url)
            {
                (trace("nop"));
            };
            if (mBase)
            {
                mBase.removeEventListener("textureReady", onTextureReady);
                mBase.dispose();
                texCount--;
            };
            this.onRestore = null;
            super.dispose();
        }

        public function uploadBitmap(_arg_1:Bitmap):void
        {
            uploadBitmapData(_arg_1.bitmapData);
        }

        public function uploadBitmapData(_arg_1:BitmapData):void
        {
            var _local_5:* = null;
            var _local_7:* = null;
            var _local_4:int;
            var _local_8:int;
            var _local_6:int;
            var _local_9:* = null;
            var _local_3:* = null;
            var _local_2:* = null;
            if (((!(_arg_1.width == mWidth)) || (!(_arg_1.height == mHeight))))
            {
                _local_5 = new BitmapData(mWidth, mHeight, true, 0);
                _local_5.copyPixels(_arg_1, _arg_1.rect, sOrigin);
                _arg_1 = _local_5;
            };
            if ((mBase is flash.display3D.textures.Texture))
            {
                _local_7 = (mBase as flash.display3D.textures.Texture);
                _local_7.uploadFromBitmapData(_arg_1);
                if ((((mMipMapping) && (_arg_1.width > 1)) && (_arg_1.height > 1)))
                {
                    _local_4 = (_arg_1.width >> 1);
                    _local_8 = (_arg_1.height >> 1);
                    _local_6 = 1;
                    _local_9 = new BitmapData(_local_4, _local_8, true, 0);
                    _local_3 = new Matrix(0.5, 0, 0, 0.5);
                    _local_2 = new Rectangle();
                    while (((_local_4 >= 1) || (_local_8 >= 1)))
                    {
                        _local_2.width = _local_4;
                        _local_2.height = _local_8;
                        _local_9.fillRect(_local_2, 0);
                        _local_9.draw(_arg_1, _local_3, null, null, null, true);
                        _local_7.uploadFromBitmapData(_local_9, _local_6++);
                        _local_3.scale(0.5, 0.5);
                        _local_4 = (_local_4 >> 1);
                        _local_8 = (_local_8 >> 1);
                    };
                    _local_9.dispose();
                };
            }
            else
            {
                (mBase["uploadFromBitmapData"](_arg_1));
            };
            if (_local_5)
            {
                _local_5.dispose();
            };
            mDataUploaded = true;
        }

        public function uploadAtfData(_arg_1:ByteArray, _arg_2:int=0, _arg_3:*=null):void
        {
            var _local_5:Boolean = ((_arg_3 is Function) || (_arg_3 === true));
            var _local_4:flash.display3D.textures.Texture = (mBase as flash.display3D.textures.Texture);
            if (_local_4 == null)
            {
                throw (new Error("This texture type does not support ATF data"));
            };
            if ((_arg_3 is Function))
            {
                mTextureReadyCallback = (_arg_3 as Function);
                mBase.addEventListener("textureReady", onTextureReady);
            };
            _local_4.uploadCompressedTextureFromByteArray(_arg_1, _arg_2, _local_5);
            mDataUploaded = true;
        }

        public function attachNetStream(_arg_1:NetStream, _arg_2:Function=null):void
        {
            attachVideo("NetStream", _arg_1, _arg_2);
        }

        public function attachCamera(_arg_1:Camera, _arg_2:Function=null):void
        {
            attachVideo("Camera", _arg_1, _arg_2);
        }

        internal function attachVideo(_arg_1:String, _arg_2:Object, _arg_3:Function=null):void
        {
            var _local_4:String = getQualifiedClassName(mBase);
            if (_local_4 == "flash.display3D.textures::VideoTexture")
            {
                mDataUploaded = true;
                mTextureReadyCallback = _arg_3;
                (mBase[("attach" + _arg_1)](_arg_2));
                mBase.addEventListener("textureReady", onTextureReady);
            }
            else
            {
                throw (new Error((("This texture type does not support " + _arg_1) + " _data")));
            };
        }

        private function onTextureReady(_arg_1:Object):void
        {
            mBase.removeEventListener("textureReady", onTextureReady);
            execute(mTextureReadyCallback, this);
            mTextureReadyCallback = null;
        }

        private function onContextCreated():void
        {
            starling_internal::createBase();
            onRestoreX();
            if (mOnRestore != null)
            {
                (mOnRestore());
            };
            if (!mDataUploaded)
            {
                clear();
            };
        }

        starling_internal function createBase():void
        {
            var _local_1:Context3D = Starling.context;
            var _local_2:String = getQualifiedClassName(mBase);
            if (_local_2 == "flash.display3D.textures::Texture")
            {
                mBase = _local_1.createTexture(mWidth, mHeight, mFormat, mOptimizedForRenderTexture);
            }
            else
            {
                if (_local_2 == "flash.display3D.textures::RectangleTexture")
                {
                    mBase = _local_1["createRectangleTexture"](mWidth, mHeight, mFormat, mOptimizedForRenderTexture);
                }
                else
                {
                    if (_local_2 == "flash.display3D.textures::VideoTexture")
                    {
                        mBase = _local_1["createVideoTexture"]();
                    }
                    else
                    {
                        throw (new NotSupportedError(("Texture type not supported: " + _local_2)));
                    };
                };
            };
            mDataUploaded = false;
        }

        public function clear(_arg_1:uint=0, _arg_2:Number=0):void
        {
            var _local_3:Context3D = Starling.context;
            if (_local_3 == null)
            {
                throw (new MissingContextError());
            };
            if (((mPremultipliedAlpha) && (_arg_2 < 1)))
            {
                _arg_1 = Color.rgb((Color.getRed(_arg_1) * _arg_2), (Color.getGreen(_arg_1) * _arg_2), (Color.getBlue(_arg_1) * _arg_2));
            };
            _local_3.setRenderToTexture(mBase);
            try
            {
                RenderSupport.clear(_arg_1, _arg_2);
            }
            catch(e:Error)
            {
            };
            _local_3.setRenderToBackBuffer();
            mDataUploaded = true;
        }

        public function get optimizedForRenderTexture():Boolean
        {
            return (mOptimizedForRenderTexture);
        }

        public function set onRestore(_arg_1:Function):void
        {
            Starling.current.removeEventListener("context3DCreate", onContextCreated);
            if (((Starling.handleLostContext) && (!(_arg_1 == null))))
            {
                if (mOnRestore != onRestoreX)
                {
                    mOnRestore = _arg_1;
                };
                Starling.current.addEventListener("context3DCreate", onContextCreated);
            }
            else
            {
                mOnRestore = null;
            };
        }

        public function set data(_arg_1:*):void
        {
            var _local_3:* = null;
            var _local_2:* = null;
            if ((_arg_1 is ByteArray))
            {
                _local_3 = (_arg_1 as ByteArray);
                textureBytes = _local_3.length;
            }
            else
            {
                _local_2 = (_arg_1 as BitmapData);
                textureBytes = ((_local_2.width * _local_2.height) * ((_local_2.transparent) ? 4 : 3));
            };
            _data = _arg_1;
            onRestore = onRestoreX;
        }

        private function onRestoreX():void
        {
            if ((_data is ByteArray))
            {
                this.uploadAtfData(_data, 0);
            }
            else
            {
                if ((_data is BitmapData))
                {
                    this.uploadBitmapData(_data);
                };
            };
        }

        override public function get base():TextureBase
        {
            return (mBase);
        }

        override public function get root():ConcreteTexture
        {
            return (this);
        }

        override public function get format():String
        {
            return (mFormat);
        }

        override public function get width():Number
        {
            return (mWidth / mScale);
        }

        override public function get height():Number
        {
            return (mHeight / mScale);
        }

        override public function get nativeWidth():Number
        {
            return (mWidth);
        }

        override public function get nativeHeight():Number
        {
            return (mHeight);
        }

        override public function get scale():Number
        {
            return (mScale);
        }

        override public function get mipMapping():Boolean
        {
            return (mMipMapping);
        }

        override public function get premultipliedAlpha():Boolean
        {
            return (mPremultipliedAlpha);
        }

        override public function get repeat():Boolean
        {
            return (mRepeat);
        }

        public function addRefImage(_arg_1:DisplayObject):void
        {
            if (!checkRefDsp)
            {
                return;
            };
            if (dbgVector == null)
            {
                dbgVector = new Vector.<DisplayObject>();
            };
            if (dbgVector.indexOf(_arg_1) == -1)
            {
                dbgVector.push(_arg_1);
            };
        }

        public function removeRefImage(_arg_1:DisplayObject):void
        {
            if (!checkRefDsp)
            {
                return;
            };
            var _local_2:int = dbgVector.indexOf(_arg_1);
            dbgVector.splice(_local_2, 1);
        }

        public function addRef():void
        {
            _refCount++;
            if (onRefChange)
            {
                (onRefChange(true));
            };
        }

        public function decRef():void
        {
            _refCount--;
            if (onRefChange)
            {
                (onRefChange(false));
            };
            if (_refCount < 0)
            {
                throw (new Error("解引用异常"));
            };
        }

        public function getRefCount():int
        {
            return (_refCount);
        }


    }
}//package starling.textures

