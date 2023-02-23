// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.TintPlugin

package com.greensock.plugins
{
    import flash.geom.Transform;
    import flash.display.DisplayObject;
    import flash.geom.ColorTransform;
    import com.greensock.TweenLite;
    import com.greensock.core.PropTween;
    import flash.display.*;
    import com.greensock.*;
    import com.greensock.core.*;

    public class TintPlugin extends TweenPlugin 
    {

        public static const API:Number = 2;

        protected static var _props:Array = ["redMultiplier", "greenMultiplier", "blueMultiplier", "alphaMultiplier", "redOffset", "greenOffset", "blueOffset", "alphaOffset"];

        protected var _transform:Transform;

        public function TintPlugin()
        {
            super("tint,colorTransform,removeTint");
        }

        override public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            if (!(_arg_1 is DisplayObject))
            {
                return (false);
            };
            var _local_5:ColorTransform = new ColorTransform();
            if (((!(_arg_2 == null)) && (!(_arg_3.vars.removeTint == true))))
            {
                _local_5.color = _arg_2;
            };
            _transform = DisplayObject(_arg_1).transform;
            var _local_4:ColorTransform = _transform.colorTransform;
            _local_5.alphaMultiplier = _local_4.alphaMultiplier;
            _local_5.alphaOffset = _local_4.alphaOffset;
            _init(_local_4, _local_5);
            return (true);
        }

        public function _init(_arg_1:ColorTransform, _arg_2:ColorTransform):void
        {
            var _local_3:* = null;
            var _local_4:int = _props.length;
            while (--_local_4 > -1)
            {
                _local_3 = _props[_local_4];
                if (_arg_1[_local_3] != _arg_2[_local_3])
                {
                    _addTween(_arg_1, _local_3, _arg_1[_local_3], _arg_2[_local_3], "tint");
                };
            };
        }

        override public function setRatio(_arg_1:Number):void
        {
            var _local_2:ColorTransform = _transform.colorTransform;
            var _local_3:PropTween = _firstPT;
            while (_local_3)
            {
                _local_2[_local_3.p] = ((_local_3.c * _arg_1) + _local_3.s);
                _local_3 = _local_3._next;
            };
            _transform.colorTransform = _local_2;
        }


    }
}//package com.greensock.plugins

