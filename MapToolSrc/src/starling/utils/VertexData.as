// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.VertexData

package starling.utils
{
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import __AS3__.vec.Vector;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.geom.Matrix3D;

    public class VertexData 
    {

        public static const ELEMENTS_PER_VERTEX:int = 8;
        public static const POSITION_OFFSET:int = 0;
        public static const COLOR_OFFSET:int = 2;
        public static const TEXCOORD_OFFSET:int = 6;

        private static var sHelperPoint:Point = new Point();
        private static var sHelperPoint3D:Vector3D = new Vector3D();

        private var mRawData:Vector.<Number>;
        private var mPremultipliedAlpha:Boolean;
        private var mNumVertices:int;

        public function VertexData(_arg_1:int, _arg_2:Boolean=false)
        {
            mRawData = new Vector.<Number>(0);
            mPremultipliedAlpha = _arg_2;
            this.numVertices = _arg_1;
        }

        public function clone(_arg_1:int=0, _arg_2:int=-1):VertexData
        {
            if (((_arg_2 < 0) || ((_arg_1 + _arg_2) > mNumVertices)))
            {
                _arg_2 = (mNumVertices - _arg_1);
            };
            var _local_3:VertexData = new VertexData(0, mPremultipliedAlpha);
            _local_3.mNumVertices = _arg_2;
            _local_3.mRawData = mRawData.slice((_arg_1 * 8), (_arg_2 * 8));
            _local_3.mRawData.fixed = true;
            return (_local_3);
        }

        public function copyTo(_arg_1:VertexData, _arg_2:int=0, _arg_3:int=0, _arg_4:int=-1):void
        {
            copyTransformedTo(_arg_1, _arg_2, null, _arg_3, _arg_4);
        }

        public function copyTransformedTo(_arg_1:VertexData, _arg_2:int=0, _arg_3:Matrix=null, _arg_4:int=0, _arg_5:int=-1):void
        {
            var _local_10:Number;
            var _local_11:Number;
            if (((_arg_5 < 0) || ((_arg_4 + _arg_5) > mNumVertices)))
            {
                _arg_5 = (mNumVertices - _arg_4);
            };
            var _local_8:Vector.<Number> = _arg_1.mRawData;
            var _local_7:int = (_arg_2 * 8);
            var _local_9:int = (_arg_4 * 8);
            var _local_6:int = ((_arg_4 + _arg_5) * 8);
            if (_arg_3)
            {
                while (_local_9 < _local_6)
                {
                    _local_11 = mRawData[_local_9++];
                    _local_10 = mRawData[_local_9++];
                    _local_8[_local_7++] = (((_arg_3.a * _local_11) + (_arg_3.c * _local_10)) + _arg_3.tx);
                    _local_8[_local_7++] = (((_arg_3.d * _local_10) + (_arg_3.b * _local_11)) + _arg_3.ty);
                    _local_8[_local_7++] = mRawData[_local_9++];
                    _local_8[_local_7++] = mRawData[_local_9++];
                    _local_8[_local_7++] = mRawData[_local_9++];
                    _local_8[_local_7++] = mRawData[_local_9++];
                    _local_8[_local_7++] = mRawData[_local_9++];
                    _local_8[_local_7++] = mRawData[_local_9++];
                };
            }
            else
            {
                while (_local_9 < _local_6)
                {
                    _local_8[_local_7++] = mRawData[_local_9++];
                };
            };
        }

        public function append(_arg_1:VertexData):void
        {
            var _local_5:int;
            mRawData.fixed = false;
            var _local_2:int = mRawData.length;
            var _local_3:Vector.<Number> = _arg_1.mRawData;
            var _local_4:int = _local_3.length;
            _local_5 = 0;
            while (_local_5 < _local_4)
            {
                mRawData[_local_2++] = _local_3[_local_5];
                _local_5++;
            };
            mNumVertices = (mNumVertices + _arg_1.numVertices);
            mRawData.fixed = true;
        }

        public function setPosition(_arg_1:int, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:int = ((_arg_1 * 8) + 0);
            mRawData[_local_4] = _arg_2;
            mRawData[(_local_4 + 1)] = _arg_3;
        }

        public function getPosition(_arg_1:int, _arg_2:Point):void
        {
            var _local_3:int = ((_arg_1 * 8) + 0);
            _arg_2.x = mRawData[_local_3];
            _arg_2.y = mRawData[(_local_3 + 1)];
        }

        public function setColorAndAlpha(_arg_1:int, _arg_2:uint, _arg_3:Number):void
        {
            if (_arg_3 < 0.001)
            {
                _arg_3 = 0.001;
            }
            else
            {
                if (_arg_3 > 1)
                {
                    _arg_3 = 1;
                };
            };
            var _local_4:int = ((_arg_1 * 8) + 2);
            var _local_5:Number = ((mPremultipliedAlpha) ? _arg_3 : 1);
            mRawData[_local_4] = ((((_arg_2 >> 16) & 0xFF) / 0xFF) * _local_5);
            mRawData[(_local_4 + 1)] = ((((_arg_2 >> 8) & 0xFF) / 0xFF) * _local_5);
            mRawData[(_local_4 + 2)] = (((_arg_2 & 0xFF) / 0xFF) * _local_5);
            mRawData[(_local_4 + 3)] = _arg_3;
        }

        public function setColor(_arg_1:int, _arg_2:uint):void
        {
            var _local_3:int = ((_arg_1 * 8) + 2);
            var _local_4:Number = ((mPremultipliedAlpha) ? mRawData[(_local_3 + 3)] : 1);
            mRawData[_local_3] = ((((_arg_2 >> 16) & 0xFF) / 0xFF) * _local_4);
            mRawData[(_local_3 + 1)] = ((((_arg_2 >> 8) & 0xFF) / 0xFF) * _local_4);
            mRawData[(_local_3 + 2)] = (((_arg_2 & 0xFF) / 0xFF) * _local_4);
        }

        public function getColor(_arg_1:int):uint
        {
            var _local_2:Number;
            var _local_4:Number;
            var _local_3:Number;
            var _local_6:int = ((_arg_1 * 8) + 2);
            var _local_5:Number = ((mPremultipliedAlpha) ? mRawData[(_local_6 + 3)] : 1);
            if (_local_5 == 0)
            {
                return (0);
            };
            _local_2 = (mRawData[_local_6] / _local_5);
            _local_4 = (mRawData[(_local_6 + 1)] / _local_5);
            _local_3 = (mRawData[(_local_6 + 2)] / _local_5);
            return ((((_local_2 * 0xFF) << 16) | ((_local_4 * 0xFF) << 8)) | (_local_3 * 0xFF));
        }

        public function setAlpha(_arg_1:int, _arg_2:Number):void
        {
            if (mPremultipliedAlpha)
            {
                setColorAndAlpha(_arg_1, getColor(_arg_1), _arg_2);
            }
            else
            {
                mRawData[(((_arg_1 * 8) + 2) + 3)] = _arg_2;
            };
        }

        public function getAlpha(_arg_1:int):Number
        {
            var _local_2:int = (((_arg_1 * 8) + 2) + 3);
            return (mRawData[_local_2]);
        }

        public function setTexCoords(_arg_1:int, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:int = ((_arg_1 * 8) + 6);
            mRawData[_local_4] = _arg_2;
            mRawData[(_local_4 + 1)] = _arg_3;
        }

        public function getTexCoords(_arg_1:int, _arg_2:Point):void
        {
            var _local_3:int = ((_arg_1 * 8) + 6);
            _arg_2.x = mRawData[_local_3];
            _arg_2.y = mRawData[(_local_3 + 1)];
        }

        public function translateVertex(_arg_1:int, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:int = ((_arg_1 * 8) + 0);
            var _local_5:* = _local_4;
            var _local_6:* = (mRawData[_local_5] + _arg_2);
            mRawData[_local_5] = _local_6;
            _local_6 = (_local_4 + 1);
            _local_5 = (mRawData[_local_6] + _arg_3);
            mRawData[_local_6] = _local_5;
        }

        public function transformVertex(_arg_1:int, _arg_2:Matrix, _arg_3:int=1):void
        {
            var _local_5:Number;
            var _local_7:Number;
            var _local_6:int;
            var _local_4:int = ((_arg_1 * 8) + 0);
            _local_6 = 0;
            while (_local_6 < _arg_3)
            {
                _local_7 = mRawData[_local_4];
                _local_5 = mRawData[(_local_4 + 1)];
                mRawData[_local_4] = (((_arg_2.a * _local_7) + (_arg_2.c * _local_5)) + _arg_2.tx);
                mRawData[(_local_4 + 1)] = (((_arg_2.d * _local_5) + (_arg_2.b * _local_7)) + _arg_2.ty);
                _local_4 = (_local_4 + 8);
                _local_6++;
            };
        }

        public function setUniformColor(_arg_1:uint):void
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < mNumVertices)
            {
                setColor(_local_2, _arg_1);
                _local_2++;
            };
        }

        public function setUniformAlpha(_arg_1:Number):void
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < mNumVertices)
            {
                setAlpha(_local_2, _arg_1);
                _local_2++;
            };
        }

        public function scaleAlpha(_arg_1:int, _arg_2:Number, _arg_3:int=1):void
        {
            var _local_5:int;
            var _local_4:int;
            if (_arg_2 == 1)
            {
                return;
            };
            if (((_arg_3 < 0) || ((_arg_1 + _arg_3) > mNumVertices)))
            {
                _arg_3 = (mNumVertices - _arg_1);
            };
            if (mPremultipliedAlpha)
            {
                _local_5 = 0;
                while (_local_5 < _arg_3)
                {
                    setAlpha((_arg_1 + _local_5), (getAlpha((_arg_1 + _local_5)) * _arg_2));
                    _local_5++;
                };
            }
            else
            {
                _local_4 = (((_arg_1 * 8) + 2) + 3);
                _local_5 = 0;
                while (_local_5 < _arg_3)
                {
                    var _local_6:int = (_local_4 + (_local_5 * 8));
                    var _local_7:* = (mRawData[_local_6] * _arg_2);
                    mRawData[_local_6] = _local_7;
                    _local_5++;
                };
            };
        }

        public function getBounds(_arg_1:Matrix=null, _arg_2:int=0, _arg_3:int=-1, _arg_4:Rectangle=null):Rectangle
        {
            var _local_9:Number;
            var _local_12:Number;
            var _local_7:int;
            var _local_8:Number;
            var _local_11:int;
            var _local_10:Number;
            if (_arg_4 == null)
            {
                _arg_4 = new Rectangle();
            };
            if (((_arg_3 < 0) || ((_arg_2 + _arg_3) > mNumVertices)))
            {
                _arg_3 = (mNumVertices - _arg_2);
            };
            if (_arg_3 == 0)
            {
                if (_arg_1 == null)
                {
                    _arg_4.setEmpty();
                }
                else
                {
                    MatrixUtil.transformCoords(_arg_1, 0, 0, sHelperPoint);
                    _arg_4.setTo(sHelperPoint.x, sHelperPoint.y, 0, 0);
                };
            }
            else
            {
                _local_9 = 1.79769313486232E308;
                var _local_6:* = -1.79769313486232E308;
                _local_12 = 1.79769313486232E308;
                var _local_5:* = -1.79769313486232E308;
                _local_7 = ((_arg_2 * 8) + 0);
                if (_arg_1 == null)
                {
                    _local_11 = 0;
                    while (_local_11 < _arg_3)
                    {
                        _local_10 = mRawData[_local_7];
                        _local_8 = mRawData[(_local_7 + 1)];
                        _local_7 = (_local_7 + 8);
                        if (_local_9 > _local_10)
                        {
                            _local_9 = _local_10;
                        };
                        if (_local_6 < _local_10)
                        {
                            _local_6 = _local_10;
                        };
                        if (_local_12 > _local_8)
                        {
                            _local_12 = _local_8;
                        };
                        if (_local_5 < _local_8)
                        {
                            _local_5 = _local_8;
                        };
                        _local_11++;
                    };
                }
                else
                {
                    _local_11 = 0;
                    while (_local_11 < _arg_3)
                    {
                        _local_10 = mRawData[_local_7];
                        _local_8 = mRawData[(_local_7 + 1)];
                        _local_7 = (_local_7 + 8);
                        MatrixUtil.transformCoords(_arg_1, _local_10, _local_8, sHelperPoint);
                        if (_local_9 > sHelperPoint.x)
                        {
                            _local_9 = sHelperPoint.x;
                        };
                        if (_local_6 < sHelperPoint.x)
                        {
                            _local_6 = sHelperPoint.x;
                        };
                        if (_local_12 > sHelperPoint.y)
                        {
                            _local_12 = sHelperPoint.y;
                        };
                        if (_local_5 < sHelperPoint.y)
                        {
                            _local_5 = sHelperPoint.y;
                        };
                        _local_11++;
                    };
                };
                _arg_4.setTo(_local_9, _local_12, (_local_6 - _local_9), (_local_5 - _local_12));
            };
            return (_arg_4);
        }

        public function getBoundsProjected(_arg_1:Matrix3D, _arg_2:Vector3D, _arg_3:int=0, _arg_4:int=-1, _arg_5:Rectangle=null):Rectangle
        {
            var _local_8:Number;
            var _local_9:Number;
            var _local_11:int;
            var _local_12:Number;
            var _local_10:int;
            var _local_13:Number;
            if (_arg_2 == null)
            {
                throw (new ArgumentError("camPos must not be null"));
            };
            if (_arg_5 == null)
            {
                _arg_5 = new Rectangle();
            };
            if (((_arg_4 < 0) || ((_arg_3 + _arg_4) > mNumVertices)))
            {
                _arg_4 = (mNumVertices - _arg_3);
            };
            if (_arg_4 == 0)
            {
                if (_arg_1)
                {
                    MatrixUtil.transformCoords3D(_arg_1, 0, 0, 0, sHelperPoint3D);
                }
                else
                {
                    sHelperPoint3D.setTo(0, 0, 0);
                };
                MathUtil.intersectLineWithXYPlane(_arg_2, sHelperPoint3D, sHelperPoint);
                _arg_5.setTo(sHelperPoint.x, sHelperPoint.y, 0, 0);
            }
            else
            {
                _local_8 = 1.79769313486232E308;
                var _local_7:* = -1.79769313486232E308;
                _local_9 = 1.79769313486232E308;
                var _local_6:* = -1.79769313486232E308;
                _local_11 = ((_arg_3 * 8) + 0);
                _local_10 = 0;
                while (_local_10 < _arg_4)
                {
                    _local_13 = mRawData[_local_11];
                    _local_12 = mRawData[(_local_11 + 1)];
                    _local_11 = (_local_11 + 8);
                    if (_arg_1)
                    {
                        MatrixUtil.transformCoords3D(_arg_1, _local_13, _local_12, 0, sHelperPoint3D);
                    }
                    else
                    {
                        sHelperPoint3D.setTo(_local_13, _local_12, 0);
                    };
                    MathUtil.intersectLineWithXYPlane(_arg_2, sHelperPoint3D, sHelperPoint);
                    if (_local_8 > sHelperPoint.x)
                    {
                        _local_8 = sHelperPoint.x;
                    };
                    if (_local_7 < sHelperPoint.x)
                    {
                        _local_7 = sHelperPoint.x;
                    };
                    if (_local_9 > sHelperPoint.y)
                    {
                        _local_9 = sHelperPoint.y;
                    };
                    if (_local_6 < sHelperPoint.y)
                    {
                        _local_6 = sHelperPoint.y;
                    };
                    _local_10++;
                };
                _arg_5.setTo(_local_8, _local_9, (_local_7 - _local_8), (_local_6 - _local_9));
            };
            return (_arg_5);
        }

        public function toString():String
        {
            var _local_4:int;
            var _local_2:String = "[VertexData \n";
            var _local_1:Point = new Point();
            var _local_3:Point = new Point();
            _local_4 = 0;
            while (_local_4 < numVertices)
            {
                getPosition(_local_4, _local_1);
                getTexCoords(_local_4, _local_3);
                _local_2 = (_local_2 + ((((((((((((((((((((("  [Vertex " + _local_4) + ": ") + "x=") + _local_1.x.toFixed(1)) + ", ") + "y=") + _local_1.y.toFixed(1)) + ", ") + "rgb=") + getColor(_local_4).toString(16)) + ", ") + "a=") + getAlpha(_local_4).toFixed(2)) + ", ") + "u=") + _local_3.x.toFixed(4)) + ", ") + "v=") + _local_3.y.toFixed(4)) + "]") + ((_local_4 == (numVertices - 1)) ? "\n" : ",\n")));
                _local_4++;
            };
            return (_local_2 + "]");
        }

        public function get tinted():Boolean
        {
            var _local_3:int;
            var _local_1:int;
            var _local_2:int = 2;
            _local_3 = 0;
            while (_local_3 < mNumVertices)
            {
                _local_1 = 0;
                while (_local_1 < 4)
                {
                    if (mRawData[(_local_2 + _local_1)] != 1)
                    {
                        return (true);
                    };
                    _local_1++;
                };
                _local_2 = (_local_2 + 8);
                _local_3++;
            };
            return (false);
        }

        public function setPremultipliedAlpha(_arg_1:Boolean, _arg_2:Boolean=true):void
        {
            var _local_6:int;
            var _local_7:int;
            var _local_3:Number;
            var _local_4:Number;
            var _local_5:Number;
            if (_arg_1 == mPremultipliedAlpha)
            {
                return;
            };
            if (_arg_2)
            {
                _local_6 = (mNumVertices * 8);
                _local_7 = 2;
                while (_local_7 < _local_6)
                {
                    _local_3 = mRawData[(_local_7 + 3)];
                    _local_4 = ((mPremultipliedAlpha) ? _local_3 : 1);
                    _local_5 = ((_arg_1) ? _local_3 : 1);
                    if (_local_4 != 0)
                    {
                        mRawData[_local_7] = ((mRawData[_local_7] / _local_4) * _local_5);
                        mRawData[(_local_7 + 1)] = ((mRawData[(_local_7 + 1)] / _local_4) * _local_5);
                        mRawData[(_local_7 + 2)] = ((mRawData[(_local_7 + 2)] / _local_4) * _local_5);
                    };
                    _local_7 = (_local_7 + 8);
                };
            };
            mPremultipliedAlpha = _arg_1;
        }

        public function get premultipliedAlpha():Boolean
        {
            return (mPremultipliedAlpha);
        }

        public function set premultipliedAlpha(_arg_1:Boolean):void
        {
            setPremultipliedAlpha(_arg_1);
        }

        public function get numVertices():int
        {
            return (mNumVertices);
        }

        public function set numVertices(_arg_1:int):void
        {
            var _local_4:int;
            mRawData.fixed = false;
            mRawData.length = (_arg_1 * 8);
            var _local_2:int = (((mNumVertices * 8) + 2) + 3);
            var _local_3:int = mRawData.length;
            _local_4 = _local_2;
            while (_local_4 < _local_3)
            {
                mRawData[_local_4] = 1;
                _local_4 = (_local_4 + 8);
            };
            mNumVertices = _arg_1;
            mRawData.fixed = true;
        }

        public function get rawData():Vector.<Number>
        {
            return (mRawData);
        }


    }
}//package starling.utils

