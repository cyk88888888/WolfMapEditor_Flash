// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.MatrixUtil

package starling.utils
{
    import __AS3__.vec.Vector;
    import starling.errors.AbstractClassError;
    import flash.geom.Matrix3D;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Vector3D;

    public class MatrixUtil 
    {

        private static var sRawData:Vector.<Number> = new <Number>[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1];
        private static var sRawData2:Vector.<Number> = new Vector.<Number>(16, true);

        public function MatrixUtil()
        {
            throw (new AbstractClassError());
        }

        public static function convertTo3D(_arg_1:Matrix, _arg_2:Matrix3D=null):Matrix3D
        {
            if (_arg_2 == null)
            {
                _arg_2 = new Matrix3D();
            };
            sRawData[0] = _arg_1.a;
            sRawData[1] = _arg_1.b;
            sRawData[4] = _arg_1.c;
            sRawData[5] = _arg_1.d;
            sRawData[12] = _arg_1.tx;
            sRawData[13] = _arg_1.ty;
            _arg_2.copyRawDataFrom(sRawData);
            return (_arg_2);
        }

        public static function convertTo2D(_arg_1:Matrix3D, _arg_2:Matrix=null):Matrix
        {
            if (_arg_2 == null)
            {
                _arg_2 = new Matrix();
            };
            _arg_1.copyRawDataTo(sRawData2);
            _arg_2.a = sRawData2[0];
            _arg_2.b = sRawData2[1];
            _arg_2.c = sRawData2[4];
            _arg_2.d = sRawData2[5];
            _arg_2.tx = sRawData2[12];
            _arg_2.ty = sRawData2[13];
            return (_arg_2);
        }

        public static function transformPoint(_arg_1:Matrix, _arg_2:Point, _arg_3:Point=null):Point
        {
            return (transformCoords(_arg_1, _arg_2.x, _arg_2.y, _arg_3));
        }

        public static function transformPoint3D(_arg_1:Matrix3D, _arg_2:Vector3D, _arg_3:Vector3D=null):Vector3D
        {
            return (transformCoords3D(_arg_1, _arg_2.x, _arg_2.y, _arg_2.z, _arg_3));
        }

        public static function transformCoords(_arg_1:Matrix, _arg_2:Number, _arg_3:Number, _arg_4:Point=null):Point
        {
            if (_arg_4 == null)
            {
                _arg_4 = new Point();
            };
            _arg_4.x = (((_arg_1.a * _arg_2) + (_arg_1.c * _arg_3)) + _arg_1.tx);
            _arg_4.y = (((_arg_1.d * _arg_3) + (_arg_1.b * _arg_2)) + _arg_1.ty);
            return (_arg_4);
        }

        public static function transformCoords3D(_arg_1:Matrix3D, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Vector3D=null):Vector3D
        {
            if (_arg_5 == null)
            {
                _arg_5 = new Vector3D();
            };
            _arg_1.copyRawDataTo(sRawData2);
            _arg_5.x = ((((_arg_2 * sRawData2[0]) + (_arg_3 * sRawData2[4])) + (_arg_4 * sRawData2[8])) + sRawData2[12]);
            _arg_5.y = ((((_arg_2 * sRawData2[1]) + (_arg_3 * sRawData2[5])) + (_arg_4 * sRawData2[9])) + sRawData2[13]);
            _arg_5.z = ((((_arg_2 * sRawData2[2]) + (_arg_3 * sRawData2[6])) + (_arg_4 * sRawData2[10])) + sRawData2[14]);
            _arg_5.w = ((((_arg_2 * sRawData2[3]) + (_arg_3 * sRawData2[7])) + (_arg_4 * sRawData2[11])) + sRawData2[15]);
            return (_arg_5);
        }

        public static function skew(_arg_1:Matrix, _arg_2:Number, _arg_3:Number):void
        {
            var _local_6:Number = Math.sin(_arg_2);
            var _local_5:Number = Math.cos(_arg_2);
            var _local_7:Number = Math.sin(_arg_3);
            var _local_4:Number = Math.cos(_arg_3);
            _arg_1.setTo(((_arg_1.a * _local_4) - (_arg_1.b * _local_6)), ((_arg_1.a * _local_7) + (_arg_1.b * _local_5)), ((_arg_1.c * _local_4) - (_arg_1.d * _local_6)), ((_arg_1.c * _local_7) + (_arg_1.d * _local_5)), ((_arg_1.tx * _local_4) - (_arg_1.ty * _local_6)), ((_arg_1.tx * _local_7) + (_arg_1.ty * _local_5)));
        }

        public static function prependMatrix(_arg_1:Matrix, _arg_2:Matrix):void
        {
            _arg_1.setTo(((_arg_1.a * _arg_2.a) + (_arg_1.c * _arg_2.b)), ((_arg_1.b * _arg_2.a) + (_arg_1.d * _arg_2.b)), ((_arg_1.a * _arg_2.c) + (_arg_1.c * _arg_2.d)), ((_arg_1.b * _arg_2.c) + (_arg_1.d * _arg_2.d)), ((_arg_1.tx + (_arg_1.a * _arg_2.tx)) + (_arg_1.c * _arg_2.ty)), ((_arg_1.ty + (_arg_1.b * _arg_2.tx)) + (_arg_1.d * _arg_2.ty)));
        }

        public static function prependTranslation(_arg_1:Matrix, _arg_2:Number, _arg_3:Number):void
        {
            _arg_1.tx = (_arg_1.tx + ((_arg_1.a * _arg_2) + (_arg_1.c * _arg_3)));
            _arg_1.ty = (_arg_1.ty + ((_arg_1.b * _arg_2) + (_arg_1.d * _arg_3)));
        }

        public static function prependScale(_arg_1:Matrix, _arg_2:Number, _arg_3:Number):void
        {
            _arg_1.setTo((_arg_1.a * _arg_2), (_arg_1.b * _arg_2), (_arg_1.c * _arg_3), (_arg_1.d * _arg_3), _arg_1.tx, _arg_1.ty);
        }

        public static function prependRotation(_arg_1:Matrix, _arg_2:Number):void
        {
            var _local_4:Number = Math.sin(_arg_2);
            var _local_3:Number = Math.cos(_arg_2);
            _arg_1.setTo(((_arg_1.a * _local_3) + (_arg_1.c * _local_4)), ((_arg_1.b * _local_3) + (_arg_1.d * _local_4)), ((_arg_1.c * _local_3) - (_arg_1.a * _local_4)), ((_arg_1.d * _local_3) - (_arg_1.b * _local_4)), _arg_1.tx, _arg_1.ty);
        }

        public static function prependSkew(_arg_1:Matrix, _arg_2:Number, _arg_3:Number):void
        {
            var _local_6:Number = Math.sin(_arg_2);
            var _local_5:Number = Math.cos(_arg_2);
            var _local_7:Number = Math.sin(_arg_3);
            var _local_4:Number = Math.cos(_arg_3);
            _arg_1.setTo(((_arg_1.a * _local_4) + (_arg_1.c * _local_7)), ((_arg_1.b * _local_4) + (_arg_1.d * _local_7)), ((_arg_1.c * _local_5) - (_arg_1.a * _local_6)), ((_arg_1.d * _local_5) - (_arg_1.b * _local_6)), _arg_1.tx, _arg_1.ty);
        }


    }
}//package starling.utils

