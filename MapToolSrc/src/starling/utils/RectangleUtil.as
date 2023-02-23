// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.RectangleUtil

package starling.utils
{
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import starling.errors.AbstractClassError;
    import flash.geom.Rectangle;
    import flash.geom.Matrix;

    public class RectangleUtil 
    {

        private static const sHelperPoint:Point = new Point();
        private static const sPositions:Vector.<Point> = new <Point>[new Point(0, 0), new Point(1, 0), new Point(0, 1), new Point(1, 1)];

        public function RectangleUtil()
        {
            throw (new AbstractClassError());
        }

        public static function intersect(_arg_1:Rectangle, _arg_2:Rectangle, _arg_3:Rectangle=null):Rectangle
        {
            if (_arg_3 == null)
            {
                _arg_3 = new Rectangle();
            };
            var _local_5:Number = ((_arg_1.x > _arg_2.x) ? _arg_1.x : _arg_2.x);
            var _local_6:Number = ((_arg_1.right < _arg_2.right) ? _arg_1.right : _arg_2.right);
            var _local_7:Number = ((_arg_1.y > _arg_2.y) ? _arg_1.y : _arg_2.y);
            var _local_4:Number = ((_arg_1.bottom < _arg_2.bottom) ? _arg_1.bottom : _arg_2.bottom);
            if (((_local_5 > _local_6) || (_local_7 > _local_4)))
            {
                _arg_3.setEmpty();
            }
            else
            {
                _arg_3.setTo(_local_5, _local_7, (_local_6 - _local_5), (_local_4 - _local_7));
            };
            return (_arg_3);
        }

        public static function fit(_arg_1:Rectangle, _arg_2:Rectangle, _arg_3:String="showAll", _arg_4:Boolean=false, _arg_5:Rectangle=null):Rectangle
        {
            if (!ScaleMode.isValid(_arg_3))
            {
                throw (new ArgumentError(("Invalid scaleMode: " + _arg_3)));
            };
            if (_arg_5 == null)
            {
                _arg_5 = new Rectangle();
            };
            var _local_9:Number = _arg_1.width;
            var _local_6:Number = _arg_1.height;
            var _local_7:Number = (_arg_2.width / _local_9);
            var _local_8:Number = (_arg_2.height / _local_6);
            var _local_10:* = 1;
            if (_arg_3 == "showAll")
            {
                _local_10 = ((_local_7 < _local_8) ? _local_7 : _local_8);
                if (_arg_4)
                {
                    _local_10 = nextSuitableScaleFactor(_local_10, false);
                };
            }
            else
            {
                if (_arg_3 == "noBorder")
                {
                    _local_10 = ((_local_7 > _local_8) ? _local_7 : _local_8);
                    if (_arg_4)
                    {
                        _local_10 = nextSuitableScaleFactor(_local_10, true);
                    };
                };
            };
            _local_9 = (_local_9 * _local_10);
            _local_6 = (_local_6 * _local_10);
            _arg_5.setTo((_arg_2.x + ((_arg_2.width - _local_9) / 2)), (_arg_2.y + ((_arg_2.height - _local_6) / 2)), _local_9, _local_6);
            return (_arg_5);
        }

        private static function nextSuitableScaleFactor(_arg_1:Number, _arg_2:Boolean):Number
        {
            var _local_3:* = 1;
            if (_arg_2)
            {
                if (_arg_1 >= 0.5)
                {
                    return (Math.ceil(_arg_1));
                };
                while ((1 / (_local_3 + 1)) > _arg_1)
                {
                    _local_3++;
                };
            }
            else
            {
                if (_arg_1 >= 1)
                {
                    return (Math.floor(_arg_1));
                };
                while ((1 / _local_3) > _arg_1)
                {
                    _local_3++;
                };
            };
            return (1 / _local_3);
        }

        public static function normalize(_arg_1:Rectangle):void
        {
            if (_arg_1.width < 0)
            {
                _arg_1.width = -(_arg_1.width);
                _arg_1.x = (_arg_1.x - _arg_1.width);
            };
            if (_arg_1.height < 0)
            {
                _arg_1.height = -(_arg_1.height);
                _arg_1.y = (_arg_1.y - _arg_1.height);
            };
        }

        public static function getBounds(_arg_1:Rectangle, _arg_2:Matrix, _arg_3:Rectangle=null):Rectangle
        {
            var _local_7:int;
            if (_arg_3 == null)
            {
                _arg_3 = new Rectangle();
            };
            var _local_6:* = 1.79769313486232E308;
            var _local_5:* = -1.79769313486232E308;
            var _local_8:* = 1.79769313486232E308;
            var _local_4:* = -1.79769313486232E308;
            _local_7 = 0;
            while (_local_7 < 4)
            {
                MatrixUtil.transformCoords(_arg_2, (sPositions[_local_7].x * _arg_1.width), (sPositions[_local_7].y * _arg_1.height), sHelperPoint);
                if (_local_6 > sHelperPoint.x)
                {
                    _local_6 = sHelperPoint.x;
                };
                if (_local_5 < sHelperPoint.x)
                {
                    _local_5 = sHelperPoint.x;
                };
                if (_local_8 > sHelperPoint.y)
                {
                    _local_8 = sHelperPoint.y;
                };
                if (_local_4 < sHelperPoint.y)
                {
                    _local_4 = sHelperPoint.y;
                };
                _local_7++;
            };
            _arg_3.setTo(_local_6, _local_8, (_local_5 - _local_6), (_local_4 - _local_8));
            return (_arg_3);
        }


    }
}//package starling.utils

