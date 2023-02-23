// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.plugins.TweenPlugin

package com.greensock.plugins
{
    import com.greensock.core.PropTween;
    import com.greensock.TweenLite;

    public class TweenPlugin 
    {

        public static const version:String = "12.1.5";
        public static const API:Number = 2;

        public var _propName:String;
        public var _overwriteProps:Array;
        public var _priority:int = 0;
        protected var _firstPT:PropTween;

        public function TweenPlugin(_arg_1:String="", _arg_2:int=0)
        {
            _overwriteProps = _arg_1.split(",");
            _propName = _overwriteProps[0];
            _priority = ((_arg_2) || (0));
        }

        private static function _onTweenEvent(_arg_1:String, _arg_2:TweenLite):Boolean
        {
            var _local_7:Boolean;
            var _local_6:* = null;
            var _local_5:* = null;
            var _local_3:* = null;
            var _local_8:* = null;
            var _local_4:PropTween = _arg_2._firstPT;
            if (_arg_1 == "_onInitAllProps")
            {
                while (_local_4)
                {
                    _local_3 = _local_4._next;
                    _local_8 = _local_6;
                    while (((_local_8) && (_local_8.pr > _local_4.pr)))
                    {
                        _local_8 = _local_8._next;
                    };
                    var _local_9:* = ((_local_8) ? _local_8._prev : _local_5);
                    _local_4._prev = _local_9;
                    if (_local_9)
                    {
                        _local_4._prev._next = _local_4;
                    }
                    else
                    {
                        _local_6 = _local_4;
                    };
                    _local_9 = _local_8;
                    _local_4._next = _local_9;
                    if (_local_9)
                    {
                        _local_8._prev = _local_4;
                    }
                    else
                    {
                        _local_5 = _local_4;
                    };
                    _local_4 = _local_3;
                };
                _local_9 = _local_6;
                _arg_2._firstPT = _local_9;
                _local_4 = _local_9;
            };
            while (_local_4)
            {
                if (_local_4.pg)
                {
                    if ((_arg_1 in _local_4.t))
                    {
                        if (_local_4.t[_arg_1]())
                        {
                            _local_7 = true;
                        };
                    };
                };
                _local_4 = _local_4._next;
            };
            return (_local_7);
        }

        public static function activate(_arg_1:Array):Boolean
        {
            TweenLite._onPluginEvent = TweenPlugin._onTweenEvent;
            var _local_2:int = _arg_1.length;
            while (--_local_2 > -1)
            {
                if (_arg_1[_local_2].API == 2)
                {
                    TweenLite._plugins[new ((_arg_1[_local_2] as Class))()._propName] = _arg_1[_local_2];
                };
            };
            return (true);
        }


        public function _onInitTween(_arg_1:Object, _arg_2:*, _arg_3:TweenLite):Boolean
        {
            return (false);
        }

        protected function _addTween(_arg_1:Object, _arg_2:String, _arg_3:Number, _arg_4:*, _arg_5:String=null, _arg_6:Boolean=false):PropTween
        {
            var _local_7:Number = ((_arg_4 == null) ? 0 : (((typeof(_arg_4) === "number") || (!(_arg_4.charAt(1) === "="))) ? (_arg_4 - _arg_3) : (Number(_arg_4.charAt(0) + "1") * _arg_4.substr(2))));
            if (_local_7 !== 0)
            {
                _firstPT = new PropTween(_arg_1, _arg_2, _arg_3, _local_7, ((_arg_5) || (_arg_2)), false, _firstPT);
                _firstPT.r = _arg_6;
                return (_firstPT);
            };
            return (null);
        }

        public function setRatio(_arg_1:Number):void
        {
            var _local_2:Number;
            var _local_3:PropTween = _firstPT;
            while (_local_3)
            {
                _local_2 = ((_local_3.c * _arg_1) + _local_3.s);
                if (_local_3.r)
                {
                    _local_2 = ((_local_2 + ((_local_2 > 0) ? 0.5 : -0.5)) | 0x00);
                };
                if (_local_3.f)
                {
                    (_local_3.t[_local_3.p](_local_2));
                }
                else
                {
                    _local_3.t[_local_3.p] = _local_2;
                };
                _local_3 = _local_3._next;
            };
        }

        public function _roundProps(_arg_1:Object, _arg_2:Boolean=true):void
        {
            var _local_3:PropTween = _firstPT;
            while (_local_3)
            {
                if (((_propName in _arg_1) || ((!(_local_3.n == null)) && (_local_3.n.split((_propName + "_")).join("") in _arg_1))))
                {
                    _local_3.r = _arg_2;
                };
                _local_3 = _local_3._next;
            };
        }

        public function _kill(_arg_1:Object):Boolean
        {
            var _local_3:int;
            if ((_propName in _arg_1))
            {
                _overwriteProps = [];
            }
            else
            {
                _local_3 = _overwriteProps.length;
                while (--_local_3 > -1)
                {
                    if ((_overwriteProps[_local_3] in _arg_1))
                    {
                        _overwriteProps.splice(_local_3, 1);
                    };
                };
            };
            var _local_2:PropTween = _firstPT;
            while (_local_2)
            {
                if ((_local_2.n in _arg_1))
                {
                    if (_local_2._next)
                    {
                        _local_2._next._prev = _local_2._prev;
                    };
                    if (_local_2._prev)
                    {
                        _local_2._prev._next = _local_2._next;
                        _local_2._prev = null;
                    }
                    else
                    {
                        if (_firstPT == _local_2)
                        {
                            _firstPT = _local_2._next;
                        };
                    };
                };
                _local_2 = _local_2._next;
            };
            return (false);
        }


    }
}//package com.greensock.plugins

