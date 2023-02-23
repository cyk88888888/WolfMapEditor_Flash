// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.FrameLabelPlugin

package com.greensock.plugins
{
    import flash.display.MovieClip;
    import com.greensock.TweenLite;

    public class FrameLabelPlugin extends FramePlugin 
    {

        public static const API:Number = 2;

        public function FrameLabelPlugin()
        {
            _propName = "frameLabel";
        }

        override public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            if (((!(_arg_3.target)) is MovieClip))
            {
                return (false);
            };
            _target = (_arg_1 as MovieClip);
            this.frame = _target.currentFrame;
            var _local_7:Array = _target.currentLabels;
            var _local_6:String = _arg_2;
            var _local_5:int = _target.currentFrame;
            var _local_4:int = _local_7.length;
            while (--_local_4 > -1)
            {
                if (_local_7[_local_4].name == _local_6)
                {
                    _local_5 = _local_7[_local_4].frame;
                    break;
                };
            };
            if (this.frame != _local_5)
            {
                _addTween(this, "frame", this.frame, _local_5, "frame", true);
            };
            return (true);
        }


    }
}//package com.greensock.plugins

