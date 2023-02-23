// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.base.InitModule

package modules.base
{
    import framework.mgr.ModuleMgr;
    import modules.mapEditor.MapEditorScene;
    import modules.mapEditor.MapEditorLayer;
    import modules.mapEditor.MapComp;
    import modules.common.JuHuaDlg;
    import modules.common.MsgBoxDlg;

    public class InitModule 
    {


        public static function init():void
        {
            registerModule();
            registerLayer();
        }

        private static function registerModule():void
        {
            ModuleMgr.registerModule(MapEditorScene, ["assets/MapEditor.zip"]);
        }

        private static function registerLayer():void
        {
            var _local_2:int;
            var _local_1:Array = [MapEditorLayer, MapComp, JuHuaDlg, MsgBoxDlg];
            _local_2 = 0;
            while (_local_2 < _local_1.length)
            {
                ModuleMgr.registerLayer(_local_1[_local_2]);
                _local_2++;
            };
        }


    }
}//package modules.base

