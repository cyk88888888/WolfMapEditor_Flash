﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.FramePlugin

package com.greensock.plugins
{
    import flash.display.MovieClip;
    import com.greensock.TweenLite;

    public class FramePlugin extends TweenPlugin 
    {

        public static const API:Number = 2;

        public var frame:int;
        protected var _target:MovieClip;

        public function FramePlugin()
        {
            super("frame,frameLabel,frameForward,frameBackward");
        }

        override public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            if (((!(_arg_1 is MovieClip)) || (isNaN(_arg_2))))
            {
                return (false);
            };
            _target = (_arg_1 as MovieClip);
            this.frame = _target.currentFrame;
            _addTween(this, "frame", this.frame, _arg_2, "frame", true);
            return (true);
        }

        override public function setRatio(_arg_1:Number):void
        {
            super.setRatio(_arg_1);
            if (this.frame != _target.currentFrame)
            {
                _target.gotoAndStop(this.frame);
            };
        }


    }
}//package com.greensock.plugins

