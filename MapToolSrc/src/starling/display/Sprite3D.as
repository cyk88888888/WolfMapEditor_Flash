// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.display.Sprite3D

package starling.display
{
    import flash.geom.Vector3D;
    import flash.geom.Matrix3D;
    import flash.geom.Matrix;
    import starling.core.RenderSupport;
    import starling.utils.MatrixUtil;
    import starling.utils.MathUtil;
    import flash.geom.Point;
    import starling.events.Event;
    import starling.utils.rad2deg;

    public class Sprite3D extends DisplayObjectContainer 
    {

        private static const E:Number = 1E-5;

        private static var sHelperPoint:Vector3D = new Vector3D();
        private static var sHelperPointAlt:Vector3D = new Vector3D();
        private static var sHelperMatrix:Matrix3D = new Matrix3D();

        private var mRotationX:Number;
        private var mRotationY:Number;
        private var mScaleZ:Number;
        private var mPivotZ:Number;
        private var mZ:Number;
        private var mTransformationMatrix:Matrix;
        private var mTransformationMatrix3D:Matrix3D;
        private var mTransformationChanged:Boolean;

        public function Sprite3D()
        {
            mScaleZ = 1;
            mRotationX = (mRotationY = (mPivotZ = (mZ = 0)));
            mTransformationMatrix = new Matrix();
            mTransformationMatrix3D = new Matrix3D();
            setIs3D(true);
            addEventListener("added", onAddedChild);
            addEventListener("removed", onRemovedChild);
        }

        override public function render(_arg_1:RenderSupport, _arg_2:Number):void
        {
            if (is2D)
            {
                super.render(_arg_1, _arg_2);
            }
            else
            {
                _arg_1.finishQuadBatch();
                _arg_1.pushMatrix3D();
                _arg_1.transformMatrix3D(this);
                super.render(_arg_1, _arg_2);
                _arg_1.finishQuadBatch();
                _arg_1.popMatrix3D();
            };
        }

        override public function hitTest(_arg_1:Point, _arg_2:Boolean=false):DisplayObject
        {
            if (is2D)
            {
                return (super.hitTest(_arg_1, _arg_2));
            };
            if (((_arg_2) && ((!(visible)) || (!(touchable)))))
            {
                return (null);
            };
            sHelperMatrix.copyFrom(transformationMatrix3D);
            sHelperMatrix.invert();
            stage.getCameraPosition(this, sHelperPoint);
            MatrixUtil.transformCoords3D(sHelperMatrix, _arg_1.x, _arg_1.y, 0, sHelperPointAlt);
            MathUtil.intersectLineWithXYPlane(sHelperPoint, sHelperPointAlt, _arg_1);
            return (super.hitTest(_arg_1, _arg_2));
        }

        private function onAddedChild(_arg_1:Event):void
        {
            recursivelySetIs3D((_arg_1.target as DisplayObject), true);
        }

        private function onRemovedChild(_arg_1:Event):void
        {
            recursivelySetIs3D((_arg_1.target as DisplayObject), false);
        }

        private function recursivelySetIs3D(_arg_1:DisplayObject, _arg_2:Boolean):void
        {
            var _local_3:* = null;
            var _local_4:int;
            var _local_5:int;
            if ((_arg_1 is Sprite3D))
            {
                return;
            };
            if ((_arg_1 is DisplayObjectContainer))
            {
                _local_3 = (_arg_1 as DisplayObjectContainer);
                _local_4 = _local_3.numChildren;
                _local_5 = 0;
                while (_local_5 < _local_4)
                {
                    recursivelySetIs3D(_local_3.getChildAt(_local_5), _arg_2);
                    _local_5++;
                };
            };
            _arg_1.setIs3D(_arg_2);
        }

        private function updateMatrices():void
        {
            var _local_7:Number = this.x;
            var _local_6:Number = this.y;
            var _local_1:Number = this.scaleX;
            var _local_2:Number = this.scaleY;
            var _local_3:Number = this.pivotX;
            var _local_4:Number = this.pivotY;
            var _local_5:Number = this.rotation;
            mTransformationMatrix3D.identity();
            if ((((!(_local_1 == 1)) || (!(_local_2 == 1))) || (!(mScaleZ == 1))))
            {
                mTransformationMatrix3D.appendScale(((_local_1) || (1E-5)), ((_local_2) || (1E-5)), ((mScaleZ) || (1E-5)));
            };
            if (mRotationX != 0)
            {
                mTransformationMatrix3D.appendRotation(rad2deg(mRotationX), Vector3D.X_AXIS);
            };
            if (mRotationY != 0)
            {
                mTransformationMatrix3D.appendRotation(rad2deg(mRotationY), Vector3D.Y_AXIS);
            };
            if (_local_5 != 0)
            {
                mTransformationMatrix3D.appendRotation(rad2deg(_local_5), Vector3D.Z_AXIS);
            };
            if ((((!(_local_7 == 0)) || (!(_local_6 == 0))) || (!(mZ == 0))))
            {
                mTransformationMatrix3D.appendTranslation(_local_7, _local_6, mZ);
            };
            if ((((!(_local_3 == 0)) || (!(_local_4 == 0))) || (!(mPivotZ == 0))))
            {
                mTransformationMatrix3D.prependTranslation(-(_local_3), -(_local_4), -(mPivotZ));
            };
            if (is2D)
            {
                MatrixUtil.convertTo2D(mTransformationMatrix3D, mTransformationMatrix);
            }
            else
            {
                mTransformationMatrix.identity();
            };
        }

        final private function get is2D():Boolean
        {
            return ((((((((mZ > -(1E-5)) && (mZ < 1E-5)) && (mRotationX > -(1E-5))) && (mRotationX < 1E-5)) && (mRotationY > -(1E-5))) && (mRotationY < 1E-5)) && (mPivotZ > -(1E-5))) && (mPivotZ < 1E-5));
        }

        override public function get transformationMatrix():Matrix
        {
            if (mTransformationChanged)
            {
                updateMatrices();
                mTransformationChanged = false;
            };
            return (mTransformationMatrix);
        }

        override public function set transformationMatrix(_arg_1:Matrix):void
        {
            super.transformationMatrix = _arg_1;
            mRotationX = (mRotationY = (mPivotZ = (mZ = 0)));
            mTransformationChanged = true;
        }

        override public function get transformationMatrix3D():Matrix3D
        {
            if (mTransformationChanged)
            {
                updateMatrices();
                mTransformationChanged = false;
            };
            return (mTransformationMatrix3D);
        }

        override public function set x(_arg_1:Number):void
        {
            super.x = _arg_1;
            mTransformationChanged = true;
        }

        override public function set y(_arg_1:Number):void
        {
            super.y = _arg_1;
            mTransformationChanged = true;
        }

        public function get z():Number
        {
            return (mZ);
        }

        public function set z(_arg_1:Number):void
        {
            mZ = _arg_1;
            mTransformationChanged = true;
        }

        override public function set pivotX(_arg_1:Number):void
        {
            super.pivotX = _arg_1;
            mTransformationChanged = true;
        }

        override public function set pivotY(_arg_1:Number):void
        {
            super.pivotY = _arg_1;
            mTransformationChanged = true;
        }

        public function get pivotZ():Number
        {
            return (mPivotZ);
        }

        public function set pivotZ(_arg_1:Number):void
        {
            mPivotZ = _arg_1;
            mTransformationChanged = true;
        }

        override public function set scaleX(_arg_1:Number):void
        {
            super.scaleX = _arg_1;
            mTransformationChanged = true;
        }

        override public function set scaleY(_arg_1:Number):void
        {
            super.scaleY = _arg_1;
            mTransformationChanged = true;
        }

        public function get scaleZ():Number
        {
            return (mScaleZ);
        }

        public function set scaleZ(_arg_1:Number):void
        {
            mScaleZ = _arg_1;
            mTransformationChanged = true;
        }

        override public function set skewX(_arg_1:Number):void
        {
            throw (new Error("3D objects do not support skewing"));
        }

        override public function set skewY(_arg_1:Number):void
        {
            throw (new Error("3D objects do not support skewing"));
        }

        override public function set rotation(_arg_1:Number):void
        {
            super.rotation = _arg_1;
            mTransformationChanged = true;
        }

        public function get rotationX():Number
        {
            return (mRotationX);
        }

        public function set rotationX(_arg_1:Number):void
        {
            mRotationX = MathUtil.normalizeAngle(_arg_1);
            mTransformationChanged = true;
        }

        public function get rotationY():Number
        {
            return (mRotationY);
        }

        public function set rotationY(_arg_1:Number):void
        {
            mRotationY = MathUtil.normalizeAngle(_arg_1);
            mTransformationChanged = true;
        }

        public function get rotationZ():Number
        {
            return (rotation);
        }

        public function set rotationZ(_arg_1:Number):void
        {
            rotation = _arg_1;
        }


    }
}//package starling.display

