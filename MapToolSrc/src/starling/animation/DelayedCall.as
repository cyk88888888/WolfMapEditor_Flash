// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.animation.DelayedCall

package starling.animation
{
    import starling.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import starling.core.starling_internal;

    use namespace starling_internal;

    public class DelayedCall extends EventDispatcher implements IAnimatable 
    {

        private static var sPool:Vector.<DelayedCall> = new Vector.<DelayedCall>(0);

        private var mCurrentTime:Number;
        private var mTotalTime:Number;
        private var mCall:Function;
        private var mArgs:Array;
        private var mRepeatCount:int;

        public function DelayedCall(_arg_1:Function, _arg_2:Number, _arg_3:Array=null)
        {
            reset(_arg_1, _arg_2, _arg_3);
        }

        starling_internal static function fromPool(_arg_1:Function, _arg_2:Number, _arg_3:Array=null):DelayedCall
        {
            if (sPool.length)
            {
                return (sPool.pop().reset(_arg_1, _arg_2, _arg_3));
            };
            return (new DelayedCall(_arg_1, _arg_2, _arg_3));
        }

        starling_internal static function toPool(_arg_1:DelayedCall):void
        {
            _arg_1.mCall = null;
            _arg_1.mArgs = null;
            _arg_1.removeEventListeners();
            sPool.push(_arg_1);
        }


        public function reset(_arg_1:Function, _arg_2:Number, _arg_3:Array=null):DelayedCall
        {
            mCurrentTime = 0;
            mTotalTime = Math.max(_arg_2, 0.0001);
            mCall = _arg_1;
            mArgs = _arg_3;
            mRepeatCount = 1;
            return (this);
        }

        public function advanceTime(_arg_1:Number):void
        {
            var _local_2:* = null;
            var _local_3:* = null;
            var _local_4:Number = mCurrentTime;
            mCurrentTime = (mCurrentTime + _arg_1);
            if (mCurrentTime > mTotalTime)
            {
                mCurrentTime = mTotalTime;
            };
            if (((_local_4 < mTotalTime) && (mCurrentTime >= mTotalTime)))
            {
                if (((mRepeatCount == 0) || (mRepeatCount > 1)))
                {
                    mCall.apply(null, mArgs);
                    if (mRepeatCount > 0)
                    {
                        mRepeatCount = (mRepeatCount - 1);
                    };
                    mCurrentTime = 0;
                    advanceTime(((_local_4 + _arg_1) - mTotalTime));
                }
                else
                {
                    _local_2 = mCall;
                    _local_3 = mArgs;
                    dispatchEventWith("removeFromJuggler");
                    _local_2.apply(null, _local_3);
                };
            };
        }

        public function complete():void
        {
            var _local_1:Number = (mTotalTime - mCurrentTime);
            if (_local_1 > 0)
            {
                advanceTime(_local_1);
            };
        }

        public function get isComplete():Boolean
        {
            return ((mRepeatCount == 1) && (mCurrentTime >= mTotalTime));
        }

        public function get totalTime():Number
        {
            return (mTotalTime);
        }

        public function get currentTime():Number
        {
            return (mCurrentTime);
        }

        public function get repeatCount():int
        {
            return (mRepeatCount);
        }

        public function set repeatCount(_arg_1:int):void
        {
            mRepeatCount = _arg_1;
        }


    }
}//package starling.animation

