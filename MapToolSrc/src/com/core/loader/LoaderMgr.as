// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.LoaderMgr

package com.core.loader
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import flash.utils.getTimer;
    import core.utils.DbgUtil;
    import template.vo.LoadInfoVo;
    import common.loader.ResVer;
    import com.common.inltrace.InternalTrace;
    import com.common.util.ArrayUtils;
    import flash.system.ApplicationDomain;
    import com.core.loader.task.ResTask;
    import com.core.loader.task.SWFTask;
    import com.game.manager.timediv.TimeDivision;
    import flash.utils.ByteArray;
    import common.asset.SoundRef;
    import flash.media.Sound;
    import com.core.base.IAnimData;
    import com.common.util.Reflection;

    public class LoaderMgr implements IResLoaderHandler 
    {

        private static var _instance:LoaderMgr;

        public var domainCache:Dictionary = new Dictionary();
        private var _resDic:Dictionary = new Dictionary();
        private var _loadingDic:Dictionary = new Dictionary();
        private var _queueArrayDic:Dictionary = ResQueueType.getQueueArrayDic();
        private var _workingList:Vector.<LoadingItem> = new Vector.<LoadingItem>();
        private var _workingUrls:Dictionary = new Dictionary();
        private var _loadedUrls:Dictionary = new Dictionary();
        private var _cacheTimeUrls:Dictionary = new Dictionary();
        private var _taskList:Dictionary = new Dictionary();
        public var reportFunc:Function;
        public var resLoadCount:Object = {};
        private var _loadingList:Vector.<LoadingItem> = new Vector.<LoadingItem>();
        public var RETRY_NUM:int = 2;
        private var _failRes:Object = {};
        private var snd_dic:Dictionary = new Dictionary();
        private var CHECK_INTERVAL:int = 10000;
        private var lastCheckTime:int = getTimer();


        public static function getInstance():LoaderMgr
        {
            if (!_instance)
            {
                _instance = new (LoaderMgr)();
            };
            return (_instance);
        }


        public function load(_arg_1:String, _arg_2:Function=null, _arg_3:Boolean=true, _arg_4:Array=null, _arg_5:uint=1, _arg_6:uint=100000, _arg_7:Function=null, _arg_8:Function=null):void
        {
            var _local_14:* = null;
            var _local_13:* = null;
            var _local_12:int = ((resLoadCount[_arg_1]) || (0));
            resLoadCount[_arg_1] = (_local_12 + 1);
            if (trace_preload)
            {
                traceInlLDR("load:", _arg_1);
            };
            if (_arg_1.indexOf("null") == 0)
            {
                DbgUtil.assert("invalid url");
            };
            var _local_10:ResContent = getResource(_arg_1);
            var _local_11:LoadingItem = getLoadingItem(_arg_1);
            if (trace_preload)
            {
                _local_14 = new LoadInfoVo();
                _local_14.url = _arg_1;
                _local_14.size = (ResVer.getFileSize(_arg_1) / 0x0400);
                _local_14.time = getTimer();
                _local_14.again = ((_local_10 == null) ? 0 : 1);
                InternalTrace.loadInfo.push(_local_14);
            };
            if (_local_10 != null)
            {
                if (_local_10.decoded)
                {
                    _local_13 = LdrCallBack.NEW();
                    _local_13.setVals(_arg_1, _arg_2, _arg_4);
                    _local_13.execute();
                    LdrCallBack.FREE(_local_13);
                }
                else
                {
                    if (((!(_failRes[_arg_1])) || (_failRes[_arg_1] < RETRY_NUM)))
                    {
                        _local_11.addDecodedCallBack(_arg_2, _arg_4, _arg_3);
                    };
                };
                return;
            };
            var _local_9:int = -1;
            if (_local_11 == null)
            {
                _workingUrls[_arg_1] = 1;
                _local_11 = addLoadingItem(_arg_1);
            }
            else
            {
                _local_9 = _workingList.indexOf(_local_11);
                removeLastQueue(_local_11);
            };
            _local_11.queueType = _arg_5;
            _local_11.priority = _arg_6;
            _local_11.addDecodedCallBack(_arg_2, _arg_4, _arg_3);
            _local_11.addProgressCallBack(_arg_7);
            _local_11.addErrorCallBack(_arg_8);
            if (_local_9 > -1)
            {
                return;
            };
            addToNewQueue(_local_11, _arg_5);
            loadNext();
        }

        private function removeLastQueue(_arg_1:LoadingItem):void
        {
            var _local_3:Array = _queueArrayDic[_arg_1.queueType];
            var _local_2:int = _local_3.indexOf(_arg_1);
            if (_local_2 > -1)
            {
                ArrayUtils.removeAt(_local_3, _local_2);
            };
        }

        private function addToNewQueue(_arg_1:LoadingItem, _arg_2:uint):void
        {
            var _local_5:* = null;
            var _local_4:Array = _queueArrayDic[_arg_2];
            var _local_3:int;
            while (_local_3 < _local_4.length)
            {
                _local_5 = _local_4[_local_3];
                if (_local_5.queueType >= _arg_1.queueType) break;
                _local_3++;
            };
            if (_local_3 == 0)
            {
                _local_4.unshift(_arg_1);
            }
            else
            {
                _local_4.splice(_local_3, 0, _arg_1);
            };
        }

        public function getDomain(_arg_1:String):ApplicationDomain
        {
            return (domainCache[_arg_1]);
        }

        private function setResource(_arg_1:String, _arg_2:ResContent):void
        {
            _resDic[_arg_1] = _arg_2;
        }

        public function getResource(_arg_1:String):ResContent
        {
            _arg_1 = ResVer.toRelativeUrl(_arg_1);
            return (_resDic[_arg_1]);
        }

        public function removeResource(_arg_1:String):void
        {
            cancelLoad(_arg_1);
            _arg_1 = ResVer.toRelativeUrl(_arg_1);
            var _local_2:ResContent = _resDic[_arg_1];
            if (_local_2)
            {
                _local_2.dispose();
            };
            delete _resDic[_arg_1];
            delete _cacheTimeUrls[_arg_1];
            delete domainCache[_arg_1]; //not popped
        }

        public function printResContentList(_arg_1:Function):void
        {
            var _local_4:* = null;
            var _local_2:* = null;
            var _local_3:* = null;
            for (var _local_5:String in _resDic)
            {
                _local_4 = _resDic[_local_5];
                _local_2 = _local_4.getRefCount().toString();
                _local_3 = ((("ref:" + _local_2) + " ") + _local_4.url);
                if (_arg_1)
                {
                    (_arg_1(_local_3));
                }
                else
                {
                    (trace(_local_3));
                };
            };
        }

        public function cancelLoad(_arg_1:String):void
        {
            var _local_3:* = null;
            var _local_4:uint;
            var _local_2:LoadingItem = getLoadingItem(_arg_1);
            if (_local_2)
            {
                _local_3 = _taskList[_arg_1];
                _local_4 = _workingUrls[_arg_1];
                if ((((!(_local_4 == 3)) && (!(_local_4 == 4))) || ((_local_2) && (_local_3))))
                {
                    _local_2.onError();
                };
            };
            removeLoadingItem(_local_2);
            removeProcessingItem(_arg_1);
        }

        private function getLoadingItem(_arg_1:String):LoadingItem
        {
            return (_loadingDic[_arg_1]);
        }

        private function addLoadingItem(_arg_1:String):LoadingItem
        {
            var _local_2:LoadingItem = LoadingItem.NEW(_arg_1);
            _loadingDic[_arg_1] = _local_2;
            return (_local_2);
        }

        private function removeProcessingItem(_arg_1:String):void
        {
            var _local_4:ResTask = _taskList[_arg_1];
            if (_local_4)
            {
                _local_4.removeCallBack();
            };
            var _local_5:LoadingItem = getLoadingItem(_arg_1);
            if (_local_5 == null)
            {
                return;
            };
            var _local_3:Array = _queueArrayDic[_local_5.queueType];
            var _local_2:int = _local_3.indexOf(_local_5);
            if (_local_2 > -1)
            {
                ArrayUtils.removeAt(_local_3, _local_2);
            };
            if (!_local_5.isCallBackRunning)
            {
                removeWorkingItem(_local_5);
                LoadingItem.FREE(_loadingDic[_arg_1]);
                _loadingDic[_arg_1] = null;
                delete _loadingDic[_arg_1];
            };
        }

        private function removeWorkingItem(_arg_1:LoadingItem):void
        {
            ArrayUtils.eRemove(_workingList, _arg_1);
        }

        private function removeLoadingItem(_arg_1:LoadingItem):void
        {
            ArrayUtils.eRemove(_loadingList, _arg_1);
        }

        private function getWorkingList():Array
        {
            var _local_4:int;
            var _local_1:* = null;
            var _local_2:* = null;
            var _local_3:Array = [];
            _local_4 = 0;
            while (_local_4 < _loadingList.length)
            {
                _local_1 = _loadingList[_local_4];
                if (_local_1 != null)
                {
                    var _local_5:* = ((_local_3[_local_1.queueType]) || ([]));
                    _local_3[_local_1.queueType] = _local_5;
                    _local_2 = _local_5;
                    _local_2.push(_local_1);
                };
                _local_4++;
            };
            return (_local_3);
        }

        private function loadNext():void
        {
            procCricleQueueLoad();
        }

        private function procCricleQueueLoad():void
        {
            var _local_4:uint;
            var _local_2:Vector.<LoadingItem> = _loadingList;
            var _local_3:int = 6;
            var _local_1:Array = _queueArrayDic[3];
            while (_local_1.length)
            {
                if (ArrayUtils.eLen(_local_2) >= _local_3) break;
                startNext(_local_1);
            };
            while (lengthOfAllQueue() > 0)
            {
                if (ArrayUtils.eLen(_local_2) >= _local_3)
                {
                    DbgUtil.nop();
                    return;
                };
                _local_4 = ResQueueType.nextQueue();
                _local_1 = _queueArrayDic[_local_4];
                if (_local_1.length != 0)
                {
                    startNext(_local_1);
                };
            };
        }

        private function lengthOfAllQueue():uint
        {
            var _local_2:uint;
            for each (var _local_1:Array in _queueArrayDic)
            {
                _local_2 = (_local_2 + _local_1.length);
            };
            return (_local_2);
        }

        private function startNext(_arg_1:Array):void
        {
            var _local_2:LoadingItem = _arg_1.shift();
            var _local_3:String = _local_2.url;
            _workingUrls[_local_3] = 2;
            ArrayUtils.ePush(_workingList, _local_2);
            ArrayUtils.ePush(_loadingList, _local_2);
            _local_2.startLoad(this);
        }

        public function onStreamLoadComplete(_arg_1:String, _arg_2:ByteArray):void
        {
            var _local_5:* = null;
            _workingUrls[_arg_1] = 3;
            _loadedUrls[_arg_1] = true;
            var _local_3:LoadingItem = getLoadingItem(_arg_1);
            var _local_7:ResContent = getResource(_arg_1);
            if (_local_7 == null)
            {
                _local_7 = new ResContent(_arg_1);
            };
            _local_7.onLoaded(_arg_2);
            setResource(_arg_1, _local_7);
            _local_3.onLoaded();
            _local_3.loader = null;
            removeLoadingItem(_local_3);
            var _local_6:Boolean = ((_arg_2 == null) || (_arg_2.length == 0));
            if (_local_6)
            {
                onError(_arg_1, true);
                return;
            };
            var _local_4:Class = ResTypes.getTask(_arg_1);
            if (_local_4 != null)
            {
                _local_5 = new (_local_4)();
                if ((_local_5 is SWFTask))
                {
                    if (_local_6)
                    {
                        DbgUtil.assert("length of bytes can't be ZERO");
                    };
                };
                _local_5.init(_arg_2, _arg_1, onOneDecoded);
                TimeDivision.getInstance().add(_local_5);
                _taskList[_arg_1] = _local_5;
            }
            else
            {
                onOneDecoded(_arg_1, _arg_2);
            };
            loadNext();
        }

        public function onError(_arg_1:String, _arg_2:Boolean, _arg_3:Boolean=true):void
        {
            var _local_4:* = null;
            if (_arg_2)
            {
                DbgUtil.nop();
            };
            var _local_5:int = ((_failRes[_arg_1]) || (0));
            if (((_arg_2) && (_local_5 < RETRY_NUM)))
            {
                _failRes[_arg_1] = (_local_5 + 1);
                ((trace_load) && (traceInlLDR(((("load error retry " + _local_5) + " ") + _arg_1))));
                if (reportFunc)
                {
                    (reportFunc(((("[loader] ErrorRetry: " + _local_5) + " ") + _arg_1)));
                };
                retryLoad(_arg_1);
                return;
            };
            _local_4 = getLoadingItem(_arg_1);
            _local_4.onError();
            _local_4.loader = null;
            removeLoadingItem(_local_4);
            removeProcessingItem(_arg_1);
            if (_arg_3)
            {
                loadNext();
            };
        }

        public function retryLoad(_arg_1:String, _arg_2:Boolean=true):void
        {
            var _local_3:* = null;
            var _local_4:LoadingItem = getLoadingItem(_arg_1);
            if (_local_4.retry <= RETRY_NUM)
            {
                _local_3 = _queueArrayDic[_local_4.queueType];
                _local_3.unshift(_local_4);
            };
            _local_4.retry++;
            _local_4.appendTryCount = _arg_2;
            removeLoadingItem(_local_4);
            removeWorkingItem(_local_4);
            loadNext();
        }

        public function onProgress(_arg_1:String, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:LoadingItem = getLoadingItem(_arg_1);
            _local_4.onProgress(_arg_2, _arg_3);
        }

        private function onOneDecoded(_arg_1:String, _arg_2:*):void
        {
            _workingUrls[_arg_1] = 4;
            _taskList[_arg_1] = null;
            delete _taskList[_arg_1];
            var _local_3:ResContent = getResource(_arg_1);
            _local_3.onDecoded(_arg_2);
            var _local_4:LoadingItem = getLoadingItem(_arg_1);
            _local_4.onDecoded();
            removeProcessingItem(_arg_1);
        }

        public function removeCompleteCallBack(_arg_1:String, _arg_2:Function):void
        {
            var _local_3:LoadingItem = getLoadingItem(_arg_1);
            if (_local_3)
            {
                _local_3.removeDecodeCallBack(_arg_2);
            };
        }

        public function loadSound(_arg_1:String, _arg_2:Function):void
        {
            load(_arg_1, _arg_2, false, null, 5);
        }

        protected function checkSoundRef(_arg_1:int):void
        {
            var _local_4:* = null;
            var _local_2:int = (CHECK_INTERVAL * 30);
            for (var _local_3:String in snd_dic)
            {
                _local_4 = (snd_dic[_local_3] as SoundRef);
                if (_local_4.getRefCount() == 0)
                {
                    if ((_arg_1 - _local_4.lastRefTime) > _local_2)
                    {
                        delete snd_dic[_local_3];
                    };
                };
            };
        }

        public function delSound(_arg_1:String):SoundRef
        {
            var _local_2:SoundRef = snd_dic[_arg_1];
            delete snd_dic[_arg_1];
            return (_local_2);
        }

        public function getSound(_arg_1:String):SoundRef
        {
            if (snd_dic[_arg_1])
            {
                return (snd_dic[_arg_1]);
            };
            var _local_2:Boolean = ResVer.isFileExist(_arg_1);
            if (!_local_2)
            {
                return (null);
            };
            var _local_3:Sound = new Sound();
            var _local_4:SoundRef = new SoundRef(_local_3);
            _local_4.loadSnd(_arg_1);
            snd_dic[_arg_1] = _local_4;
            return (_local_4);
        }

        public function update():void
        {
            var _local_1:* = null;
            var _local_2:int = getTimer();
            if ((_local_2 - lastCheckTime) < CHECK_INTERVAL)
            {
                return;
            };
            lastCheckTime = _local_2;
            for (var _local_3:String in _workingUrls)
            {
                if (_workingUrls[_local_3] == 4)
                {
                    if (_cacheTimeUrls[_local_3] <= _local_2)
                    {
                        _local_1 = getResource(_local_3);
                        if (!(((!(_local_1)) || (!(_local_1.content is IAnimData))) || (_local_1.getRefCount() > 0)))
                        {
                            removeResource(_local_3);
                            delete _workingUrls[_local_3];
                        };
                    };
                };
            };
        }

        public function freeUselessResource():void
        {
            var _local_2:* = null;
            var _local_1:* = null;
            var _local_3:int = getTimer();
            ((trace_load) && (traceInlLDR("-------------------------freeUselessResource start--------------------------")));
            for (var _local_4:String in _workingUrls)
            {
                if (_workingUrls[_local_4] == 4)
                {
                    _local_2 = getLoadingItem(_local_4);
                    if (((_local_2) && (_workingList.indexOf(_local_2) > -1)))
                    {
                        ((trace_load) && (traceInlLDR("HoldResource:", "loading")));
                    }
                    else
                    {
                        if (_local_4.indexOf("ui/") > -1)
                        {
                            ((trace_load) && (traceInlLDR("HoldResource:", _local_4)));
                        }
                        else
                        {
                            if (_local_4.indexOf("/uiLinkFx/") > -1)
                            {
                                ((trace_load) && (traceInlLDR("HoldResource:", _local_4)));
                            }
                            else
                            {
                                _local_1 = getResource(_local_4);
                                if (((_local_1) && (_local_1.getRefCount() > 0)))
                                {
                                    ((trace_load) && (traceInlLDR("HoldResource:", _local_4, "count:", _local_1.getRefCount())));
                                }
                                else
                                {
                                    removeResource(_local_4);
                                    ((trace_load) && (traceInlLDR("RemoveResource:", _local_4)));
                                    delete _workingUrls[_local_4];
                                };
                            };
                        };
                    };
                };
            };
            ((trace_load) && (traceInlLDR("-------------------------freeUselessResource end--------------------------", (getTimer() - _local_3)))); //not popped
        }

        public function upDateCache(_arg_1:String, _arg_2:uint=10000):void
        {
            _cacheTimeUrls[_arg_1] = (getTimer() + _arg_2);
        }

        public function debguOut(_arg_1:Function=null):void
        {
            var _local_9:int;
            var _local_8:* = null;
            var _local_5:int;
            var _local_3:* = null;
            var _local_2:* = null;
            var _local_4:Array = [];
            for (var _local_7:String in _workingUrls)
            {
                if (_workingUrls[_local_7] == 2)
                {
                    _local_4.push(_local_7);
                    (_arg_1(_local_7));
                };
            };
            var _local_6:Array = getWorkingList();
            _local_9 = 0;
            while (_local_9 < _local_6.length)
            {
                _local_8 = _local_6[_local_9];
                if (_local_8 != null)
                {
                    _local_5 = 0;
                    while (_local_5 < _local_8.length)
                    {
                        _local_3 = _local_8[_local_5];
                        _local_2 = Reflection.staticVal2FieldName(ResQueueType)[_local_9];
                        (_arg_1(((_local_2 + ":") + _local_3.url)));
                        _local_5++;
                    };
                };
                _local_9++;
            };
        }


    }
}//package com.core.loader

