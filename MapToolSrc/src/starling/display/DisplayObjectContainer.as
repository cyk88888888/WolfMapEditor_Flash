// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.display.DisplayObjectContainer

package starling.display
{
    import flash.geom.Matrix;
    import flash.geom.Point;
    import __AS3__.vec.Vector;
    import flash.utils.getQualifiedClassName;
    import flash.system.Capabilities;
    import starling.errors.AbstractClassError;
    import flash.geom.Rectangle;
    import starling.utils.MatrixUtil;
    import starling.core.RenderSupport;
    import starling.events.Event;
    import starling.core.starling_internal;

    use namespace starling_internal;

    public class DisplayObjectContainer extends DisplayObject 
    {

        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sHelperPoint:Point = new Point();
        private static var sBroadcastListeners:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
        private static var sSortBuffer:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);

        private var mChildren:Vector.<DisplayObject>;
        private var mTouchGroup:Boolean;

        public function DisplayObjectContainer()
        {
            if (((Capabilities.isDebugger) && (getQualifiedClassName(this) == "starling.display::DisplayObjectContainer")))
            {
                throw (new AbstractClassError());
            };
            mChildren = new Vector.<DisplayObject>(0);
        }

        private static function mergeSort(_arg_1:Vector.<DisplayObject>, _arg_2:Function, _arg_3:int, _arg_4:int, _arg_5:Vector.<DisplayObject>):void
        {
            var _local_10:int;
            var _local_9:int;
            var _local_7:int;
            var _local_8:int;
            var _local_6:int;
            if (_arg_4 <= 1)
            {
                return;
            };
            _local_10 = 0;
            _local_9 = (_arg_3 + _arg_4);
            _local_7 = int((_arg_4 / 2));
            _local_8 = _arg_3;
            _local_6 = (_arg_3 + _local_7);
            mergeSort(_arg_1, _arg_2, _arg_3, _local_7, _arg_5);
            mergeSort(_arg_1, _arg_2, (_arg_3 + _local_7), (_arg_4 - _local_7), _arg_5);
            _local_10 = 0;
            while (_local_10 < _arg_4)
            {
                if (((_local_8 < (_arg_3 + _local_7)) && ((_local_6 == _local_9) || (_arg_2(_arg_1[_local_8], _arg_1[_local_6]) <= 0))))
                {
                    _arg_5[_local_10] = _arg_1[_local_8];
                    _local_8++;
                }
                else
                {
                    _arg_5[_local_10] = _arg_1[_local_6];
                    _local_6++;
                };
                _local_10++;
            };
            _local_10 = _arg_3;
            while (_local_10 < _local_9)
            {
                _arg_1[_local_10] = _arg_5[(_local_10 - _arg_3)];
                _local_10++;
            };
        }


        override public function dispose():void
        {
            var _local_1:int;
            _local_1 = (mChildren.length - 1);
            while (_local_1 >= 0)
            {
                mChildren[_local_1].dispose();
                _local_1--;
            };
            super.dispose();
        }

        public function addChild(_arg_1:DisplayObject):DisplayObject
        {
            return (addChildAt(_arg_1, mChildren.length));
        }

        public function addChildAt(_arg_1:DisplayObject, _arg_2:int):DisplayObject
        {
            var _local_3:* = null;
            var _local_4:int = mChildren.length;
            if (((_arg_2 >= 0) && (_arg_2 <= _local_4)))
            {
                if (_arg_1.parent == this)
                {
                    setChildIndex(_arg_1, _arg_2);
                }
                else
                {
                    _arg_1.removeFromParent();
                    if (_arg_2 == _local_4)
                    {
                        mChildren[_local_4] = _arg_1;
                    }
                    else
                    {
                        spliceChildren(_arg_2, 0, _arg_1);
                    };
                    _arg_1.setParent(this);
                    _arg_1.dispatchEventWith("added", true);
                    if (stage)
                    {
                        _local_3 = (_arg_1 as DisplayObjectContainer);
                        if (_local_3)
                        {
                            _local_3.broadcastEventWith("addedToStage");
                        }
                        else
                        {
                            _arg_1.dispatchEventWith("addedToStage");
                        };
                    };
                };
                return (_arg_1);
            };
            throw (new RangeError("Invalid child index"));
        }

        public function removeChild(_arg_1:DisplayObject, _arg_2:Boolean=false):DisplayObject
        {
            var _local_3:int = getChildIndex(_arg_1);
            if (_local_3 != -1)
            {
                removeChildAt(_local_3, _arg_2);
            };
            return (_arg_1);
        }

        public function removeChildAt(_arg_1:int, _arg_2:Boolean=false):DisplayObject
        {
            var _local_3:* = null;
            var _local_4:* = null;
            if (((_arg_1 >= 0) && (_arg_1 < mChildren.length)))
            {
                _local_3 = mChildren[_arg_1];
                _local_3.dispatchEventWith("removed", true);
                if (stage)
                {
                    _local_4 = (_local_3 as DisplayObjectContainer);
                    if (_local_4)
                    {
                        _local_4.broadcastEventWith("removedFromStage");
                    }
                    else
                    {
                        _local_3.dispatchEventWith("removedFromStage");
                    };
                };
                _local_3.setParent(null);
                _arg_1 = mChildren.indexOf(_local_3);
                if (_arg_1 >= 0)
                {
                    spliceChildren(_arg_1, 1);
                };
                if (_arg_2)
                {
                    _local_3.dispose();
                };
                return (_local_3);
            };
            throw (new RangeError("Invalid child index"));
        }

        public function removeChildren(_arg_1:int=0, _arg_2:int=-1, _arg_3:Boolean=false):void
        {
            var _local_4:int;
            if (((_arg_2 < 0) || (_arg_2 >= numChildren)))
            {
                _arg_2 = (numChildren - 1);
            };
            _local_4 = _arg_1;
            while (_local_4 <= _arg_2)
            {
                removeChildAt(_arg_1, _arg_3);
                _local_4++;
            };
        }

        public function getChildAt(_arg_1:int):DisplayObject
        {
            var _local_2:int = mChildren.length;
            if (_arg_1 < 0)
            {
                _arg_1 = (_local_2 + _arg_1);
            };
            if (((_arg_1 >= 0) && (_arg_1 < _local_2)))
            {
                return (mChildren[_arg_1]);
            };
            throw (new RangeError("Invalid child index"));
        }

        public function getChildByName(_arg_1:String):DisplayObject
        {
            var _local_3:int;
            var _local_2:int = mChildren.length;
            _local_3 = 0;
            while (_local_3 < _local_2)
            {
                if (mChildren[_local_3].name == _arg_1)
                {
                    return (mChildren[_local_3]);
                };
                _local_3++;
            };
            return (null);
        }

        public function getChildIndex(_arg_1:DisplayObject):int
        {
            return (mChildren.indexOf(_arg_1));
        }

        public function setChildIndex(_arg_1:DisplayObject, _arg_2:int):void
        {
            var _local_3:int = getChildIndex(_arg_1);
            if (_local_3 == _arg_2)
            {
                return;
            };
            if (_local_3 == -1)
            {
                throw (new ArgumentError("Not a child of this container"));
            };
            spliceChildren(_local_3, 1);
            spliceChildren(_arg_2, 0, _arg_1);
        }

        public function swapChildren(_arg_1:DisplayObject, _arg_2:DisplayObject):void
        {
            var _local_3:int = getChildIndex(_arg_1);
            var _local_4:int = getChildIndex(_arg_2);
            if (((_local_3 == -1) || (_local_4 == -1)))
            {
                throw (new ArgumentError("Not a child of this container"));
            };
            swapChildrenAt(_local_3, _local_4);
        }

        public function swapChildrenAt(_arg_1:int, _arg_2:int):void
        {
            var _local_3:DisplayObject = getChildAt(_arg_1);
            var _local_4:DisplayObject = getChildAt(_arg_2);
            mChildren[_arg_1] = _local_4;
            mChildren[_arg_2] = _local_3;
        }

        public function sortChildren(_arg_1:Function):void
        {
            sSortBuffer.length = mChildren.length;
            mergeSort(mChildren, _arg_1, 0, mChildren.length, sSortBuffer);
            sSortBuffer.length = 0;
        }

        public function contains(_arg_1:DisplayObject):Boolean
        {
            while (_arg_1)
            {
                if (_arg_1 == this)
                {
                    return (true);
                };
                _arg_1 = _arg_1.parent;
            };
            return (false);
        }

        override public function getBounds(_arg_1:DisplayObject, _arg_2:Rectangle=null):Rectangle
        {
            var _local_6:Number;
            var _local_8:Number;
            var _local_7:int;
            if (_arg_2 == null)
            {
                _arg_2 = new Rectangle();
            };
            var _local_4:int = mChildren.length;
            if (_local_4 == 0)
            {
                getTransformationMatrix(_arg_1, sHelperMatrix);
                MatrixUtil.transformCoords(sHelperMatrix, 0, 0, sHelperPoint);
                _arg_2.setTo(sHelperPoint.x, sHelperPoint.y, 0, 0);
            }
            else
            {
                if (_local_4 == 1)
                {
                    mChildren[0].getBounds(_arg_1, _arg_2);
                }
                else
                {
                    _local_6 = 1.79769313486232E308;
                    var _local_5:* = -1.79769313486232E308;
                    _local_8 = 1.79769313486232E308;
                    var _local_3:* = -1.79769313486232E308;
                    _local_7 = 0;
                    while (_local_7 < _local_4)
                    {
                        mChildren[_local_7].getBounds(_arg_1, _arg_2);
                        if (_local_6 > _arg_2.x)
                        {
                            _local_6 = _arg_2.x;
                        };
                        if (_local_5 < _arg_2.right)
                        {
                            _local_5 = _arg_2.right;
                        };
                        if (_local_8 > _arg_2.y)
                        {
                            _local_8 = _arg_2.y;
                        };
                        if (_local_3 < _arg_2.bottom)
                        {
                            _local_3 = _arg_2.bottom;
                        };
                        _local_7++;
                    };
                    _arg_2.setTo(_local_6, _local_8, (_local_5 - _local_6), (_local_3 - _local_8));
                };
            };
            return (_arg_2);
        }

        override public function hitTest(_arg_1:Point, _arg_2:Boolean=false):DisplayObject
        {
            var _local_8:int;
            var _local_3:* = null;
            if (((_arg_2) && ((!(visible)) || (!(touchable)))))
            {
                return (null);
            };
            if (!hitTestMask(_arg_1))
            {
                return (null);
            };
            var _local_6:DisplayObject;
            var _local_4:Number = _arg_1.x;
            var _local_5:Number = _arg_1.y;
            var _local_7:int = mChildren.length;
            _local_8 = (_local_7 - 1);
            while (_local_8 >= 0)
            {
                _local_3 = mChildren[_local_8];
                if (!_local_3.isMask)
                {
                    sHelperMatrix.copyFrom(_local_3.transformationMatrix);
                    sHelperMatrix.invert();
                    MatrixUtil.transformCoords(sHelperMatrix, _local_4, _local_5, sHelperPoint);
                    _local_6 = _local_3.hitTest(sHelperPoint, _arg_2);
                    if (_local_6)
                    {
                        return (((_arg_2) && (mTouchGroup)) ? this : _local_6);
                    };
                };
                _local_8--;
            };
            return (null);
        }

        override public function render(_arg_1:RenderSupport, _arg_2:Number):void
        {
            var _local_9:int;
            var _local_3:* = null;
            var _local_8:* = null;
            var _local_6:* = null;
            var _local_5:Number = (_arg_2 * this.alpha);
            var _local_7:int = mChildren.length;
            var _local_4:String = _arg_1.blendMode;
            _local_9 = 0;
            while (_local_9 < _local_7)
            {
                _local_3 = mChildren[_local_9];
                if (_local_3.hasVisibleArea)
                {
                    _local_8 = _local_3.filter;
                    _local_6 = _local_3.mask;
                    _arg_1.pushMatrix();
                    _arg_1.transformMatrix(_local_3);
                    _arg_1.blendMode = _local_3.blendMode;
                    if (_local_6)
                    {
                        _arg_1.pushMask(_local_6);
                    };
                    if (_local_8)
                    {
                        _local_8.render(_local_3, _arg_1, _local_5);
                    }
                    else
                    {
                        _local_3.render(_arg_1, _local_5);
                    };
                    if (_local_6)
                    {
                        _arg_1.popMask();
                    };
                    _arg_1.blendMode = _local_4;
                    _arg_1.popMatrix();
                };
                _local_9++;
            };
        }

        public function broadcastEvent(_arg_1:Event):void
        {
            var _local_4:int;
            if (_arg_1.bubbles)
            {
                throw (new ArgumentError("Broadcast of bubbling events is prohibited"));
            };
            var _local_2:int = sBroadcastListeners.length;
            getChildEventListeners(this, _arg_1.type, sBroadcastListeners);
            var _local_3:int = sBroadcastListeners.length;
            _local_4 = _local_2;
            while (_local_4 < _local_3)
            {
                sBroadcastListeners[_local_4].dispatchEvent(_arg_1);
                _local_4++;
            };
            sBroadcastListeners.length = _local_2;
        }

        public function broadcastEventWith(_arg_1:String, _arg_2:Object=null):void
        {
            var _local_3:Event = Event.starling_internal::fromPool(_arg_1, false, _arg_2);
            broadcastEvent(_local_3);
            Event.starling_internal::toPool(_local_3);
        }

        public function get numChildren():int
        {
            return (mChildren.length);
        }

        public function get touchGroup():Boolean
        {
            return (mTouchGroup);
        }

        public function set touchGroup(_arg_1:Boolean):void
        {
            mTouchGroup = _arg_1;
        }

        private function spliceChildren(_arg_1:int, _arg_2:uint=0xFFFFFFFF, _arg_3:DisplayObject=null):void
        {
            var _local_10:int;
            var _local_6:Vector.<DisplayObject> = mChildren;
            var _local_8:uint = _local_6.length;
            if (_arg_1 < 0)
            {
                _arg_1 = (_arg_1 + _local_8);
            };
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            }
            else
            {
                if (_arg_1 > _local_8)
                {
                    _arg_1 = _local_8;
                };
            };
            if ((_arg_1 + _arg_2) > _local_8)
            {
                _arg_2 = (_local_8 - _arg_1);
            };
            var _local_7:int = ((_arg_3) ? 1 : 0);
            var _local_9:int = (_local_7 - _arg_2);
            var _local_5:uint = (_local_8 + _local_9);
            var _local_4:int = ((_local_8 - _arg_1) - _arg_2);
            if (_local_9 < 0)
            {
                _local_10 = (_arg_1 + _local_7);
                while (_local_4)
                {
                    _local_6[_local_10] = _local_6[(_local_10 - _local_9)];
                    _local_4--;
                    _local_10++;
                };
                _local_6.length = _local_5;
            }
            else
            {
                if (_local_9 > 0)
                {
                    _local_10 = 1;
                    while (_local_4)
                    {
                        _local_6[(_local_5 - _local_10)] = _local_6[(_local_8 - _local_10)];
                        _local_4--;
                        _local_10++;
                    };
                    _local_6.length = _local_5;
                };
            };
            if (_arg_3)
            {
                _local_6[_arg_1] = _arg_3;
            };
        }

        internal function getChildEventListeners(_arg_1:DisplayObject, _arg_2:String, _arg_3:Vector.<DisplayObject>):void
        {
            var _local_5:*;
            var _local_6:int;
            var _local_7:int;
            var _local_4:DisplayObjectContainer = (_arg_1 as DisplayObjectContainer);
            if (_arg_1.hasEventListener(_arg_2))
            {
                _arg_3[_arg_3.length] = _arg_1;
            };
            if (_local_4)
            {
                _local_5 = _local_4.mChildren;
                _local_6 = _local_5.length;
                _local_7 = 0;
                while (_local_7 < _local_6)
                {
                    getChildEventListeners(_local_5[_local_7], _arg_2, _arg_3);
                    _local_7++;
                };
            };
        }


    }
}//package starling.display

