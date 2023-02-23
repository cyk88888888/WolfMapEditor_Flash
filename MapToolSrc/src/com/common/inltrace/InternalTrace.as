// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.common.inltrace.InternalTrace

package com.common.inltrace
{
    import flash.display.Sprite;
    import flash.filters.GlowFilter;
    import flash.display.Stage;
    import flash.text.TextField;
    import flash.events.Event;
    import flash.utils.getTimer;
    import flash.net.FileReference;
    import flash.utils.setTimeout;
    import flash.events.KeyboardEvent;
    import flash.geom.Point;
    import flash.display.DisplayObject;
    import flash.utils.getQualifiedClassName;

    public class InternalTrace extends Sprite 
    {

        private static const ShowNum:int = 400;

        private static var _gf1Arr:Array = [new GlowFilter(16737996, 1, 18, 18, 3, 1)];
        private static var _gf2Arr:Array = [new GlowFilter(6737151, 1, 18, 18, 3, 1)];
        private static var _select:BtnSP;
        private static var _stage:Stage;
        private static var _cacheMsg:Object = {};
        private static var _showIdx:String;
        private static var _sp:Sprite = new Sprite();
        private static var _tf:TextField;
        private static var _stopUpdate:Boolean = false;
        private static var _dragXY:BtnSP;
        private static var _dragWH:BtnSP;
        private static var _tempShow:Array;
        public static var loadInfo:Array = [];
        private static var showW:int = 0;
        private static var showH:int = 0;
        public static var lastTimer:uint = 0;
        public static var idx:uint = 0;
        public static var all:Array = [];
        private static var timeout:uint = 0;


        public static function init(_arg_1:Stage):void
        {
            var _local_2:* = null;
            if (_stage != null)
            {
                return;
            };
            _stage = _arg_1;
            _tf = new TextField();
            _tf.x = 20;
            _tf.y = 40;
            _tf.border = true;
            _tf.defaultTextFormat = BtnSP.tfm;
            var _local_4:Object = TraceConfig.Cache;
            var _local_7:int = 20;
            var _local_5:BtnSP;
            for (var _local_3:String in _local_4)
            {
                _local_2 = new BtnSP(((_local_3 + ".") + _local_4[_local_3]), _local_7, 10, onBtnClickFun);
                if (_local_5 == null)
                {
                    _local_5 = _local_2;
                };
                _local_7 = ((_local_7 + _sp.addChild(_local_2).width) + 20);
            };
            _local_7 = ((_local_7 + _sp.addChild(new BtnSP("保存", _local_7, 10, onBtnClickFun)).width) + 20);
            _local_7 = ((_local_7 + _sp.addChild(new BtnSP("清除", _local_7, 10, onBtnClickFun)).width) + 20);
            _local_7 = ((_local_7 + _sp.addChild(new BtnSP("关闭(F2)", _local_7, 10, onBtnClickFun)).width) + 20);
            _local_7 = ((_local_7 + _sp.addChild(new BtnSP("隐藏S", _local_7, 10, onBtnClickFun)).width) + 20);
            _local_7 = (((_local_7 + _sp.addChild(new BtnSP("停止自更新", (_local_7 + 200), 10, onBtnClickFun)).width) + 20) + 200);
            var _local_6:TextField = new TextField();
            _local_6.defaultTextFormat = BtnSP.tfm;
            _local_6.text = "用鼠标滚轮或者拖选文本内容来滚动显示内容";
            _local_6.x = _local_7;
            _local_6.y = 15;
            _local_6.width = (_local_6.textWidth + 20);
            _local_6.filters = [new GlowFilter(0, 1, 2, 2, 3)];
            _sp.x = 20;
            _sp.y = 20;
            _sp.addChild(_tf);
            _sp.addChild(_local_6);
            _sp.addChild((_dragWH = new BtnSP("拖动大小", 1300, 750, new Function())));
            _sp.addChild((_dragXY = new BtnSP("拖动位置", 700, 750, new Function())));
            _dragWH.addEventListener("mouseDown", onDragWH);
            _dragXY.addEventListener("mouseDown", onDragXY);
            _arg_1.addEventListener("mouseUp", onDragUp);
            _arg_1.addEventListener("keyUp", onHotKey);
            if (_local_5)
            {
                onBtnClickFun(_local_5.label, _local_5);
            };
        }

        private static function onDragWH(_arg_1:Event):void
        {
            _stage.addEventListener("enterFrame", onDragEnterFrameWH);
        }

        private static function onDragXY(_arg_1:Event):void
        {
            _sp.startDrag();
        }

        private static function onDragUp(_arg_1:Event):void
        {
            _sp.stopDrag();
            _stage.removeEventListener("enterFrame", onDragEnterFrameWH);
        }

        private static function onDragEnterFrameWH(_arg_1:Event):void
        {
            showW = _sp.mouseX;
            showH = _sp.mouseY;
            if (showW < 300)
            {
                showW = 300;
            };
            if (showH < 300)
            {
                showH = 300;
            };
            show(true);
        }

        public static function addMsg(_arg_1:int, _arg_2:String, _arg_3:Boolean=false):void
        {
            if (((_stage == null) && (!(_arg_3))))
            {
                return;
            };
            var _local_5:int = getTimer();
            if (lastTimer == _local_5)
            {
                idx++;
            }
            else
            {
                idx = 0;
            };
            lastTimer = _local_5;
            var _local_6:String = ((padString(_local_5.toString(), 6, "0") + "_") + idx.toString());
            var _local_8:* = ((_cacheMsg[_arg_1]) || ([]));
            _cacheMsg[_arg_1] = _local_8;
            var _local_4:Array = _local_8;
            var _local_7:String = ((_local_6 + ":  ") + _arg_2);
            _local_4.push(_local_7);
            all.push(_local_7);
            if (((!(_showIdx == null)) && (_showIdx == _arg_1)))
            {
                _tempShow.push(_local_7);
                if (_tempShow.length > 400)
                {
                    _tempShow.shift();
                };
                showIdx = _showIdx;
            };
        }

        public static function clear(_arg_1:*):void
        {
            all.length = 0;
            _cacheMsg[_arg_1] = [];
            if (_arg_1 == _showIdx)
            {
                _tempShow.length = 0;
            };
            showIdx = _arg_1;
        }

        public static function show(_arg_1:Boolean=false):void
        {
            var _local_2:* = null;
            if (_stage == null)
            {
                return;
            };
            if (((!(_sp.stage == null)) && (_arg_1 == false)))
            {
                close();
                return;
            };
            if (showW == 0)
            {
                showW = (_stage.stageWidth - 40);
            };
            if (showH == 0)
            {
                showH = (_stage.stageHeight - 40);
            };
            if (_sp.stage == null)
            {
                _stage.addChild(_sp);
            };
            _sp.graphics.clear();
            _sp.graphics.lineStyle(2, 0xFF9900);
            _sp.graphics.beginFill(0xCCCCCC);
            _sp.graphics.drawRect(0, 0, showW, showH);
            _tf.width = (showW - 40);
            _tf.height = (showH - 90);
            showIdx = _showIdx;
            _dragWH.x = (showW - 100);
            var _local_4:int = (showH - 30);
            _dragWH.y = _local_4;
            _dragXY.x = ((showW >> 1) - 50);
            _dragXY.y = _local_4;
            var _local_3:int = _sp.numChildren;
            while (_local_3 > 0)
            {
                _local_2 = _sp.getChildAt(--_local_3);
                if ((_local_2.x + _local_2.width) > showW)
                {
                    _local_2.visible = false;
                }
                else
                {
                    _local_2.visible = true;
                };
            };
        }

        private static function close():void
        {
            if (_sp.parent != null)
            {
                _sp.parent.removeChild(_sp);
            };
        }

        private static function onBtnClickFun(_arg_1:String, _arg_2:BtnSP=null):void
        {
            var _local_6:int;
            var _local_4:* = null;
            if (_arg_1 == "清除")
            {
                if (_arg_2.ctrl)
                {
                    for (var _local_5:String in _cacheMsg)
                    {
                        _cacheMsg[_local_5] = [];
                    };
                };
                clear(_showIdx);
                return;
            };
            if (_arg_1 == "关闭(F2)")
            {
                close();
                return;
            };
            if (_arg_1 == "隐藏S")
            {
                _local_6 = _stage.numChildren;
                while (_local_6 > 0)
                {
                    if (_stage.getChildAt(--_local_6) != _sp)
                    {
                        _stage.getChildAt(_local_6).visible = false;
                    };
                };
                return;
            };
            if (_arg_1 == "停止自更新")
            {
                _stopUpdate = (!(_stopUpdate));
                return;
            };
            if (_arg_1 == "保存")
            {
                save(_arg_2);
                return;
            };
            if (_arg_2 != null)
            {
                if (_select != null)
                {
                    _select.filters = null;
                    _select = null;
                };
                _arg_2.filters = _gf1Arr;
                _select = _arg_2;
                _stopUpdate = false;
            };
            var _local_3:String = _arg_1.split(".")[0];
            if (_local_3 != _showIdx)
            {
                _local_4 = ((_cacheMsg[_local_3]) || ([]));
                if (_local_4.length < 400)
                {
                    _tempShow = _local_4.slice();
                }
                else
                {
                    _tempShow = _local_4.slice((_local_4.length - 400), _local_4.length);
                };
            };
            _showIdx = _local_3;
            showIdx = _showIdx;
        }

        private static function save(_arg_1:BtnSP):void
        {
            var _local_2:* = null;
            var _local_3:FileReference = new FileReference();
            _local_2 = all.join("\n");
            _local_3.save(_local_2, (_select.label + ".txt"));
        }

        private static function set showIdx(_arg_1:String):void
        {
            if (_sp.stage == null)
            {
                return;
            };
            if (_stopUpdate == true)
            {
                return;
            };
            if (timeout == 0)
            {
                timeout = setTimeout(flushText, 1);
            };
        }

        private static function flushText():void
        {
            timeout = 0;
            _tf.text = (_tempShow.join("\n") + "\n");
            _tf.scrollH = 0;
            _tf.scrollV = _tf.maxScrollV;
        }

        private static function onHotKey(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == 113)
            {
                show();
            }
            else
            {
                if (_arg_1.ctrlKey)
                {
                    switch (_arg_1.keyCode)
                    {
                        case 120:
                            if (_arg_1.altKey)
                            {
                                objUnderMouse(_stage, printUIPath);
                            }
                            else
                            {
                                objUnderMouse(_stage, printParent);
                            };
                        default:
                    };
                };
            };
        }

        private static function padString(_arg_1:String, _arg_2:int, _arg_3:String="0"):String
        {
            var _local_5:int;
            if (_arg_3 == null)
            {
                return (_arg_1);
            };
            var _local_4:Array = [];
            _local_5 = 0;
            while (_local_5 < (Math.abs(_arg_2) - _arg_1.length))
            {
                _local_4.push(_arg_3);
                _local_5++;
            };
            if (_arg_2 < 0)
            {
                _local_4.unshift(_arg_1);
            }
            else
            {
                _local_4.push(_arg_1);
            };
            return (_local_4.join(""));
        }

        private static function objUnderMouse(_arg_1:Stage, _arg_2:Function):void
        {
            traceInl1("===============");
            var _local_4:Array = _arg_1.getObjectsUnderPoint(new Point(_arg_1.mouseX, _arg_1.mouseY));
            for each (var _local_3:DisplayObject in _local_4)
            {
                (_arg_2(_local_3));
            };
        }

        private static function printUIPath(_arg_1:DisplayObject):String
        {
            var _local_4:* = null;
            var _local_3:* = null;
            var _local_2:String = "";
            do 
            {
                _local_4 = getQualifiedClassName(_arg_1);
                if (_local_4.indexOf("::") != -1)
                {
                    _local_4 = _local_4.substr((_local_4.indexOf("::") + 2));
                };
                _local_3 = _arg_1.name;
                if (((_local_3 == null) || (_local_3.match(/instance[0-9]+/g).length == 1)))
                {
                    _local_2 = ((("C:" + _local_4) + "|") + _local_2);
                }
                else
                {
                    _local_2 = ((("I:" + _local_3) + "|") + _local_2);
                };
                if (_local_4 == "DebugSprite") break;
                _arg_1 = _arg_1.parent;
            } while (_arg_1);
            traceInl1(_local_2);
            return (_local_2);
        }

        private static function printParent(_arg_1:DisplayObject):String
        {
            var _local_3:* = null;
            var _local_2:String = (getDspId(_arg_1) + (((_arg_1.visible == false) || (_arg_1.alpha == 0)) ? "=FALSE" : "=TRUE"));
            while (_arg_1.parent)
            {
                _arg_1 = _arg_1.parent;
                _local_3 = getDspId(_arg_1);
                if (_local_3 == "inst:Stage") break;
                _local_2 = ((_local_3 + "/") + _local_2);
            };
            traceInl1(_local_2);
            return (_local_2);
        }

        private static function getDspId(_arg_1:DisplayObject):String
        {
            var _local_3:String = getQualifiedClassName(_arg_1);
            if (_local_3.indexOf("::") != -1)
            {
                _local_3 = _local_3.substr((_local_3.indexOf("::") + 2));
            };
            var _local_2:String = _arg_1.name;
            if (((_local_2 == null) || (_local_2.match(/instance[0-9]+/g).length == 1)))
            {
                _local_2 = "inst";
            };
            return ((_local_2 + ":") + _local_3);
        }


    }
}//package com.common.inltrace

