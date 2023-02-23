// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.events.Touch

package starling.events
{
    import flash.geom.Point;
    import starling.display.DisplayObject;
    import __AS3__.vec.Vector;
    import starling.utils.formatString;

    public class Touch 
    {

        private static var sHelperPoint:Point = new Point();

        private var mID:int;
        private var mGlobalX:Number;
        private var mGlobalY:Number;
        private var mPreviousGlobalX:Number;
        private var mPreviousGlobalY:Number;
        private var mTapCount:int;
        private var mPhase:String;
        private var mTarget:DisplayObject;
        private var mTimestamp:Number;
        private var mPressure:Number;
        private var mWidth:Number;
        private var mHeight:Number;
        private var mCancelled:Boolean;
        private var mBubbleChain:Vector.<EventDispatcher>;

        public function Touch(_arg_1:int)
        {
            mID = _arg_1;
            mTapCount = 0;
            mPhase = "hover";
            mPressure = (mWidth = (mHeight = 1));
            mBubbleChain = new Vector.<EventDispatcher>(0);
        }

        public function getLocation(_arg_1:DisplayObject, _arg_2:Point=null):Point
        {
            sHelperPoint.setTo(mGlobalX, mGlobalY);
            return (_arg_1.globalToLocal(sHelperPoint, _arg_2));
        }

        public function getPreviousLocation(_arg_1:DisplayObject, _arg_2:Point=null):Point
        {
            sHelperPoint.setTo(mPreviousGlobalX, mPreviousGlobalY);
            return (_arg_1.globalToLocal(sHelperPoint, _arg_2));
        }

        public function getMovement(_arg_1:DisplayObject, _arg_2:Point=null):Point
        {
            if (_arg_2 == null)
            {
                _arg_2 = new Point();
            };
            getLocation(_arg_1, _arg_2);
            var _local_4:Number = _arg_2.x;
            var _local_3:Number = _arg_2.y;
            getPreviousLocation(_arg_1, _arg_2);
            _arg_2.setTo((_local_4 - _arg_2.x), (_local_3 - _arg_2.y));
            return (_arg_2);
        }

        public function isTouching(_arg_1:DisplayObject):Boolean
        {
            return (!(mBubbleChain.indexOf(_arg_1) == -1));
        }

        public function toString():String
        {
            return (formatString("Touch {0}: globalX={1}, globalY={2}, phase={3}", mID, mGlobalX, mGlobalY, mPhase));
        }

        public function clone():Touch
        {
            var _local_1:Touch = new Touch(mID);
            _local_1.mGlobalX = mGlobalX;
            _local_1.mGlobalY = mGlobalY;
            _local_1.mPreviousGlobalX = mPreviousGlobalX;
            _local_1.mPreviousGlobalY = mPreviousGlobalY;
            _local_1.mPhase = mPhase;
            _local_1.mTapCount = mTapCount;
            _local_1.mTimestamp = mTimestamp;
            _local_1.mPressure = mPressure;
            _local_1.mWidth = mWidth;
            _local_1.mHeight = mHeight;
            _local_1.mCancelled = mCancelled;
            _local_1.target = mTarget;
            return (_local_1);
        }

        private function updateBubbleChain():void
        {
            var _local_2:int;
            var _local_1:* = null;
            if (mTarget)
            {
                _local_2 = 1;
                _local_1 = mTarget;
                mBubbleChain.length = 1;
                mBubbleChain[0] = _local_1;
                while ((_local_1 = _local_1.parent) != null)
                {
                    mBubbleChain[_local_2++] = _local_1;
                };
            }
            else
            {
                mBubbleChain.length = 0;
            };
        }

        public function get id():int
        {
            return (mID);
        }

        public function get previousGlobalX():Number
        {
            return (mPreviousGlobalX);
        }

        public function get previousGlobalY():Number
        {
            return (mPreviousGlobalY);
        }

        public function get globalX():Number
        {
            return (mGlobalX);
        }

        public function set globalX(_arg_1:Number):void
        {
            mPreviousGlobalX = ((mGlobalX != mGlobalX) ? _arg_1 : mGlobalX);
            mGlobalX = _arg_1;
        }

        public function get globalY():Number
        {
            return (mGlobalY);
        }

        public function set globalY(_arg_1:Number):void
        {
            mPreviousGlobalY = ((mGlobalY != mGlobalY) ? _arg_1 : mGlobalY);
            mGlobalY = _arg_1;
        }

        public function get tapCount():int
        {
            return (mTapCount);
        }

        public function set tapCount(_arg_1:int):void
        {
            mTapCount = _arg_1;
        }

        public function get phase():String
        {
            return (mPhase);
        }

        public function set phase(_arg_1:String):void
        {
            mPhase = _arg_1;
        }

        public function get target():DisplayObject
        {
            return (mTarget);
        }

        public function set target(_arg_1:DisplayObject):void
        {
            if (mTarget != _arg_1)
            {
                mTarget = _arg_1;
                updateBubbleChain();
            };
        }

        public function get timestamp():Number
        {
            return (mTimestamp);
        }

        public function set timestamp(_arg_1:Number):void
        {
            mTimestamp = _arg_1;
        }

        public function get pressure():Number
        {
            return (mPressure);
        }

        public function set pressure(_arg_1:Number):void
        {
            mPressure = _arg_1;
        }

        public function get width():Number
        {
            return (mWidth);
        }

        public function set width(_arg_1:Number):void
        {
            mWidth = _arg_1;
        }

        public function get height():Number
        {
            return (mHeight);
        }

        public function set height(_arg_1:Number):void
        {
            mHeight = _arg_1;
        }

        public function get cancelled():Boolean
        {
            return (mCancelled);
        }

        public function set cancelled(_arg_1:Boolean):void
        {
            mCancelled = _arg_1;
        }

        internal function dispatchEvent(_arg_1:TouchEvent):void
        {
            if (mTarget)
            {
                _arg_1.dispatch(mBubbleChain);
            };
        }

        internal function get bubbleChain():Vector.<EventDispatcher>
        {
            return (mBubbleChain.concat());
        }


    }
}//package starling.events

