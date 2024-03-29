﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.textures.Texture

package starling.textures
{
    import starling.utils.VertexVO;
    import flash.utils.getQualifiedClassName;
    import flash.system.Capabilities;
    import starling.errors.AbstractClassError;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    import starling.core.Starling;
    import flash.display3D.Context3D;
    import starling.errors.MissingContextError;
    import flash.net.NetStream;
    import flash.media.Camera;
    import starling.utils.SystemUtil;
    import starling.errors.NotSupportedError;
    import flash.display3D.textures.TextureBase;
    import starling.utils.execute;
    import starling.utils.Color;
    import starling.utils.getNextPowerOfTwo;
    import flash.geom.Rectangle;
    import starling.utils.VertexData;
    import __AS3__.vec.Vector;

    public class Texture 
    {

        private static var idnumber:uint = 0;
        public static var sFreeVertex:Function;
        public static var onTextureCreateError:Function;

        public var id:uint = 0xFFFFFFFF;
        public var url:String;
        public var vertex:VertexVO;
        public var disposed:Boolean = false;

        public function Texture()
        {
            if (((Capabilities.isDebugger) && (getQualifiedClassName(this) == "starling.textures::Texture")))
            {
                throw (new AbstractClassError());
            };
            idnumber++;
            this.id = idnumber;
        }

        public static function fromData(_arg_1:Object, _arg_2:TextureOptions=null):starling.textures.Texture
        {
            var _local_3:starling.textures.Texture;
            if ((_arg_1 is Bitmap))
            {
                _arg_1 = (_arg_1 as Bitmap).bitmapData;
            };
            if (_arg_2 == null)
            {
                _arg_2 = new TextureOptions();
            };
            if ((_arg_1 is Class))
            {
                _local_3 = fromEmbeddedAsset((_arg_1 as Class), _arg_2.mipMapping, _arg_2.optimizeForRenderToTexture, _arg_2.scale, _arg_2.format, _arg_2.repeat);
            }
            else
            {
                if ((_arg_1 is BitmapData))
                {
                    _local_3 = fromBitmapData((_arg_1 as BitmapData), _arg_2.mipMapping, _arg_2.optimizeForRenderToTexture, _arg_2.scale, _arg_2.format, _arg_2.repeat);
                }
                else
                {
                    if ((_arg_1 is ByteArray))
                    {
                        _local_3 = fromAtfData((_arg_1 as ByteArray), _arg_2.scale, _arg_2.mipMapping, _arg_2.onReady, _arg_2.repeat);
                    }
                    else
                    {
                        throw (new ArgumentError(("Unsupported 'data' type: " + getQualifiedClassName(_arg_1))));
                    };
                };
            };
            return (_local_3);
        }

        public static function fromEmbeddedAsset(assetClass:Class, mipMapping:Boolean=true, optimizeForRenderToTexture:Boolean=false, scale:Number=1, format:String="bgra", repeat:Boolean=false):starling.textures.Texture
        {
            var asset:Object = new assetClass();
            if ((asset is Bitmap))
            {
                var texture:starling.textures.Texture = starling.textures.Texture.fromBitmap((asset as Bitmap), internal::mipMapping, optimizeForRenderToTexture, internal::scale, internal::format, internal::repeat);
                texture.root.onRestore = function ():void
                {
                    texture.root.uploadBitmap(new assetClass());
                };
            }
            else
            {
                if ((asset is ByteArray))
                {
                    texture = starling.textures.Texture.fromAtfData((asset as ByteArray), internal::scale, internal::mipMapping, null, internal::repeat);
                    texture.root.onRestore = function ():void
                    {
                        texture.root.uploadAtfData(new assetClass());
                    };
                }
                else
                {
                    throw (new ArgumentError(("Invalid asset type: " + getQualifiedClassName(asset))));
                };
            };
            asset = null;
            return (texture);
        }

        public static function fromBitmap(_arg_1:Bitmap, _arg_2:Boolean=true, _arg_3:Boolean=false, _arg_4:Number=1, _arg_5:String="bgra", _arg_6:Boolean=false):starling.textures.Texture
        {
            return (fromBitmapData(_arg_1.bitmapData, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6));
        }

        public static function fromBitmapData(_arg_1:BitmapData, _arg_2:Boolean=true, _arg_3:Boolean=false, _arg_4:Number=1, _arg_5:String="bgra", _arg_6:Boolean=false):starling.textures.Texture
        {
            var _local_8:starling.textures.Texture = starling.textures.Texture.empty((_arg_1.width / _arg_4), (_arg_1.height / _arg_4), true, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
            var _local_7:ConcreteTexture = _local_8.root;
            _local_7.uploadBitmapData(_arg_1);
            _local_7.data = _arg_1;
            return (_local_8);
        }

        public static function fromAtfData(_arg_1:ByteArray, _arg_2:Number=1, _arg_3:Boolean=true, _arg_4:Function=null, _arg_5:Boolean=false):starling.textures.Texture
        {
            var _local_8:* = null;
            var _local_7:Context3D = Starling.context;
            if (_local_7 == null)
            {
                throw (new MissingContextError());
            };
            var _local_9:AtfData = AtfData.getInstance();
            _local_9.parse(_arg_1);
            if (onTextureCreateError == null)
            {
                _local_8 = _local_7.createTexture(_local_9.width, _local_9.height, _local_9.format, false);
            }
            else
            {
                try
                {
                    _local_8 = _local_7.createTexture(_local_9.width, _local_9.height, _local_9.format, false);
                }
                catch(e:Error)
                {
                    (onTextureCreateError(e));
                    throw (e);
                };
            };
            var _local_6:ConcreteTexture = new ConcreteTexture(_local_8, _local_9.format, _local_9.width, _local_9.height, ((_arg_3) && (_local_9.numTextures > 1)), false, false, _arg_2, _arg_5);
            _local_6.uploadAtfData(_arg_1, 0, _arg_4);
            _local_6.data = _arg_1;
            return (_local_6);
        }

        public static function fromNetStream(stream:NetStream, scale:Number=1, onComplete:Function=null):starling.textures.Texture
        {
            if (((stream.client == stream) && (!("onMetaData" in stream))))
            {
                stream.client = {"onMetaData":function (_arg_1:Object):void
                    {
                    }};
            };
            return (fromVideoAttachment("NetStream", stream, internal::scale, onComplete));
        }

        public static function fromCamera(_arg_1:Camera, _arg_2:Number=1, _arg_3:Function=null):starling.textures.Texture
        {
            return (fromVideoAttachment("Camera", _arg_1, _arg_2, _arg_3));
        }

        private static function fromVideoAttachment(type:String, attachment:Object, scale:Number, onComplete:Function):starling.textures.Texture
        {
            const TEXTURE_READY:String = "textureReady";
            if (!SystemUtil.supportsVideoTexture)
            {
                throw (new NotSupportedError("Video Textures are not supported on this platform"));
            };
            var context:Context3D = Starling.context;
            if (context == null)
            {
                throw (new MissingContextError());
            };
            var base:TextureBase = context["createVideoTexture"]();
            (internal::base[("attach" + type)](attachment));
            internal::base.addEventListener("textureReady", function (_arg_1:Object):void
            {
                internal::base.removeEventListener("textureReady", arguments.callee);
                execute(onComplete, texture);
            });
            var texture:ConcreteVideoTexture = new ConcreteVideoTexture(internal::base, internal::scale);
            texture.onRestore = function ():void
            {
                texture.root.attachVideo(type, attachment);
            };
            return (texture);
        }

        public static function fromColor(width:Number, height:Number, color:uint=0xFFFFFFFF, optimizeForRenderToTexture:Boolean=false, scale:Number=-1, format:String="bgra"):starling.textures.Texture
        {
            var texture:starling.textures.Texture = starling.textures.Texture.empty(internal::width, internal::height, true, false, optimizeForRenderToTexture, internal::scale, internal::format);
            texture.root.clear(color, (Color.getAlpha(color) / 0xFF));
            texture.root.onRestore = function ():void
            {
                texture.root.clear(color, (Color.getAlpha(color) / 0xFF));
            };
            return (texture);
        }

        public static function empty(_arg_1:Number, _arg_2:Number, _arg_3:Boolean=true, _arg_4:Boolean=true, _arg_5:Boolean=false, _arg_6:Number=-1, _arg_7:String="bgra", _arg_8:Boolean=false):starling.textures.Texture
        {
            var _local_9:int;
            var _local_14:int;
            var _local_12:* = null;
            if (_arg_6 <= 0)
            {
                _arg_6 = Starling.contentScaleFactor;
            };
            var _local_15:Context3D = Starling.context;
            if (_local_15 == null)
            {
                throw (new MissingContextError());
            };
            var _local_11:Number = (_arg_1 * _arg_6);
            var _local_10:Number = (_arg_2 * _arg_6);
            var _local_16:Boolean = (((((!(_arg_4)) && (!(_arg_8))) && (!(Starling.current.profile == "baselineConstrained"))) && ("createRectangleTexture" in _local_15)) && (_arg_7.indexOf("compressed") == -1));
            if (_local_16)
            {
                _local_14 = Math.ceil((_local_11 - 1E-9));
                _local_9 = Math.ceil((_local_10 - 1E-9));
                _local_12 = _local_15["createRectangleTexture"](_local_14, _local_9, _arg_7, _arg_5);
            }
            else
            {
                _local_14 = getNextPowerOfTwo(_local_11);
                _local_9 = getNextPowerOfTwo(_local_10);
                if (onTextureCreateError == null)
                {
                    _local_12 = _local_15.createTexture(_local_14, _local_9, _arg_7, _arg_5);
                }
                else
                {
                    try
                    {
                        _local_12 = _local_15.createTexture(_local_14, _local_9, _arg_7, _arg_5);
                    }
                    catch(e:Error)
                    {
                        (onTextureCreateError(e));
                        throw (e);
                    };
                };
            };
            var _local_13:ConcreteTexture = new ConcreteTexture(_local_12, _arg_7, _local_14, _local_9, _arg_4, _arg_3, _arg_5, _arg_6, _arg_8);
            _local_13.onRestore = _local_13.clear;
            if ((((_local_14 - _local_11) < 0.001) && ((_local_9 - _local_10) < 0.001)))
            {
                return (_local_13);
            };
            return (new SubTexture(_local_13, new Rectangle(0, 0, _arg_1, _arg_2), true));
        }

        public static function fromTexture(_arg_1:starling.textures.Texture, _arg_2:Rectangle=null, _arg_3:Rectangle=null, _arg_4:Boolean=false):starling.textures.Texture
        {
            return (new SubTexture(_arg_1, _arg_2, false, _arg_3, _arg_4));
        }

        public static function get maxSize():int
        {
            var _local_1:Starling = Starling.current;
            var _local_2:String = ((_local_1) ? _local_1.profile : "baseline");
            if (((_local_2 == "baseline") || (_local_2 == "baselineConstrained")))
            {
                return (0x0800);
            };
            return (0x1000);
        }

        public static function compress(_arg_1:ByteArray):void
        {
            if (isAtf(_arg_1))
            {
                _arg_1.deflate();
            };
        }

        private static function isAtf(_arg_1:ByteArray):Boolean
        {
            return (((_arg_1[0] == 65) && (_arg_1[1] == 84)) && (_arg_1[2] == 70));
        }

        public static function uncompress(_arg_1:ByteArray):void
        {
            if (!isAtf(_arg_1))
            {
                _arg_1.inflate();
            };
        }


        public function dispose():void
        {
            if (disposed)
            {
                throw (new Error("duplicate dispose call"));
            };
            disposed = true;
        }

        public function freeVertex():void
        {
            if (vertex)
            {
                (sFreeVertex(vertex));
                vertex = null;
            };
        }

        public function adjustVertexData(_arg_1:VertexData, _arg_2:int, _arg_3:int):void
        {
        }

        public function adjustTexCoords(_arg_1:Vector.<Number>, _arg_2:int=0, _arg_3:int=0, _arg_4:int=-1):void
        {
        }

        public function get frame():Rectangle
        {
            return (null);
        }

        public function get repeat():Boolean
        {
            return (false);
        }

        public function get width():Number
        {
            return (0);
        }

        public function get height():Number
        {
            return (0);
        }

        public function get nativeWidth():Number
        {
            return (0);
        }

        public function get nativeHeight():Number
        {
            return (0);
        }

        public function get scale():Number
        {
            return (1);
        }

        public function get base():TextureBase
        {
            return (null);
        }

        public function get root():ConcreteTexture
        {
            return (null);
        }

        public function get format():String
        {
            return ("bgra");
        }

        public function get mipMapping():Boolean
        {
            return (false);
        }

        public function get premultipliedAlpha():Boolean
        {
            return (false);
        }


    }
}//package starling.textures

