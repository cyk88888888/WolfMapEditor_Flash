// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.display.BlendMode

package starling.display
{
    import starling.errors.AbstractClassError;

    public class BlendMode 
    {

        public static const AUTO:String = "auto";
        public static const NONE:String = "none";
        public static const NORMAL:String = "normal";
        public static const ADD:String = "add";
        public static const MULTIPLY:String = "multiply";
        public static const SCREEN:String = "screen";
        public static const ERASE:String = "erase";
        public static const MASK:String = "mask";
        public static const BELOW:String = "below";

        private static var sBlendFactors:Array = [{
            "none":["one", "zero"],
            "normal":["sourceAlpha", "oneMinusSourceAlpha"],
            "add":["sourceAlpha", "destinationAlpha"],
            "multiply":["destinationColor", "oneMinusSourceAlpha"],
            "screen":["sourceAlpha", "one"],
            "erase":["zero", "oneMinusSourceAlpha"],
            "mask":["zero", "sourceAlpha"],
            "below":["oneMinusDestinationAlpha", "destinationAlpha"]
        }, {
            "none":["one", "zero"],
            "normal":["one", "oneMinusSourceAlpha"],
            "add":["one", "one"],
            "multiply":["destinationColor", "oneMinusSourceAlpha"],
            "screen":["one", "oneMinusSourceColor"],
            "erase":["zero", "oneMinusSourceAlpha"],
            "mask":["zero", "sourceAlpha"],
            "below":["oneMinusDestinationAlpha", "destinationAlpha"]
        }];

        public function BlendMode()
        {
            throw (new AbstractClassError());
        }

        public static function getBlendFactors(_arg_1:String, _arg_2:Boolean=true):Array
        {
            var _local_3:Object = sBlendFactors[((_arg_2) ? 1 : 0)];
            if ((_arg_1 in _local_3))
            {
                return (_local_3[_arg_1]);
            };
            throw (new ArgumentError("Invalid blend mode"));
        }

        public static function register(_arg_1:String, _arg_2:String, _arg_3:String, _arg_4:Boolean=true):void
        {
            var _local_6:Object = sBlendFactors[int(_arg_4)];
            _local_6[_arg_1] = [_arg_2, _arg_3];
            var _local_5:Object = sBlendFactors[(!(_arg_4))];
            if (!(_arg_1 in _local_5))
            {
                _local_5[_arg_1] = [_arg_2, _arg_3];
            };
        }


    }
}//package starling.display

