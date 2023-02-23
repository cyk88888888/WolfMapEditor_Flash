// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.events.TouchProcessor

package starling.events
{
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import starling.display.Stage;
    import starling.display.DisplayObject;
    import flash.utils.getDefinitionByName;

    public class TouchProcessor 
    {

        private static var sUpdatedTouches:Vector.<Touch> = new Vector.<Touch>(0);
        private static var sHoveringTouchData:Vector.<Object> = new Vector.<Object>(0);
        private static var sHelperPoint:Point = new Point();

        private var mStage:Stage;
        private var mRoot:DisplayObject;
        private var mElapsedTime:Number;
        private var mTouchMarker:TouchMarker;
        private var mLastTaps:Vector.<Touch>;
        private var mShiftDown:Boolean = false;
        private var mCtrlDown:Boolean = false;
        private var mMultitapTime:Number = 0.3;
        private var mMultitapDistance:Number = 25;
        protected var mQueue:Vector.<Array>;
        protected var mCurrentTouches:Vector.<Touch>;

        public function TouchProcessor(_arg_1:Stage)
        {
            mRoot = (mStage = _arg_1);
            mElapsedTime = 0;
            mCurrentTouches = new Vector.<Touch>(0);
            mQueue = new Vector.<Array>(0);
            mLastTaps = new Vector.<Touch>(0);
            monitorInterruptions(true);
        }

        public function dispose():void
        {
            monitorInterruptions(false);
            if (mTouchMarker)
            {
                mTouchMarker.dispose();
            };
        }

        public function advanceTime(_arg_1:Number):void
        {
            var _local_4:int;
            var _local_2:* = null;
            var _local_3:* = null;
            mElapsedTime = (mElapsedTime + _arg_1);
            sUpdatedTouches.length = 0;
            if (mLastTaps.length > 0)
            {
                _local_4 = (mLastTaps.length - 1);
                while (_local_4 >= 0)
                {
                    if ((mElapsedTime - mLastTaps[_local_4].timestamp) > mMultitapTime)
                    {
                        mLastTaps.splice(_local_4, 1);
                    };
                    _local_4--;
                };
            };
            while (mQueue.length > 0)
            {
                for each (_local_2 in mCurrentTouches)
                {
                    if (((_local_2.phase == "began") || (_local_2.phase == "moved")))
                    {
                        _local_2.phase = "stationary";
                    };
                };
                while (((mQueue.length > 0) && (!(containsTouchWithID(sUpdatedTouches, mQueue[(mQueue.length - 1)][0])))))
                {
                    _local_3 = mQueue.pop();
                    _local_2 = createOrUpdateTouch(_local_3[0], _local_3[1], _local_3[2], _local_3[3], _local_3[4], _local_3[5], _local_3[6]);
                    sUpdatedTouches[sUpdatedTouches.length] = _local_2;
                };
                processTouches(sUpdatedTouches, mShiftDown, mCtrlDown);
                _local_4 = (mCurrentTouches.length - 1);
                while (_local_4 >= 0)
                {
                    if (mCurrentTouches[_local_4].phase == "ended")
                    {
                        mCurrentTouches.splice(_local_4, 1);
                    };
                    _local_4--;
                };
                sUpdatedTouches.length = 0;
            };
        }

        protected function processTouches(_arg_1:Vector.<Touch>, _arg_2:Boolean, _arg_3:Boolean):void
        {
            var _local_5:* = null;
            sHoveringTouchData.length = 0;
            var _local_6:TouchEvent = new TouchEvent("touch", mCurrentTouches, _arg_2, _arg_3);
            for each (_local_5 in _arg_1)
            {
                if (((_local_5.phase == "hover") && (_local_5.target)))
                {
                    sHoveringTouchData[sHoveringTouchData.length] = {
                        "touch":_local_5,
                        "target":_local_5.target,
                        "bubbleChain":_local_5.bubbleChain
                    };
                };
                if (((_local_5.phase == "hover") || (_local_5.phase == "began")))
                {
                    sHelperPoint.setTo(_local_5.globalX, _local_5.globalY);
                    _local_5.target = mRoot.hitTest(sHelperPoint, true);
                };
            };
            for each (var _local_4:Object in sHoveringTouchData)
            {
                if (_local_4.touch.target != _local_4.target)
                {
                    _local_6.dispatch(_local_4.bubbleChain);
                };
            };
            for each (_local_5 in _arg_1)
            {
                _local_5.dispatchEvent(_local_6);
            };
        }

        public function enqueue(_arg_1:int, _arg_2:String, _arg_3:Number, _arg_4:Number, _arg_5:Number=1, _arg_6:Number=1, _arg_7:Number=1):void
        {
            mQueue.unshift(arguments);
            if ((((mCtrlDown) && (simulateMultitouch)) && (_arg_1 == 0)))
            {
                mTouchMarker.moveMarker(_arg_3, _arg_4, mShiftDown);
                mQueue.unshift([1, _arg_2, mTouchMarker.mockX, mTouchMarker.mockY]);
            };
        }

        public function enqueueMouseLeftStage():void
        {
            var _local_4:Touch = getCurrentTouch(0);
            if (((_local_4 == null) || (!(_local_4.phase == "hover"))))
            {
                return;
            };
            var _local_6:int = 1;
            var _local_1:Number = _local_4.globalX;
            var _local_3:Number = _local_4.globalY;
            var _local_5:Number = _local_4.globalX;
            var _local_2:Number = (mStage.stageWidth - _local_5);
            var _local_9:Number = _local_4.globalY;
            var _local_8:Number = (mStage.stageHeight - _local_9);
            var _local_7:Number = Math.min(_local_5, _local_2, _local_9, _local_8);
            if (_local_7 == _local_5)
            {
                _local_1 = -(_local_6);
            }
            else
            {
                if (_local_7 == _local_2)
                {
                    _local_1 = (mStage.stageWidth + _local_6);
                }
                else
                {
                    if (_local_7 == _local_9)
                    {
                        _local_3 = -(_local_6);
                    }
                    else
                    {
                        _local_3 = (mStage.stageHeight + _local_6);
                    };
                };
            };
            enqueue(0, "hover", _local_1, _local_3);
        }

        public function cancelTouches():void
        {
            if (mCurrentTouches.length > 0)
            {
                for each (var _local_1:Touch in mCurrentTouches)
                {
                    if ((((_local_1.phase == "began") || (_local_1.phase == "moved")) || (_local_1.phase == "stationary")))
                    {
                        _local_1.phase = "ended";
                        _local_1.cancelled = true;
                    };
                };
                processTouches(mCurrentTouches, mShiftDown, mCtrlDown);
            };
            mCurrentTouches.length = 0;
            mQueue.length = 0;
        }

        private function createOrUpdateTouch(_arg_1:int, _arg_2:String, _arg_3:Number, _arg_4:Number, _arg_5:Number=1, _arg_6:Number=1, _arg_7:Number=1):Touch
        {
            var _local_8:Touch = getCurrentTouch(_arg_1);
            if (_local_8 == null)
            {
                _local_8 = new Touch(_arg_1);
                addCurrentTouch(_local_8);
            };
            _local_8.globalX = _arg_3;
            _local_8.globalY = _arg_4;
            _local_8.phase = _arg_2;
            _local_8.timestamp = mElapsedTime;
            _local_8.pressure = _arg_5;
            _local_8.width = _arg_6;
            _local_8.height = _arg_7;
            if (_arg_2 == "began")
            {
                updateTapCount(_local_8);
            };
            return (_local_8);
        }

        private function updateTapCount(_arg_1:Touch):void
        {
            var _local_2:Number;
            var _local_4:Touch;
            var _local_5:Number = (mMultitapDistance * mMultitapDistance);
            for each (var _local_3:Touch in mLastTaps)
            {
                _local_2 = (Math.pow((_local_3.globalX - _arg_1.globalX), 2) + Math.pow((_local_3.globalY - _arg_1.globalY), 2));
                if (_local_2 <= _local_5)
                {
                    _local_4 = _local_3;
                    break;
                };
            };
            if (_local_4)
            {
                _arg_1.tapCount = (_local_4.tapCount + 1);
                mLastTaps.splice(mLastTaps.indexOf(_local_4), 1);
            }
            else
            {
                _arg_1.tapCount = 1;
            };
            mLastTaps.push(_arg_1.clone());
        }

        private function addCurrentTouch(_arg_1:Touch):void
        {
            var _local_2:int;
            _local_2 = (mCurrentTouches.length - 1);
            while (_local_2 >= 0)
            {
                if (mCurrentTouches[_local_2].id == _arg_1.id)
                {
                    mCurrentTouches.splice(_local_2, 1);
                };
                _local_2--;
            };
            mCurrentTouches.push(_arg_1);
        }

        private function getCurrentTouch(_arg_1:int):Touch
        {
            for each (var _local_2:Touch in mCurrentTouches)
            {
                if (_local_2.id == _arg_1)
                {
                    return (_local_2);
                };
            };
            return (null);
        }

        private function containsTouchWithID(_arg_1:Vector.<Touch>, _arg_2:int):Boolean
        {
            for each (var _local_3:Touch in _arg_1)
            {
                if (_local_3.id == _arg_2)
                {
                    return (true);
                };
            };
            return (false);
        }

        public function get simulateMultitouch():Boolean
        {
            return (!(mTouchMarker == null));
        }

        public function set simulateMultitouch(_arg_1:Boolean):void
        {
            if (simulateMultitouch == _arg_1)
            {
                return;
            };
            if (_arg_1)
            {
                mTouchMarker = new TouchMarker();
                mTouchMarker.visible = false;
                mStage.addChild(mTouchMarker);
            }
            else
            {
                mTouchMarker.removeFromParent(true);
                mTouchMarker = null;
            };
        }

        public function get multitapTime():Number
        {
            return (mMultitapTime);
        }

        public function set multitapTime(_arg_1:Number):void
        {
            mMultitapTime = _arg_1;
        }

        public function get multitapDistance():Number
        {
            return (mMultitapDistance);
        }

        public function set multitapDistance(_arg_1:Number):void
        {
            mMultitapDistance = _arg_1;
        }

        public function get root():DisplayObject
        {
            return (mRoot);
        }

        public function set root(_arg_1:DisplayObject):void
        {
            mRoot = _arg_1;
        }

        public function get stage():Stage
        {
            return (mStage);
        }

        public function get numCurrentTouches():int
        {
            return (mCurrentTouches.length);
        }

        private function onKey(_arg_1:KeyboardEvent):void
        {
            var _local_2:Boolean;
            var _local_4:* = null;
            var _local_3:* = null;
            if (((_arg_1.keyCode == 17) || (_arg_1.keyCode == 15)))
            {
                _local_2 = mCtrlDown;
                mCtrlDown = (_arg_1.type == "keyDown");
                if (((simulateMultitouch) && (!(_local_2 == mCtrlDown))))
                {
                    mTouchMarker.visible = mCtrlDown;
                    mTouchMarker.moveCenter((mStage.stageWidth / 2), (mStage.stageHeight / 2));
                    _local_4 = getCurrentTouch(0);
                    _local_3 = getCurrentTouch(1);
                    if (_local_4)
                    {
                        mTouchMarker.moveMarker(_local_4.globalX, _local_4.globalY);
                    };
                    if ((((_local_2) && (_local_3)) && (!(_local_3.phase == "ended"))))
                    {
                        mQueue.unshift([1, "ended", _local_3.globalX, _local_3.globalY]);
                    }
                    else
                    {
                        if (((mCtrlDown) && (_local_4)))
                        {
                            if (((_local_4.phase == "hover") || (_local_4.phase == "ended")))
                            {
                                mQueue.unshift([1, "hover", mTouchMarker.mockX, mTouchMarker.mockY]);
                            }
                            else
                            {
                                mQueue.unshift([1, "began", mTouchMarker.mockX, mTouchMarker.mockY]);
                            };
                        };
                    };
                };
            }
            else
            {
                if (_arg_1.keyCode == 16)
                {
                    mShiftDown = (_arg_1.type == "keyDown");
                };
            };
        }

        private function monitorInterruptions(_arg_1:Boolean):void
        {
            var _local_3:* = null;
            var _local_2:* = null;
            try
            {
                _local_3 = getDefinitionByName("flash.desktop::NativeApplication");
                _local_2 = _local_3["nativeApplication"];
                if (_arg_1)
                {
                    _local_2.addEventListener("deactivate", onInterruption, false, 0, true);
                }
                else
                {
                    _local_2.removeEventListener("deactivate", onInterruption);
                };
            }
            catch(e:Error)
            {
            };
        }

        private function onInterruption(_arg_1:Object):void
        {
            cancelTouches();
        }


    }
}//package starling.events

