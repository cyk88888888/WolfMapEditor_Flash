// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.ResContent

package com.core.loader
{
    import com.core.IRefDispose;
    import flash.utils.ByteArray;
    import core.utils.DbgUtil;
    import com.core.base.IAnimData;
    import com.core.imagedecode.ParallelDecoding;

    public class ResContent implements IRefDispose 
    {

        private var _url:String;
        private var _rawData:ByteArray;
        private var _content:*;
        private var _decoded:Boolean;
        private var _lastRefTime:int;
        private var _refCount:int;

        public function ResContent(_arg_1:String)
        {
            _url = _arg_1;
        }

        public function get url():String
        {
            return (_url);
        }

        public function get content():*
        {
            return (_content);
        }

        public function get rawData():ByteArray
        {
            return (_rawData);
        }

        public function get decoded():Boolean
        {
            return (_decoded);
        }

        public function onLoaded(_arg_1:ByteArray):void
        {
            _rawData = _arg_1;
        }

        public function onDecoded(_arg_1:*):void
        {
            _decoded = true;
            if (trace_preload)
            {
                if ("template/tmplib.swf" == _url)
                {
                    DbgUtil.nop();
                };
            };
            _rawData = null;
            _content = _arg_1;
        }

        public function addRef():void
        {
            if ("swf/uiFx/yindao_shenbingxingtishi.swf" == _url)
            {
                DbgUtil.nop();
            };
            _refCount++;
        }

        public function decRef():void
        {
            if ("swf/uiFx/yindao_shenbingxingtishi.swf" == _url)
            {
                DbgUtil.nop();
            };
            _refCount--;
            DbgUtil.assert(((_refCount >= 0) || ("解引用异常")));
        }

        public function getRefCount():int
        {
            var _local_2:* = null;
            var _local_1:int;
            if ((_content is IAnimData))
            {
                _local_2 = (_content as IAnimData);
                return (_local_2.getRefCount());
            };
            return (_refCount);
        }

        public function dispose():void
        {
            if ("swf/uiFx/HUD_jingyanbaodian01.swf" == _url)
            {
                DbgUtil.nop();
            };
            _url = null;
            if (_rawData)
            {
                if (!ParallelDecoding.getInstance().ref(_rawData))
                {
                    _rawData.clear();
                }
                else
                {
                    if (trace_load)
                    {
                        traceInl1("bytes clear while decoding");
                    };
                };
                _rawData = null;
            };
            _content = null;
        }

        public function get lastRefTime():int
        {
            return (_lastRefTime);
        }

        public function set lastRefTime(_arg_1:int):void
        {
            _lastRefTime = _arg_1;
        }


    }
}//package com.core.loader

