// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.display.Quad

package starling.display
{
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.geom.Matrix;
    import flash.geom.Matrix3D;
    import starling.utils.VertexData;
    import flash.geom.Rectangle;
    import starling.core.RenderSupport;

    public class Quad extends DisplayObject 
    {

        private static var sHelperPoint:Point = new Point();
        private static var sHelperPoint3D:Vector3D = new Vector3D();
        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sHelperMatrix3D:Matrix3D = new Matrix3D();

        private var mTinted:Boolean;
        protected var mVertexData:VertexData;

        public function Quad(_arg_1:Number, _arg_2:Number, _arg_3:uint=0xFFFFFF, _arg_4:Boolean=true)
        {
            if (((_arg_1 == 0) || (_arg_2 == 0)))
            {
                throw (new ArgumentError("Invalid size: width and height must not be zero"));
            };
            mTinted = (!(_arg_3 == 0xFFFFFF));
            mVertexData = new VertexData(4, _arg_4);
            if (((_arg_1 == _arg_1) && (_arg_2 == _arg_2)))
            {
                adjustSize(_arg_1, _arg_2);
            };
            mVertexData.setUniformColor(_arg_3);
            onVertexDataChanged();
        }

        protected function adjustSize(_arg_1:Number, _arg_2:Number):void
        {
            mVertexData.setPosition(0, 0, 0);
            mVertexData.setPosition(1, _arg_1, 0);
            mVertexData.setPosition(2, 0, _arg_2);
            mVertexData.setPosition(3, _arg_1, _arg_2);
        }

        protected function onVertexDataChanged():void
        {
        }

        override public function getBounds(_arg_1:DisplayObject, _arg_2:Rectangle=null):Rectangle
        {
            var _local_3:Number;
            var _local_4:Number;
            if (_arg_2 == null)
            {
                _arg_2 = new Rectangle();
            };
            if (_arg_1 == this)
            {
                mVertexData.getPosition(3, sHelperPoint);
                _arg_2.setTo(0, 0, sHelperPoint.x, sHelperPoint.y);
            }
            else
            {
                if (((_arg_1 == parent) && (rotation == 0)))
                {
                    _local_3 = this.scaleX;
                    _local_4 = this.scaleY;
                    mVertexData.getPosition(3, sHelperPoint);
                    _arg_2.setTo((x - (pivotX * _local_3)), (y - (pivotY * _local_4)), (sHelperPoint.x * _local_3), (sHelperPoint.y * _local_4));
                    if (_local_3 < 0)
                    {
                        _arg_2.width = (_arg_2.width * -1);
                        _arg_2.x = (_arg_2.x - _arg_2.width);
                    };
                    if (_local_4 < 0)
                    {
                        _arg_2.height = (_arg_2.height * -1);
                        _arg_2.y = (_arg_2.y - _arg_2.height);
                    };
                }
                else
                {
                    if (((is3D) && (stage)))
                    {
                        stage.getCameraPosition(_arg_1, sHelperPoint3D);
                        getTransformationMatrix3D(_arg_1, sHelperMatrix3D);
                        mVertexData.getBoundsProjected(sHelperMatrix3D, sHelperPoint3D, 0, 4, _arg_2);
                    }
                    else
                    {
                        getTransformationMatrix(_arg_1, sHelperMatrix);
                        mVertexData.getBounds(sHelperMatrix, 0, 4, _arg_2);
                    };
                };
            };
            return (_arg_2);
        }

        public function getVertexColor(_arg_1:int):uint
        {
            return (mVertexData.getColor(_arg_1));
        }

        public function setVertexColor(_arg_1:int, _arg_2:uint):void
        {
            mVertexData.setColor(_arg_1, _arg_2);
            onVertexDataChanged();
            if (_arg_2 != 0xFFFFFF)
            {
                mTinted = true;
            }
            else
            {
                mTinted = mVertexData.tinted;
            };
        }

        public function getVertexAlpha(_arg_1:int):Number
        {
            return (mVertexData.getAlpha(_arg_1));
        }

        public function setVertexAlpha(_arg_1:int, _arg_2:Number):void
        {
            mVertexData.setAlpha(_arg_1, _arg_2);
            onVertexDataChanged();
            if (_arg_2 != 1)
            {
                mTinted = true;
            }
            else
            {
                mTinted = mVertexData.tinted;
            };
        }

        public function get color():uint
        {
            return (mVertexData.getColor(0));
        }

        public function set color(_arg_1:uint):void
        {
            mVertexData.setUniformColor(_arg_1);
            onVertexDataChanged();
            if (((!(_arg_1 == 0xFFFFFF)) || (!(alpha == 1))))
            {
                mTinted = true;
            }
            else
            {
                mTinted = mVertexData.tinted;
            };
        }

        override public function set alpha(_arg_1:Number):void
        {
            super.alpha = _arg_1;
            if (_arg_1 < 1)
            {
                mTinted = true;
            }
            else
            {
                mTinted = mVertexData.tinted;
            };
        }

        public function copyVertexDataTo(_arg_1:VertexData, _arg_2:int=0):void
        {
            mVertexData.copyTo(_arg_1, _arg_2);
        }

        public function copyVertexDataTransformedTo(_arg_1:VertexData, _arg_2:int=0, _arg_3:Matrix=null):void
        {
            mVertexData.copyTransformedTo(_arg_1, _arg_2, _arg_3, 0, 4);
        }

        override public function render(_arg_1:RenderSupport, _arg_2:Number):void
        {
            _arg_1.batchQuad(this, _arg_2);
        }

        public function get tinted():Boolean
        {
            return (mTinted);
        }

        public function get premultipliedAlpha():Boolean
        {
            return (mVertexData.premultipliedAlpha);
        }


    }
}//package starling.display

