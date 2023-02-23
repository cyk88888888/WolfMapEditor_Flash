// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.ShortRotationPlugin

package com.greensock.plugins
{
    import com.greensock.TweenLite;

    public class ShortRotationPlugin extends TweenPlugin 
    {

        public static const API:Number = 2;

        public function ShortRotationPlugin()
        {
            super("shortRotation");
            _overwriteProps.pop();
        }

        override public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            var _local_6:Number;
            if (typeof(_arg_2) == "number")
            {
                return (false);
            };
            var _local_5:* = (_arg_2.useRadians == true);
            for (var _local_4:String in _arg_2)
            {
                if (_local_4 != "useRadians")
                {
                    _local_6 = ((_arg_1[_local_4] is Function) ? _arg_1[(((_local_4.indexOf("set")) || (!(("get" + _local_4.substr(3)) in _arg_1))) ? _local_4 : ("get" + _local_4.substr(3)))]() : _arg_1[_local_4]);
                    _initRotation(_arg_1, _local_4, _local_6, ((typeof(_arg_2[_local_4]) == "number") ? _arg_2[_local_4] : (_local_6 + _arg_2[_local_4].split("=").join(""))), _local_5);
                };
            };
            return (true);
        }

        public function _initRotation(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:Number, _arg_5:Boolean=false):void
        {
            var _local_7:Number;
            _local_7 = ((_arg_5) ? (3.14159265358979 * 2) : 360);
            var _local_6:Number = ((_arg_4 - _arg_3) % _local_7);
            if (_local_6 != (_local_6 % (_local_7 / 2)))
            {
                _local_6 = ((_local_6 < 0) ? (_local_6 + _local_7) : (_local_6 - _local_7));
            };
            _addTween(_arg_1, _arg_2, _arg_3, (_arg_3 + _local_6), _arg_2);
            _overwriteProps[_overwriteProps.length] = _arg_2;
        }


    }
}//package com.greensock.plugins

