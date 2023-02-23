// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.greensock.TweenLite

package com.greensock
{
    import com.greensock.core.Animation;
    import com.greensock.easing.Ease;
    import flash.display.Shape;
    import flash.utils.Dictionary;
    import com.greensock.core.PropTween;
    import flash.events.Event;

    public class TweenLite extends Animation 
    {

        public static const version:String = "12.1.5";

        public static var defaultEase:Ease = new Ease(null, null, 1, 1);
        public static var defaultOverwrite:String = "auto";
        public static var ticker:Shape = Animation.ticker;
        public static var _plugins:Object = {};
        public static var _onPluginEvent:Function;
        protected static var _tweenLookup:Dictionary = new Dictionary(false);
        protected static var _reservedProps:Object = {
            "ease":1,
            "delay":1,
            "overwrite":1,
            "onComplete":1,
            "onCompleteParams":1,
            "onCompleteScope":1,
            "useFrames":1,
            "runBackwards":1,
            "startAt":1,
            "onUpdate":1,
            "onUpdateParams":1,
            "onUpdateScope":1,
            "onStart":1,
            "onStartParams":1,
            "onStartScope":1,
            "onReverseComplete":1,
            "onReverseCompleteParams":1,
            "onReverseCompleteScope":1,
            "onRepeat":1,
            "onRepeatParams":1,
            "onRepeatScope":1,
            "easeParams":1,
            "yoyo":1,
            "onCompleteListener":1,
            "onUpdateListener":1,
            "onStartListener":1,
            "onReverseCompleteListener":1,
            "onRepeatListener":1,
            "orientToBezier":1,
            "immediateRender":1,
            "repeat":1,
            "repeatDelay":1,
            "data":1,
            "paused":1,
            "reversed":1
        };
        protected static var _overwriteLookup:Object;
        public static var cbTypes:Object = {};

        public var target:Object;
        public var ratio:Number;
        public var _propLookup:Object;
        public var _firstPT:PropTween;
        protected var _targets:Array;
        public var _ease:Ease;
        protected var _easeType:int;
        protected var _easePower:int;
        protected var _siblings:Array;
        protected var _overwrite:int;
        protected var _overwrittenProps:Object;
        protected var _notifyPluginsOfEnabled:Boolean;
        protected var _startAt:TweenLite;

        public function TweenLite(_arg_1:Object, _arg_2:Number, _arg_3:Object)
        {
            var _local_4:int;
            super(_arg_2, _arg_3);
            if (_arg_1 == null)
            {
                throw (new Error(((("Cannot tween a null object. Duration: " + _arg_2) + ", data: ") + this.data)));
            };
            if (!_overwriteLookup)
            {
                _overwriteLookup = {
                    "none":0,
                    "all":1,
                    "auto":2,
                    "concurrent":3,
                    "allOnStart":4,
                    "preexisting":5,
                    "true":1,
                    "false":0
                };
                ticker.addEventListener("enterFrame", _dumpGarbage, false, -1, true);
            };
            ratio = 0;
            this.target = _arg_1;
            _ease = defaultEase;
            _overwrite = (("overwrite" in this.vars) ? ((typeof(this.vars.overwrite) === "number") ? (this.vars.overwrite >> 0) : _overwriteLookup[this.vars.overwrite]) : _overwriteLookup[defaultOverwrite]);
            if (((this.target is Array) && (typeof(this.target[0]) === "object")))
            {
                _targets = this.target.concat();
                _propLookup = [];
                _siblings = [];
                _local_4 = _targets.length;
                while (--_local_4 > -1)
                {
                    _siblings[_local_4] = _register(_targets[_local_4], this, false);
                    if (_overwrite == 1)
                    {
                        if (_siblings[_local_4].length > 1)
                        {
                            _applyOverwrite(_targets[_local_4], this, null, 1, _siblings[_local_4]);
                        };
                    };
                };
            }
            else
            {
                _propLookup = {};
                _siblings = _tweenLookup[_arg_1];
                if (_siblings == null)
                {
                    var _local_5:* = [this];
                    _tweenLookup[_arg_1] = _local_5;
                    _siblings = _local_5;
                }
                else
                {
                    _siblings[_siblings.length] = this;
                    if (_overwrite == 1)
                    {
                        _applyOverwrite(_arg_1, this, null, 1, _siblings);
                    };
                };
            };
            if (((this.vars.immediateRender) || (((_arg_2 == 0) && (_delay == 0)) && (!(this.vars.immediateRender == false)))))
            {
                render(-(_delay), false, true);
            };
        }

        public static function containsSelf(_arg_1:Object):Boolean
        {
            var _local_2:int;
            _local_2 = 0;
            while (_local_2 < _arg_1.length)
            {
                if ((_arg_1[_local_2] is String))
                {
                    if (_arg_1[_local_2].indexOf("{self}") != -1)
                    {
                        return (true);
                    };
                };
                _local_2++;
            };
            return (false);
        }

        public static function to(_arg_1:Object, _arg_2:Number, _arg_3:Object):TweenLite
        {
            return (new TweenLite(_arg_1, _arg_2, _arg_3));
        }

        public static function from(_arg_1:Object, _arg_2:Number, _arg_3:Object):TweenLite
        {
            _arg_3 = _prepVars(_arg_3, true);
            _arg_3.runBackwards = true;
            return (new TweenLite(_arg_1, _arg_2, _arg_3));
        }

        public static function fromTo(_arg_1:Object, _arg_2:Number, _arg_3:Object, _arg_4:Object):TweenLite
        {
            _arg_4 = _prepVars(_arg_4, true);
            _arg_3 = _prepVars(_arg_3);
            _arg_4.startAt = _arg_3;
            _arg_4.immediateRender = ((!(_arg_4.immediateRender == false)) && (!(_arg_3.immediateRender == false)));
            return (new TweenLite(_arg_1, _arg_2, _arg_4));
        }

        protected static function _prepVars(_arg_1:Object, _arg_2:Boolean=false):Object
        {
            if (_arg_1._isGSVars)
            {
                _arg_1 = _arg_1.vars;
            };
            if (((_arg_2) && (!("immediateRender" in _arg_1))))
            {
                _arg_1.immediateRender = true;
            };
            return (_arg_1);
        }

        public static function delayedCall(_arg_1:Number, _arg_2:Function, _arg_3:Array=null, _arg_4:Boolean=false):TweenLite
        {
            return (new TweenLite(_arg_2, 0, {
                "delay":_arg_1,
                "onComplete":_arg_2,
                "onCompleteParams":_arg_3,
                "onReverseComplete":_arg_2,
                "onReverseCompleteParams":_arg_3,
                "immediateRender":false,
                "useFrames":_arg_4,
                "overwrite":0
            }));
        }

        public static function set(_arg_1:Object, _arg_2:Object):TweenLite
        {
            return (new TweenLite(_arg_1, 0, _arg_2));
        }

        private static function _dumpGarbage(_arg_1:Event):void
        {
            var _local_2:* = null;
            var _local_3:* = null;
            if (((_rootFrame / 60) >> 0) === (_rootFrame / 60))
            {
                for (_local_2 in _tweenLookup)
                {
                    _local_3 = _tweenLookup[_local_2];
                    removeGc(_local_3);
                    if (_local_3.length === 0)
                    {
                        delete _tweenLookup[_local_2];
                    };
                };
            };
        }

        private static function removeGc(_arg_1:Array):void
        {
            var _local_2:*;
            var _local_3:int;
            _local_3 = _arg_1.length;
            while (--_local_3 > -1)
            {
                _local_2 = _arg_1.shift();
                if (!_local_2._gc)
                {
                    _arg_1.push(_local_2);
                };
            };
        }

        public static function killTweensOf(_arg_1:*, _arg_2:*=false, _arg_3:Object=null):void
        {
            var _local_4:* = null;
            if (typeof(_arg_2) === "object")
            {
                _arg_3 = _arg_2;
                _arg_2 = false;
            };
            _local_4 = TweenLite.getTweensOf(_arg_1, _arg_2);
            var _local_5:int = _local_4.length;
            while (--_local_5 > -1)
            {
                _local_4[_local_5]._kill(_arg_3, _arg_1);
            };
        }

        public static function killDelayedCallsTo(_arg_1:Function):void
        {
            killTweensOf(_arg_1);
        }

        public static function getTweensOf(_arg_1:*, _arg_2:Boolean=false):Array
        {
            var _local_3:* = null;
            var _local_6:int;
            var _local_4:* = null;
            var _local_5:int;
            if ((((_arg_1 is Array) && (!(typeof(_arg_1[0]) == "string"))) && (!(typeof(_arg_1[0]) == "number"))))
            {
                _local_5 = _arg_1.length;
                _local_3 = [];
                while (--_local_5 > -1)
                {
                    _local_3 = _local_3.concat(getTweensOf(_arg_1[_local_5], _arg_2));
                };
                _local_5 = _local_3.length;
                while (--_local_5 > -1)
                {
                    _local_4 = _local_3[_local_5];
                    _local_6 = _local_5;
                    while (--_local_6 > -1)
                    {
                        if (_local_4 === _local_3[_local_6])
                        {
                            _local_3.splice(_local_5, 1);
                        };
                    };
                };
            }
            else
            {
                _local_3 = _register(_arg_1).concat();
                _local_5 = _local_3.length;
                while (--_local_5 > -1)
                {
                    if (((_local_3[_local_5]._gc) || ((_arg_2) && (!(_local_3[_local_5].isActive())))))
                    {
                        _local_3.splice(_local_5, 1);
                    };
                };
            };
            return (_local_3);
        }

        protected static function _register(_arg_1:Object, _arg_2:TweenLite=null, _arg_3:Boolean=false):Array
        {
            var _local_5:int;
            var _local_4:Array = _tweenLookup[_arg_1];
            if (_local_4 == null)
            {
                var _local_6:* = [];
                _tweenLookup[_arg_1] = _local_6;
                _local_4 = _local_6;
            };
            if (_arg_2)
            {
                _local_5 = _local_4.length;
                _local_4[_local_5] = _arg_2;
                if (_arg_3)
                {
                    while (--_local_5 > -1)
                    {
                        if (_local_4[_local_5] === _arg_2)
                        {
                            removeAt(_local_4, _local_5);
                        };
                    };
                };
            };
            return (_local_4);
        }

        public static function removeAt(_arg_1:*, _arg_2:uint):void
        {
            var _local_3:Function = _arg_1["removeAt"];
            if (_local_3)
            {
                (_arg_1["removeAt"](_arg_2));
            }
            else
            {
                _arg_1.splice(_arg_2, 1);
            };
        }

        protected static function _applyOverwrite(_arg_1:Object, _arg_2:TweenLite, _arg_3:Object, _arg_4:int, _arg_5:Array):Boolean
        {
            var _local_14:Boolean;
            var _local_6:* = null;
            var _local_7:int;
            var _local_8:int;
            var _local_10:Number;
            if (((_arg_4 == 1) || (_arg_4 >= 4)))
            {
                _local_8 = _arg_5.length;
                _local_7 = 0;
                while (_local_7 < _local_8)
                {
                    _local_6 = _arg_5[_local_7];
                    if (_local_6 != _arg_2)
                    {
                        if (!_local_6._gc)
                        {
                            if (_local_6._enabled(false, false))
                            {
                                _local_14 = true;
                            };
                        };
                    }
                    else
                    {
                        if (_arg_4 == 5) break;
                    };
                    _local_7++;
                };
                return (_local_14);
            };
            var _local_13:Number = (_arg_2._startTime + 1E-10);
            var _local_12:Array = [];
            var _local_9:int;
            var _local_11:* = (_arg_2._duration == 0);
            _local_7 = _arg_5.length;
            while (--_local_7 > -1)
            {
                _local_6 = _arg_5[_local_7];
                if (!(((_local_6 === _arg_2) || (_local_6._gc)) || (_local_6._paused)))
                {
                    if (_local_6._timeline != _arg_2._timeline)
                    {
                        _local_10 = ((_local_10) || (_checkOverlap(_arg_2, 0, _local_11)));
                        if (_checkOverlap(_local_6, _local_10, _local_11) === 0)
                        {
                            _local_12[_local_9++] = _local_6;
                        };
                    }
                    else
                    {
                        if (_local_6._startTime <= _local_13)
                        {
                            if ((_local_6._startTime + (_local_6.totalDuration() / _local_6._timeScale)) > _local_13)
                            {
                                if (!(((_local_11) || (!(_local_6._initted))) && ((_local_13 - _local_6._startTime) <= 2E-10)))
                                {
                                    _local_12[_local_9++] = _local_6;
                                };
                            };
                        };
                    };
                };
            };
            _local_7 = _local_9;
            while (--_local_7 > -1)
            {
                _local_6 = _local_12[_local_7];
                if (_arg_4 == 2)
                {
                    if (_local_6._kill(_arg_3, _arg_1))
                    {
                        _local_14 = true;
                    };
                };
                if (((!(_arg_4 === 2)) || ((!(_local_6._firstPT)) && (_local_6._initted))))
                {
                    if (_local_6._enabled(false, false))
                    {
                        _local_14 = true;
                    };
                };
            };
            return (_local_14);
        }

        private static function _checkOverlap(_arg_1:Animation, _arg_2:Number, _arg_3:Boolean):Number
        {
            var _local_6:* = null;
            _local_6 = _arg_1._timeline;
            var _local_7:Number = _local_6._timeScale;
            var _local_5:Number = _arg_1._startTime;
            var _local_4:* = 1E-10;
            while (_local_6._timeline)
            {
                _local_5 = (_local_5 + _local_6._startTime);
                _local_7 = (_local_7 * _local_6._timeScale);
                if (_local_6._paused)
                {
                    return (-100);
                };
                _local_6 = _local_6._timeline;
            };
            _local_5 = (_local_5 / _local_7);
            return ((_local_5 > _arg_2) ? (_local_5 - _arg_2) : ((((_arg_3) && (_local_5 == _arg_2)) || ((!(_arg_1._initted)) && ((_local_5 - _arg_2) < (2 * _local_4)))) ? _local_4 : ((_local_5 = (_local_5 + ((_arg_1.totalDuration() / _arg_1._timeScale) / _local_7))), ((_local_5 > (_arg_2 + _local_4)) ? 0 : ((_local_5 - _arg_2) - _local_4)))));
        }


        protected function _init():void
        {
            var _local_5:int;
            var _local_2:Boolean;
            var _local_3:* = null;
            var _local_1:* = null;
            var _local_6:* = null;
            var _local_4:Boolean = vars.immediateRender;
            if (vars.startAt)
            {
                if (_startAt != null)
                {
                    _startAt.render(-1, true);
                };
                vars.startAt.overwrite = 0;
                vars.startAt.immediateRender = true;
                _startAt = new TweenLite(target, 0, vars.startAt);
                if (_local_4)
                {
                    if (_time > 0)
                    {
                        _startAt = null;
                    }
                    else
                    {
                        if (_duration !== 0)
                        {
                            return;
                        };
                    };
                };
            }
            else
            {
                if (((vars.runBackwards) && (!(_duration === 0))))
                {
                    if (_startAt != null)
                    {
                        _startAt.render(-1, true);
                        _startAt = null;
                    }
                    else
                    {
                        _local_6 = {};
                        for (_local_1 in vars)
                        {
                            if (!(_local_1 in _reservedProps))
                            {
                                _local_6[_local_1] = vars[_local_1];
                            };
                        };
                        _local_6.overwrite = 0;
                        _local_6.data = "isFromStart";
                        _startAt = TweenLite.to(target, 0, _local_6);
                        if (!_local_4)
                        {
                            _startAt.render(-1, true);
                        }
                        else
                        {
                            if (_time === 0)
                            {
                                return;
                            };
                        };
                    };
                };
            };
            if ((vars.ease is Ease))
            {
                _ease = ((vars.easeParams is Array) ? vars.ease.config.apply(vars.ease, vars.easeParams) : vars.ease);
            }
            else
            {
                if (typeof(vars.ease) === "function")
                {
                    _ease = new Ease(vars.ease, vars.easeParams);
                }
                else
                {
                    _ease = defaultEase;
                };
            };
            _easeType = _ease._type;
            _easePower = _ease._power;
            _firstPT = null;
            if (_targets)
            {
                _local_5 = _targets.length;
                while (--_local_5 > -1)
                {
                    var _local_8:* = {};
                    _propLookup[_local_5] = _local_8;
                    if (_initProps(_targets[_local_5], _local_8, _siblings[_local_5], ((_overwrittenProps) ? _overwrittenProps[_local_5] : null)))
                    {
                        _local_2 = true;
                    };
                };
            }
            else
            {
                _local_2 = _initProps(target, _propLookup, _siblings, _overwrittenProps);
            };
            if (_local_2)
            {
                (_onPluginEvent("_onInitAllProps", this));
            };
            if (_overwrittenProps)
            {
                if (_firstPT == null)
                {
                    if (typeof(target) !== "function")
                    {
                        _enabled(false, false);
                    };
                };
            };
            if (vars.runBackwards)
            {
                _local_3 = _firstPT;
                while (_local_3)
                {
                    _local_3.s = (_local_3.s + _local_3.c);
                    _local_3.c = -(_local_3.c);
                    _local_3 = _local_3._next;
                };
            };
            _onUpdate = vars.onUpdate;
            _initted = true;
        }

        protected function _initProps(_arg_1:Object, _arg_2:Object, _arg_3:Array, _arg_4:Object):Boolean
        {
            var _local_5:* = null;
            var _local_9:int;
            var _local_7:Boolean;
            var _local_8:* = null;
            var _local_6:* = null;
            var _local_10:Object = this.vars;
            if (_arg_1 == null)
            {
                return (false);
            };
            for (_local_5 in _local_10)
            {
                _local_6 = _local_10[_local_5];
                if ((_local_5 in _reservedProps))
                {
                    if ((_local_6 is Array))
                    {
                        if (containsSelf(_local_6))
                        {
                            _local_10[_local_5] = _swapSelfInParams((_local_6 as Array));
                        };
                    };
                }
                else
                {
                    if (((_local_5 in _plugins) && ((_local_8 = new (_plugins[_local_5])())._onInitTween(_arg_1, _local_6, this))))
                    {
                        _firstPT = new PropTween(_local_8, "setRatio", 0, 1, _local_5, true, _firstPT, _local_8._priority);
                        _local_9 = _local_8._overwriteProps.length;
                        while (--_local_9 > -1)
                        {
                            _arg_2[_local_8._overwriteProps[_local_9]] = _firstPT;
                        };
                        if (((_local_8._priority) || ("_onInitAllProps" in _local_8)))
                        {
                            _local_7 = true;
                        };
                        if ((("_onDisable" in _local_8) || ("_onEnable" in _local_8)))
                        {
                            _notifyPluginsOfEnabled = true;
                        };
                    }
                    else
                    {
                        var _local_11:* = new PropTween(_arg_1, _local_5, 0, 1, _local_5, false, _firstPT);
                        _arg_2[_local_5] = _local_11;
                        _firstPT = _local_11;
                        _firstPT.s = ((_firstPT.f) ? _arg_1[(((_local_5.indexOf("set")) || (!(("get" + _local_5.substr(3)) in _arg_1))) ? _local_5 : ("get" + _local_5.substr(3)))]() : _arg_1[_local_5]);
                        _firstPT.c = ((typeof(_local_6) === "number") ? (_local_6 - _firstPT.s) : (((typeof(_local_6) === "string") && (_local_6.charAt(1) === "=")) ? (Number(_local_6.charAt(0) + "1") * _local_6.substr(2)) : ((_local_6) || (0))));
                    };
                };
            };
            if (_arg_4)
            {
                if (_kill(_arg_4, _arg_1))
                {
                    return (_initProps(_arg_1, _arg_2, _arg_3, _arg_4));
                };
            };
            if (_overwrite > 1)
            {
                if (_firstPT != null)
                {
                    if (_arg_3.length > 1)
                    {
                        if (_applyOverwrite(_arg_1, this, _arg_2, _overwrite, _arg_3))
                        {
                            _kill(_arg_2, _arg_1);
                            return (_initProps(_arg_1, _arg_2, _arg_3, _arg_4));
                        };
                    };
                };
            };
            return (_local_7);
        }

        override public function render(_arg_1:Number, _arg_2:Boolean=false, _arg_3:Boolean=false):void
        {
            var _local_8:* = null;
            var _local_5:* = null;
            var _local_6:Number;
            var _local_10:Boolean;
            var _local_4:Number;
            var _local_7:* = null;
            var _local_9:Number = _time;
            if (_arg_1 >= _duration)
            {
                _totalTime = (_time = _duration);
                ratio = ((_ease._calcEnd) ? _ease.getRatio(1) : 1);
                if (!_reversed)
                {
                    _local_10 = true;
                    _local_8 = "onComplete";
                };
                if (_duration == 0)
                {
                    _local_6 = _rawPrevTime;
                    if (_startTime === _timeline._duration)
                    {
                        _arg_1 = 0;
                    };
                    if ((((_arg_1 === 0) || (_local_6 < 0)) || (_local_6 === _tinyNum)))
                    {
                        if (_local_6 !== _arg_1)
                        {
                            _arg_3 = true;
                            if (((_local_6 > 0) && (!(_local_6 === _tinyNum))))
                            {
                                _local_8 = "onReverseComplete";
                            };
                        };
                    };
                    _local_6 = ((((!(_arg_2)) || (!(_arg_1 === 0))) || (_rawPrevTime === _arg_1)) ? _arg_1 : _tinyNum);
                    _rawPrevTime = _local_6;
                };
            }
            else
            {
                if (_arg_1 < 1E-7)
                {
                    _totalTime = (_time = 0);
                    ratio = ((_ease._calcEnd) ? _ease.getRatio(0) : 0);
                    if (((!(_local_9 === 0)) || (((_duration === 0) && (_rawPrevTime > 0)) && (!(_rawPrevTime === _tinyNum)))))
                    {
                        _local_8 = "onReverseComplete";
                        _local_10 = _reversed;
                    };
                    if (_arg_1 < 0)
                    {
                        _active = false;
                        if (_duration == 0)
                        {
                            if (_rawPrevTime >= 0)
                            {
                                _arg_3 = true;
                            };
                            _local_6 = ((((!(_arg_2)) || (!(_arg_1 === 0))) || (_rawPrevTime === _arg_1)) ? _arg_1 : _tinyNum);
                            _rawPrevTime = _local_6;
                        };
                    }
                    else
                    {
                        if (!_initted)
                        {
                            _arg_3 = true;
                        };
                    };
                }
                else
                {
                    _totalTime = (_time = _arg_1);
                    if (_easeType)
                    {
                        _local_4 = (_arg_1 / _duration);
                        if (((_easeType == 1) || ((_easeType == 3) && (_local_4 >= 0.5))))
                        {
                            _local_4 = (1 - _local_4);
                        };
                        if (_easeType == 3)
                        {
                            _local_4 = (_local_4 * 2);
                        };
                        if (_easePower == 1)
                        {
                            _local_4 = (_local_4 * _local_4);
                        }
                        else
                        {
                            if (_easePower == 2)
                            {
                                _local_4 = (_local_4 * (_local_4 * _local_4));
                            }
                            else
                            {
                                if (_easePower == 3)
                                {
                                    _local_4 = (_local_4 * ((_local_4 * _local_4) * _local_4));
                                }
                                else
                                {
                                    if (_easePower == 4)
                                    {
                                        _local_4 = (_local_4 * (((_local_4 * _local_4) * _local_4) * _local_4));
                                    };
                                };
                            };
                        };
                        if (_easeType == 1)
                        {
                            ratio = (1 - _local_4);
                        }
                        else
                        {
                            if (_easeType == 2)
                            {
                                ratio = _local_4;
                            }
                            else
                            {
                                if ((_arg_1 / _duration) < 0.5)
                                {
                                    ratio = (_local_4 / 2);
                                }
                                else
                                {
                                    ratio = (1 - (_local_4 / 2));
                                };
                            };
                        };
                    }
                    else
                    {
                        ratio = _ease.getRatio((_arg_1 / _duration));
                    };
                };
            };
            if (((_time == _local_9) && (!(_arg_3))))
            {
                return;
            };
            if (!_initted)
            {
                _init();
                if (((!(_initted)) || (_gc)))
                {
                    return;
                };
                if (((_time) && (!(_local_10))))
                {
                    ratio = _ease.getRatio((_time / _duration));
                }
                else
                {
                    if (((_local_10) && (_ease._calcEnd)))
                    {
                        ratio = _ease.getRatio(((_time === 0) ? 0 : 1));
                    };
                };
            };
            if (!_active)
            {
                if ((((!(_paused)) && (!(_time === _local_9))) && (_arg_1 >= 0)))
                {
                    _active = true;
                };
            };
            if (_local_9 == 0)
            {
                if (_startAt != null)
                {
                    if (_arg_1 >= 0)
                    {
                        _startAt.render(_arg_1, _arg_2, _arg_3);
                    }
                    else
                    {
                        if (!_local_8)
                        {
                            _local_8 = "_dummyGS";
                        };
                    };
                };
                if (vars.onStart)
                {
                    if (((!(_time == 0)) || (_duration == 0)))
                    {
                        if (!_arg_2)
                        {
                            vars.onStart.apply(null, vars.onStartParams);
                        };
                    };
                };
            };
            _local_5 = _firstPT;
            while (_local_5)
            {
                if (_local_5.f)
                {
                    (_local_5.t[_local_5.p](((_local_5.c * ratio) + _local_5.s)));
                }
                else
                {
                    _local_5.t[_local_5.p] = ((_local_5.c * ratio) + _local_5.s);
                };
                _local_5 = _local_5._next;
            };
            if (_onUpdate != null)
            {
                if ((((_arg_1 < 0) && (!(_startAt == null))) && (!(_startTime == 0))))
                {
                    _startAt.render(_arg_1, _arg_2, _arg_3);
                };
                if (!_arg_2)
                {
                    if (((!(_time === _local_9)) || (_local_10)))
                    {
                        _onUpdate.apply(null, vars.onUpdateParams);
                    };
                };
            };
            if (_local_8)
            {
                if (!_gc)
                {
                    if (((((_arg_1 < 0) && (!(_startAt == null))) && (_onUpdate == null)) && (!(_startTime == 0))))
                    {
                        _startAt.render(_arg_1, _arg_2, _arg_3);
                    };
                    if (_local_10)
                    {
                        if (_timeline.autoRemoveChildren)
                        {
                            _enabled(false, false);
                        };
                        _active = false;
                    };
                    if (!_arg_2)
                    {
                        if (vars[_local_8])
                        {
                            _local_7 = cbTypes[_local_8];
                            if (_local_7 == null)
                            {
                                var _local_11:* = (_local_8 + "Params");
                                cbTypes[_local_8] = _local_11;
                                _local_7 = _local_11;
                            };
                            vars[_local_8].apply(null, vars[_local_7]);
                        };
                    };
                    if ((((_duration === 0) && (_rawPrevTime === _tinyNum)) && (!(_local_6 === _tinyNum))))
                    {
                        _rawPrevTime = 0;
                    };
                };
            };
        }

        override public function _kill(_arg_1:Object=null, _arg_2:Object=null):Boolean
        {
            var _local_5:* = null;
            var _local_3:* = null;
            var _local_4:* = null;
            var _local_8:* = null;
            var _local_10:Boolean;
            var _local_9:* = null;
            var _local_6:Boolean;
            var _local_7:int;
            if (_arg_1 === "all")
            {
                _arg_1 = null;
            };
            if (_arg_1 == null)
            {
                if (((_arg_2 == null) || (_arg_2 == this.target)))
                {
                    return (_enabled(false, false));
                };
            };
            _arg_2 = (((_arg_2) || (_targets)) || (this.target));
            if (((_arg_2 is Array) && (typeof(_arg_2[0]) === "object")))
            {
                _local_7 = _arg_2.length;
                while (--_local_7 > -1)
                {
                    if (_kill(_arg_1, _arg_2[_local_7]))
                    {
                        _local_10 = true;
                    };
                };
            }
            else
            {
                if (_targets)
                {
                    _local_7 = _targets.length;
                    while (--_local_7 > -1)
                    {
                        if (_arg_2 === _targets[_local_7])
                        {
                            _local_8 = ((_propLookup[_local_7]) || ({}));
                            _overwrittenProps = ((_overwrittenProps) || ([]));
                            var _local_11:* = ((_arg_1) ? ((_overwrittenProps[_local_7]) || ({})) : "all");
                            _overwrittenProps[_local_7] = _local_11;
                            _local_5 = _local_11;
                            break;
                        };
                    };
                }
                else
                {
                    if (_arg_2 !== this.target)
                    {
                        return (false);
                    };
                    _local_8 = _propLookup;
                    _local_5 = (_overwrittenProps = ((_arg_1) ? ((_overwrittenProps) || ({})) : "all"));
                };
                if (_local_8)
                {
                    _local_9 = ((_arg_1) || (_local_8));
                    _local_6 = ((((!(_arg_1 == _local_5)) && (!(_local_5 == "all"))) && (!(_arg_1 == _local_8))) && ((!(typeof(_arg_1) == "object")) || (!(_arg_1._tempKill == true))));
                    for (_local_3 in _local_9)
                    {
                        _local_4 = _local_8[_local_3];
                        if (_local_4 != null)
                        {
                            if (((_local_4.pg) && (_local_4.t._kill(_local_9))))
                            {
                                _local_10 = true;
                            };
                            if (((!(_local_4.pg)) || (_local_4.t._overwriteProps.length === 0)))
                            {
                                if (_local_4._prev)
                                {
                                    _local_4._prev._next = _local_4._next;
                                }
                                else
                                {
                                    if (_local_4 == _firstPT)
                                    {
                                        _firstPT = _local_4._next;
                                    };
                                };
                                if (_local_4._next)
                                {
                                    _local_4._next._prev = _local_4._prev;
                                };
                                _local_11 = null;
                                _local_4._prev = _local_11;
                                _local_4._next = _local_11;
                            };
                            delete _local_8[_local_3];
                        };
                        if (_local_6)
                        {
                            _local_5[_local_3] = 1;
                        };
                    };
                    if (((_firstPT == null) && (_initted)))
                    {
                        _enabled(false, false);
                    };
                };
            };
            return (_local_10);
        }

        override public function invalidate():*
        {
            if (_notifyPluginsOfEnabled)
            {
                (_onPluginEvent("_onDisable", this));
            };
            _firstPT = null;
            _overwrittenProps = null;
            _onUpdate = null;
            _startAt = null;
            _initted = (_active = (_notifyPluginsOfEnabled = false));
            _propLookup = ((_targets) ? {} : []);
            return (this);
        }

        override public function _enabled(_arg_1:Boolean, _arg_2:Boolean=false):Boolean
        {
            var _local_3:int;
            if (((_arg_1) && (_gc)))
            {
                if (_targets)
                {
                    _local_3 = _targets.length;
                    while (--_local_3 > -1)
                    {
                        _siblings[_local_3] = _register(_targets[_local_3], this, true);
                    };
                }
                else
                {
                    _siblings = _register(target, this, true);
                };
            };
            super._enabled(_arg_1, _arg_2);
            if (_notifyPluginsOfEnabled)
            {
                if (_firstPT != null)
                {
                    return (_onPluginEvent(((_arg_1) ? "_onEnable" : "_onDisable"), this));
                };
            };
            return (false);
        }


    }
}//package com.greensock

