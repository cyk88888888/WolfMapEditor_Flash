// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.game.manager.TextureCache

package com.game.manager
{
    import flash.utils.Dictionary;
    import flash.utils.getTimer;
    import starling.textures.ConcreteTexture;
    import com.core.loader.LoaderMgr;
    import com.core.loader.ResContent;
    import flash.utils.ByteArray;
    import core.utils.DbgUtil;
    import starling.core.Starling;
    import com.common.util.ArrayUtils;
    import flash.display.BitmapData;
    import starling.textures.Texture;
    import com.core.imagedecode.ImageDecoding;
    import starling.textures.SubTexture;
    import com.core.game.SpriteSheetData;

    public class TextureCache 
    {

        private static const CHECK_INTERVAL:int = 1000;
        private static const WAIT_AFTER_LOADED:int = 5000;
        private static const HOLDING_TIME:int = 5000;
        private static const lM:int = 0x100000;
        private static const REL_MEM:int = 104857600;
        private static const CHECK_PASS_THRESHOLD:int = 30;
        private static const LIMIT_COUNT:int = 0x0300;

        private static var _instance:TextureCache;
        private static var _holdItemStr:Array = [];
        private static var _holdSizeTotal:int;

        public var _dicTextures:Dictionary = new Dictionary();
        private var _loading:Dictionary = new Dictionary();
        private var waitContextCreate:Dictionary;
        private var waitContextCreateIgnored:Dictionary;
        public var textureBytes:uint = 0;
        public var totalTextureCount:uint = 0;
        private var lastCheckTime:int = getTimer();


        public static function getInstance():TextureCache
        {
            if (_instance == null)
            {
                _instance = new (TextureCache)();
            };
            return (_instance);
        }

        private static function getItemSize(_arg_1:TextureItem):int
        {
            return ((_arg_1.tex as ConcreteTexture).textureBytes / 0x0400);
        }


        public function removeCallBack(_arg_1:String, _arg_2:Function):void
        {
            var _local_3:TextureItem = getCacheItem(_arg_1);
            if (_local_3)
            {
                _local_3.removeUploadCallBack(_arg_2);
            };
        }

        public function loadTexture(_arg_1:String, _arg_2:Function, _arg_3:uint, _arg_4:Function, _arg_5:Function=null, _arg_6:Function=null):void
        {
            var _local_8:*;
            var _local_7:* = null;
            var _local_9:TextureItem = ensureCacheItem(_arg_1);
            if (_local_9.tex)
            {
                if (_arg_5 != null)
                {
                    (_arg_5(_arg_1));
                };
                if (_arg_2 != null)
                {
                    (_arg_2(_arg_1, _local_9));
                };
                return;
            };
            if (_arg_2 != null)
            {
                _local_9.addUploadCallBack(_arg_2);
            };
            if (_arg_5 != null)
            {
                if (_local_9.state == 2)
                {
                    (_arg_5(_arg_1));
                }
                else
                {
                    _local_9.addLoadedCallBack(_arg_5);
                };
            };
            _local_9.addErrorCallBack(_arg_4);
            if (!_loading[_arg_1])
            {
                _loading[_arg_1] = true;
                _local_9.state = 1;
                LoaderMgr.getInstance().load(_arg_1, loadCompleteHandler, false, null, _arg_3, 100000, _arg_6, loadErrorHandler);
            }
            else
            {
                _local_8 = null;
                if (waitContextCreateIgnored)
                {
                    _local_8 = waitContextCreateIgnored[_arg_1];
                    waitContextCreateIgnored[_arg_1] = null;
                };
                if (_local_8 == null)
                {
                    _local_7 = LoaderMgr.getInstance().getResource(_arg_1);
                    if (((_local_7) && (_local_7.content)))
                    {
                        _local_8 = _local_7.content;
                    };
                };
                if (_local_8)
                {
                    upload(_arg_1, _local_8);
                };
            };
        }

        public function removeLoad(_arg_1:String):void
        {
            var _local_2:TextureItem = getCacheItem(_arg_1);
            if (_local_2)
            {
                _local_2.clearCallBack();
            };
            LoaderMgr.getInstance().cancelLoad(_arg_1);
            delete _loading[_arg_1]; //not popped
        }

        private function loadCompleteHandler(_arg_1:String):void
        {
            var _local_4:* = null;
            var _local_2:* = null;
            var _local_5:TextureItem = getCacheItem(_arg_1);
            var _local_3:ResContent = LoaderMgr.getInstance().getResource(_arg_1);
            _local_5.state = 2;
            if (trace_load)
            {
                traceInlLDR(("TexLoaded:" + _arg_1));
            };
            _local_5.onLoaded();
            if ((_local_3.content is ByteArray))
            {
                _local_4 = (_local_3.content as ByteArray);
                if (_local_4.length <= 3)
                {
                    _local_2 = ("ATFBytes invalid:" + _arg_1);
                    DbgUtil.reportErr(_local_2);
                    return;
                };
            };
            if (((Starling.current == null) || (!(Starling.current.contextValid))))
            {
                if (waitContextCreate == null)
                {
                    waitContextCreate = new Dictionary();
                };
                waitContextCreate[_arg_1] = _local_3.content;
            }
            else
            {
                upload(_arg_1, _local_3.content);
            };
        }

        public function onContext3dCreate():void
        {
            var _local_3:* = null;
            var _local_2:uint;
            var _local_1:*;
            if (waitContextCreate == null)
            {
                return;
            };
            if (waitContextCreateIgnored == null)
            {
                waitContextCreateIgnored = new Dictionary();
            };
            for (var _local_4:String in waitContextCreate)
            {
                _local_3 = getCacheItem(_local_4);
                if (_local_3 != null)
                {
                    _local_2 = ArrayUtils.eLen(_local_3.cbksUpload);
                    _local_1 = waitContextCreate[_local_4];
                    if (_local_2 >= 1)
                    {
                        upload(_local_4, _local_1);
                    }
                    else
                    {
                        waitContextCreateIgnored[_local_4] = _local_1;
                    };
                };
            };
            waitContextCreate = null;
        }

        private function upload(_arg_1:String, _arg_2:*):void
        {
            var _local_4:* = null;
            var _local_5:* = null;
            var _local_7:* = null;
            var _local_3:* = null;
            var _local_6:* = null;
            if ((_arg_2 is BitmapData))
            {
                _local_4 = (_arg_2 as BitmapData);
                _local_5 = (Texture.fromBitmapData(_local_4, false, false, 1) as ConcreteTexture);
                _local_5.url = _arg_1;
                onConcreteTextureCreated(_local_5);
            }
            else
            {
                _local_7 = (_arg_2 as ByteArray);
                try
                {
                    Texture.uncompress(_local_7);
                    if (ImageDecoding.sync)
                    {
                        _local_3 = (Texture.fromAtfData(_local_7, 1, false, null) as ConcreteTexture);
                        _local_3.url = _arg_1;
                        onConcreteTextureCreated(_local_3);
                    }
                    else
                    {
                        _local_3 = (Texture.fromAtfData(_local_7, 1, false, onConcreteTextureCreated) as ConcreteTexture);
                        _local_3.url = _arg_1;
                    };
                }
                catch(e:Error)
                {
                    _local_6 = DbgUtil.splitStackTrace(e);
                    traceErr(_local_6);
                };
            };
        }

        private function onConcreteTextureCreated(_arg_1:ConcreteTexture):void
        {
            var _local_3:String = _arg_1.url;
            if (trace_load)
            {
                traceInlLDR(("TexCreated:" + _local_3));
            };
            if (true != _loading[_local_3])
            {
                _arg_1.dispose();
                return;
            };
            delete _loading[_local_3];
            var _local_2:TextureItem = getCacheItem(_local_3);
            if (_local_2 == null)
            {
                _arg_1.dispose();
                return;
            };
            _local_2.state = 3;
            textureBytes = (textureBytes + _arg_1.textureBytes);
            totalTextureCount++;
            _local_2.setTextureVal(_arg_1);
            _local_2.lastRefTime = getTimer();
            _local_2.onUploaded(_local_3);
        }

        public function getCacheItem(_arg_1:String):TextureItem
        {
            return (_dicTextures[_arg_1]);
        }

        public function findTextureItem(_arg_1:Texture):TextureItem
        {
            if (_arg_1 == null)
            {
                return (null);
            };
            _arg_1 = ((_arg_1 is SubTexture) ? (_arg_1 as SubTexture).parent : _arg_1);
            for each (var _local_2:TextureItem in _dicTextures)
            {
                if (_arg_1 == _local_2.tex)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        public function ensureCacheItem(_arg_1:String):TextureItem
        {
            var _local_2:* = null;
            if (_dicTextures[_arg_1] == undefined)
            {
                _local_2 = TextureItem.NEW();
                _local_2.url = _arg_1;
                _local_2.lastRefTime = getTimer();
                addTextureItem(_arg_1, _local_2);
            };
            return (_dicTextures[_arg_1]);
        }

        public function getTexture(_arg_1:String):Texture
        {
            var _local_2:TextureItem = _dicTextures[_arg_1];
            if (_local_2 == null)
            {
                return (null);
            };
            return (_local_2.tex);
        }

        private function addTextureItem(_arg_1:String, _arg_2:TextureItem):void
        {
            _dicTextures[_arg_1] = _arg_2;
        }

        private function removeTextureItem(_arg_1:TextureItem):void
        {
            var _local_2:String = _arg_1.url;
            if (_arg_1.tex)
            {
                totalTextureCount--;
                textureBytes = (textureBytes - (_arg_1.tex as ConcreteTexture).textureBytes);
            };
            TextureItem.FREE(_arg_1);
            delete _dicTextures[_local_2]; //not popped
        }

        private function loadErrorHandler(_arg_1:String):void
        {
            delete _loading[_arg_1];
            var _local_2:TextureItem = getCacheItem(_arg_1);
            _local_2.state = 4;
            _local_2.onError();
            removeTextureItem(_local_2);
        }

        public function update():void
        {
            var _local_5:uint;
            var _local_1:Boolean;
            var _local_2:uint;
            var _local_4:Boolean;
            var _local_3:int = getTimer();
            if ((_local_3 - lastCheckTime) > 1000)
            {
                _local_4 = true;
                lastCheckTime = _local_3;
            };
            if (_local_4)
            {
                _local_5 = ConcreteTexture.texCount;
                _local_1 = ((textureBytes > 104857600) || (_local_5 > 0x0300));
                _local_2 = 0;
                if (((_local_1) || ((_local_2 = ORefCount()) > 30)))
                {
                    freeUselessTexture();
                };
            };
        }

        private function ORefCount():uint
        {
            var _local_2:* = null;
            var _local_1:uint;
            for (var _local_3:String in _dicTextures)
            {
                _local_2 = _dicTextures[_local_3];
                if (_local_2.getRefCount() == 0)
                {
                    _local_1++;
                };
            };
            return (_local_1);
        }

        public function freeUselessTexture():void
        {
            var _local_5:* = null;
            var _local_4:Boolean;
            var _local_3:* = null;
            var _local_1:* = null;
            var _local_8:uint;
            var _local_2:int = getTimer();
            for (var _local_6:String in _dicTextures)
            {
                _local_5 = _dicTextures[_local_6];
                if (_local_5.tex != null)
                {
                    if (_local_5.state != 2)
                    {
                        if (!_local_5.hold)
                        {
                            if (_local_5.getRefCount() <= 0)
                            {
                                if (!((_local_5.lastRefTime > 0) && (((_local_2 - _local_5.lastRefTime) < 5000) || (_local_5.tex == null))))
                                {
                                    _local_4 = false;
                                    if (_local_5.deRefTime != -1)
                                    {
                                        _local_4 = ((_local_2 - _local_5.deRefTime) > 5000);
                                    }
                                    else
                                    {
                                        if (((_local_5.deRefTime == -1) && (!(_local_5.tex == null))))
                                        {
                                            _local_4 = ((_local_2 - _local_5.lastRefTime) > 5000);
                                        }
                                        else
                                        {
                                            if (_local_5.deRefTime == 0)
                                            {
                                                DbgUtil.assert("不可能");
                                            };
                                        };
                                    };
                                    if (_local_4)
                                    {
                                        _local_8++;
                                        _local_3 = ((_local_6.indexOf(".png") == -1) ? _local_6 : _local_6.replace(".png", ".atf"));
                                        _local_1 = SpriteSheetData.getInstance().getSheetData(_local_3);
                                        if (_local_1)
                                        {
                                            _local_1.disposeTexture();
                                        };
                                        ((trace_load) && (traceInlLDR("DisposeTexture", _local_6)));
                                        LoaderMgr.getInstance().removeResource(_local_6);
                                        removeTextureItem(_local_5);
                                    };
                                };
                            };
                        };
                    };
                };
            };
            var _local_7:int = (getTimer() - _local_2);
        }

        public function debugOut(_arg_1:Function=null):void
        {
            var _local_9:* = null;
            var _local_8:* = null;
            var _local_5:* = null;
            var _local_2:* = null;
            var _local_7:int;
            var _local_4:* = null;
            var _local_6:uint;
            if (!_arg_1)
            {
                _arg_1 = trace;
            };
            for (var _local_10:String in _dicTextures)
            {
                _local_9 = _dicTextures[_local_10];
                _local_6++;
                _local_8 = "ref:";
                if (_local_9.tex == null)
                {
                    _local_8 = "nil";
                };
                _local_5 = _local_9.getRefCount().toString();
                _local_2 = ((_local_9.hold) ? ("h" + _local_5) : _local_5);
                _local_7 = getTimer();
                _local_4 = (((((((((((_local_8 + _local_2) + " ") + _local_9.url) + " L:") + _local_9.lastRefTime) + " D:") + _local_9.deRefTime) + " LT:") + (_local_7 - _local_9.lastRefTime)) + " DT:") + (_local_7 - _local_9.deRefTime));
                (_arg_1(_local_4));
            };
            (_arg_1((((("TextureItem Count:" + _local_6) + " size:") + (textureBytes / 0x100000)) + "MB")));
            var _local_3:uint = ConcreteTexture.texCount;
            _arg_1(("ConcreteTexture Count:" + _local_3)); //not popped
        }


    }
}//package com.game.manager

