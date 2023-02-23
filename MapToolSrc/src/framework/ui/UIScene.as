// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.ui.UIScene

package framework.ui
{
    import fairygui.GComponent;
    import framework.mgr.SubLayerMgr;
    import flash.events.Event;
    import framework.mgr.SceneMgr;
    import framework.base.BaseUT;
    import framework.base.Global;
    import fairygui.GRoot;

    public class UIScene extends GComponent 
    {

        protected var subLayerMgr:SubLayerMgr;
        public var layer:GComponent;
        public var dlg:GComponent;
        public var msg:GComponent;
        public var menuLayer:GComponent;
        protected var mainClassLayer:Class;
        private var _isFirstEnter:Boolean = true;
        protected var _moduleParam:*;
        private var _msgHandler:Object = {};

        public function UIScene()
        {
            subLayerMgr = new SubLayerMgr();
            ctor_b();
            ctor();
            ctor_a();
            registerModuleClass();
            this.addEventListener("addedToStage", oAddtoStage);
        }

        protected function registerModuleClass():void
        {
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
            initLayer();
            if (mainClassLayer != null)
            {
                subLayerMgr.register(mainClassLayer);
                push(mainClassLayer);
            };
        }

        private function initLayer():void
        {
            layer = addGCom2GRoot("UILayer");
            menuLayer = addGCom2GRoot("UIMenuLayer");
            dlg = addGCom2GRoot("UIDlg");
            msg = addGCom2GRoot("UIMsg");
            __doEnter();
        }

        private function addGCom2GRoot(_arg_1:String):GComponent
        {
            var _local_2:GComponent = new GComponent();
            _local_2.name = _arg_1;
            SceneMgr.inst.curScene.addChild(_local_2);
            BaseUT.setFitSize(_local_2);
            return (_local_2);
        }

        private function __doEnter():void
        {
            (trace(("进入" + className)));
            onEnter_b();
            onEnter();
            if (_isFirstEnter)
            {
                _isFirstEnter = false;
                onFirstEnter();
            };
            onEnter_a();
        }

        public function setData(_arg_1:*):void
        {
            _moduleParam = _arg_1;
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

        public function get className():String
        {
            return (BaseUT.getClassNameByObj(this));
        }

        public function resetToMain():void
        {
            releaseAllLayer();
            push(mainClassLayer, null);
        }

        public function run(_arg_1:Class, _arg_2:*=null):void
        {
            subLayerMgr.run(_arg_1, _arg_2);
        }

        public function push(_arg_1:Class, _arg_2:*=null):void
        {
            subLayerMgr.push(_arg_1, _arg_2);
        }

        public function pop():void
        {
            subLayerMgr.pop();
        }

        public function addSelfToOldParent():void
        {
            for each (var _local_1:GComponent in getChildren())
            {
                eachChildByParent((_local_1 as GComponent), true);
            };
            __doEnter();
            GRoot.inst.addChild(SceneMgr.inst.curScene);
        }

        public function removeSelf():void
        {
            for each (var _local_1:GComponent in getChildren())
            {
                eachChildByParent((_local_1 as GComponent));
            };
            _dispose();
            SceneMgr.inst.curScene.removeFromParent();
        }

        private function releaseAllLayer():void
        {
            subLayerMgr.ReleaseAllLayer();
        }

        private function _dispose():void
        {
            unAll();
            (trace(("退出" + className)));
            onExit_b();
            onExit();
            onExit_a();
        }

        private function eachChildByParent(_arg_1:GComponent, _arg_2:Boolean=false):void
        {
            for each (var _local_3:UIComp in _arg_1.getChildren())
            {
                if (_arg_2)
                {
                    (_local_3 as UIComp).__doEnter();
                }
                else
                {
                    (_local_3 as UIComp).__dispose();
                };
            };
        }

        private function destory():void
        {
            subLayerMgr.dispose();
            subLayerMgr = null;
            (trace(("onDestroy: " + className)));
            dispose();
        }

        public function close():void
        {
            _dispose();
            destory();
        }


    }
}//package framework.ui

