// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.ui.UIComp

package framework.ui
{
    import fairygui.GComponent;
    import flash.utils.Dictionary;
    import fairygui.UIPackage;
    import flash.events.Event;
    import __AS3__.vec.Vector;
    import fairygui.GObject;
    import framework.mgr.ModuleMgr;
    import framework.base.BaseUT;
    import framework.base.Global;

    public class UIComp extends GComponent 
    {

        public var view:GComponent;
        private var _oldParent:GComponent;
        public var __data:Object = null;
        private var isFirstEnter:Boolean = true;
        public var hasDestory:Boolean = false;
        private var needCreateView:Boolean = true;
        private var childCompDic:Dictionary;
        private var _msgHandler:Object = {};
        private var _objTapMap:Dictionary;

        public function UIComp()
        {
            ctor_b();
            ctor();
            ctor_a();
            this.addEventListener("addedToStage", oAddtoStage);
        }

        protected function get pkgName():String
        {
            return ("");
        }

        protected function ctor_b():void
        {
        }

        protected function ctor():void
        {
        }

        protected function ctor_a():void
        {
        }

        protected function onEnter_b():void
        {
        }

        protected function onEnter():void
        {
        }

        protected function onFirstEnter():void
        {
        }

        protected function onEnter_a():void
        {
        }

        protected function dchg():void
        {
        }

        protected function onExit_b():void
        {
        }

        protected function onExit():void
        {
        }

        protected function onExit_a():void
        {
        }

        private function oAddtoStage(_arg_1:Event):void
        {
            this.removeEventListener("addedToStage", oAddtoStage);
            if (!needCreateView)
            {
                return;
            };
            _oldParent = parent;
            if (pkgName == "")
            {
                throw (new Error("请先在对应界面重写pkgName和compName字段！！！"));
            };
            var _local_2:GComponent = UIPackage.createObject(pkgName, className).asCom;
            addChild(_local_2);
            setView(_local_2);
        }

        public function setView(_arg_1:GComponent):void
        {
            view = _arg_1;
            setSize(view.viewWidth, view.viewHeight);
            __doEnter();
        }

        public function __doEnter():void
        {
            (trace(("进入" + className)));
            onEnter_b();
            onEnter();
            if (isFirstEnter)
            {
                isFirstEnter = false;
                onFirstEnter();
            };
            onEnter_a();
            InitProperty();
        }

        protected function InitProperty():void
        {
            var _local_6:int;
            var _local_4:* = null;
            var _local_2:* = null;
            var _local_3:*;
            var _local_1:* = null;
            var _local_5:Vector.<GObject> = view.getChildren();
            if (childCompDic == null)
            {
                childCompDic = new Dictionary();
            };
            if (_objTapMap == null)
            {
                _objTapMap = new Dictionary();
            };
            _local_6 = 0;
            while (_local_6 < _local_5.length)
            {
                _local_4 = _local_5[_local_6];
                if (((_local_4 is GComponent) && (_local_4.packageItem)))
                {
                    _local_2 = _local_4.name;
                    if (hasOwnProperty(("_tap_" + _local_2)))
                    {
                        _local_4.addClickListener(this[("_tap_" + _local_2)]);
                        _objTapMap[("_tap_" + _local_2)] = _local_4;
                    };
                    _local_3 = ModuleMgr.allLayerMap[_local_4.packageItem.name];
                    if (_local_3 != null)
                    {
                        if (!childCompDic[_local_4.name])
                        {
                            _local_1 = BaseUT.createClassByName(_local_3);
                            _local_1.name = (_local_2 + "_script");
                            _local_1.needCreateView = false;
                            childCompDic[_local_4.name] = _local_1;
                        };
                        _local_1.setView((_local_4 as GComponent));
                    };
                };
                _local_6++;
            };
        }

        public function get className():String
        {
            return (BaseUT.getClassNameByObj(this));
        }

        protected function emit(_arg_1:String, _arg_2:Object=null):void
        {
            Global.emmiter.emit(_arg_1, _arg_2);
        }

        protected function onEmitter(_arg_1:String, _arg_2:Function):void
        {
            _msgHandler[_arg_1] = _arg_2;
            Global.emmiter.onEmitter(_arg_1, _arg_2);
        }

        protected function unEmitter(_arg_1:String):void
        {
            delete _msgHandler[_arg_1];
            Global.emmiter.un(_arg_1);
        }

        private function unAll():void
        {
            for (var _local_1:String in _msgHandler)
            {
                delete _msgHandler[_local_1];
                unEmitter(_local_1);
            };
        }

        public function setData(_arg_1:*):void
        {
            if (_arg_1 == data)
            {
                return;
            };
            __data = _arg_1;
            dchg();
        }

        public function setParent(_arg_1:GComponent):void
        {
            _oldParent = _arg_1;
            _arg_1.addChild(this);
        }

        public function addSelfToOldParent():void
        {
            __doEnter();
            setParent(_oldParent);
        }

        public function removeSelf():void
        {
            __dispose();
            removeFromParent();
        }

        public function __dispose():void
        {
            var _local_2:* = null;
            (trace(("退出: " + className)));
            if (childCompDic != null)
            {
                for each (var _local_1:UIComp in childCompDic)
                {
                    _local_1.__dispose();
                };
            };
            unAll();
            if (_objTapMap)
            {
                for (var _local_3:String in _objTapMap)
                {
                    _local_2 = _objTapMap[_local_3];
                    _local_2.removeClickListener(this[_local_3]);
                };
            };
            onExit_b();
            onExit();
            onExit_a();
        }

        protected function destory():void
        {
            if (hasDestory)
            {
                return;
            };
            hasDestory = true;
            for each (var _local_1:UIComp in childCompDic)
            {
                _local_1.destory();
            };
            (trace(("onDestroy: " + className)));
            view.dispose();
            dispose();
        }


    }
}//package framework.ui

