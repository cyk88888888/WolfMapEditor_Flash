// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.display.Stage

package starling.display
{
    import flash.geom.Matrix3D;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import starling.events.EnterFrameEvent;
    import __AS3__.vec.Vector;
    import starling.core.starling_internal;
    import starling.core.RenderSupport;
    import starling.core.Starling;
    import flash.display.BitmapData;
    import starling.utils.MatrixUtil;
    import flash.errors.IllegalOperationError;
    import starling.filters.FragmentFilter;

    use namespace starling_internal;

    public class Stage extends DisplayObjectContainer 
    {

        private static var sHelperMatrix:Matrix3D = new Matrix3D();

        private var mWidth:int;
        private var mHeight:int;
        private var mColor:uint;
        private var mFieldOfView:Number;
        private var mProjectionOffset:Point;
        private var mCameraPosition:Vector3D;
        private var mEnterFrameEvent:EnterFrameEvent;
        private var mEnterFrameListeners:Vector.<DisplayObject>;

        public function Stage(_arg_1:int, _arg_2:int, _arg_3:uint=0)
        {
            mWidth = _arg_1;
            mHeight = _arg_2;
            mColor = _arg_3;
            mFieldOfView = 1;
            mProjectionOffset = new Point();
            mCameraPosition = new Vector3D();
            mEnterFrameEvent = new EnterFrameEvent("enterFrame", 0);
            mEnterFrameListeners = new Vector.<DisplayObject>(0);
        }

        public function advanceTime(_arg_1:Number):void
        {
            mEnterFrameEvent.starling_internal::reset("enterFrame", false, _arg_1);
            broadcastEvent(mEnterFrameEvent);
        }

        override public function hitTest(_arg_1:Point, _arg_2:Boolean=false):DisplayObject
        {
            if (((_arg_2) && ((!(visible)) || (!(touchable)))))
            {
                return (null);
            };
            if (((((_arg_1.x < 0) || (_arg_1.x > mWidth)) || (_arg_1.y < 0)) || (_arg_1.y > mHeight)))
            {
                return (null);
            };
            var _local_3:DisplayObject = super.hitTest(_arg_1, _arg_2);
            if (_local_3 == null)
            {
                _local_3 = this;
            };
            return (_local_3);
        }

        public function drawToBitmapData(_arg_1:BitmapData=null, _arg_2:Boolean=true):BitmapData
        {
            var _local_5:int;
            var _local_3:int;
            var _local_4:RenderSupport = new RenderSupport();
            var _local_6:Starling = Starling.current;
            if (_arg_1 == null)
            {
                _local_5 = (_local_6.backBufferWidth * _local_6.backBufferPixelsPerPoint);
                _local_3 = (_local_6.backBufferHeight * _local_6.backBufferPixelsPerPoint);
                _arg_1 = new BitmapData(_local_5, _local_3, _arg_2);
            };
            _local_4.renderTarget = null;
            _local_4.setProjectionMatrix(0, 0, mWidth, mHeight, mWidth, mHeight, cameraPosition);
            if (_arg_2)
            {
                _local_4.clear();
            }
            else
            {
                _local_4.clear(mColor, 1);
            };
            render(_local_4, 1);
            _local_4.finishQuadBatch();
            _local_4.dispose();
            Starling.current.context.drawToBitmapData(_arg_1);
            Starling.current.context.present();
            return (_arg_1);
        }

        public function getCameraPosition(_arg_1:DisplayObject=null, _arg_2:Vector3D=null):Vector3D
        {
            getTransformationMatrix3D(_arg_1, sHelperMatrix);
            return (MatrixUtil.transformCoords3D(sHelperMatrix, ((mWidth / 2) + mProjectionOffset.x), ((mHeight / 2) + mProjectionOffset.y), -(focalLength), _arg_2));
        }

        internal function addEnterFrameListener(_arg_1:DisplayObject):void
        {
            mEnterFrameListeners.push(_arg_1);
        }

        internal function removeEnterFrameListener(_arg_1:DisplayObject):void
        {
            var _local_2:int = mEnterFrameListeners.indexOf(_arg_1);
            if (_local_2 >= 0)
            {
                mEnterFrameListeners.splice(_local_2, 1);
            };
        }

        override internal function getChildEventListeners(_arg_1:DisplayObject, _arg_2:String, _arg_3:Vector.<DisplayObject>):void
        {
            var _local_5:int;
            var _local_4:int;
            if (((_arg_2 == "enterFrame") && (_arg_1 == this)))
            {
                _local_5 = 0;
                _local_4 = mEnterFrameListeners.length;
                while (_local_5 < _local_4)
                {
                    _arg_3[_arg_3.length] = mEnterFrameListeners[_local_5];
                    _local_5++;
                };
            }
            else
            {
                super.getChildEventListeners(_arg_1, _arg_2, _arg_3);
            };
        }

        override public function set width(_arg_1:Number):void
        {
            throw (new IllegalOperationError("Cannot set width of stage"));
        }

        override public function set height(_arg_1:Number):void
        {
            throw (new IllegalOperationError("Cannot set height of stage"));
        }

        override public function set x(_arg_1:Number):void
        {
            throw (new IllegalOperationError("Cannot set x-coordinate of stage"));
        }

        override public function set y(_arg_1:Number):void
        {
            throw (new IllegalOperationError("Cannot set y-coordinate of stage"));
        }

        override public function set scaleX(_arg_1:Number):void
        {
            throw (new IllegalOperationError("Cannot scale stage"));
        }

        override public function set scaleY(_arg_1:Number):void
        {
            throw (new IllegalOperationError("Cannot scale stage"));
        }

        override public function set rotation(_arg_1:Number):void
        {
            throw (new IllegalOperationError("Cannot rotate stage"));
        }

        override public function set skewX(_arg_1:Number):void
        {
            throw (new IllegalOperationError("Cannot skew stage"));
        }

        override public function set skewY(_arg_1:Number):void
        {
            throw (new IllegalOperationError("Cannot skew stage"));
        }

        override public function set filter(_arg_1:FragmentFilter):void
        {
            throw (new IllegalOperationError("Cannot add filter to stage. Add it to 'root' instead!"));
        }

        public function get color():uint
        {
            return (mColor);
        }

        public function set color(_arg_1:uint):void
        {
            mColor = _arg_1;
        }

        public function get stageWidth():int
        {
            return (mWidth);
        }

        public function set stageWidth(_arg_1:int):void
        {
            mWidth = _arg_1;
        }

        public function get stageHeight():int
        {
            return (mHeight);
        }

        public function set stageHeight(_arg_1:int):void
        {
            mHeight = _arg_1;
        }

        public function get focalLength():Number
        {
            return (mWidth / (2 * Math.tan((mFieldOfView / 2))));
        }

        public function set focalLength(_arg_1:Number):void
        {
            mFieldOfView = (2 * Math.atan((stageWidth / (2 * _arg_1))));
        }

        public function get fieldOfView():Number
        {
            return (mFieldOfView);
        }

        public function set fieldOfView(_arg_1:Number):void
        {
            mFieldOfView = _arg_1;
        }

        public function get projectionOffset():Point
        {
            return (mProjectionOffset);
        }

        public function set projectionOffset(_arg_1:Point):void
        {
            mProjectionOffset.setTo(_arg_1.x, _arg_1.y);
        }

        public function get cameraPosition():Vector3D
        {
            return (getCameraPosition(null, mCameraPosition));
        }


    }
}//package starling.display

