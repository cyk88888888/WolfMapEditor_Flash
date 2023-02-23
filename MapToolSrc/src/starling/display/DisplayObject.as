// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.display.DisplayObject

package starling.display
{
    import starling.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import starling.filters.FragmentFilter;
    import flash.utils.getQualifiedClassName;
    import flash.system.Capabilities;
    import starling.errors.AbstractClassError;
    import starling.errors.AbstractMethodError;
    import starling.utils.MatrixUtil;
    import starling.utils.MathUtil;
    import starling.core.RenderSupport;
    import flash.errors.IllegalOperationError;
    import starling.events.Event;
    import starling.core.Starling;
    import flash.ui.Mouse;
    import starling.events.TouchEvent;

    public class DisplayObject extends EventDispatcher 
    {

        private static var sAncestors:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
        private static var sHelperPoint:Point = new Point();
        private static var sHelperPoint3D:Vector3D = new Vector3D();
        private static var sHelperPointAlt3D:Vector3D = new Vector3D();
        private static var sHelperRect:Rectangle = new Rectangle();
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sHelperMatrixAlt:Matrix = new Matrix();
        private static var sHelperMatrix3D:Matrix3D = new Matrix3D();
        private static var sHelperMatrixAlt3D:Matrix3D = new Matrix3D();

        private var mX:Number;
        private var mY:Number;
        private var mPivotX:Number;
        private var mPivotY:Number;
        private var mScaleX:Number;
        private var mScaleY:Number;
        private var mSkewX:Number;
        private var mSkewY:Number;
        private var mRotation:Number;
        private var mAlpha:Number;
        private var mVisible:Boolean;
        private var mTouchable:Boolean;
        private var mBlendMode:String;
        private var mName:String;
        private var mUseHandCursor:Boolean;
        private var mParent:DisplayObjectContainer;
        private var mTransformationMatrix:Matrix;
        private var mTransformationMatrix3D:Matrix3D;
        private var mOrientationChanged:Boolean;
        private var mFilter:FragmentFilter;
        private var mIs3D:Boolean;
        private var mMask:DisplayObject;
        private var mIsMask:Boolean;
        public var zOrder:int = 0;

        public function DisplayObject()
        {
            if (((Capabilities.isDebugger) && (getQualifiedClassName(this) == "starling.display::DisplayObject")))
            {
                throw (new AbstractClassError());
            };
            mX = (mY = (mPivotX = (mPivotY = (mRotation = (mSkewX = (mSkewY = 0))))));
            mScaleX = (mScaleY = (mAlpha = 1));
            mVisible = (mTouchable = true);
            mBlendMode = "auto";
            mTransformationMatrix = new Matrix();
            mOrientationChanged = (mUseHandCursor = false);
        }

        public function dispose():void
        {
            if (mFilter)
            {
                mFilter.dispose();
            };
            if (mMask)
            {
                mMask.dispose();
            };
            removeEventListeners();
            mask = null;
        }

        public function removeFromParent(_arg_1:Boolean=false):void
        {
            if (mParent)
            {
                mParent.removeChild(this, _arg_1);
            }
            else
            {
                if (_arg_1)
                {
                    this.dispose();
                };
            };
        }

        public function getTransformationMatrix(_arg_1:DisplayObject, _arg_2:Matrix=null):Matrix
        {
            var _local_4:* = null;
            var _local_3:* = null;
            if (_arg_2)
            {
                _arg_2.identity();
            }
            else
            {
                _arg_2 = new Matrix();
            };
            if (_arg_1 == this)
            {
                return (_arg_2);
            };
            if (((_arg_1 == mParent) || ((_arg_1 == null) && (mParent == null))))
            {
                _arg_2.copyFrom(transformationMatrix);
                return (_arg_2);
            };
            if (((_arg_1 == null) || (_arg_1 == base)))
            {
                _local_3 = this;
                while (_local_3 != _arg_1)
                {
                    _arg_2.concat(_local_3.transformationMatrix);
                    _local_3 = _local_3.mParent;
                };
                return (_arg_2);
            };
            if (_arg_1.mParent == this)
            {
                _arg_1.getTransformationMatrix(this, _arg_2);
                _arg_2.invert();
                return (_arg_2);
            };
            _local_4 = findCommonParent(this, _arg_1);
            _local_3 = this;
            while (_local_3 != _local_4)
            {
                _arg_2.concat(_local_3.transformationMatrix);
                _local_3 = _local_3.mParent;
            };
            if (_local_4 == _arg_1)
            {
                return (_arg_2);
            };
            sHelperMatrix.identity();
            _local_3 = _arg_1;
            while (_local_3 != _local_4)
            {
                sHelperMatrix.concat(_local_3.transformationMatrix);
                _local_3 = _local_3.mParent;
            };
            sHelperMatrix.invert();
            _arg_2.concat(sHelperMatrix);
            return (_arg_2);
        }

        public function getBounds(_arg_1:DisplayObject, _arg_2:Rectangle=null):Rectangle
        {
            throw (new AbstractMethodError());
        }

        public function hitTest(_arg_1:Point, _arg_2:Boolean=false):DisplayObject
        {
            if (((_arg_2) && ((!(mVisible)) || (!(mTouchable)))))
            {
                return (null);
            };
            if (((mMask) && (!(hitTestMask(_arg_1)))))
            {
                return (null);
            };
            if (getBounds(this, sHelperRect).containsPoint(_arg_1))
            {
                return (this);
            };
            return (null);
        }

        public function hitTestMask(_arg_1:Point):Boolean
        {
            var _local_2:* = null;
            if (mMask)
            {
                if (mMask.stage)
                {
                    getTransformationMatrix(mMask, sHelperMatrixAlt);
                }
                else
                {
                    sHelperMatrixAlt.copyFrom(mMask.transformationMatrix);
                    sHelperMatrixAlt.invert();
                };
                _local_2 = ((_arg_1 == sHelperPoint) ? new Point() : sHelperPoint);
                MatrixUtil.transformPoint(sHelperMatrixAlt, _arg_1, _local_2);
                return (!(mMask.hitTest(_local_2, true) == null));
            };
            return (true);
        }

        public function localToGlobal(_arg_1:Point, _arg_2:Point=null):Point
        {
            if (is3D)
            {
                sHelperPoint3D.setTo(_arg_1.x, _arg_1.y, 0);
                return (local3DToGlobal(sHelperPoint3D, _arg_2));
            };
            getTransformationMatrix(base, sHelperMatrixAlt);
            return (MatrixUtil.transformPoint(sHelperMatrixAlt, _arg_1, _arg_2));
        }

        public function globalToLocal(_arg_1:Point, _arg_2:Point=null):Point
        {
            if (is3D)
            {
                globalToLocal3D(_arg_1, sHelperPoint3D);
                stage.getCameraPosition(this, sHelperPointAlt3D);
                return (MathUtil.intersectLineWithXYPlane(sHelperPointAlt3D, sHelperPoint3D, _arg_2));
            };
            getTransformationMatrix(base, sHelperMatrixAlt);
            sHelperMatrixAlt.invert();
            return (MatrixUtil.transformPoint(sHelperMatrixAlt, _arg_1, _arg_2));
        }

        public function render(_arg_1:RenderSupport, _arg_2:Number):void
        {
            throw (new AbstractMethodError());
        }

        public function get hasVisibleArea():Boolean
        {
            return (((((!(mAlpha == 0)) && (mVisible)) && (!(mIsMask))) && (!(mScaleX == 0))) && (!(mScaleY == 0)));
        }

        public function alignPivot(_arg_1:String="center", _arg_2:String="center"):void
        {
            var _local_3:Rectangle = getBounds(this, sHelperRect);
            mOrientationChanged = true;
            if (_arg_1 == "left")
            {
                mPivotX = _local_3.x;
            }
            else
            {
                if (_arg_1 == "center")
                {
                    mPivotX = (_local_3.x + (_local_3.width / 2));
                }
                else
                {
                    if (_arg_1 == "right")
                    {
                        mPivotX = (_local_3.x + _local_3.width);
                    }
                    else
                    {
                        throw (new ArgumentError(("Invalid horizontal alignment: " + _arg_1)));
                    };
                };
            };
            if (_arg_2 == "top")
            {
                mPivotY = _local_3.y;
            }
            else
            {
                if (_arg_2 == "center")
                {
                    mPivotY = (_local_3.y + (_local_3.height / 2));
                }
                else
                {
                    if (_arg_2 == "bottom")
                    {
                        mPivotY = (_local_3.y + _local_3.height);
                    }
                    else
                    {
                        throw (new ArgumentError(("Invalid vertical alignment: " + _arg_2)));
                    };
                };
            };
        }

        public function getTransformationMatrix3D(_arg_1:DisplayObject, _arg_2:Matrix3D=null):Matrix3D
        {
            var _local_4:* = null;
            var _local_3:* = null;
            if (_arg_2)
            {
                _arg_2.identity();
            }
            else
            {
                _arg_2 = new Matrix3D();
            };
            if (_arg_1 == this)
            {
                return (_arg_2);
            };
            if (((_arg_1 == mParent) || ((_arg_1 == null) && (mParent == null))))
            {
                _arg_2.copyFrom(transformationMatrix3D);
                return (_arg_2);
            };
            if (((_arg_1 == null) || (_arg_1 == base)))
            {
                _local_3 = this;
                while (_local_3 != _arg_1)
                {
                    _arg_2.append(_local_3.transformationMatrix3D);
                    _local_3 = _local_3.mParent;
                };
                return (_arg_2);
            };
            if (_arg_1.mParent == this)
            {
                _arg_1.getTransformationMatrix3D(this, _arg_2);
                _arg_2.invert();
                return (_arg_2);
            };
            _local_4 = findCommonParent(this, _arg_1);
            _local_3 = this;
            while (_local_3 != _local_4)
            {
                _arg_2.append(_local_3.transformationMatrix3D);
                _local_3 = _local_3.mParent;
            };
            if (_local_4 == _arg_1)
            {
                return (_arg_2);
            };
            sHelperMatrix3D.identity();
            _local_3 = _arg_1;
            while (_local_3 != _local_4)
            {
                sHelperMatrix3D.append(_local_3.transformationMatrix3D);
                _local_3 = _local_3.mParent;
            };
            sHelperMatrix3D.invert();
            _arg_2.append(sHelperMatrix3D);
            return (_arg_2);
        }

        public function local3DToGlobal(_arg_1:Vector3D, _arg_2:Point=null):Point
        {
            var _local_3:Stage = this.stage;
            if (_local_3 == null)
            {
                throw (new IllegalOperationError("Object not connected to stage"));
            };
            getTransformationMatrix3D(_local_3, sHelperMatrixAlt3D);
            MatrixUtil.transformPoint3D(sHelperMatrixAlt3D, _arg_1, sHelperPoint3D);
            return (MathUtil.intersectLineWithXYPlane(_local_3.cameraPosition, sHelperPoint3D, _arg_2));
        }

        public function globalToLocal3D(_arg_1:Point, _arg_2:Vector3D=null):Vector3D
        {
            var _local_3:Stage = this.stage;
            if (_local_3 == null)
            {
                throw (new IllegalOperationError("Object not connected to stage"));
            };
            getTransformationMatrix3D(_local_3, sHelperMatrixAlt3D);
            sHelperMatrixAlt3D.invert();
            return (MatrixUtil.transformCoords3D(sHelperMatrixAlt3D, _arg_1.x, _arg_1.y, 0, _arg_2));
        }

        internal function setParent(_arg_1:DisplayObjectContainer):void
        {
            var _local_2:DisplayObject = _arg_1;
            while (((!(_local_2 == this)) && (!(_local_2 == null))))
            {
                _local_2 = _local_2.mParent;
            };
            if (_local_2 == this)
            {
                throw (new ArgumentError("An object cannot be added as a child to itself or one of its children (or children's children, etc.)"));
            };
            mParent = _arg_1;
        }

        internal function setIs3D(_arg_1:Boolean):void
        {
            mIs3D = _arg_1;
        }

        internal function get isMask():Boolean
        {
            return (mIsMask);
        }

        final private function isEquivalent(_arg_1:Number, _arg_2:Number, _arg_3:Number=0.0001):Boolean
        {
            return (((_arg_1 - _arg_3) < _arg_2) && ((_arg_1 + _arg_3) > _arg_2));
        }

        final private function findCommonParent(_arg_1:DisplayObject, _arg_2:DisplayObject):DisplayObject
        {
            var _local_3:* = _arg_1;
            while (_local_3)
            {
                sAncestors[sAncestors.length] = _local_3;
                _local_3 = _local_3.mParent;
            };
            _local_3 = _arg_2;
            while (((_local_3) && (sAncestors.indexOf(_local_3) == -1)))
            {
                _local_3 = _local_3.mParent;
            };
            sAncestors.length = 0;
            if (_local_3)
            {
                return (_local_3);
            };
            throw (new ArgumentError("Object not connected to target"));
        }

        override public function dispatchEvent(_arg_1:Event):void
        {
            if (((_arg_1.type == "removedFromStage") && (stage == null)))
            {
                return;
            };
            super.dispatchEvent(_arg_1);
        }

        override public function addEventListener(_arg_1:String, _arg_2:Function):void
        {
            if (((_arg_1 == "enterFrame") && (!(hasEventListener(_arg_1)))))
            {
                addEventListener("addedToStage", addEnterFrameListenerToStage);
                addEventListener("removedFromStage", removeEnterFrameListenerFromStage);
                if (this.stage)
                {
                    addEnterFrameListenerToStage();
                };
            };
            super.addEventListener(_arg_1, _arg_2);
        }

        override public function removeEventListener(_arg_1:String, _arg_2:Function):void
        {
            super.removeEventListener(_arg_1, _arg_2);
            if (((_arg_1 == "enterFrame") && (!(hasEventListener(_arg_1)))))
            {
                removeEventListener("addedToStage", addEnterFrameListenerToStage);
                removeEventListener("removedFromStage", removeEnterFrameListenerFromStage);
                removeEnterFrameListenerFromStage();
            };
        }

        override public function removeEventListeners(_arg_1:String=null):void
        {
            if ((((_arg_1 == null) || (_arg_1 == "enterFrame")) && (hasEventListener("enterFrame"))))
            {
                removeEventListener("addedToStage", addEnterFrameListenerToStage);
                removeEventListener("removedFromStage", removeEnterFrameListenerFromStage);
                removeEnterFrameListenerFromStage();
            };
            super.removeEventListeners(_arg_1);
        }

        private function addEnterFrameListenerToStage():void
        {
            Starling.current.stage.addEnterFrameListener(this);
        }

        private function removeEnterFrameListenerFromStage():void
        {
            Starling.current.stage.removeEnterFrameListener(this);
        }

        public function get transformationMatrix():Matrix
        {
            var _local_6:Number;
            var _local_7:Number;
            var _local_8:Number;
            var _local_4:Number;
            var _local_5:Number;
            var _local_3:Number;
            var _local_2:Number;
            var _local_1:Number;
            if (mOrientationChanged)
            {
                mOrientationChanged = false;
                if (((mSkewX == 0) && (mSkewY == 0)))
                {
                    if (mRotation == 0)
                    {
                        mTransformationMatrix.setTo(mScaleX, 0, 0, mScaleY, (mX - (mPivotX * mScaleX)), (mY - (mPivotY * mScaleY)));
                    }
                    else
                    {
                        _local_6 = Math.cos(mRotation);
                        _local_7 = Math.sin(mRotation);
                        _local_8 = (mScaleX * _local_6);
                        _local_4 = (mScaleX * _local_7);
                        _local_5 = (mScaleY * -(_local_7));
                        _local_3 = (mScaleY * _local_6);
                        _local_2 = ((mX - (mPivotX * _local_8)) - (mPivotY * _local_5));
                        _local_1 = ((mY - (mPivotX * _local_4)) - (mPivotY * _local_3));
                        mTransformationMatrix.setTo(_local_8, _local_4, _local_5, _local_3, _local_2, _local_1);
                    };
                }
                else
                {
                    mTransformationMatrix.identity();
                    mTransformationMatrix.scale(mScaleX, mScaleY);
                    MatrixUtil.skew(mTransformationMatrix, mSkewX, mSkewY);
                    mTransformationMatrix.rotate(mRotation);
                    mTransformationMatrix.translate(mX, mY);
                    if (((!(mPivotX == 0)) || (!(mPivotY == 0))))
                    {
                        mTransformationMatrix.tx = ((mX - (mTransformationMatrix.a * mPivotX)) - (mTransformationMatrix.c * mPivotY));
                        mTransformationMatrix.ty = ((mY - (mTransformationMatrix.b * mPivotX)) - (mTransformationMatrix.d * mPivotY));
                    };
                };
            };
            return (mTransformationMatrix);
        }

        public function set transformationMatrix(_arg_1:Matrix):void
        {
            var _local_2:Number;
            _local_2 = 0.785398163397448;
            mOrientationChanged = false;
            mTransformationMatrix.copyFrom(_arg_1);
            mPivotX = (mPivotY = 0);
            mX = _arg_1.tx;
            mY = _arg_1.ty;
            mSkewX = Math.atan((-(_arg_1.c) / _arg_1.d));
            mSkewY = Math.atan((_arg_1.b / _arg_1.a));
            if (mSkewX != mSkewX)
            {
                mSkewX = 0;
            };
            if (mSkewY != mSkewY)
            {
                mSkewY = 0;
            };
            mScaleY = (((mSkewX > -(0.785398163397448)) && (mSkewX < 0.785398163397448)) ? (_arg_1.d / Math.cos(mSkewX)) : (-(_arg_1.c) / Math.sin(mSkewX)));
            mScaleX = (((mSkewY > -(0.785398163397448)) && (mSkewY < 0.785398163397448)) ? (_arg_1.a / Math.cos(mSkewY)) : (_arg_1.b / Math.sin(mSkewY)));
            if (isEquivalent(mSkewX, mSkewY))
            {
                mRotation = mSkewX;
                mSkewX = (mSkewY = 0);
            }
            else
            {
                mRotation = 0;
            };
        }

        public function get transformationMatrix3D():Matrix3D
        {
            if (mTransformationMatrix3D == null)
            {
                mTransformationMatrix3D = new Matrix3D();
            };
            return (MatrixUtil.convertTo3D(transformationMatrix, mTransformationMatrix3D));
        }

        public function get is3D():Boolean
        {
            return (mIs3D);
        }

        public function get useHandCursor():Boolean
        {
            return (mUseHandCursor);
        }

        public function set useHandCursor(_arg_1:Boolean):void
        {
            if (_arg_1 == mUseHandCursor)
            {
                return;
            };
            mUseHandCursor = _arg_1;
            if (mUseHandCursor)
            {
                addEventListener("touch", onTouch);
            }
            else
            {
                removeEventListener("touch", onTouch);
            };
        }

        private function onTouch(_arg_1:TouchEvent):void
        {
            Mouse.cursor = ((_arg_1.interactsWith(this)) ? "button" : "auto");
        }

        public function get bounds():Rectangle
        {
            return (getBounds(mParent));
        }

        public function get width():Number
        {
            return (getBounds(mParent, sHelperRect).width);
        }

        public function set width(_arg_1:Number):void
        {
            scaleX = 1;
            var _local_2:Number = width;
            if (_local_2 != 0)
            {
                scaleX = (_arg_1 / _local_2);
            };
        }

        public function get height():Number
        {
            return (getBounds(mParent, sHelperRect).height);
        }

        public function set height(_arg_1:Number):void
        {
            scaleY = 1;
            var _local_2:Number = height;
            if (_local_2 != 0)
            {
                scaleY = (_arg_1 / _local_2);
            };
        }

        public function get x():Number
        {
            return (mX);
        }

        public function set x(_arg_1:Number):void
        {
            if (mX != _arg_1)
            {
                mX = _arg_1;
                mOrientationChanged = true;
            };
        }

        public function get y():Number
        {
            return (mY);
        }

        public function set y(_arg_1:Number):void
        {
            if (mY != _arg_1)
            {
                mY = _arg_1;
                mOrientationChanged = true;
            };
        }

        public function get pivotX():Number
        {
            return (mPivotX);
        }

        public function set pivotX(_arg_1:Number):void
        {
            if (mPivotX != _arg_1)
            {
                mPivotX = _arg_1;
                mOrientationChanged = true;
            };
        }

        public function get pivotY():Number
        {
            return (mPivotY);
        }

        public function set pivotY(_arg_1:Number):void
        {
            if (mPivotY != _arg_1)
            {
                mPivotY = _arg_1;
                mOrientationChanged = true;
            };
        }

        public function get scaleX():Number
        {
            return (mScaleX);
        }

        public function set scaleX(_arg_1:Number):void
        {
            if (mScaleX != _arg_1)
            {
                mScaleX = _arg_1;
                mOrientationChanged = true;
            };
        }

        public function get scaleY():Number
        {
            return (mScaleY);
        }

        public function set scaleY(_arg_1:Number):void
        {
            if (mScaleY != _arg_1)
            {
                mScaleY = _arg_1;
                mOrientationChanged = true;
            };
        }

        public function get scale():Number
        {
            return (scaleX);
        }

        public function set scale(_arg_1:Number):void
        {
            scaleX = (scaleY = _arg_1);
        }

        public function get skewX():Number
        {
            return (mSkewX);
        }

        public function set skewX(_arg_1:Number):void
        {
            _arg_1 = MathUtil.normalizeAngle(_arg_1);
            if (mSkewX != _arg_1)
            {
                mSkewX = _arg_1;
                mOrientationChanged = true;
            };
        }

        public function get skewY():Number
        {
            return (mSkewY);
        }

        public function set skewY(_arg_1:Number):void
        {
            _arg_1 = MathUtil.normalizeAngle(_arg_1);
            if (mSkewY != _arg_1)
            {
                mSkewY = _arg_1;
                mOrientationChanged = true;
            };
        }

        public function get rotation():Number
        {
            return (mRotation);
        }

        public function set rotation(_arg_1:Number):void
        {
            _arg_1 = MathUtil.normalizeAngle(_arg_1);
            if (mRotation != _arg_1)
            {
                mRotation = _arg_1;
                mOrientationChanged = true;
            };
        }

        public function get alpha():Number
        {
            return (mAlpha);
        }

        public function set alpha(_arg_1:Number):void
        {
            mAlpha = ((_arg_1 < 0) ? 0 : ((_arg_1 > 1) ? 1 : _arg_1));
        }

        public function get visible():Boolean
        {
            return (mVisible);
        }

        public function set visible(_arg_1:Boolean):void
        {
            mVisible = _arg_1;
        }

        public function get touchable():Boolean
        {
            return (mTouchable);
        }

        public function set touchable(_arg_1:Boolean):void
        {
            mTouchable = _arg_1;
        }

        public function get blendMode():String
        {
            return (mBlendMode);
        }

        public function set blendMode(_arg_1:String):void
        {
            mBlendMode = _arg_1;
        }

        public function get name():String
        {
            return (mName);
        }

        public function set name(_arg_1:String):void
        {
            mName = _arg_1;
        }

        public function get filter():FragmentFilter
        {
            return (mFilter);
        }

        public function set filter(_arg_1:FragmentFilter):void
        {
            mFilter = _arg_1;
        }

        public function get mask():DisplayObject
        {
            return (mMask);
        }

        public function set mask(_arg_1:DisplayObject):void
        {
            if (mMask != _arg_1)
            {
                if (mMask)
                {
                    mMask.mIsMask = false;
                };
                if (_arg_1)
                {
                    _arg_1.mIsMask = true;
                };
                mMask = _arg_1;
            };
        }

        public function get parent():DisplayObjectContainer
        {
            return (mParent);
        }

        public function get base():DisplayObject
        {
            var _local_1:* = this;
            while (_local_1.mParent)
            {
                _local_1 = _local_1.mParent;
            };
            return (_local_1);
        }

        public function get root():DisplayObject
        {
            var _local_1:* = this;
            while (_local_1.mParent)
            {
                if ((_local_1.mParent is Stage))
                {
                    return (_local_1);
                };
                _local_1 = _local_1.parent;
            };
            return (null);
        }

        public function get stage():Stage
        {
            return (this.base as Stage);
        }


    }
}//package starling.display

