// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.AnimData

package com.core.loader
{
    import com.core.base.IAnimData;
    import __AS3__.vec.Vector;
    import com.core.base.FrameData;
    import core.utils.DbgUtil;

    public class AnimData implements IAnimData 
    {

        private var _url:String;
        protected var _frameRate:int;
        protected var _origX:int;
        protected var _origY:int;
        protected var _blendMode:String = "normal";
        protected var _hasOrigin:Boolean = false;
        protected var _frameDatas:Vector.<FrameData>;
        private var _refCount:int;


        public function init(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:String, _arg_5:Boolean, _arg_6:Vector.<FrameData>):void
        {
            _frameRate = _arg_1;
            _origX = _arg_2;
            _origY = _arg_3;
            _blendMode = _arg_4;
            _hasOrigin = _arg_5;
            _frameDatas = _arg_6;
        }

        public function get frameRate():int
        {
            return (_frameRate);
        }

        public function get origX():int
        {
            return (_origX);
        }

        public function get origY():int
        {
            return (_origY);
        }

        public function get blendMode():String
        {
            return (_blendMode);
        }

        public function get hasOrigin():Boolean
        {
            return (_hasOrigin);
        }

        public function get frameDatas():Vector.<FrameData>
        {
            return (_frameDatas);
        }

        public function addRef():void
        {
            _refCount++;
        }

        public function decRef():void
        {
            _refCount--;
            DbgUtil.assert(((_refCount >= 0) || ("解引用异常")));
        }

        protected function refHandler():void
        {
            var _local_1:* = null;
            while (((_frameDatas) && (_frameDatas.length)))
            {
                _local_1 = _frameDatas.pop();
                _local_1.dispose();
            };
            LoaderMgr.getInstance().removeResource(_url);
            _frameDatas = null;
        }

        public function getRefCount():int
        {
            return (_refCount);
        }

        public function dispose():void
        {
            var _local_1:int;
            if (_frameDatas)
            {
                _local_1 = _frameDatas.length;
                while (--_local_1 > -1)
                {
                    _frameDatas[_local_1].dispose();
                };
                _frameDatas.length = 0;
            };
            _frameDatas = null;
        }

        public function get url():String
        {
            return (this._url);
        }

        public function set url(_arg_1:String):void
        {
            _url = _arg_1;
        }


    }
}//package com.core.loader

