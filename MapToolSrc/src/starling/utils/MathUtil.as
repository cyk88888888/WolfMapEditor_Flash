// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.MathUtil

package starling.utils
{
    import starling.errors.AbstractClassError;
    import flash.geom.Point;
    import flash.geom.Vector3D;

    public class MathUtil 
    {

        private static const TWO_PI:Number = 6.28318530717959;

        public function MathUtil()
        {
            throw (new AbstractClassError());
        }

        public static function intersectLineWithXYPlane(_arg_1:Vector3D, _arg_2:Vector3D, _arg_3:Point=null):Point
        {
            if (_arg_3 == null)
            {
                _arg_3 = new Point();
            };
            var _local_7:Number = (_arg_2.x - _arg_1.x);
            var _local_6:Number = (_arg_2.y - _arg_1.y);
            var _local_5:Number = (_arg_2.z - _arg_1.z);
            var _local_4:Number = (-(_arg_1.z) / _local_5);
            _arg_3.x = (_arg_1.x + (_local_4 * _local_7));
            _arg_3.y = (_arg_1.y + (_local_4 * _local_6));
            return (_arg_3);
        }

        public static function normalizeAngle(_arg_1:Number):Number
        {
            _arg_1 = (_arg_1 % 6.28318530717959);
            if (_arg_1 < -(3.14159265358979))
            {
                _arg_1 = (_arg_1 + 6.28318530717959);
            };
            if (_arg_1 > 3.14159265358979)
            {
                _arg_1 = (_arg_1 - 6.28318530717959);
            };
            return (_arg_1);
        }

        public static function clamp(_arg_1:Number, _arg_2:Number, _arg_3:Number):Number
        {
            return ((_arg_1 < _arg_2) ? _arg_2 : ((_arg_1 > _arg_3) ? _arg_3 : _arg_1));
        }


    }
}//package starling.utils

