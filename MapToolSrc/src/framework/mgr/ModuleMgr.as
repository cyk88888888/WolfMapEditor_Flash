// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.mgr.ModuleMgr

package framework.mgr
{
    import flash.utils.Dictionary;
    import framework.base.ModuleCfgInfo;
    import framework.base.BaseUT;
    import framework.ui.UILayer;

    public class ModuleMgr 
    {

        private static var _inst:ModuleMgr;
        public static var moduleInfoMap:Dictionary;
        public static var allLayerMap:Dictionary;


        public static function get inst():ModuleMgr
        {
            if (!_inst)
            {
                _inst = new (ModuleMgr)();
            };
            return (_inst);
        }

        public static function registerModule(_arg_1:Class, _arg_2:Array, _arg_3:Boolean=false):void
        {
            if (!moduleInfoMap)
            {
                moduleInfoMap = new Dictionary();
            };
            var _local_5:ModuleCfgInfo = new ModuleCfgInfo(_arg_1, _arg_2, _arg_3);
            var _local_4:String = BaseUT.getClassNameByObj(_arg_1);
            moduleInfoMap[_local_4] = _local_5;
        }

        public static function registerLayer(_arg_1:Class):void
        {
            if (!allLayerMap)
            {
                allLayerMap = new Dictionary();
            };
            allLayerMap[BaseUT.getClassNameByObj(_arg_1)] = _arg_1;
        }


        public function getModuleInfo(_arg_1:String):ModuleCfgInfo
        {
            return ((moduleInfoMap) ? moduleInfoMap[_arg_1] : null);
        }

        public function showLayer(_arg_1:Class, _arg_2:*=null):UILayer
        {
            var _local_3:UILayer = (BaseUT.createClassByName(_arg_1) as UILayer);
            _local_3.name = (BaseUT.getClassNameByObj(_arg_1) + "_script");
            BaseUT.setFitSize(_local_3);
            if (_arg_2 != null)
            {
                _local_3.setData(_arg_2);
            };
            _local_3.getParent().addChild(_local_3);
            BaseUT.setFitSize(_local_3.view);
            _local_3.onAddToLayer();
            return (_local_3);
        }


    }
}//package framework.mgr

