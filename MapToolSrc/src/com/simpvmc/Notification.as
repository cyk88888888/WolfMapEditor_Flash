// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.simpvmc.Notification

package com.simpvmc
{
    import com.simpvmc.interfaces.INotification;
    import core.utils.ObjectPoolList;

    public class Notification extends SEvent implements INotification 
    {

        public static var ObjectPool:ObjectPoolList;

        private var _ret:*;

        public function Notification(_arg_1:String="")
        {
            super(_arg_1, false, false);
        }

        public static function NEW(_arg_1:String):Notification
        {
            if (!ObjectPool)
            {
                ObjectPool = new ObjectPoolList(Notification);
            };
            var _local_2:Notification = (ObjectPool.Alloc(Notification) as Notification);
            _local_2.type = _arg_1;
            return (_local_2);
        }

        public static function FREE(_arg_1:Notification):void
        {
            _arg_1.clear();
            ObjectPool.Release(_arg_1);
        }


        public function get name():String
        {
            return (this.type);
        }

        public function get ret():*
        {
            return (_ret);
        }

        public function set ret(_arg_1:*):void
        {
            _ret = _arg_1;
        }


    }
}//package com.simpvmc

