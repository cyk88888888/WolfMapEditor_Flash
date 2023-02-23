// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.common.util.KeyMgr

package com.common.util
{
    import flash.utils.Dictionary;
    import flash.display.Stage;
    import flash.events.MouseEvent;
    import flash.events.KeyboardEvent;
    import flash.display.InteractiveObject;
    import flash.text.TextField;
    import core.utils.DbgUtil;

    public class KeyMgr 
    {

        public static const CTRL:int = -2147483648;
        public static const SHIFT:int = 0x40000000;
        public static const ALT:int = 0x20000000;

        private static var _instance:KeyMgr;

        private var _keyDict:Object = {};
        private var keyDownFuns:Dictionary;
        private var hotKeyMap:Dictionary;
        private var keyUpMap:Dictionary;
        private var targetMap:Dictionary;
        public var enable:Boolean;
        private var stage:Stage;

        public function KeyMgr(_arg_1:SingletonEnforcer)
        {
        }

        public static function getInstance():KeyMgr
        {
            if (!_instance)
            {
                _instance = new KeyMgr(new SingletonEnforcer());
            };
            return (_instance);
        }


        public function init(_arg_1:Stage):void
        {
            this.stage = _arg_1;
            keyDownFuns = new Dictionary();
            hotKeyMap = new Dictionary();
            keyUpMap = new Dictionary();
            targetMap = new Dictionary();
            _arg_1.addEventListener("keyUp", keyUpHandler, false, 2147483647);
            _arg_1.addEventListener("keyDown", keyDownHandler, false, 2147483647);
            _arg_1.addEventListener("mouseDown", onMouseDown, false, 2147483647);
            _arg_1.addEventListener("mouseUp", onMouseUp, false, 2147483647);
        }

        private function onMouseUp(_arg_1:MouseEvent):void
        {
            updateKeyFromMouseEvent(_arg_1);
        }

        private function updateKeyFromKeyEvent(_arg_1:KeyboardEvent):void
        {
            ((_arg_1.ctrlKey) ? setKeyDown(17) : setKeyUp(17));
            ((_arg_1.altKey) ? setKeyDown(18) : setKeyUp(18));
            ((_arg_1.shiftKey) ? setKeyDown(16) : setKeyUp(16)); //not popped
        }

        private function updateKeyFromMouseEvent(_arg_1:MouseEvent):void
        {
            ((_arg_1.ctrlKey) ? setKeyDown(17) : setKeyUp(17));
            ((_arg_1.altKey) ? setKeyDown(18) : setKeyUp(18));
            ((_arg_1.shiftKey) ? setKeyDown(16) : setKeyUp(16)); //not popped
        }

        private function onMouseDown(_arg_1:MouseEvent):void
        {
            updateKeyFromMouseEvent(_arg_1);
        }

        public function removeKeyStatus(_arg_1:int=-1):void
        {
            if (_arg_1 != -1)
            {
                if (_keyDict[_arg_1] != undefined)
                {
                    _keyDict[_arg_1] = false;
                };
            }
            else
            {
                for (var _local_2:String in _keyDict)
                {
                    _keyDict[_local_2] = false;
                };
            };
        }

        public function setKeyDown(_arg_1:uint):void
        {
            _keyDict[_arg_1] = true;
        }

        private function setKeyUp(_arg_1:uint):void
        {
            _keyDict[_arg_1] = false;
        }

        public function isDown(_arg_1:uint):Boolean
        {
            return ((_keyDict[_arg_1]) ? true : false);
        }

        public function setHotKey(_arg_1:uint, _arg_2:Function):void
        {
            hotKeyMap[_arg_1] = _arg_2;
        }

        public function onKeyDown(_arg_1:uint, _arg_2:Function):void
        {
            keyDownFuns[_arg_1] = _arg_2;
        }

        public function addKeyUpFun(_arg_1:Function):void
        {
            keyUpMap[_arg_1] = _arg_1;
        }

        public function removeKeyUpFun(_arg_1:Function):void
        {
            keyUpMap[_arg_1] = null;
        }

        public function keyTriggerButton(_arg_1:uint, _arg_2:InteractiveObject):void
        {
            targetMap[_arg_1] = _arg_2;
        }

        protected function keyDownHandler(_arg_1:KeyboardEvent):void
        {
            updateKeyFromKeyEvent(_arg_1);
            var _local_2:uint = _arg_1.keyCode;
            setKeyDown(_local_2);
            if (!enable)
            {
                return;
            };
            if (((stage.focus is TextField) && ((stage.focus as TextField).type == "input")))
            {
                return;
            };
            if (_local_2 != 16)
            {
                DbgUtil.nop();
            };
            var _local_5:Function = keyDownFuns[_local_2];
            if (_local_5 != null)
            {
                _local_5(_local_2); //not popped
                return;
            };
            var _local_3:uint = mergeKeyCode(_arg_1);
            var _local_4:Function = hotKeyMap[_local_3];
            if (_local_4 != null)
            {
                (_local_4());
                EventUtil.swallowEvent(_arg_1);
            };
        }

        protected function keyUpHandler(_arg_1:KeyboardEvent):void
        {
            var _local_4:int;
            updateKeyFromKeyEvent(_arg_1);
            var _local_2:uint = _arg_1.keyCode;
            setKeyUp(_local_2);
            if (!enable)
            {
                return;
            };
            if (((stage.focus is TextField) && ((stage.focus as TextField).type == "input")))
            {
                return;
            };
            for each (var _local_5:Function in keyUpMap)
            {
                if ((_local_5 is Function))
                {
                    (_local_5(_local_2));
                };
            };
            var _local_3:uint = mergeKeyCode(_arg_1);
            for (var _local_6:String in targetMap)
            {
                _local_4 = parseInt(_local_6);
                if (_local_4 == _local_3)
                {
                    ((targetMap[_local_2]) && ((targetMap[_local_2] as InteractiveObject).dispatchEvent(new MouseEvent("click"))));
                };
            };
        }

        private function mergeKeyCode(_arg_1:KeyboardEvent):uint
        {
            var _local_2:uint = _arg_1.keyCode;
            var _local_3:* = _local_2;
            if (_arg_1.altKey)
            {
                _local_3 = (_local_3 | 0x20000000);
            };
            if (_arg_1.ctrlKey)
            {
                _local_3 = (_local_3 | 0x80000000);
            };
            if (_arg_1.shiftKey)
            {
                _local_3 = (_local_3 | 0x40000000);
            };
            return (_local_3);
        }


    }
}//package com.common.util

class SingletonEnforcer 
{


}


