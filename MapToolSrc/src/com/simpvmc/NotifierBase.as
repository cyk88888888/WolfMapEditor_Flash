// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.simpvmc.NotifierBase

package com.simpvmc
{
    import com.simpvmc.interfaces.INotifier;

    public class NotifierBase implements INotifier 
    {

        public static var stage4ntfy:SyncEventDispatcher;


        public static function globalNotify(_arg_1:String, _arg_2:Object=null):void
        {
            var _local_3:Notification = Notification.NEW(_arg_1);
            _local_3.body = _arg_2;
            stage4ntfy.dispatchEvent(_local_3);
            Notification.FREE(_local_3);
        }


        public function sendNotification(_arg_1:String, _arg_2:Object=null):*
        {
            var _local_3:Notification = Notification.NEW(_arg_1);
            _local_3.body = _arg_2;
            stage4ntfy.dispatchEvent(_local_3);
            var _local_4:* = _local_3.ret;
            Notification.FREE(_local_3);
            return (_local_4);
        }


    }
}//package com.simpvmc

