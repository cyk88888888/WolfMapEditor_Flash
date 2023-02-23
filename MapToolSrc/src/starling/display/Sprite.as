// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.display.Sprite

package starling.display
{
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;
    import __AS3__.vec.Vector;
    import starling.utils.MatrixUtil;
    import starling.utils.RectangleUtil;
    import starling.core.RenderSupport;

    public class Sprite extends DisplayObjectContainer 
    {

        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sHelperPoint:Point = new Point();
        private static var sHelperRect:Rectangle = new Rectangle();

        private var mFlattenedContents:Vector.<QuadBatch>;
        private var mFlattenRequested:Boolean;
        private var mFlattenOptimized:Boolean;
        private var mClipRect:Rectangle;


        override public function dispose():void
        {
            disposeFlattenedContents();
            super.dispose();
        }

        private function disposeFlattenedContents():void
        {
            var _local_2:int;
            var _local_1:int;
            if (mFlattenedContents)
            {
                _local_2 = 0;
                _local_1 = mFlattenedContents.length;
                while (_local_2 < _local_1)
                {
                    mFlattenedContents[_local_2].dispose();
                    _local_2++;
                };
                mFlattenedContents = null;
            };
        }

        public function flatten(_arg_1:Boolean=false):void
        {
            mFlattenRequested = true;
            mFlattenOptimized = _arg_1;
            broadcastEventWith("flatten");
        }

        public function unflatten():void
        {
            mFlattenRequested = false;
            disposeFlattenedContents();
        }

        public function get isFlattened():Boolean
        {
            return ((!(mFlattenedContents == null)) || (mFlattenRequested));
        }

        public function get clipRect():Rectangle
        {
            return (mClipRect);
        }

        public function set clipRect(_arg_1:Rectangle):void
        {
            if (((mClipRect) && (_arg_1)))
            {
                mClipRect.copyFrom(_arg_1);
            }
            else
            {
                mClipRect = ((_arg_1) ? _arg_1.clone() : null);
            };
        }

        public function getClipRect(_arg_1:DisplayObject, _arg_2:Rectangle=null):Rectangle
        {
            var _local_8:Number;
            var _local_11:Number;
            var _local_9:int;
            var _local_4:* = null;
            if (mClipRect == null)
            {
                return (null);
            };
            if (_arg_2 == null)
            {
                _arg_2 = new Rectangle();
            };
            var _local_7:* = 1.79769313486232E308;
            var _local_6:* = -1.79769313486232E308;
            var _local_10:* = 1.79769313486232E308;
            var _local_5:* = -1.79769313486232E308;
            var _local_3:Matrix = getTransformationMatrix(_arg_1, sHelperMatrix);
            _local_9 = 0;
            while (_local_9 < 4)
            {
                switch (_local_9)
                {
                    case 0:
                        _local_11 = mClipRect.left;
                        _local_8 = mClipRect.top;
                        break;
                    case 1:
                        _local_11 = mClipRect.left;
                        _local_8 = mClipRect.bottom;
                        break;
                    case 2:
                        _local_11 = mClipRect.right;
                        _local_8 = mClipRect.top;
                        break;
                    case 3:
                        _local_11 = mClipRect.right;
                        _local_8 = mClipRect.bottom;
                    default:
                };
                _local_4 = MatrixUtil.transformCoords(_local_3, _local_11, _local_8, sHelperPoint);
                if (_local_7 > _local_4.x)
                {
                    _local_7 = _local_4.x;
                };
                if (_local_6 < _local_4.x)
                {
                    _local_6 = _local_4.x;
                };
                if (_local_10 > _local_4.y)
                {
                    _local_10 = _local_4.y;
                };
                if (_local_5 < _local_4.y)
                {
                    _local_5 = _local_4.y;
                };
                _local_9++;
            };
            _arg_2.setTo(_local_7, _local_10, (_local_6 - _local_7), (_local_5 - _local_10));
            return (_arg_2);
        }

        override public function getBounds(_arg_1:DisplayObject, _arg_2:Rectangle=null):Rectangle
        {
            var _local_3:Rectangle = super.getBounds(_arg_1, _arg_2);
            if (mClipRect)
            {
                RectangleUtil.intersect(_local_3, getClipRect(_arg_1, sHelperRect), _local_3);
            };
            return (_local_3);
        }

        override public function hitTest(_arg_1:Point, _arg_2:Boolean=false):DisplayObject
        {
            if (((!(mClipRect == null)) && (!(mClipRect.containsPoint(_arg_1)))))
            {
                return (null);
            };
            return (super.hitTest(_arg_1, _arg_2));
        }

        override public function render(_arg_1:RenderSupport, _arg_2:Number):void
        {
            var _local_7:* = null;
            var _local_5:Number;
            var _local_8:int;
            var _local_4:* = null;
            var _local_9:int;
            var _local_6:* = null;
            var _local_3:* = null;
            if (mClipRect)
            {
                _local_7 = _arg_1.pushClipRect(getClipRect(stage, sHelperRect));
                if (_local_7.isEmpty())
                {
                    _arg_1.popClipRect();
                    return;
                };
            };
            if (((mFlattenedContents) || (mFlattenRequested)))
            {
                if (mFlattenedContents == null)
                {
                    mFlattenedContents = new Vector.<QuadBatch>(0);
                };
                if (mFlattenRequested)
                {
                    QuadBatch.compile(this, mFlattenedContents);
                    if (mFlattenOptimized)
                    {
                        QuadBatch.optimize(mFlattenedContents);
                    };
                    _arg_1.applyClipRect();
                    mFlattenRequested = false;
                };
                _local_5 = (_arg_2 * this.alpha);
                _local_8 = mFlattenedContents.length;
                _local_4 = _arg_1.mvpMatrix3D;
                _arg_1.finishQuadBatch();
                _arg_1.raiseDrawCount(_local_8);
                _local_9 = 0;
                while (_local_9 < _local_8)
                {
                    _local_6 = mFlattenedContents[_local_9];
                    _local_3 = ((_local_6.blendMode == "auto") ? _arg_1.blendMode : _local_6.blendMode);
                    _local_6.renderCustom(_local_4, _local_5, _local_3);
                    _local_9++;
                };
            }
            else
            {
                super.render(_arg_1, _arg_2);
            };
            if (mClipRect)
            {
                _arg_1.popClipRect();
            };
        }


    }
}//package starling.display

