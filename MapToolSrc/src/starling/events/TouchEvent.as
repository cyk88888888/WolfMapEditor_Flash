// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.events.TouchEvent

package starling.events
{
    import __AS3__.vec.Vector;
    import starling.display.DisplayObject;

    public class TouchEvent extends Event 
    {

        public static const TOUCH:String = "touch";

        private static var sTouches:Vector.<Touch> = new Vector.<Touch>(0);

        private var mShiftKey:Boolean;
        private var mCtrlKey:Boolean;
        private var mTimestamp:Number;
        private var mVisitedObjects:Vector.<EventDispatcher>;

        public function TouchEvent(_arg_1:String, _arg_2:Vector.<Touch>, _arg_3:Boolean=false, _arg_4:Boolean=false, _arg_5:Boolean=true)
        {
            var _local_7:int;
            super(_arg_1, _arg_5, _arg_2);
            mShiftKey = _arg_3;
            mCtrlKey = _arg_4;
            mTimestamp = -1;
            mVisitedObjects = new Vector.<EventDispatcher>(0);
            var _local_6:int = _arg_2.length;
            _local_7 = 0;
            while (_local_7 < _local_6)
            {
                if (_arg_2[_local_7].timestamp > mTimestamp)
                {
                    mTimestamp = _arg_2[_local_7].timestamp;
                };
                _local_7++;
            };
        }

        public function getTouches(_arg_1:DisplayObject, _arg_2:String=null, _arg_3:Vector.<Touch>=null):Vector.<Touch>
        {
            var _local_9:int;
            var _local_4:* = null;
            var _local_8:Boolean;
            var _local_6:Boolean;
            if (_arg_3 == null)
            {
                _arg_3 = new Vector.<Touch>(0);
            };
            var _local_5:Vector.<Touch> = (data as Vector.<Touch>);
            var _local_7:int = _local_5.length;
            _local_9 = 0;
            while (_local_9 < _local_7)
            {
                _local_4 = _local_5[_local_9];
                _local_8 = _local_4.isTouching(_arg_1);
                _local_6 = ((_arg_2 == null) || (_arg_2 == _local_4.phase));
                if (((_local_8) && (_local_6)))
                {
                    _arg_3[_arg_3.length] = _local_4;
                };
                _local_9++;
            };
            return (_arg_3);
        }

        public function getTouch(_arg_1:DisplayObject, _arg_2:String=null, _arg_3:int=-1):Touch
        {
            var _local_4:* = null;
            var _local_6:int;
            getTouches(_arg_1, _arg_2, sTouches);
            var _local_5:int = sTouches.length;
            if (_local_5 > 0)
            {
                _local_4 = null;
                if (_arg_3 < 0)
                {
                    _local_4 = sTouches[0];
                }
                else
                {
                    _local_6 = 0;
                    while (_local_6 < _local_5)
                    {
                        if (sTouches[_local_6].id == _arg_3)
                        {
                            _local_4 = sTouches[_local_6];
                            break;
                        };
                        _local_6++;
                    };
                };
                sTouches.length = 0;
                return (_local_4);
            };
            return (null);
        }

        public function interactsWith(_arg_1:DisplayObject):Boolean
        {
            var _local_3:int;
            var _local_2:Boolean;
            getTouches(_arg_1, null, sTouches);
            _local_3 = (sTouches.length - 1);
            while (_local_3 >= 0)
            {
                if (sTouches[_local_3].phase != "ended")
                {
                    _local_2 = true;
                    break;
                };
                _local_3--;
            };
            sTouches.length = 0;
            return (_local_2);
        }

        internal function dispatch(_arg_1:Vector.<EventDispatcher>):void
        {
            var _local_3:int;
            var _local_2:* = null;
            var _local_6:int;
            var _local_5:* = null;
            var _local_4:Boolean;
            if (((_arg_1) && (_arg_1.length)))
            {
                _local_3 = ((bubbles) ? _arg_1.length : 1);
                _local_2 = target;
                setTarget((_arg_1[0] as EventDispatcher));
                _local_6 = 0;
                while (_local_6 < _local_3)
                {
                    _local_5 = (_arg_1[_local_6] as EventDispatcher);
                    if (mVisitedObjects.indexOf(_local_5) == -1)
                    {
                        _local_4 = _local_5.invokeEvent(this);
                        mVisitedObjects[mVisitedObjects.length] = _local_5;
                        if (_local_4) break;
                    };
                    _local_6++;
                };
                setTarget(_local_2);
            };
        }

        public function get timestamp():Number
        {
            return (mTimestamp);
        }

        public function get touches():Vector.<Touch>
        {
            return ((data as Vector.<Touch>).concat());
        }

        public function get shiftKey():Boolean
        {
            return (mShiftKey);
        }

        public function get ctrlKey():Boolean
        {
            return (mCtrlKey);
        }


    }
}//package starling.events

