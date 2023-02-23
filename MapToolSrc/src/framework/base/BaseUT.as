// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.base.BaseUT

package framework.base
{
    import flash.utils.getQualifiedClassName;
    import flash.utils.getDefinitionByName;
    import fairygui.GRoot;
    import flash.geom.Point;
    import fairygui.GComponent;
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;

    public class BaseUT 
    {

        public static var scaleMode:ScaleMode;


        public static function createClassByName(_arg_1:Class):*
        {
            var _local_2:String = getQualifiedClassName(_arg_1);
            var _local_3:* = getDefinitionByName(_local_2);
            return (new (_local_3)());
        }

        public static function getClassNameByObj(_arg_1:*):String
        {
            var _local_2:String = getQualifiedClassName(_arg_1);
            return (_local_2.split("::")[1]);
        }

        public static function setFitSize(_arg_1:GComponent):Point
        {
            var _local_2:Number = ((GRoot.inst.height < scaleMode.designHeight_max) ? GRoot.inst.height : scaleMode.designHeight_max);
            _arg_1.setSize(scaleMode.designWidth, _local_2);
            return (new Point(scaleMode.designWidth, _local_2));
        }

        public static function getDictionaryCount(_arg_1:Dictionary):int
        {
            var _local_2:int;
            for (var _local_3:Object in _arg_1)
            {
                _local_2++;
            };
            return (_local_2);
        }

        public static function angle_to_vector(_arg_1:Number):Point
        {
            var _local_5:Number = angle_to_radian(_arg_1);
            var _local_2:Number = Math.cos(_local_5);
            var _local_3:Number = Math.sin(_local_5);
            var _local_4:Point = normalize(new Point(_local_2, _local_3));
            return (_local_4);
        }

        public static function angle_to_radian(_arg_1:Number):Number
        {
            return ((3.14159265358979 / 180) * _arg_1);
        }

        public static function radian_to_angle(_arg_1:Number):Number
        {
            return ((180 / 3.14159265358979) * _arg_1);
        }

        public static function normalize(_arg_1:Point):Point
        {
            var _local_4:Number = _arg_1.x;
            var _local_3:Number = _arg_1.y;
            var _local_2:Number = ((_local_4 * _local_4) + (_local_3 * _local_3));
            if (_local_2 > 0)
            {
                _local_2 = (1 / Math.sqrt(_local_2));
                _local_4 = (_local_4 * _local_2);
                _local_3 = (_local_3 * _local_2);
            };
            return (new Point(_local_4, _local_3));
        }

        public static function checkIsPngOrJpg(_arg_1:String):Boolean
        {
            return ((_arg_1.indexOf(".png") > -1) || (_arg_1.indexOf(".jpg") > -1));
        }

        public static function clone(_arg_1:*):Object
        {
            if (!_arg_1)
            {
                return (null);
            };
            var _local_2:ByteArray = new ByteArray();
            _local_2.writeObject(_arg_1);
            _local_2.position = 0;
            return (_local_2.readObject());
        }

        public static function distance(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):Number
        {
            var _local_5:Number = (_arg_1 - _arg_3);
            var _local_6:Number = (_arg_2 - _arg_4);
            return (Math.sqrt(((_local_5 * _local_5) + (_local_6 * _local_6))));
        }


    }
}//package framework.base

