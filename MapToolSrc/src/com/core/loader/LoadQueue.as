// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.LoadQueue

package com.core.loader
{
    import flash.utils.Dictionary;
    import common.loader.ResVer;
    import com.game.manager.TextureCache;

    public class LoadQueue 
    {

        public var lastLoadedUrl:String;
        public var totalCount:uint;
        public var loadedCount:uint;
        public var preloadId:uint = 0;
        public var allFromCache:Boolean;
        public var errorList:Array = [];
        private var urlList:Array;
        private var onLoadStep:Function;
        private var onProgress:Function;
        private var onComplete:Function;
        private var staticStore:Boolean;
        private var queueType:uint;
        private var _priority:int;
        private var resSizes:Dictionary = new Dictionary();
        private var _totalSize:Number = 0;
        private var loadedBytes:Dictionary = new Dictionary();
        public var isLoading:Boolean;
        public var curUrl:String;

        public function LoadQueue(_arg_1:Array, _arg_2:Function, _arg_3:Function=null, _arg_4:Function=null, _arg_5:Boolean=false, _arg_6:uint=1, _arg_7:int=100000)
        {
            loadedCount = 0;
            this.queueType = _arg_6;
            setResUrlList(_arg_1);
            this.onLoadStep = _arg_2;
            this.onProgress = _arg_3;
            this.onComplete = _arg_4;
            this.staticStore = _arg_5;
            _priority = _arg_7;
        }

        private function setResUrlList(_arg_1:Array):void
        {
            totalCount = _arg_1.length;
            this.urlList = _arg_1;
        }

        public function cancel():void
        {
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < urlList.length)
            {
                LoaderMgr.getInstance().removeCompleteCallBack(urlList[_local_3], onLoad);
                _local_3++;
            };
            urlList.length = 0;
            loadedCount = 0;
            for (var _local_2:String in resSizes)
            {
                delete resSizes[_local_2];
            };
            for (var _local_1:String in loadedBytes)
            {
                delete loadedBytes[_local_1];
            };
            dispose();
        }

        public function needLoad():Boolean
        {
            var _local_2:int;
            var _local_1:* = null;
            _local_2 = 0;
            while (_local_2 < urlList.length)
            {
                _local_1 = LoaderMgr.getInstance().getResource(urlList[_local_2]);
                if (((_local_1 == null) || (!(_local_1.content))))
                {
                    return (true);
                };
                _local_2++;
            };
            return (false);
        }

        public function startLoad():void
        {
            var _local_3:* = null;
            var _local_4:int;
            var _local_1:* = null;
            isLoading = true;
            errorList.length = 0;
            var _local_2:int;
            _totalSize = 0;
            _local_4 = 0;
            while (_local_4 < urlList.length)
            {
                _local_3 = urlList[_local_4];
                resSizes[_local_3] = ResVer.getFileSize(_local_3);
                _totalSize = (_totalSize + resSizes[_local_3]);
                _local_1 = LoaderMgr.getInstance().getResource(_local_3);
                if (_local_1 != null)
                {
                    _local_2++;
                };
                _local_4++;
            };
            allFromCache = (_local_2 == urlList.length);
            _local_4 = 0;
            while (_local_4 < urlList.length)
            {
                _local_3 = urlList[_local_4];
                if (_local_3.indexOf(".atf") > -1)
                {
                    TextureCache.getInstance().loadTexture(_local_3, null, queueType, onResError, onLoad, onLoadProgress);
                }
                else
                {
                    LoaderMgr.getInstance().load(_local_3, onLoad, staticStore, null, queueType, ((_priority - urlList.length) + _local_4), onLoadProgress, onResError);
                };
                _local_4++;
            };
        }

        private function onResError(_arg_1:String):void
        {
            errorList.push(_arg_1);
            onOneLoaded(_arg_1);
        }

        private function onLoadProgress(_arg_1:String, _arg_2:Number, _arg_3:Number):void
        {
            if (onProgress == null)
            {
                return;
            };
            loadedBytes[_arg_1] = _arg_2;
            var _local_5:* = 0;
            for each (var _local_4:Number in loadedBytes)
            {
                _local_5 = (_local_5 + _local_4);
            };
            curUrl = _arg_1;
            onProgress(this, (Math.min(_totalSize, _local_5) / _totalSize), 0); //not popped
        }

        private function onLoad(_arg_1:String):void
        {
            lastLoadedUrl = _arg_1;
            loadedBytes[_arg_1] = resSizes[_arg_1];
            if (onLoadStep != null)
            {
                (onLoadStep(this));
            };
            onOneLoaded(_arg_1);
        }

        private function onOneLoaded(_arg_1:String):void
        {
            loadedCount++;
            onLoadProgress(_arg_1, resSizes[_arg_1], 0);
            if (isComplete)
            {
                callComplete();
            };
        }

        private function callComplete():void
        {
            isLoading = false;
            var _local_1:Function = onComplete;
            dispose();
            if (_local_1 != null)
            {
                ((_local_1.length == 1) ? _local_1(this) : _local_1());
            };
        }

        private function get isComplete():Boolean
        {
            return (loadedCount >= totalCount);
        }

        public function get lastLoaded():ResContent
        {
            return (LoaderMgr.getInstance().getResource(lastLoadedUrl));
        }

        public function dispose():void
        {
            onLoadStep = null;
            onProgress = null;
            onComplete = null;
        }


    }
}//package com.core.loader

