// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.LoadingItem

package com.core.loader
{
    import core.utils.ObjectPoolList;
    import __AS3__.vec.Vector;
    import core.utils.DbgUtil;

    public class LoadingItem 
    {

        public static var ObjectPool:ObjectPoolList;

        public var appendTryCount:Boolean = false;
        public var retry:int;
        private var _url:String;
        public var queueType:uint;
        public var priority:uint;
        private var _loader:ResLoader;
        private var _decodeCallBacks:Vector.<LdrCallBack> = new Vector.<LdrCallBack>();
        private var _loadCallBacks:Vector.<LdrCallBack> = new Vector.<LdrCallBack>();
        private var _errorCallBacks:Vector.<LdrCallBack> = new Vector.<LdrCallBack>();
        private var _progressCallBacks:Vector.<Function> = new Vector.<Function>();
        private var _isCallBackRunning:Boolean = false;


        public static function NEW(_arg_1:String):LoadingItem
        {
            if (!ObjectPool)
            {
                ObjectPool = new ObjectPoolList(LoadingItem);
            };
            var _local_2:LoadingItem = ObjectPool.Alloc(LoadingItem);
            _local_2.url = _arg_1;
            return (_local_2);
        }

        public static function FREE(_arg_1:LoadingItem):void
        {
            _arg_1.dispose();
            ObjectPool.Release(_arg_1);
        }


        public function set url(_arg_1:String):void
        {
            _url = _arg_1;
        }

        public function get url():String
        {
            return (_url);
        }

        public function startLoad(_arg_1:LoaderMgr):void
        {
            var _local_4:String = this.url;
            var _local_3:ResLoader = new ResLoader();
            this.loader = _local_3;
            var _local_2:String = ((this.appendTryCount) ? ("&tc=" + this.retry) : null);
            this.loader.load(_local_4, _arg_1, this.queueType, _local_2);
        }

        public function addLoadedCallBack(_arg_1:Function, _arg_2:Array=null):void
        {
            addCallBackToList(_arg_1, _arg_2, _loadCallBacks);
        }

        public function addDecodedCallBack(_arg_1:Function, _arg_2:Array, _arg_3:Boolean=true):void
        {
            addCallBackToList(_arg_1, _arg_2, _decodeCallBacks, _arg_3);
        }

        public function addErrorCallBack(_arg_1:Function, _arg_2:Array=null):void
        {
            addCallBackToList(_arg_1, _arg_2, _errorCallBacks);
        }

        private function removeFromList(_arg_1:Function, _arg_2:Vector.<LdrCallBack>):void
        {
            var _local_3:int;
            var _local_4:* = null;
            if (_arg_1 == null)
            {
                return;
            };
            _local_3 = (_arg_2.length - 1);
            while (_local_3 >= 0)
            {
                _local_4 = _arg_2[_local_3];
                if (((_local_4) && (_local_4.equal(_arg_1))))
                {
                    LdrCallBack.FREE(_local_4);
                    _arg_2[_local_3] = null;
                };
                _local_3--;
            };
        }

        private function addCallBackToList(_arg_1:Function, _arg_2:Array, _arg_3:Vector.<LdrCallBack>, _arg_4:Boolean=true):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            if (_arg_4)
            {
                for each (var _local_5:LdrCallBack in _arg_3)
                {
                    if (((_local_5) && (_local_5.equal(_arg_1))))
                    {
                        return;
                    };
                };
            };
            _local_5 = LdrCallBack.NEW();
            _local_5.setVals(_url, _arg_1, _arg_2);
            addEmptyOrEnd(_arg_3, _local_5);
        }

        private function addEmptyOrEnd(_arg_1:*, _arg_2:*):void
        {
            var _local_4:*;
            var _local_3:Number = _arg_1.indexOf(null);
            ((_local_3 == -1) ? _arg_1.push(_arg_2) : ((_local_4 = _arg_2), (_arg_1[_local_3] = _local_4), _local_4)); //not popped
        }

        private function removeAll(_arg_1:Vector.<LdrCallBack>):void
        {
            var _local_3:int;
            var _local_2:* = null;
            _local_3 = 0;
            while (_local_3 < _arg_1.length)
            {
                _local_2 = _arg_1[_local_3];
                if (_local_2 != null)
                {
                    LdrCallBack.FREE(_local_2);
                    _arg_1[_local_3] = null;
                };
                _local_3++;
            };
        }

        public function get isCallBackRunning():Boolean
        {
            return (_isCallBackRunning);
        }

        private function callList(_arg_1:Vector.<LdrCallBack>):void
        {
            var _local_3:int;
            var _local_2:* = null;
            _isCallBackRunning = true;
            _local_3 = 0;
            while (_local_3 < _arg_1.length)
            {
                _local_2 = _arg_1[_local_3];
                if (_local_2 != null)
                {
                    _local_2.execute();
                    LdrCallBack.FREE(_local_2);
                    _arg_1[_local_3] = null;
                };
                _local_3++;
            };
            _isCallBackRunning = false;
        }

        public function onLoaded():void
        {
            var _local_2:* = null;
            var _local_1:* = null;
            if (DbgUtil.tryExec)
            {
                try
                {
                    callList(_loadCallBacks);
                }
                catch(e:Error)
                {
                    _local_2 = DbgUtil.splitStackTrace(e);
                    _local_1 = (((("loaded:" + this._url) + " ") + " ") + _local_2);
                    DbgUtil.reportErr(_local_1);
                };
            }
            else
            {
                callList(_loadCallBacks);
            };
        }

        public function onDecoded():void
        {
            var _local_2:* = null;
            var _local_1:* = null;
            if (DbgUtil.tryExec)
            {
                try
                {
                    callList(_decodeCallBacks);
                }
                catch(e:Error)
                {
                    _local_2 = DbgUtil.splitStackTrace(e);
                    _local_1 = (((("derr:" + this._url) + " ") + " ") + _local_2);
                    DbgUtil.reportErr(_local_1);
                };
            }
            else
            {
                callList(_decodeCallBacks);
            };
        }

        public function onError():void
        {
            var _local_2:* = null;
            var _local_1:* = null;
            if (DbgUtil.tryExec)
            {
                try
                {
                    callList(_errorCallBacks);
                }
                catch(e:Error)
                {
                    _local_2 = DbgUtil.splitStackTrace(e);
                    _local_1 = (((("lerr:" + this._url) + " ") + " ") + _local_2);
                    DbgUtil.reportErr(_local_1);
                };
            }
            else
            {
                callList(_errorCallBacks);
            };
        }

        public function removeDecodeCallBack(_arg_1:Function):void
        {
            removeFromList(_arg_1, _decodeCallBacks);
        }

        public function addProgressCallBack(_arg_1:Function):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            if (_progressCallBacks.indexOf(_arg_1) < 0)
            {
                _progressCallBacks.push(_arg_1);
            };
        }

        public function onProgress(_arg_1:Number, _arg_2:Number):void
        {
            var _local_3:* = null;
            var _local_4:int = _progressCallBacks.length;
            while (--_local_4 > -1)
            {
                _local_3 = _progressCallBacks[_local_4];
                (_local_3(_url, _arg_1, _arg_2));
            };
        }

        public function dispose():void
        {
            retry = 0;
            appendTryCount = false;
            url = null;
            loader = null;
            removeAll(_decodeCallBacks);
            removeAll(_loadCallBacks);
            removeAll(_errorCallBacks);
            _progressCallBacks.length = 0;
        }

        public function get loader():ResLoader
        {
            return (_loader);
        }

        public function set loader(_arg_1:ResLoader):void
        {
            if (_arg_1 == null)
            {
                if (_loader)
                {
                    _loader.dispose();
                };
            };
            _loader = _arg_1;
        }

        public function toString():String
        {
            return (_url);
        }


    }
}//package com.core.loader

