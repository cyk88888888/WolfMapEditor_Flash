// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.events.KeyboardEvent

package starling.events
{
    public class KeyboardEvent extends Event 
    {

        public static const KEY_UP:String = "keyUp";
        public static const KEY_DOWN:String = "keyDown";

        private var mCharCode:uint;
        private var mKeyCode:uint;
        private var mKeyLocation:uint;
        private var mAltKey:Boolean;
        private var mCtrlKey:Boolean;
        private var mShiftKey:Boolean;
        private var mIsDefaultPrevented:Boolean;

        public function KeyboardEvent(_arg_1:String, _arg_2:uint=0, _arg_3:uint=0, _arg_4:uint=0, _arg_5:Boolean=false, _arg_6:Boolean=false, _arg_7:Boolean=false)
        {
            super(_arg_1, false, _arg_3);
            mCharCode = _arg_2;
            mKeyCode = _arg_3;
            mKeyLocation = _arg_4;
            mCtrlKey = _arg_5;
            mAltKey = _arg_6;
            mShiftKey = _arg_7;
        }

        public function preventDefault():void
        {
            mIsDefaultPrevented = true;
        }

        public function isDefaultPrevented():Boolean
        {
            return (mIsDefaultPrevented);
        }

        public function get charCode():uint
        {
            return (mCharCode);
        }

        public function get keyCode():uint
        {
            return (mKeyCode);
        }

        public function get keyLocation():uint
        {
            return (mKeyLocation);
        }

        public function get altKey():Boolean
        {
            return (mAltKey);
        }

        public function get ctrlKey():Boolean
        {
            return (mCtrlKey);
        }

        public function get shiftKey():Boolean
        {
            return (mShiftKey);
        }


    }
}//package starling.events

