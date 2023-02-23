// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.animation.Juggler

package starling.animation
{
    import __AS3__.vec.Vector;
    import starling.events.EventDispatcher;
    import starling.core.starling_internal;
    import starling.events.Event;

    use namespace starling_internal;

    public class Juggler implements IAnimatable 
    {

        private var mObjects:Vector.<IAnimatable>;
        private var mElapsedTime:Number;

        public function Juggler()
        {
            mElapsedTime = 0;
            mObjects = new Vector.<IAnimatable>(0);
        }

        public function add(_arg_1:IAnimatable):void
        {
            var _local_2:* = null;
            if (((_arg_1) && (mObjects.indexOf(_arg_1) == -1)))
            {
                mObjects[mObjects.length] = _arg_1;
                _local_2 = (_arg_1 as EventDispatcher);
                if (_local_2)
                {
                    _local_2.addEventListener("removeFromJuggler", onRemove);
                };
            };
        }

        public function contains(_arg_1:IAnimatable):Boolean
        {
            return (!(mObjects.indexOf(_arg_1) == -1));
        }

        public function remove(_arg_1:IAnimatable):void
        {
            if (_arg_1 == null)
            {
                return;
            };
            var _local_3:EventDispatcher = (_arg_1 as EventDispatcher);
            if (_local_3)
            {
                _local_3.removeEventListener("removeFromJuggler", onRemove);
            };
            var _local_2:int = mObjects.indexOf(_arg_1);
            if (_local_2 != -1)
            {
                mObjects[_local_2] = null;
            };
        }

        public function removeTweens(_arg_1:Object):void
        {
            var _local_3:int;
            var _local_2:* = null;
            if (_arg_1 == null)
            {
                return;
            };
            _local_3 = (mObjects.length - 1);
            while (_local_3 >= 0)
            {
                _local_2 = (mObjects[_local_3] as Tween);
                if (((_local_2) && (_local_2.target == _arg_1)))
                {
                    _local_2.removeEventListener("removeFromJuggler", onRemove);
                    mObjects[_local_3] = null;
                };
                _local_3--;
            };
        }

        public function containsTweens(_arg_1:Object):Boolean
        {
            var _local_3:int;
            var _local_2:* = null;
            if (_arg_1 == null)
            {
                return (false);
            };
            _local_3 = (mObjects.length - 1);
            while (_local_3 >= 0)
            {
                _local_2 = (mObjects[_local_3] as Tween);
                if (((_local_2) && (_local_2.target == _arg_1)))
                {
                    return (true);
                };
                _local_3--;
            };
            return (false);
        }

        public function purge():void
        {
            var _local_2:int;
            var _local_1:* = null;
            _local_2 = (mObjects.length - 1);
            while (_local_2 >= 0)
            {
                _local_1 = (mObjects[_local_2] as EventDispatcher);
                if (_local_1)
                {
                    _local_1.removeEventListener("removeFromJuggler", onRemove);
                };
                mObjects[_local_2] = null;
                _local_2--;
            };
        }

        public function delayCall(_arg_1:Function, _arg_2:Number, ... _args):IAnimatable
        {
            if (_arg_1 == null)
            {
                return (null);
            };
            var _local_4:DelayedCall = DelayedCall.starling_internal::fromPool(_arg_1, _arg_2, _args);
            _local_4.addEventListener("removeFromJuggler", onPooledDelayedCallComplete);
            add(_local_4);
            return (_local_4);
        }

        public function repeatCall(_arg_1:Function, _arg_2:Number, _arg_3:int=0, ... _args):IAnimatable
        {
            if (_arg_1 == null)
            {
                return (null);
            };
            var _local_5:DelayedCall = DelayedCall.starling_internal::fromPool(_arg_1, _arg_2, _args);
            _local_5.repeatCount = _arg_3;
            _local_5.addEventListener("removeFromJuggler", onPooledDelayedCallComplete);
            add(_local_5);
            return (_local_5);
        }

        private function onPooledDelayedCallComplete(_arg_1:Event):void
        {
            DelayedCall.starling_internal::toPool((_arg_1.target as DelayedCall));
        }

        public function tween(_arg_1:Object, _arg_2:Number, _arg_3:Object):IAnimatable
        {
            var _local_5:* = null;
            if (_arg_1 == null)
            {
                throw (new ArgumentError("target must not be null"));
            };
            var _local_4:Tween = Tween.starling_internal::fromPool(_arg_1, _arg_2);
            for (var _local_6:String in _arg_3)
            {
                _local_5 = _arg_3[_local_6];
                if (_local_4.hasOwnProperty(_local_6))
                {
                    _local_4[_local_6] = _local_5;
                }
                else
                {
                    if (_arg_1.hasOwnProperty(Tween.getPropertyName(_local_6)))
                    {
                        _local_4.animate(_local_6, (_local_5 as Number));
                    }
                    else
                    {
                        throw (new ArgumentError(("Invalid property: " + _local_6)));
                    };
                };
            };
            _local_4.addEventListener("removeFromJuggler", onPooledTweenComplete);
            add(_local_4);
            return (_local_4);
        }

        private function onPooledTweenComplete(_arg_1:Event):void
        {
            Tween.starling_internal::toPool((_arg_1.target as Tween));
        }

        public function advanceTime(_arg_1:Number):void
        {
            var _local_5:int;
            var _local_3:* = null;
            var _local_4:int = mObjects.length;
            var _local_2:int;
            mElapsedTime = (mElapsedTime + _arg_1);
            if (_local_4 == 0)
            {
                return;
            };
            _local_5 = 0;
            while (_local_5 < _local_4)
            {
                _local_3 = mObjects[_local_5];
                if (_local_3)
                {
                    if (_local_2 != _local_5)
                    {
                        mObjects[_local_2] = _local_3;
                        mObjects[_local_5] = null;
                    };
                    _local_3.advanceTime(_arg_1);
                    _local_2++;
                };
                _local_5++;
            };
            if (_local_2 != _local_5)
            {
                _local_4 = mObjects.length;
                while (_local_5 < _local_4)
                {
                    mObjects[_local_2++] = mObjects[_local_5++];
                };
                mObjects.length = _local_2;
            };
        }

        private function onRemove(_arg_1:Event):void
        {
            remove((_arg_1.target as IAnimatable));
            var _local_2:Tween = (_arg_1.target as Tween);
            if (((_local_2) && (_local_2.isComplete)))
            {
                add(_local_2.nextTween);
            };
        }

        public function get elapsedTime():Number
        {
            return (mElapsedTime);
        }

        protected function get objects():Vector.<IAnimatable>
        {
            return (mObjects);
        }


    }
}//package starling.animation

