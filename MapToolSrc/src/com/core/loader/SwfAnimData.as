// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.SwfAnimData

package com.core.loader
{
    import flash.geom.Matrix;
    import flash.display.MovieClip;
    import flash.utils.ByteArray;
    import common.util.DspUtils;
    import flash.display.BitmapData;
    import flash.geom.Rectangle;
    import flash.display.DisplayObject;
    import flash.text.TextField;
    import flash.text.StaticText;
    import __AS3__.vec.Vector;
    import com.core.base.FrameData;
    import flash.system.ApplicationDomain;

    public class SwfAnimData extends AnimData 
    {

        private static const matrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);

        private var _swf:MovieClip;
        private var _width:int = 0;
        private var _height:int = 0;
        private var _data:ByteArray;


        private static function createFromSwf(_arg_1:int, _arg_2:MovieClip, _arg_3:Rectangle=null):BitmapData
        {
            var _local_4:* = null;
            var _local_5:* = null;
            if (_arg_3 == null)
            {
                _arg_2.gotoAndStop(_arg_1);
                _local_5 = getOriginText(_arg_2);
                DspUtils.removeChild(_local_5);
                _arg_3 = DspUtils.getMovieClipBounds(_arg_2);
            };
            _local_4 = new BitmapData(_arg_3.width, _arg_3.height, true, 0xFFFFFF);
            matrix.tx = -(_arg_3.x);
            matrix.ty = -(_arg_3.y);
            _local_4.draw(_arg_2, matrix);
            return (_local_4);
        }

        private static function procOrigText(_arg_1:MovieClip):Object
        {
            var _local_2:DisplayObject = getOriginText(_arg_1);
            if (_local_2)
            {
                _local_2.visible = false;
            };
            return (_local_2);
        }

        private static function getOriginText(_arg_1:MovieClip):*
        {
            var _local_3:int;
            var _local_2:* = null;
            _local_3 = 0;
            while (_local_3 < _arg_1.numChildren)
            {
                _local_2 = _arg_1.getChildAt(_local_3);
                if (((_local_2 is StaticText) || (_local_2 is TextField)))
                {
                    _arg_1["txt"] = _local_2;
                    return (_local_2);
                };
                _local_3++;
            };
            return (null);
        }


        public function parse(_arg_1:ApplicationDomain, _arg_2:String=null):void
        {
            var _local_7:* = null;
            var _local_8:int;
            var _local_6:* = null;
            var _local_4:int;
            var _local_5:int;
            var _local_3:* = null;
            this.url = _arg_2;
            var _local_11:Class = (_arg_1.getDefinition("Data") as Class);
            var _local_10:ByteArray = new (_local_11)();
            _hasOrigin = true;
            _origX = _local_10.readShort();
            _origY = _local_10.readShort();
            _frameRate = _local_10.readUnsignedByte();
            if (trace_load)
            {
                if (_frameRate > 10)
                {
                    traceInl1(((("FPS:" + _frameRate) + " URL:") + _arg_2));
                };
            };
            _blendMode = _local_10.readUTF();
            _frameDatas = new Vector.<FrameData>();
            var _local_9:uint = _local_10.readUnsignedByte();
            do 
            {
                _local_8 = _local_10.readUnsignedByte();
                _local_7 = new FrameData();
                _local_6 = new ((_arg_1.getDefinition(("a" + _local_8)) as Class))();
                _local_4 = _local_10.readShort();
                _local_5 = _local_10.readShort();
                _local_3 = new Rectangle(_local_4, _local_5, (_local_6.width - _local_4), (_local_6.height - _local_5));
                _local_7.initClipped(_local_8, _local_3, _local_6);
                _frameDatas.push(_local_7);
                _local_8++;
            } while (--_local_9 > 0);
            _local_10.clear();
            delete LoaderMgr.getInstance().domainCache[this.url]; //not popped
        }

        public function setSwf(_arg_1:MovieClip, _arg_2:String=null):void
        {
            _swf = _arg_1;
            this.url = _arg_2;
            _swf.stop();
            readInfo();
        }

        public function getSwf():MovieClip
        {
            return (_swf);
        }

        private function readInfo():void
        {
            var _local_1:* = null;
            _frameRate = ((_swf.loaderInfo) ? _swf.loaderInfo.frameRate : 12);
            var _local_2:* = procOrigText(_swf);
            if (_local_2)
            {
                _local_1 = _local_2.text.split(/[.,，]/);
                _hasOrigin = true;
                _origX = _local_1[0];
                _origY = _local_1[1];
                if (((_local_1.length >= 3) && (!(_local_1[2] == ""))))
                {
                    _blendMode = _local_1[2];
                };
                if (_local_1.length >= 4)
                {
                    _frameRate = _local_1[3];
                };
            };
        }

        override public function get frameDatas():Vector.<FrameData>
        {
            var _local_1:* = null;
            var _local_4:* = null;
            var _local_5:int;
            var _local_6:int;
            var _local_7:* = null;
            var _local_2:* = null;
            var _local_3:* = null;
            if (_frameDatas == null)
            {
                _frameDatas = new Vector.<FrameData>();
                _local_5 = 1;
                _local_6 = _swf.totalFrames;
                while (_local_5 <= _local_6)
                {
                    _swf.gotoAndStop(_local_5);
                    _local_7 = getOriginText(_swf);
                    DspUtils.removeChild(_local_7);
                    _local_1 = DspUtils.getMovieClipBounds(_swf);
                    if (((_local_1.height == 0) || (_local_1.width == 0)))
                    {
                        _frameDatas.push(FrameData.emptyFrame);
                    }
                    else
                    {
                        _local_4 = new FrameData();
                        _local_2 = new Rectangle(-(_local_1.x), -(_local_1.y), _local_1.right, _local_1.bottom);
                        if (_local_1.right > _width)
                        {
                            _width = _local_1.right;
                        };
                        if (_local_1.bottom > _height)
                        {
                            _height = _local_1.bottom;
                        };
                        _local_3 = createFromSwf(_local_5, _swf, _local_1);
                        _local_4.initClipped(_local_5, _local_2, _local_3);
                        _frameDatas.push(_local_4);
                    };
                    _local_5++;
                };
                _swf = null;
                delete LoaderMgr.getInstance().domainCache[this.url];
            };
            return (_frameDatas);
        }

        override public function dispose():void
        {
            _swf = null;
            super.dispose();
        }


    }
}//package com.core.loader

