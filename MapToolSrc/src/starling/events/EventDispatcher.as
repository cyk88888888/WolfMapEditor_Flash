// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.events.EventDispatcher

package starling.events
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import starling.display.DisplayObject;
    import starling.core.starling_internal;

    use namespace starling_internal;

    public class EventDispatcher 
    {

        private static var sBubbleChains:Array = [];

        private var mEventListeners:Dictionary;


        public function addEventListener(_arg_1:String, _arg_2:Function):void
        {
            if (mEventListeners == null)
            {
                mEventListeners = new Dictionary();
            };
            var _local_3:Vector.<Function> = (mEventListeners[_arg_1] as Vector.<Function>);
            if (_local_3 == null)
            {
                mEventListeners[_arg_1] = new <Function>[_arg_2];
            }
            else
            {
                if (_local_3.indexOf(_arg_2) == -1)
                {
                    _local_3[_local_3.length] = _arg_2;
                };
            };
        }

        public function removeEventListener(_arg_1:String, _arg_2:Function):void
        {
            var _local_3:*;
            var _local_5:int;
            var _local_4:int;
            var _local_6:*;
            var _local_7:int;
            if (mEventListeners)
            {
                _local_3 = (mEventListeners[_arg_1] as Vector.<Function>);
                _local_5 = ((_local_3) ? _local_3.length : 0);
                if (_local_5 > 0)
                {
                    _local_4 = _local_3.indexOf(_arg_2);
                    if (_local_4 != -1)
                    {
                        _local_6 = _local_3.slice(0, _local_4);
                        _local_7 = (_local_4 + 1);
                        while (_local_7 < _local_5)
                        {
                            _local_6[(_local_7 - 1)] = _local_3[_local_7];
                            _local_7++;
                        };
                        mEventListeners[_arg_1] = _local_6;
                    };
                };
            };
        }

        public function removeEventListeners(_arg_1:String=null):void
        {
            if (((_arg_1) && (mEventListeners)))
            {
                delete mEventListeners[_arg_1];
            }
            else
            {
                mEventListeners = null;
            };
        }

        public function dispatchEvent(_arg_1:Event):void
        {
            var _local_3:Boolean = _arg_1.bubbles;
            if (((!(_local_3)) && ((mEventListeners == null) || (!(_arg_1.type in mEventListeners)))))
            {
                return;
            };
            var _local_2:EventDispatcher = _arg_1.target;
            _arg_1.setTarget(this);
            if (((_local_3) && (this is DisplayObject)))
            {
                bubbleEvent(_arg_1);
            }
            else
            {
                invokeEvent(_arg_1);
            };
            if (_local_2)
            {
                _arg_1.setTarget(_local_2);
            };
        }

        internal function invokeEvent(_arg_1:Event):Boolean
        {
            var _local_6:int;
            var _local_3:* = null;
            var _local_5:int;
            var _local_2:Vector.<Function> = ((mEventListeners) ? (mEventListeners[_arg_1.type] as Vector.<Function>) : null);
            var _local_4:int = ((_local_2 == null) ? 0 : _local_2.length);
            if (_local_4)
            {
                _arg_1.setCurrentTarget(this);
                _local_6 = 0;
                while (_local_6 < _local_4)
                {
                    _local_3 = (_local_2[_local_6] as Function);
                    _local_5 = _local_3.length;
                    if (_local_5 == 0)
                    {
                        (_local_3());
                    }
                    else
                    {
                        if (_local_5 == 1)
                        {
                            (_local_3(_arg_1));
                        }
                        else
                        {
                            (_local_3(_arg_1, _arg_1.data));
                        };
                    };
                    if (_arg_1.stopsImmediatePropagation)
                    {
                        return (true);
                    };
                    _local_6++;
                };
                return (_arg_1.stopsPropagation);
            };
            return (false);
        }

        internal function bubbleEvent(_arg_1:Event):void
        {
            var _local_3:*;
            var _local_6:int;
            var _local_4:Boolean;
            var _local_2:DisplayObject = (this as DisplayObject);
            var _local_5:int = 1;
            if (sBubbleChains.length > 0)
            {
                _local_3 = sBubbleChains.pop();
                _local_3[0] = _local_2;
            }
            else
            {
                _local_3 = new <EventDispatcher>[_local_2];
            };
            while ((_local_2 = _local_2.parent) != null)
            {
                _local_3[_local_5++] = _local_2;
            };
            _local_6 = 0;
            while (_local_6 < _local_5)
            {
                _local_4 = _local_3[_local_6].invokeEvent(_arg_1);
                if (_local_4) break;
                _local_6++;
            };
            _local_3.length = 0;
            sBubbleChains[sBubbleChains.length] = _local_3;
        }

        public function dispatchEventWith(_arg_1:String, _arg_2:Boolean=false, _arg_3:Object=null):void
        {
            var _local_4:* = null;
            if (((_arg_2) || (hasEventListener(_arg_1))))
            {
                _local_4 = Event.starling_internal::fromPool(_arg_1, _arg_2, _arg_3);
                dispatchEvent(_local_4);
                Event.starling_internal::toPool(_local_4);
            };
        }

        public function hasEventListener(_arg_1:String):Boolean
        {
            var _local_2:Vector.<Function> = ((mEventListeners) ? mEventListeners[_arg_1] : null);
            return ((_local_2) ? (!(_local_2.length == 0)) : false);
        }


    }
}//package starling.events

