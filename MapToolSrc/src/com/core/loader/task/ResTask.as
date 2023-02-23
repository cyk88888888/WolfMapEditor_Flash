// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.task.ResTask

package com.core.loader.task
{
    import com.game.manager.timediv.ITask;
    import flash.utils.ByteArray;
    import core.utils.DbgUtil;

    public class ResTask implements ITask 
    {

        public static const START:uint = 0;
        public static const LOAD:uint = 1;
        public static const LOADING:uint = 2;
        public static const PARSE:uint = 3;
        public static const COMPLETE:uint = 4;

        protected var _bytes:ByteArray;
        protected var _url:String;
        protected var _onComplete:Function;
        protected var _content:*;
        protected var _state:uint;


        public function init(_arg_1:ByteArray, _arg_2:String, _arg_3:Function):void
        {
            DbgUtil.assert((((!(_arg_1 == null)) && (!(_arg_1.length == 0))) || ("bytes should not be 0")));
            _bytes = _arg_1;
            _url = _arg_2;
            _onComplete = _arg_3;
            _content = null;
            _state = 0;
        }

        public function removeCallBack():void
        {
            _onComplete = null;
        }

        public function step():Boolean
        {
            return (false);
        }

        public function complete():void
        {
            if (_onComplete != null)
            {
                (_onComplete(_url, _content));
            };
            dispose();
        }

        protected function clearBytes():void
        {
            ((_bytes) && (_bytes.clear())); //not popped
        }

        public function dispose():void
        {
            clearBytes();
            _bytes = null;
            _url = null;
            _onComplete = null;
            _content = null;
        }


    }
}//package com.core.loader.task

