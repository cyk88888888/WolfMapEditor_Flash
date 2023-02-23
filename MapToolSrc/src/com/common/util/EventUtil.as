// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.common.util.EventUtil

package com.common.util
{
    import flash.events.Event;

    public class EventUtil 
    {


        public static function swallowEvent(_arg_1:Event):void
        {
            stopPropagation(_arg_1);
            stopImmediatePropagation(_arg_1);
        }

        public static function stopPropagation(_arg_1:Event):void
        {
            _arg_1.stopPropagation();
        }

        public static function stopImmediatePropagation(_arg_1:Event):void
        {
            _arg_1.stopImmediatePropagation();
        }


    }
}//package com.common.util

