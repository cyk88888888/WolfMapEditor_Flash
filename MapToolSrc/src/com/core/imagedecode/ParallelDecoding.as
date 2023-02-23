// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.imagedecode.ParallelDecoding

package com.core.imagedecode
{
    import flash.utils.Dictionary;
    import flash.system.LoaderContext;
    import flash.utils.ByteArray;
    import core.utils.DbgUtil;
    import flash.display.Loader;
    import flash.system.ApplicationDomain;
    import flash.events.EventDispatcher;
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.AsyncErrorEvent;

    public class ParallelDecoding 
    {

        private static var _instance:ParallelDecoding;

        private var _vec:Dictionary = new Dictionary(true);
        private var loaderContext:LoaderContext = new LoaderContext();


        public static function getInstance():ParallelDecoding
        {
            return ((_instance) ||= (new (ParallelDecoding)()));
        }


        public function ref(_arg_1:ByteArray):Boolean
        {
            return (!(_vec[_arg_1] == null));
        }

        private function removeDecoded(_arg_1:ByteArray):void
        {
            _vec[_arg_1] = null;
            delete _vec[_arg_1]; //not popped
        }

        public function decode(_arg_1:ByteArray, _arg_2:Boolean, _arg_3:Function, _arg_4:String=""):void
        {
            var _local_7:DecodeItem = DecodeItem.NEW();
            _local_7.init(_arg_1, _arg_2, _arg_3, _arg_4);
            DbgUtil.assert(((_vec[_arg_1] == null) || ("Already In Queue")));
            _vec[_arg_1] = _local_7;
            if (trace_decode)
            {
                doTrace("ParallelDecoding:loadBytes", _arg_4);
            };
            var _local_6:Loader = new ImageLoader(_arg_1);
            configureListeners(_local_6.contentLoaderInfo);
            var _local_5:ApplicationDomain = ApplicationDomain.currentDomain;
            loaderContext.applicationDomain = ((_local_7.joinAppDomain) ? _local_5 : null);
            loaderContext.allowCodeImport = true;
            _local_6.loadBytes(_local_7.bytes, loaderContext);
        }

        private function configureListeners(_arg_1:EventDispatcher):void
        {
            _arg_1.addEventListener("open", onOPEN);
            _arg_1.addEventListener("init", onINIT);
            _arg_1.addEventListener("asyncError", onASYNC_ERROR);
            _arg_1.addEventListener("ioError", onIO_ERROR);
            _arg_1.addEventListener("progress", onPROGRESS);
            _arg_1.addEventListener("securityError", onSECURITY_ERROR);
            _arg_1.addEventListener("unload", onUNLOAD);
        }

        private function removeListeners(_arg_1:EventDispatcher):void
        {
            _arg_1.removeEventListener("open", onOPEN);
            _arg_1.removeEventListener("init", onINIT);
            _arg_1.removeEventListener("asyncError", onASYNC_ERROR);
            _arg_1.removeEventListener("ioError", onIO_ERROR);
            _arg_1.removeEventListener("progress", onPROGRESS);
            _arg_1.removeEventListener("securityError", onSECURITY_ERROR);
            _arg_1.removeEventListener("unload", onUNLOAD);
        }

        private function onINIT(_arg_1:Event):void
        {
            var _local_2:LoaderInfo = (_arg_1.currentTarget as LoaderInfo);
            var _local_4:DecodeItem = (_vec[(_local_2.loader as ImageLoader).bytes] as DecodeItem);
            var _local_3:Loader = _local_2.loader;
            if (trace_decode)
            {
                doTrace("ParallelDecoding:onINIT", _local_4.dbgInfo, _arg_1);
            };
            _local_4.complete(_local_3.contentLoaderInfo);
            onDone(_arg_1);
        }

        private function onIO_ERROR(_arg_1:IOErrorEvent):void
        {
            var _local_2:* = null;
            var _local_3:* = null;
            if (trace_decode)
            {
                _local_2 = (_arg_1.currentTarget as LoaderInfo);
                _local_3 = (_vec[(_local_2.loader as ImageLoader).bytes] as DecodeItem);
                doTrace("ParallelDecoding:onIO_ERROR", _local_3.dbgInfo, _arg_1);
            };
            onDone(_arg_1);
        }

        private function onOPEN(_arg_1:Event):void
        {
            var _local_2:* = null;
            var _local_3:* = null;
            if (trace_decode)
            {
                _local_2 = (_arg_1.currentTarget as LoaderInfo);
                _local_3 = (_vec[(_local_2.loader as ImageLoader).bytes] as DecodeItem);
                doTrace("ParallelDecoding:onOPEN", _local_3.dbgInfo, _arg_1);
            };
        }

        private function onPROGRESS(_arg_1:ProgressEvent):void
        {
            var _local_2:* = null;
            var _local_3:* = null;
            if (trace_decode)
            {
                _local_2 = (_arg_1.currentTarget as LoaderInfo);
                _local_3 = (_vec[(_local_2.loader as ImageLoader).bytes] as DecodeItem);
                doTrace("ParallelDecoding:onPROGRESS", _local_3.dbgInfo, _arg_1);
            };
        }

        private function onSECURITY_ERROR(_arg_1:SecurityErrorEvent):void
        {
            var _local_2:* = null;
            var _local_3:* = null;
            if (trace_decode)
            {
                _local_2 = (_arg_1.currentTarget as LoaderInfo);
                _local_3 = (_vec[(_local_2.loader as ImageLoader).bytes] as DecodeItem);
                doTrace("ParallelDecoding:onSECURITY_ERROR", _local_3.dbgInfo, _arg_1);
            };
            onDone(_arg_1);
        }

        private function onUNLOAD(_arg_1:Event):void
        {
            var _local_2:* = null;
            var _local_3:* = null;
            if (trace_decode)
            {
                _local_2 = (_arg_1.currentTarget as LoaderInfo);
                _local_3 = (_vec[(_local_2.loader as ImageLoader).bytes] as DecodeItem);
            };
            onDone(_arg_1);
        }

        private function onCOMPLETE(_arg_1:Event):void
        {
            var _local_2:* = null;
            var _local_3:* = null;
            if (trace_decode)
            {
                _local_2 = (_arg_1.currentTarget as LoaderInfo);
                _local_3 = (_vec[(_local_2.loader as ImageLoader).bytes] as DecodeItem);
                doTrace("ParallelDecoding:onCOMPLETE", _local_3.dbgInfo, _arg_1);
            };
            onDone(_arg_1);
        }

        private function onASYNC_ERROR(_arg_1:AsyncErrorEvent):void
        {
            var _local_2:* = null;
            var _local_3:* = null;
            if (trace_decode)
            {
                _local_2 = (_arg_1.currentTarget as LoaderInfo);
                _local_3 = (_vec[(_local_2.loader as ImageLoader).bytes] as DecodeItem);
                doTrace("ParallelDecoding:onASYNC_ERROR", _local_3.dbgInfo, _arg_1);
            };
            onDone(_arg_1);
        }

        private function onDone(_arg_1:Event):void
        {
            var _local_2:LoaderInfo = (_arg_1.currentTarget as LoaderInfo);
            removeListeners(_local_2);
            var _local_4:ImageLoader = (_local_2.loader as ImageLoader);
            var _local_3:DecodeItem = (_vec[_local_4.bytes] as DecodeItem);
            removeDecoded(_local_4.bytes);
            _local_4.unloadAndStop(false);
            _local_4.bytes = null;
            DecodeItem.FREE(_local_3);
        }


    }
}//package com.core.imagedecode

