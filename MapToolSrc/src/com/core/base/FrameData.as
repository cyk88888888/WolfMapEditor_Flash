// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.base.FrameData

package com.core.base
{
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.display.BitmapData;
    import flash.utils.ByteArray;
    import core.utils.DbgUtil;
    import flash.geom.Point;
    import com.core.BmdEncodeOption;

    public class FrameData 
    {

        private static const matrix:Matrix = new Matrix(1, 0, 0, 1, 0, 0);
        public static const useDraw:Boolean = false;

        private static var _emptyFrame:FrameData;

        public var frameId:int;
        public var frameOffset:Rectangle;
        private var _subBitmap:BitmapData;
        public var originBitmap:BitmapData;
        private var rcClip:Rectangle;
        private var bytes:ByteArray;


        public static function get emptyFrame():FrameData
        {
            if (_emptyFrame == null)
            {
                _emptyFrame = new (FrameData)();
                _emptyFrame.initClipped(0, new Rectangle(0, 0, 1, 1), new BitmapData(1, 1, true, 0xFFFFFF));
            };
            return (_emptyFrame);
        }

        public static function fromTexture(_arg_1:BitmapData, _arg_2:Rectangle, _arg_3:Rectangle):FrameData
        {
            var _local_4:FrameData = new (FrameData)();
            var _local_5:BitmapData = new BitmapData(_arg_2.width, _arg_2.height);
            _local_4.initClipped(0, _arg_3, _local_5);
            if (_local_4.frameOffset == null)
            {
                DbgUtil.nop();
            };
            _local_5.copyPixels(_arg_1, _arg_2, new Point());
            return (_local_4);
        }


        public function get subBitmap():BitmapData
        {
            return (_subBitmap);
        }

        public function set subBitmap(_arg_1:BitmapData):void
        {
            if (((!(_arg_1 == null)) && ((_arg_1.width == 1) || (_arg_1.height == 1))))
            {
                DbgUtil.nop();
            };
            _subBitmap = _arg_1;
        }

        public function dispose():void
        {
            frameOffset = null;
            subBitmap = null;
        }

        public function isValidSize():Boolean
        {
            var _local_1:int;
            var _local_4:int;
            var _local_2:BitmapData = this._subBitmap;
            if (rcClip != null)
            {
                _local_1 = rcClip.width;
                _local_4 = rcClip.height;
            }
            else
            {
                _local_1 = _local_2.width;
                _local_4 = _local_2.height;
            };
            var _local_3:Boolean = ((_local_1 < 1) && (_local_4 < 1));
            return (!(_local_3));
        }

        public function getBytes():ByteArray
        {
            if (bytes)
            {
                return (bytes);
            };
            var _local_3:Object = BmdEncodeOption.jpegxrEncoderOptions;
            if (((this.originBitmap) && (this.rcClip)))
            {
                bytes = this.originBitmap.encode(rcClip, _local_3);
                return (bytes);
            };
            var _local_2:BitmapData = this._subBitmap;
            var _local_1:Rectangle = new Rectangle(0, 0, _local_2.width, _local_2.height);
            bytes = _local_2.encode(_local_1, _local_3);
            return (bytes);
        }

        public function initClipped(_arg_1:int, _arg_2:Rectangle, _arg_3:BitmapData):void
        {
            this.frameId = _arg_1;
            this.frameOffset = _arg_2;
            this.subBitmap = _arg_3;
        }

        public function init(_arg_1:String, _arg_2:BitmapData, _arg_3:Rectangle):void
        {
            this.frameId = parseInt(_arg_1);
            this.originBitmap = _arg_2;
            this.rcClip = _arg_3;
            bytes = null;
        }

        public function get frameOffsetX():int
        {
            if (rcClip != null)
            {
                return (-(rcClip.x));
            };
            return (frameOffset.x);
        }

        public function get frameOffsetY():int
        {
            if (rcClip != null)
            {
                return (-(rcClip.y));
            };
            return (frameOffset.y);
        }

        public function get canvasWidth():int
        {
            if (this.originBitmap != null)
            {
                return (originBitmap.width);
            };
            return (frameOffset.width);
        }

        public function get canvasHeight():int
        {
            if (this.originBitmap != null)
            {
                return (originBitmap.height);
            };
            return (frameOffset.height);
        }


    }
}//package com.core.base

