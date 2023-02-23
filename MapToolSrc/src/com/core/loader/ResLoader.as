// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.ResLoader

package com.core.loader
{
    import common.loader.ResVer;
    import core.utils.DbgUtil;
    import com.common.util.Reflection;
    import flash.utils.setInterval;
    import flash.events.ProgressEvent;
    import flash.events.Event;
    import flash.utils.ByteArray;
    import flash.utils.clearInterval;

    public class ResLoader 
    {

        private static var _time:Number = new Date().time;
        public static var minBytePre5Second:int = 0x0400;

        private var _stream:URLLoaderExt;
        private var _url:String;
        private var loaderMgr:IResLoaderHandler;
        private var timer:uint = 0;
        private var bytesLoaded:Number;
        private var bytesTotal:Number;
        private var _lastLoaded:Number;


        public function get url():String
        {
            return (_url);
        }

        public function load(_arg_1:String, _arg_2:IResLoaderHandler, _arg_3:uint, _arg_4:String):void
        {
            _url = _arg_1;
            loaderMgr = _arg_2;
            _arg_1 = ResVer.format(_arg_1);
            var _local_5:String = ResVer.getVer(_arg_1);
            if (_local_5 == null)
            {
                loaderMgr.onError(_url, false);
                ioErrorHandler(null);
                return;
            };
            if (_local_5 == "?rUnknown")
            {
                _local_5 = ("?v=" + _time);
            };
            DbgUtil.assert(((_stream == null) || ("_stream should be null")));
            _stream = URLLoaderExt.NEW();
            configureListeners();
            _arg_1 = (ResVer.prependResRoot(_arg_1) + _local_5);
            if (_arg_4 != null)
            {
                _arg_1 = (_arg_1 + _arg_4);
            };
            if (DbgUtil.loaderAppendQueueType)
            {
                _arg_1 = ((_arg_1 + "&q=") + Reflection.staticVal2FieldName(ResQueueType)[_arg_3]);
            };
            bytesLoaded = (_lastLoaded = 0);
            DbgUtil.assert(((timer == 0) || ("timer should be null")));
            if (trace_preload)
            {
                if (_arg_1.indexOf(".mp3") != -1)
                {
                    DbgUtil.nop();
                };
            };
            _stream.loadUrl(_arg_1);
        }

        private function progressHandler(_arg_1:ProgressEvent):void
        {
            if (timer == 0)
            {
                timer = setInterval(checkLoad, 5000);
            };
            bytesLoaded = _arg_1.bytesLoaded;
            NetStatistics.setLoadedBytes(_url, bytesLoaded);
            bytesTotal = _arg_1.bytesTotal;
            if (!closed)
            {
                loaderMgr.onProgress(_url, bytesLoaded, bytesTotal);
            };
        }

        private function checkLoad():void
        {
            if ((bytesLoaded - _lastLoaded) < minBytePre5Second)
            {
                onRecvTimeOut();
            }
            else
            {
                _lastLoaded = bytesLoaded;
            };
        }

        private function onSizeMissMatch(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:String = ((((((("MissMatch2:" + _arg_1) + "/") + _arg_2) + "/") + _arg_3) + " URL:") + _url);
            DbgUtil.reportErr(_local_4);
        }

        private function onRecvTimeOut():void
        {
            ((trace_load) && (traceInlLDR(("load time out retry:" + _url))));
            loaderMgr.retryLoad(_url);
            onLoadStop(true);
        }

        private function configureListeners():void
        {
            _stream.addEventListener("complete", loadCompleteHandler);
            _stream.addEventListener("progress", progressHandler);
            _stream.addEventListener("ioError", ioErrorHandler);
            _stream.addEventListener("securityError", securityErrorHandler);
        }

        private function removeListerner():void
        {
            _stream.removeEventListener("complete", loadCompleteHandler);
            _stream.removeEventListener("progress", progressHandler);
            _stream.removeEventListener("ioError", ioErrorHandler);
            _stream.removeEventListener("securityError", securityErrorHandler);
        }

        private function ioErrorHandler(_arg_1:Event):void
        {
            var _local_2:* = (!(_arg_1 == null));
            if (_local_2)
            {
                if (_stream)
                {
                    NetStatistics.setLoadedBytes(_url, _stream.bytesLoaded);
                };
            }
            else
            {
                DbgUtil.nop();
            };
            if (!closed)
            {
                loaderMgr.onError(_url, _local_2, false);
            };
            if (trace_preload)
            {
                traceInlLDR("ioErrorHandler:", _url, ((_local_2) ? _arg_1 : "null"), (!(loaderMgr == null)));
            };
            onLoadStop();
        }

        private function securityErrorHandler(_arg_1:Event):void
        {
            if (!closed)
            {
                loaderMgr.onError(_url, false);
            };
            if (trace_preload)
            {
                traceInlLDR("securityErrorHandler:", _url, ((_arg_1 != null) ? _arg_1 : "null"), (!(loaderMgr == null)));
            };
            onLoadStop();
        }

        private function loadCompleteHandler(_arg_1:Event):void
        {
            var _local_3:* = null;
            bytesLoaded = _stream.bytesLoaded;
            NetStatistics.setLoadedBytes(_url, bytesLoaded);
            var _local_4:uint = ResVer.getFileSize(_url);
            var _local_2:Number = bytesTotal;
            if (((!(_local_2 == 0)) && (!(bytesLoaded == _local_2))))
            {
                loaderMgr.retryLoad(_url, true);
                onLoadStop(false);
                onSizeMissMatch(bytesLoaded, _local_2, _local_4);
            }
            else
            {
                _local_3 = _stream.data;
                _stream.close();
                if (!closed)
                {
                    loaderMgr.onStreamLoadComplete(_url, _local_3);
                };
                onLoadStop();
            };
        }

        private function newByteArray():ByteArray
        {
            if (_url.indexOf(".atf") != -1)
            {
                return (new ATFByteArray());
            };
            return (new ByteArray());
        }

        public function stop():void
        {
            onLoadStop(true);
        }

        private function get closed():Boolean
        {
            return (_stream == null);
        }

        private function onLoadStop(_arg_1:Boolean=false):void
        {
            if (timer)
            {
                (clearInterval(timer));
                timer = 0;
            };
            if (_stream == null)
            {
                return;
            };
            _url = null;
            removeListerner();
            if (_arg_1)
            {
                try
                {
                    _stream.close();
                }
                catch(e)
                {
                };
            };
            URLLoaderExt.FREE(_stream);
            _stream = null;
        }

        public function dispose():void
        {
            onLoadStop(true);
        }


    }
}//package com.core.loader

