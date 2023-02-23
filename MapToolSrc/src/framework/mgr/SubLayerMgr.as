// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.mgr.SubLayerMgr

package framework.mgr
{
    import flash.utils.Dictionary;
    import framework.ui.UILayer;
    import __AS3__.vec.Vector;
    import framework.base.BaseUT;

    public class SubLayerMgr 
    {

        private var _classMap:Dictionary;
        private var _scriptMap:Dictionary;
        public var curLayer:UILayer;
        private var _popArr:Vector.<UILayer>;

        public function SubLayerMgr()
        {
            _classMap = new Dictionary();
            _scriptMap = new Dictionary();
            _popArr = new Vector.<UILayer>();
        }

        public function register(_arg_1:Class, _arg_2:*=null):void
        {
            _classMap[BaseUT.getClassNameByObj(_arg_1)] = _arg_1;
        }

        public function run(_arg_1:Class, _arg_2:*=null):void
        {
            _show(_arg_1, _arg_2);
        }

        public function push(_arg_1:Class, _arg_2:*=null):void
        {
            _show(_arg_1, _arg_2, true);
        }

        private function _show(_arg_1:Class, _arg_2:*, _arg_3:Boolean=false):void
        {
            var _local_5:String = BaseUT.getClassNameByObj(_arg_1);
            if (((!(curLayer == null)) && (curLayer.className == _local_5)))
            {
                return;
            };
            var _local_6:* = _classMap[_arg_1];
            var _local_4:Boolean = ((_local_6 == null) && (!(_arg_3)));
            checkDestoryLastLayer(_local_4);
            if (curLayer != null)
            {
                if (_arg_3)
                {
                    _popArr.push(curLayer);
                };
                if (((_arg_3) || (!(_local_4))))
                {
                    curLayer.removeSelf();
                };
            };
            if (_scriptMap[_local_5])
            {
                curLayer = _scriptMap[_local_5];
                curLayer.addSelfToOldParent();
                return;
            };
            curLayer = ModuleMgr.inst.showLayer(_arg_1, _arg_2);
            if (_classMap[_local_5] != null)
            {
                _scriptMap[_local_5] = curLayer;
            };
        }

        private function checkDestoryLastLayer(_arg_1:Boolean=false):void
        {
            if ((((_arg_1) && (!(curLayer == null))) && (!(curLayer.hasDestory))))
            {
                curLayer.close();
            };
        }

        public function pop():void
        {
            if (_popArr.length <= 0)
            {
                throw (new Error("已经pop到底了！！！"));
            };
            checkDestoryLastLayer(true);
            curLayer = _popArr.pop();
            curLayer.addSelfToOldParent();
        }

        public function ReleaseAllLayer():void
        {
            checkDestoryLastLayer(true);
            for each (var _local_1:UILayer in _popArr)
            {
                if (!_local_1.hasDestory)
                {
                    _local_1.close();
                };
            };
            for each (_local_1 in _scriptMap)
            {
                if (!_local_1.hasDestory)
                {
                    _local_1.close();
                };
            };
            _popArr = new Vector.<UILayer>();
        }

        public function dispose():void
        {
            ReleaseAllLayer();
            _classMap = null;
            _popArr = null;
        }


    }
}//package framework.mgr

