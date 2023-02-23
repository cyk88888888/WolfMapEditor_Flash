// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.simpvmc.SEvent

package com.simpvmc
{
    import flash.events.Event;

    public class SEvent extends Event 
    {

        private var _type:String;
        private var _target:Object;
        private var _body:Object;

        public function SEvent(_arg_1:String, _arg_2:Boolean=false, _arg_3:Boolean=false)
        {
            super(_arg_1, _arg_2, _arg_3);
            this.type = _arg_1;
        }

        public function clear():void
        {
            this.body = null;
            this.type = null;
            this.target = null;
        }

        override public function get type():String
        {
            return (_type);
        }

        public function set type(_arg_1:String):void
        {
            _type = _arg_1;
        }

        override public function get target():Object
        {
            return (_target);
        }

        public function set target(_arg_1:Object):void
        {
            _target = _arg_1;
        }

        public function get body():*
        {
            return (_body);
        }

        public function set body(_arg_1:*):void
        {
            _body = _arg_1;
        }


    }
}//package com.simpvmc

