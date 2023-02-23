// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.mapEditor.MapEditorScene

package modules.mapEditor
{
    import framework.ui.UIScene;

    public class MapEditorScene extends UIScene 
    {


        override protected function ctor():void
        {
            mainClassLayer = MapEditorLayer;
            var _local_2:Array = [];
            for each (var _local_1:Class in _local_2)
            {
                subLayerMgr.register(_local_1);
            };
        }


    }
}//package modules.mapEditor

