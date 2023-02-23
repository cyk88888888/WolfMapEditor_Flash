// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.ColorTransformPlugin

package com.greensock.plugins
{
    import flash.geom.ColorTransform;
    import flash.display.DisplayObject;
    import com.greensock.TweenLite;

    public class ColorTransformPlugin extends TintPlugin 
    {

        public static const API:Number = 2;

        public function ColorTransformPlugin()
        {
            _propName = "colorTransform";
        }

        override public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            var _local_5:* = null;
            var _local_7:Number;
            var _local_6:ColorTransform = new ColorTransform();
            if ((_arg_1 is DisplayObject))
            {
                _transform = DisplayObject(_arg_1).transform;
                _local_5 = _transform.colorTransform;
            }
            else
            {
                if ((_arg_1 is ColorTransform))
                {
                    _local_5 = (_arg_1 as ColorTransform);
                }
                else
                {
                    return (false);
                };
            };
            if ((_arg_2 is ColorTransform))
            {
                _local_6.concat(_arg_2);
            }
            else
            {
                _local_6.concat(_local_5);
            };
            for (var _local_4:String in _arg_2)
            {
                if (((_local_4 == "tint") || (_local_4 == "color")))
                {
                    if (_arg_2[_local_4] != null)
                    {
                        _local_6.color = _arg_2[_local_4];
                    };
                }
                else
                {
                    if (!(((_local_4 == "tintAmount") || (_local_4 == "exposure")) || (_local_4 == "brightness")))
                    {
                        _local_6[_local_4] = _arg_2[_local_4];
                    };
                };
            };
            if (!(_arg_2 is ColorTransform))
            {
                if (!isNaN(_arg_2.tintAmount))
                {
                    _local_7 = (_arg_2.tintAmount / (1 - (((_local_6.redMultiplier + _local_6.greenMultiplier) + _local_6.blueMultiplier) / 3)));
                    _local_6.redOffset = (_local_6.redOffset * _local_7);
                    _local_6.greenOffset = (_local_6.greenOffset * _local_7);
                    _local_6.blueOffset = (_local_6.blueOffset * _local_7);
                    var _local_9:* = (1 - _arg_2.tintAmount);
                    _local_6.blueMultiplier = _local_9;
                    var _local_8:* = _local_9;
                    _local_6.greenMultiplier = _local_8;
                    _local_6.redMultiplier = _local_8;
                }
                else
                {
                    if (!isNaN(_arg_2.exposure))
                    {
                        _local_9 = (0xFF * (_arg_2.exposure - 1));
                        _local_6.blueOffset = _local_9;
                        _local_8 = _local_9;
                        _local_6.greenOffset = _local_8;
                        _local_6.redOffset = _local_8;
                        _local_9 = 1;
                        _local_6.blueMultiplier = _local_9;
                        _local_8 = _local_9;
                        _local_6.greenMultiplier = _local_8;
                        _local_6.redMultiplier = _local_8;
                    }
                    else
                    {
                        if (!isNaN(_arg_2.brightness))
                        {
                            _local_9 = Math.max(0, ((_arg_2.brightness - 1) * 0xFF));
                            _local_6.blueOffset = _local_9;
                            _local_8 = _local_9;
                            _local_6.greenOffset = _local_8;
                            _local_6.redOffset = _local_8;
                            _local_9 = (1 - Math.abs((_arg_2.brightness - 1)));
                            _local_6.blueMultiplier = _local_9;
                            _local_8 = _local_9;
                            _local_6.greenMultiplier = _local_8;
                            _local_6.redMultiplier = _local_8;
                        };
                    };
                };
            };
            _init(_local_5, _local_6);
            return (true);
        }


    }
}//package com.greensock.plugins

