// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.base.Emiter

package framework.base
{
    import com.simpvmc.NotifierBase;
    import flash.utils.Dictionary;
    import com.simpvmc.Notification;

    public class Emiter extends NotifierBase 
    {

        private var _msgHandler:Dictionary = new Dictionary();


        protected function registerN():void
        {
        }

        public function emit(_arg_1:String, _arg_2:Object=null):void
        {
            NotifierBase.globalNotify(_arg_1, _arg_2);
        }

        public function onEmitter(_arg_1:String, _arg_2:Function):void
        {
            if (!_msgHandler[_arg_1])
            {
                _msgHandler[_arg_1] = [];
            };
            _msgHandler[_arg_1].push(_arg_2);
            stage4ntfy.addEventListener(_arg_1, onMvCMessage);
        }

        public function un(_arg_1:String):void
        {
            delete _msgHandler[_arg_1];
            stage4ntfy.removeEventListener(_arg_1, onMvCMessage);
        }

        public function unAll():void
        {
            for (var _local_1:String in _msgHandler)
            {
                delete _msgHandler[_local_1];
                stage4ntfy.removeEventListener(_local_1, onMvCMessage);
            };
        }

        public function onMvCMessage(_arg_1:Notification):void
        {
            var _local_3:int;
            var _local_2:Array = _msgHandler[_arg_1.name];
            if (_local_2 != null)
            {
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    (_local_2[_local_3](_arg_1));
                    _local_3++;
                };
            };
        }


    }
}//package framework.base

