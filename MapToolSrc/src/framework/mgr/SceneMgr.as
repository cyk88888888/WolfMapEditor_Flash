
package framework.mgr
{
    import __AS3__.vec.Vector;
    import framework.ui.UIScene;
    import framework.base.ModuleCfgInfo;
    import com.core.loader.LoadQueue;
    import com.core.loader.LoaderMgr;
    import fairygui.UIPackage;
    import flash.utils.ByteArray;
    import framework.base.BaseUT;
    import flash.geom.Point;
    import fairygui.GRoot;

    public class SceneMgr 
    {

        private static var _inst:SceneMgr;

        private var _popArr:Vector.<UIScene>;
        public var curScene:UIScene;
        public var curSceneName:String;
        private var _curOpenSceneData:Object;

        public function SceneMgr()
        {
            _popArr = new Vector.<UIScene>();
        }

        public static function get inst():SceneMgr
        {
            if (!_inst)
            {
                _inst = new (SceneMgr)();
            };
            return (_inst);
        }


        public function run(_arg_1:String, _arg_2:*=null):void
        {
            showScene(_arg_1, _arg_2);
        }

        public function push(_arg_1:String, _arg_2:*=null):void
        {
            showScene(_arg_1, _arg_2, true);
        }

        private function showScene(sceneName:String, data:*=null, toPush:Boolean=false):void
        {
            var self:SceneMgr = this;
            if (((!(curScene == null)) && (curScene.className == sceneName)))
            {
                return;
            };
            var moduleInfo:ModuleCfgInfo = ModuleMgr.inst.getModuleInfo(sceneName);
            if (moduleInfo == null)
            {
                throw (new Error(("未注册模块：" + sceneName)));
            };
            curSceneName = sceneName;
            if (moduleInfo.preResList != null)
            {
                var loadQueue:LoadQueue = new LoadQueue(moduleInfo.preResList, null, null, function ():void
                {
                    onQueueLoaded.call(self, moduleInfo, data, toPush);
                });
                loadQueue.startLoad();
            }
            else
            {
                onUILoaded(moduleInfo, data, toPush);
            };
        }

        private function onQueueLoaded(_arg_1:ModuleCfgInfo, _arg_2:*, _arg_3:Boolean):void
        {
            var _local_4:* = null;
            for each (var _local_5:String in _arg_1.preResList)
            {
                _local_4 = LoaderMgr.getInstance().getResource(_local_5);
                UIPackage.addPackage(ByteArray(_local_4.content), null);
            };
            onUILoaded(_arg_1, _arg_2, _arg_3);
        }

        private function onUILoaded(_arg_1:ModuleCfgInfo, _arg_2:*, _arg_3:Boolean):void
        {
            if (((_arg_3) && (!(curScene == null))))
            {
                _popArr.push(curScene);
                curScene.removeSelf();
            }
            else
            {
                checkDestoryLastScene((!(_arg_3)));
            };
            curScene = new _arg_1.targetClass();
            curScene.name = _arg_1.name;
            var _local_4:Point = BaseUT.setFitSize(curScene);
            curScene.setXY(((GRoot.inst.width - _local_4.x) / 2), ((GRoot.inst.height - _local_4.y) / 2));
            GRoot.inst.addChild(curScene);
            if (_arg_2 != null)
            {
                curScene.setData(_arg_2);
            };
        }

        private function checkDestoryLastScene(_arg_1:Boolean=false):void
        {
            var _local_2:* = null;
            if (curScene != null)
            {
                _local_2 = ModuleMgr.inst.getModuleInfo(curScene.name);
                if (_arg_1)
                {
                    curScene.close();
                    if (((!(_local_2.cacheEnabled)) && (!(_local_2.preResList == null))))
                    {
                        for each (var _local_3:String in _local_2.preResList)
                        {
                            UIPackage.removePackage(_local_3);
                        };
                    };
                };
            };
        }

        public function pop():void
        {
            if (_popArr.length <= 0)
            {
                throw (new Error("已经pop到底了！！！！！！！"));
            };
            checkDestoryLastScene(true);
            curScene = _popArr.pop();
            curSceneName = curScene.name;
            curScene.addSelfToOldParent();
        }


    }
}//package framework.mgr

