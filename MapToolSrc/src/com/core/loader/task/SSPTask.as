// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.task.SSPTask

package com.core.loader.task
{
    import com.core.loader.AnimData;
    import __AS3__.vec.Vector;
    import flash.utils.ByteArray;
    import core.utils.DbgUtil;
    import com.core.base.FrameData;
    import com.core.NBlendMode;
    import flash.geom.Rectangle;
    import com.common.util.Tools;
    import com.core.imagedecode.ParallelDecoding;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.LoaderInfo;

    public class SSPTask extends ResTask 
    {

        private var _animData:AnimData;
        private var _bmdBytes:Vector.<ByteArray>;
        private var endFrameId:int;
        private var _loadedCount:int;


        override public function step():Boolean
        {
            var _local_1:* = null;
            switch (_state)
            {
                case 0:
                    _animData = new AnimData();
                    _animData.url = this._url;
                    try
                    {
                        decodeV2(_bytes);
                        clearBytes();
                    }
                    catch(e:Error)
                    {
                        _local_1 = DbgUtil.splitStackTrace(e);
                        if (DbgUtil.tryExec)
                        {
                            traceErr(_local_1);
                            return (true);
                        };
                        throw (new Error(((("DEC_SSP:" + this._url) + " ") + _local_1)));
                    };
                    _state = 1;
                    break;
                case 1:
                    loadBitmap();
                    _state = 2;
                    break;
                case 2:
                    break;
                case 4:
                    return (true);
                default:
            };
            return (false);
        }

        private function decodeV2(_arg_1:ByteArray):void
        {
            var _local_7:Boolean;
            var _local_19:int;
            var _local_14:int;
            var _local_20:int;
            var _local_16:int;
            var _local_9:* = null;
            var _local_6:int;
            var _local_2:int;
            var _local_8:* = null;
            var _local_4:* = null;
            if (((!(_arg_1[0] == 83)) || (!(_arg_1[1] == 80))))
            {
                _arg_1.inflate();
            };
            _bmdBytes = new Vector.<ByteArray>();
            var _local_17:Vector.<FrameData> = new Vector.<FrameData>();
            var _local_5:uint = _arg_1.readUnsignedShort();
            var _local_15:uint = _arg_1.readUnsignedShort();
            var _local_10:int = _arg_1.readByte();
            var _local_3:int = _arg_1.readByte();
            var _local_11:String = NBlendMode.getBlendMode(_local_3);
            var _local_13:int = -(_arg_1.readShort());
            var _local_12:int = -(_arg_1.readShort());
            if (((!(_local_13 == 0)) || (!(_local_12 == 0))))
            {
                _local_7 = true;
            };
            endFrameId = _arg_1.readShort();
            var _local_18:int = _arg_1.readUnsignedShort();
            _local_6 = 0;
            while (_local_6 < _local_18)
            {
                _local_9 = new FrameData();
                _local_2 = _arg_1.readShort();
                _local_16 = _arg_1.readShort();
                _local_19 = _arg_1.readShort();
                _local_14 = _arg_1.readShort();
                _local_20 = _arg_1.readShort();
                _local_8 = new Rectangle(_local_16, _local_19, _local_14, _local_20);
                _local_9.initClipped(_local_2, _local_8, null);
                _local_4 = new ByteArray();
                Tools.readByteArray(_arg_1, _local_4);
                _bmdBytes.push(_local_4);
                _local_17.push(_local_9);
                _local_6++;
            };
            _animData.init(_local_10, _local_13, _local_12, _local_11, _local_7, _local_17);
        }

        private function loadBitmap():void
        {
            var _local_1:int;
            var _local_2:* = null;
            _local_1 = 0;
            while (_local_1 < _bmdBytes.length)
            {
                _local_2 = _bmdBytes[_local_1];
                ParallelDecoding.getInstance().decode(_local_2, false, onImageDecoded, ((_url + ":") + _local_1));
                _local_1++;
            };
        }

        private function onImageDecoded(_arg_1:LoaderInfo, _arg_2:ByteArray):void
        {
            _loadedCount++;
            var _local_4:BitmapData = (_arg_1.content as Bitmap).bitmapData;
            var _local_3:int = _bmdBytes.indexOf(_arg_2);
            _animData.frameDatas[_local_3].subBitmap = _local_4;
            _arg_2.clear();
            if (_bmdBytes.length == _loadedCount)
            {
                nrm();
                _content = _animData;
                _state = 4;
            };
        }

        private function nrm():void
        {
            var _local_1:int;
            var _local_2:* = null;
            var _local_6:int;
            var _local_3:Vector.<FrameData> = _animData.frameDatas;
            if (endFrameId == -1)
            {
                endFrameId = _local_3[(_local_3.length - 1)].frameId;
            };
            var _local_4:uint = _local_3[0].frameId;
            if (_local_3[0].frameId > 1)
            {
                _local_4 = 1;
            };
            var _local_5:Vector.<FrameData> = new Vector.<FrameData>();
            _local_1 = _local_4;
            while (_local_1 <= endFrameId)
            {
                _local_2 = getFitFrame(_local_1, _local_3);
                _local_5.push(_local_2);
                _local_1++;
            };
            _local_6 = 0;
            while (_local_6 < _local_5.length)
            {
                _local_3[_local_6] = _local_5[_local_6];
                _local_6++;
            };
        }

        private function getFitFrame(_arg_1:int, _arg_2:Vector.<FrameData>):FrameData
        {
            var _local_4:* = null;
            var _local_3:int = -1;
            _local_3 = 0;
            while (_local_3 < _arg_2.length)
            {
                _local_4 = _arg_2[_local_3];
                if (_local_4.frameId > _arg_1) break;
                _local_3++;
            };
            var _local_5:int = ((_local_3 == 0) ? 0 : (_local_3 - 1));
            return (_arg_2[_local_5]);
        }

        override public function dispose():void
        {
            _animData = null;
            clearBmdBytes();
            _bmdBytes = null;
            super.dispose();
        }

        private function clearBmdBytes():void
        {
            var _local_1:int;
            _local_1 = (_bmdBytes.length - 1);
            while (_local_1 >= 0)
            {
                _bmdBytes[_local_1].clear();
                _local_1--;
            };
            _bmdBytes.length = 0;
        }


    }
}//package com.core.loader.task

