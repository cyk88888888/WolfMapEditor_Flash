// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.events.Event

package starling.events
{
    import __AS3__.vec.Vector;
    import starling.core.starling_internal;
    import starling.utils.formatString;
    import flash.utils.getQualifiedClassName;

    use namespace starling_internal;

    public class Event 
    {

        public static const DEVICE_LOST:String = "dvlst";
        public static const ADDED:String = "added";
        public static const ADDED_TO_STAGE:String = "addedToStage";
        public static const ENTER_FRAME:String = "enterFrame";
        public static const REMOVED:String = "removed";
        public static const REMOVED_FROM_STAGE:String = "removedFromStage";
        public static const TRIGGERED:String = "triggered";
        public static const FLATTEN:String = "flatten";
        public static const RESIZE:String = "resize";
        public static const COMPLETE:String = "complete";
        public static const CONTEXT3D_CREATE:String = "context3DCreate";
        public static const RENDER:String = "render";
        public static const ROOT_CREATED:String = "rootCreated";
        public static const REMOVE_FROM_JUGGLER:String = "removeFromJuggler";
        public static const TEXTURES_RESTORED:String = "texturesRestored";
        public static const IO_ERROR:String = "ioError";
        public static const SECURITY_ERROR:String = "securityError";
        public static const PARSE_ERROR:String = "parseError";
        public static const FATAL_ERROR:String = "fatalError";
        public static const CHANGE:String = "change";
        public static const CANCEL:String = "cancel";
        public static const SCROLL:String = "scroll";
        public static const OPEN:String = "open";
        public static const CLOSE:String = "close";
        public static const SELECT:String = "select";
        public static const READY:String = "ready";

        private static var sEventPool:Vector.<Event> = new Vector.<Event>(0);

        private var mTarget:EventDispatcher;
        private var mCurrentTarget:EventDispatcher;
        private var mType:String;
        private var mBubbles:Boolean;
        private var mStopsPropagation:Boolean;
        private var mStopsImmediatePropagation:Boolean;
        private var mData:Object;

        public function Event(_arg_1:String, _arg_2:Boolean=false, _arg_3:Object=null)
        {
            mType = _arg_1;
            mBubbles = _arg_2;
            mData = _arg_3;
        }

        starling_internal static function fromPool(_arg_1:String, _arg_2:Boolean=false, _arg_3:Object=null):Event
        {
            if (sEventPool.length)
            {
                return (sEventPool.pop().starling_internal::reset(_arg_1, _arg_2, _arg_3));
            };
            return (new Event(_arg_1, _arg_2, _arg_3));
        }

        starling_internal static function toPool(_arg_1:Event):void
        {
            var _local_2:* = null;
            _arg_1.mCurrentTarget = _local_2;
            _arg_1.mTarget = _local_2;
            _arg_1.mData = _local_2;
            sEventPool[sEventPool.length] = _arg_1;
        }


        public function stopPropagation():void
        {
            mStopsPropagation = true;
        }

        public function stopImmediatePropagation():void
        {
            mStopsPropagation = (mStopsImmediatePropagation = true);
        }

        public function toString():String
        {
            return (formatString('[{0} type="{1}" bubbles={2}]', getQualifiedClassName(this).split("::").pop(), mType, mBubbles));
        }

        public function get bubbles():Boolean
        {
            return (mBubbles);
        }

        public function get target():EventDispatcher
        {
            return (mTarget);
        }

        public function get currentTarget():EventDispatcher
        {
            return (mCurrentTarget);
        }

        public function get type():String
        {
            return (mType);
        }

        public function get data():Object
        {
            return (mData);
        }

        internal function setTarget(_arg_1:EventDispatcher):void
        {
            mTarget = _arg_1;
        }

        internal function setCurrentTarget(_arg_1:EventDispatcher):void
        {
            mCurrentTarget = _arg_1;
        }

        internal function setData(_arg_1:Object):void
        {
            mData = _arg_1;
        }

        internal function get stopsPropagation():Boolean
        {
            return (mStopsPropagation);
        }

        internal function get stopsImmediatePropagation():Boolean
        {
            return (mStopsImmediatePropagation);
        }

        starling_internal function reset(_arg_1:String, _arg_2:Boolean=false, _arg_3:Object=null):Event
        {
            mType = _arg_1;
            mBubbles = _arg_2;
            mData = _arg_3;
            mTarget = (mCurrentTarget = null);
            mStopsPropagation = (mStopsImmediatePropagation = false);
            return (this);
        }


    }
}//package starling.events

