﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.AutoAlphaPlugin

package com.greensock.plugins
{
    import com.greensock.TweenLite;

    public class AutoAlphaPlugin extends TweenPlugin 
    {

        public static const API:Number = 2;

        protected var _target:Object;
        protected var _ignoreVisible:Boolean;

        public function AutoAlphaPlugin()
        {
            super("autoAlpha,alpha,visible");
        }

        override public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            _target = _arg_1;
            _addTween(_arg_1, "alpha", _arg_1.alpha, _arg_2, "alpha");
            return (true);
        }

        override public function _kill(_arg_1:Object):Boolean
        {
            _ignoreVisible = ("visible" in _arg_1);
            return (super._kill(_arg_1));
        }

        override public function setRatio(_arg_1:Number):void
        {
            super.setRatio(_arg_1);
            if (!_ignoreVisible)
            {
                _target.visible = (!(_target.alpha == 0));
            };
        }


    }
}//package com.greensock.plugins

