// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.animation.Tween

package starling.animation
{
    import starling.events.EventDispatcher;
    import __AS3__.vec.Vector;
    import starling.core.starling_internal;

    use namespace starling_internal;

    public class Tween extends EventDispatcher implements IAnimatable 
    {

        private static const HINT_MARKER:String = "#";

        private static var sTweenPool:Vector.<Tween> = new Vector.<Tween>(0);

        private var mTarget:Object;
        private var mTransitionFunc:Function;
        private var mTransitionName:String;
        private var mProperties:Vector.<String>;
        private var mStartValues:Vector.<Number>;
        private var mEndValues:Vector.<Number>;
        private var mUpdateFuncs:Vector.<Function>;
        private var mOnStart:Function;
        private var mOnUpdate:Function;
        private var mOnRepeat:Function;
        private var mOnComplete:Function;
        private var mOnStartArgs:Array;
        private var mOnUpdateArgs:Array;
        private var mOnRepeatArgs:Array;
        private var mOnCompleteArgs:Array;
        private var mTotalTime:Number;
        private var mCurrentTime:Number;
        private var mProgress:Number;
        private var mDelay:Number;
        private var mRoundToInt:Boolean;
        private var mNextTween:Tween;
        private var mRepeatCount:int;
        private var mRepeatDelay:Number;
        private var mReverse:Boolean;
        private var mCurrentCycle:int;

        public function Tween(_arg_1:Object, _arg_2:Number, _arg_3:Object="linear")
        {
            reset(_arg_1, _arg_2, _arg_3);
        }

        internal static function getPropertyHint(_arg_1:String):String
        {
            if (((!(_arg_1.indexOf("color") == -1)) || (!(_arg_1.indexOf("Color") == -1))))
            {
                return ("rgb");
            };
            var _local_2:int = _arg_1.indexOf("#");
            if (_local_2 != -1)
            {
                return (_arg_1.substr((_local_2 + 1)));
            };
            return (null);
        }

        internal static function getPropertyName(_arg_1:String):String
        {
            var _local_2:int = _arg_1.indexOf("#");
            if (_local_2 != -1)
            {
                return (_arg_1.substring(0, _local_2));
            };
            return (_arg_1);
        }

        starling_internal static function fromPool(_arg_1:Object, _arg_2:Number, _arg_3:Object="linear"):Tween
        {
            if (sTweenPool.length)
            {
                return (sTweenPool.pop().reset(_arg_1, _arg_2, _arg_3));
            };
            return (new Tween(_arg_1, _arg_2, _arg_3));
        }

        starling_internal static function toPool(_arg_1:Tween):void
        {
            var _local_2:* = null;
            _arg_1.mOnComplete = _local_2;
            _arg_1.mOnRepeat = _local_2;
            _arg_1.mOnUpdate = _local_2;
            _arg_1.mOnStart = _local_2;
            _local_2 = null;
            _arg_1.mOnCompleteArgs = _local_2;
            _arg_1.mOnRepeatArgs = _local_2;
            _arg_1.mOnUpdateArgs = _local_2;
            _arg_1.mOnStartArgs = _local_2;
            _arg_1.mTarget = null;
            _arg_1.mTransitionFunc = null;
            _arg_1.removeEventListeners();
            sTweenPool.push(_arg_1);
        }


        public function reset(_arg_1:Object, _arg_2:Number, _arg_3:Object="linear"):Tween
        {
            mTarget = _arg_1;
            mCurrentTime = 0;
            mTotalTime = Math.max(0.0001, _arg_2);
            mProgress = 0;
            mDelay = (mRepeatDelay = 0);
            mOnStart = (mOnUpdate = (mOnRepeat = (mOnComplete = null)));
            mOnStartArgs = (mOnUpdateArgs = (mOnRepeatArgs = (mOnCompleteArgs = null)));
            mRoundToInt = (mReverse = false);
            mRepeatCount = 1;
            mCurrentCycle = -1;
            mNextTween = null;
            if ((_arg_3 is String))
            {
                this.transition = (_arg_3 as String);
            }
            else
            {
                if ((_arg_3 is Function))
                {
                    this.transitionFunc = (_arg_3 as Function);
                }
                else
                {
                    throw (new ArgumentError("Transition must be either a string or a function"));
                };
            };
            if (mProperties)
            {
                mProperties.length = 0;
            }
            else
            {
                mProperties = new Vector.<String>(0);
            };
            if (mStartValues)
            {
                mStartValues.length = 0;
            }
            else
            {
                mStartValues = new Vector.<Number>(0);
            };
            if (mEndValues)
            {
                mEndValues.length = 0;
            }
            else
            {
                mEndValues = new Vector.<Number>(0);
            };
            if (mUpdateFuncs)
            {
                mUpdateFuncs.length = 0;
            }
            else
            {
                mUpdateFuncs = new Vector.<Function>(0);
            };
            return (this);
        }

        public function animate(_arg_1:String, _arg_2:Number):void
        {
            if (mTarget == null)
            {
                return;
            };
            var _local_4:int = mProperties.length;
            var _local_3:Function = getUpdateFuncFromProperty(_arg_1);
            mProperties[_local_4] = getPropertyName(_arg_1);
            mStartValues[_local_4] = NaN;
            mEndValues[_local_4] = _arg_2;
            mUpdateFuncs[_local_4] = _local_3;
        }

        public function scaleTo(_arg_1:Number):void
        {
            animate("scaleX", _arg_1);
            animate("scaleY", _arg_1);
        }

        public function moveTo(_arg_1:Number, _arg_2:Number):void
        {
            animate("x", _arg_1);
            animate("y", _arg_2);
        }

        public function fadeTo(_arg_1:Number):void
        {
            animate("alpha", _arg_1);
        }

        public function rotateTo(_arg_1:Number, _arg_2:String="rad"):void
        {
            animate(("rotation#" + _arg_2), _arg_1);
        }

        public function advanceTime(_arg_1:Number):void
        {
            var _local_11:int;
            var _local_4:* = null;
            var _local_3:* = null;
            var _local_9:* = null;
            if (((_arg_1 == 0) || ((mRepeatCount == 1) && (mCurrentTime == mTotalTime))))
            {
                return;
            };
            var _local_8:Number = mCurrentTime;
            var _local_6:Number = (mTotalTime - mCurrentTime);
            var _local_5:Number = ((_arg_1 > _local_6) ? (_arg_1 - _local_6) : 0);
            mCurrentTime = (mCurrentTime + _arg_1);
            if (mCurrentTime <= 0)
            {
                return;
            };
            if (mCurrentTime > mTotalTime)
            {
                mCurrentTime = mTotalTime;
            };
            if ((((mCurrentCycle < 0) && (_local_8 <= 0)) && (mCurrentTime > 0)))
            {
                mCurrentCycle++;
                if (mOnStart != null)
                {
                    mOnStart.apply(this, mOnStartArgs);
                };
            };
            var _local_2:Number = (mCurrentTime / mTotalTime);
            var _local_7:Boolean = ((mReverse) && ((mCurrentCycle % 2) == 1));
            var _local_10:int = mStartValues.length;
            mProgress = ((_local_7) ? mTransitionFunc((1 - _local_2)) : mTransitionFunc(_local_2));
            _local_11 = 0;
            while (_local_11 < _local_10)
            {
                if (mStartValues[_local_11] != mStartValues[_local_11])
                {
                    mStartValues[_local_11] = (mTarget[mProperties[_local_11]] as Number);
                };
                _local_4 = (mUpdateFuncs[_local_11] as Function);
                (_local_4(mProperties[_local_11], mStartValues[_local_11], mEndValues[_local_11]));
                _local_11++;
            };
            if (mOnUpdate != null)
            {
                mOnUpdate.apply(this, mOnUpdateArgs);
            };
            if (((_local_8 < mTotalTime) && (mCurrentTime >= mTotalTime)))
            {
                if (((mRepeatCount == 0) || (mRepeatCount > 1)))
                {
                    mCurrentTime = -(mRepeatDelay);
                    mCurrentCycle++;
                    if (mRepeatCount > 1)
                    {
                        mRepeatCount--;
                    };
                    if (mOnRepeat != null)
                    {
                        mOnRepeat.apply(this, mOnRepeatArgs);
                    };
                }
                else
                {
                    _local_3 = mOnComplete;
                    _local_9 = mOnCompleteArgs;
                    dispatchEventWith("removeFromJuggler");
                    if (_local_3 != null)
                    {
                        _local_3.apply(this, _local_9);
                    };
                };
            };
            if (_local_5)
            {
                advanceTime(_local_5);
            };
        }

        private function getUpdateFuncFromProperty(_arg_1:String):Function
        {
            var _local_2:* = null;
            var _local_3:String = getPropertyHint(_arg_1);
            switch (_local_3)
            {
                case null:
                    _local_2 = updateStandard;
                    break;
                case "rgb":
                    _local_2 = updateRgb;
                    break;
                case "rad":
                    _local_2 = updateRad;
                    break;
                case "deg":
                    _local_2 = updateDeg;
                    break;
                default:
                    (trace("[Starling] Ignoring unknown property hint:", _local_3));
                    _local_2 = updateStandard;
            };
            return (_local_2);
        }

        private function updateStandard(_arg_1:String, _arg_2:Number, _arg_3:Number):void
        {
            var _local_4:Number = (_arg_2 + (mProgress * (_arg_3 - _arg_2)));
            if (mRoundToInt)
            {
                _local_4 = Math.round(_local_4);
            };
            mTarget[_arg_1] = _local_4;
        }

        private function updateRgb(_arg_1:String, _arg_2:Number, _arg_3:Number):void
        {
            var _local_13:uint = _arg_2;
            var _local_15:uint = _arg_3;
            var _local_14:uint = ((_local_13 >> 24) & 0xFF);
            var _local_10:uint = ((_local_13 >> 16) & 0xFF);
            var _local_4:uint = ((_local_13 >> 8) & 0xFF);
            var _local_6:uint = (_local_13 & 0xFF);
            var _local_16:uint = ((_local_15 >> 24) & 0xFF);
            var _local_7:uint = ((_local_15 >> 16) & 0xFF);
            var _local_11:uint = ((_local_15 >> 8) & 0xFF);
            var _local_17:uint = (_local_15 & 0xFF);
            var _local_8:uint = (_local_14 + ((_local_16 - _local_14) * mProgress));
            var _local_5:uint = (_local_10 + ((_local_7 - _local_10) * mProgress));
            var _local_12:uint = (_local_4 + ((_local_11 - _local_4) * mProgress));
            var _local_9:uint = (_local_6 + ((_local_17 - _local_6) * mProgress));
            mTarget[_arg_1] = ((((_local_8 << 24) | (_local_5 << 16)) | (_local_12 << 8)) | _local_9);
        }

        private function updateRad(_arg_1:String, _arg_2:Number, _arg_3:Number):void
        {
            updateAngle(3.14159265358979, _arg_1, _arg_2, _arg_3);
        }

        private function updateDeg(_arg_1:String, _arg_2:Number, _arg_3:Number):void
        {
            updateAngle(180, _arg_1, _arg_2, _arg_3);
        }

        private function updateAngle(_arg_1:Number, _arg_2:String, _arg_3:Number, _arg_4:Number):void
        {
            while (Math.abs((_arg_4 - _arg_3)) > _arg_1)
            {
                if (_arg_3 < _arg_4)
                {
                    _arg_4 = (_arg_4 - (2 * _arg_1));
                }
                else
                {
                    _arg_4 = (_arg_4 + (2 * _arg_1));
                };
            };
            updateStandard(_arg_2, _arg_3, _arg_4);
        }

        public function getEndValue(_arg_1:String):Number
        {
            var _local_2:int = mProperties.indexOf(_arg_1);
            if (_local_2 == -1)
            {
                throw (new ArgumentError((("The property '" + _arg_1) + "' is not animated")));
            };
            return (mEndValues[_local_2] as Number);
        }

        public function get isComplete():Boolean
        {
            return ((mCurrentTime >= mTotalTime) && (mRepeatCount == 1));
        }

        public function get target():Object
        {
            return (mTarget);
        }

        public function get transition():String
        {
            return (mTransitionName);
        }

        public function set transition(_arg_1:String):void
        {
            mTransitionName = _arg_1;
            mTransitionFunc = Transitions.getTransition(_arg_1);
            if (mTransitionFunc == null)
            {
                throw (new ArgumentError(("Invalid transiton: " + _arg_1)));
            };
        }

        public function get transitionFunc():Function
        {
            return (mTransitionFunc);
        }

        public function set transitionFunc(_arg_1:Function):void
        {
            mTransitionName = "custom";
            mTransitionFunc = _arg_1;
        }

        public function get totalTime():Number
        {
            return (mTotalTime);
        }

        public function get currentTime():Number
        {
            return (mCurrentTime);
        }

        public function get progress():Number
        {
            return (mProgress);
        }

        public function get delay():Number
        {
            return (mDelay);
        }

        public function set delay(_arg_1:Number):void
        {
            mCurrentTime = ((mCurrentTime + mDelay) - _arg_1);
            mDelay = _arg_1;
        }

        public function get repeatCount():int
        {
            return (mRepeatCount);
        }

        public function set repeatCount(_arg_1:int):void
        {
            mRepeatCount = _arg_1;
        }

        public function get repeatDelay():Number
        {
            return (mRepeatDelay);
        }

        public function set repeatDelay(_arg_1:Number):void
        {
            mRepeatDelay = _arg_1;
        }

        public function get reverse():Boolean
        {
            return (mReverse);
        }

        public function set reverse(_arg_1:Boolean):void
        {
            mReverse = _arg_1;
        }

        public function get roundToInt():Boolean
        {
            return (mRoundToInt);
        }

        public function set roundToInt(_arg_1:Boolean):void
        {
            mRoundToInt = _arg_1;
        }

        public function get onStart():Function
        {
            return (mOnStart);
        }

        public function set onStart(_arg_1:Function):void
        {
            mOnStart = _arg_1;
        }

        public function get onUpdate():Function
        {
            return (mOnUpdate);
        }

        public function set onUpdate(_arg_1:Function):void
        {
            mOnUpdate = _arg_1;
        }

        public function get onRepeat():Function
        {
            return (mOnRepeat);
        }

        public function set onRepeat(_arg_1:Function):void
        {
            mOnRepeat = _arg_1;
        }

        public function get onComplete():Function
        {
            return (mOnComplete);
        }

        public function set onComplete(_arg_1:Function):void
        {
            mOnComplete = _arg_1;
        }

        public function get onStartArgs():Array
        {
            return (mOnStartArgs);
        }

        public function set onStartArgs(_arg_1:Array):void
        {
            mOnStartArgs = _arg_1;
        }

        public function get onUpdateArgs():Array
        {
            return (mOnUpdateArgs);
        }

        public function set onUpdateArgs(_arg_1:Array):void
        {
            mOnUpdateArgs = _arg_1;
        }

        public function get onRepeatArgs():Array
        {
            return (mOnRepeatArgs);
        }

        public function set onRepeatArgs(_arg_1:Array):void
        {
            mOnRepeatArgs = _arg_1;
        }

        public function get onCompleteArgs():Array
        {
            return (mOnCompleteArgs);
        }

        public function set onCompleteArgs(_arg_1:Array):void
        {
            mOnCompleteArgs = _arg_1;
        }

        public function get nextTween():Tween
        {
            return (mNextTween);
        }

        public function set nextTween(_arg_1:Tween):void
        {
            mNextTween = _arg_1;
        }


    }
}//package starling.animation

