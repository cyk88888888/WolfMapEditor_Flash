// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.mapEditor.MapEditorLayer

package modules.mapEditor
{
    import framework.ui.UILayer;
    import fairygui.GComponent;
    import fairygui.GTextInput;
    import fairygui.GTextField;
    import fairygui.GTree;
    import fairygui.GButton;
    import fairygui.GComboBox;
    import modules.mapEditor.conctoller.MapMgr;
    import modules.base.GameEvent;
    import modules.mapEditor.conctoller.MapFileTreeNode;
    import fairygui.GTreeNode;
    import framework.base.BaseUT;
    import __AS3__.vec.Vector;
    import fairygui.event.ItemEvent;
    import framework.base.Global;
    import framework.mgr.SceneMgr;
    import flash.events.MouseEvent;
    import flash.events.Event;
    import fairygui.event.GTouchEvent;
    import modules.common.mgr.MsgMgr;
    import framework.mgr.ModuleMgr;
    import modules.mapEditor.joystick.JoystickLayer;

    public class MapEditorLayer extends UILayer 
    {

        private var mapComp:GComponent;
        private var txt_cellSize:GTextInput;
        private var txt_mapRect:GTextField;
        private var txt_gridRange:GTextInput;
        private var list_tree:GTree;
        private var _mapThingComp:GButton;
        private var txt_taskId:GTextInput;
        private var txt_groupId:GTextInput;
        private var combo_taskType:GComboBox;
        private var combo_triggerType:GComboBox;
        private var _curSelectTypeBtn:GButton;
        private var txt_top:GTextInput;
        private var txt_bottom:GTextInput;
        private var txt_left:GTextInput;
        private var txt_right:GTextInput;
        private var _isInCopyMapThing:Boolean;
        private var _drawMapThingData:Object;
        private var btn_walk:GButton;
        private var btn_block:GButton;
        private var btn_blockVert:GButton;
        private var btn_visible:GButton;
        private var btn_water:GButton;
        private var btn_waterVert:GButton;
        private var btn_start:GButton;
        private var btn_startWall:GButton;
        private var btn_switchWall:GButton;
        private var btn_mapThing:GButton;
        private var txt_mouseGridXY:GTextField;


        override protected function get pkgName():String
        {
            return ("MapEditor");
        }

        override protected function onEnter():void
        {
            txt_cellSize = view.getChild("txt_cellSize").asTextInput;
            txt_mapRect = view.getChild("txt_mapRect").asTextField;
            MapMgr.inst.mouseGridTextField = (txt_mouseGridXY = view.getChild("txt_mouseGridXY").asTextField);
            txt_gridRange = view.getChild("txt_gridRange").asTextInput;
            txt_gridRange.text = MapMgr.inst.gridRange.toString();
            txt_top = view.getChild("txt_top").asTextInput;
            txt_bottom = view.getChild("txt_bottom").asTextInput;
            txt_left = view.getChild("txt_left").asTextInput;
            txt_right = view.getChild("txt_right").asTextInput;
            var _local_1:* = "0-9\\-";
            txt_right.restrict = _local_1;
            txt_left.restrict = _local_1;
            txt_bottom.restrict = _local_1;
            txt_top.restrict = _local_1;
            btn_walk = view.getChild("btn_walk").asButton;
            btn_block = view.getChild("btn_block").asButton;
            btn_blockVert = view.getChild("btn_blockVert").asButton;
            btn_water = view.getChild("btn_water").asButton;
            btn_waterVert = view.getChild("btn_waterVert").asButton;
            btn_start = view.getChild("btn_start").asButton;
            btn_startWall = view.getChild("btn_startWall").asButton;
            btn_switchWall = view.getChild("btn_switchWall").asButton;
            btn_mapThing = view.getChild("btn_mapThing").asButton;
            btn_visible = view.getChild("btn_visible").asButton;
            mapComp = view.getChild("mapComp").asCom;
            txt_taskId = view.getChild("txt_taskId").asTextInput;
            txt_taskId.addEventListener("focusOut", onFocusOutTaskId);
            txt_groupId = view.getChild("txt_groupId").asTextInput;
            txt_groupId.addEventListener("focusOut", onFocusOutGroupId);
            combo_taskType = view.getChild("combo_taskType").asComboBox;
            combo_taskType.items = ["任务", "起始围栏", "报告皇后", "关键人物", "草丛", "斜角顶点"];
            combo_taskType.values = [1, 2, 3, 4, 5, 6];
            combo_taskType.selectedIndex = 0;
            combo_taskType.addEventListener("stateChanged", onClickTaskType);
            combo_triggerType = view.getChild("combo_triggerType").asComboBox;
            combo_triggerType.items = ["触发发亮", "不可行走", "犯人周围站立点", "草丛范围点"];
            combo_triggerType.values = [1, 2, 3, 4];
            combo_triggerType.selectedIndex = 0;
            combo_triggerType.addEventListener("stateChanged", onClickTriggerType);
            list_tree = view.getChild("list_tree").asTree;
            list_tree.treeNodeRender = renderTreeNode;
            list_tree.addEventListener("itemClick", onClickMapTreeItem);
            updateMapInfo(null);
            onEmitter(GameEvent.UpdateMapInfo, updateMapInfo);
            onEmitter(GameEvent.ResizeMapSucc, updateMapInfo);
            onEmitter(GameEvent.DragMapThingStart, onDragMapThingStart);
            onEmitter(GameEvent.UpdateMapTreeStruct, updateListTree);
            onEmitter(GameEvent.ClickMapTing, onClickMapTing);
            MapMgr.inst.changeMap(true);
            view.addEventListener("click", onClickView, true);
            view.addEventListener("mouseMove", mouseMove);
        }

        private function updateListTree(_arg_1:Object):void
        {
            var data = _arg_1;
            var createNodeRecursive = function (_arg_1:Vector.<MapFileTreeNode>, _arg_2:GTreeNode):void
            {
                var _local_3:* = null;
                for each (var _local_4:MapFileTreeNode in _arg_1)
                {
                    _local_3 = new GTreeNode(_local_4.isDir);
                    _local_3.data = ((_local_4.isDir) ? _local_4.name : [_local_4.name, ((BaseUT.checkIsPngOrJpg(_local_4.path)) ? _local_4.path : "ui://Common/file")]);
                    _arg_2.addChild(_local_3);
                    if (_local_4.isDir)
                    {
                        (createNodeRecursive(_local_4.fileArr, _local_3));
                    };
                };
            };
            list_tree.rootNode.removeChildren();
            createNodeRecursive(MapMgr.inst.mapDirectoryStrut, list_tree.rootNode); //not popped
        }

        private function renderTreeNode(_arg_1:GTreeNode, _arg_2:GComponent):void
        {
            if (_arg_1.isFolder)
            {
                _arg_2.text = _arg_1.data as String;
            }
            else
            {
                if ((_arg_1.data is Array))
                {
                    _arg_2.text = _arg_1.data[0];
                    _arg_2.icon = _arg_1.data[1];
                }
                else
                {
                    _arg_2.icon = "ui://Common/file";
                    _arg_2.text = _arg_1.data as String;
                };
            };
        }

        private function updateMapInfo(_arg_1:Object=null):void
        {
            txt_mapRect.text = ((MapMgr.inst.mapWidth + ", ") + MapMgr.inst.mapHeight);
            txt_cellSize.text = MapMgr.inst.cellSize.toString();
        }

        private function onClickMapTreeItem(_arg_1:ItemEvent):void
        {
            var _local_2:GTreeNode = _arg_1.itemObject.treeNode;
            if (!_local_2.isFolder)
            {
                _isInCopyMapThing = true;
                newDragMapThing(_local_2.data[1]);
            };
        }

        private function onDragMapThingStart(_arg_1:Object):void
        {
            newDragMapThing(_arg_1.body.url);
            _drawMapThingData = {
                "taskId":_arg_1.body.taskId,
                "groupId":_arg_1.body.groupId,
                "type":_arg_1.body.type
            };
        }

        private function newDragMapThing(_arg_1:String):void
        {
            disposeDragMapThing();
            emit(GameEvent.ChangeGridType, ["GridType_MapThing"]);
            changeGridType("GridType_MapThing", btn_mapThing);
            _mapThingComp = MapMgr.inst.getMapThingComp(_arg_1);
            _mapThingComp.x = Global.stage.mouseX;
            _mapThingComp.y = Global.stage.mouseY;
            _mapThingComp.setScale(MapMgr.inst.mapScale, MapMgr.inst.mapScale);
            SceneMgr.inst.curScene.layer.addChild(_mapThingComp);
            _mapThingComp.touchable = false;
        }

        private function onClickView(_arg_1:MouseEvent):void
        {
            if (((!(_isInCopyMapThing)) && (_mapThingComp)))
            {
                if (Global.stage.mouseX <= mapComp.width)
                {
                    emit(GameEvent.DragMapThingDown, {
                        "url":_mapThingComp.icon,
                        "taskId":((_drawMapThingData) ? _drawMapThingData.taskId : 0),
                        "groupId":((_drawMapThingData) ? _drawMapThingData.groupId : 0),
                        "type":((_drawMapThingData) ? _drawMapThingData.type : 0),
                        "isByDrag":true
                    });
                };
                disposeDragMapThing();
            };
            _isInCopyMapThing = false;
        }

        private function mouseMove(_arg_1:MouseEvent):void
        {
            if (_mapThingComp)
            {
                _mapThingComp.x = Global.stage.mouseX;
                _mapThingComp.y = Global.stage.mouseY;
            };
        }

        private function onClickMapTing(_arg_1:Object):void
        {
            txt_taskId.text = (MapMgr.inst.curMapThingInfo.taskId + "");
            txt_groupId.text = (MapMgr.inst.curMapThingInfo.groupId + "");
            combo_taskType.selectedIndex = (MapMgr.inst.curMapThingInfo.type - 1);
        }

        private function onFocusOutTaskId(_arg_1:Event):void
        {
            if (MapMgr.inst.curMapThingInfo)
            {
                MapMgr.inst.curMapThingInfo.taskId = Number(txt_taskId.text);
            };
        }

        private function onFocusOutGroupId(_arg_1:Event):void
        {
            if (MapMgr.inst.curMapThingInfo)
            {
                MapMgr.inst.curMapThingInfo.groupId = Number(txt_groupId.text);
            };
        }

        private function onClickTaskType(_arg_1:Object):void
        {
            var _local_2:int = combo_taskType.values[combo_taskType.selectedIndex];
            if (MapMgr.inst.curMapThingInfo)
            {
                MapMgr.inst.curMapThingInfo.type = _local_2;
            };
        }

        private function onClickTriggerType(_arg_1:Object):void
        {
            var _local_2:int = combo_triggerType.values[combo_triggerType.selectedIndex];
            MapMgr.inst.curMapThingTriggerType = _local_2;
        }

        private function disposeDragMapThing():void
        {
            if (_mapThingComp)
            {
                _mapThingComp.removeFromParent();
                _mapThingComp.dispose();
                _mapThingComp = null;
            };
            _drawMapThingData = null;
        }

        public function _tap_btn_walk(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_walk", btn_walk);
        }

        public function _tap_btn_block(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_block", btn_block);
        }

        public function _tap_btn_visible(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_visible", btn_visible);
        }

        public function _tap_btn_blockVert(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_blockVerts", btn_blockVert);
        }

        public function _tap_btn_water(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_water", btn_water);
        }

        public function _tap_btn_waterVert(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_WaterVerts", btn_waterVert);
        }

        public function _tap_btn_mapThing(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_MapThing", btn_mapThing);
        }

        public function _tap_btn_start(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_start", btn_start);
        }

        public function _tap_btn_startWall(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_startWall", btn_startWall);
        }

        public function _tap_btn_switchWall(_arg_1:GTouchEvent):void
        {
            changeGridType("GridType_switchWall", btn_switchWall);
        }

        private function changeGridType(_arg_1:String, _arg_2:GButton):void
        {
            emit(GameEvent.ChangeGridType, [_arg_1]);
            if (_curSelectTypeBtn)
            {
                _curSelectTypeBtn.selected = false;
            };
            _curSelectTypeBtn = _arg_2;
            _curSelectTypeBtn.selected = true;
            _arg_2.getChild("n3").asGraph.alpha = 0.5;
            _arg_2.getChild("n3").asGraph.color = MapMgr.inst.getColorByType(_arg_1);
        }

        public function _tap_btn_clearWalk(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ClearGridType, ["GridType_walk"]);
        }

        public function _tap_btn_clearBolck(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ClearGridType, ["GridType_block"]);
        }

        public function _tap_btn_clearVisible(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ClearGridType, ["GridType_visible"]);
        }

        public function _tap_btn_clearBolckVert(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ClearGridType, ["GridType_blockVerts"]);
        }

        public function _tap_btn_clearWater(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ClearGridType, ["GridType_water"]);
        }

        public function _tap_btn_clearWaterVert(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ClearGridType, ["GridType_WaterVerts"]);
        }

        public function _tap_btn_clearStart(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ClearGridType, ["GridType_start"]);
        }

        public function _tap_btn_resizeGrid(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ResizeGrid, [txt_cellSize.text]);
        }

        public function _tap_btn_cutMap(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ResizeMap, [txt_top.text, txt_bottom.text, txt_left.text, txt_right.text]);
        }

        public function _tap_btn_gridRange(_arg_1:GTouchEvent):void
        {
            MapMgr.inst.gridRange = Number(txt_gridRange.text);
            MsgMgr.ShowMsg("设置格子扩散范围大小成功！");
        }

        public function _tap_btn_toCenter(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ToCenter);
        }

        public function _tap_btn_originalScale(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ToOriginalScale);
        }

        public function _tap_btn_exportJson(_arg_1:GTouchEvent):void
        {
            MapMgr.inst.exportJsonData();
        }

        public function _tap_btn_importJson(_arg_1:GTouchEvent):void
        {
            MapMgr.inst.importJsonData();
        }

        public function _tap_btn_clearAll(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.ClearAllData);
        }

        public function _tap_btn_changeMap(_arg_1:GTouchEvent):void
        {
            MapMgr.inst.changeMap();
        }

        public function _tap_btn_runDemo(_arg_1:GTouchEvent):void
        {
            ModuleMgr.inst.showLayer(JoystickLayer);
            emit(GameEvent.RunDemo);
        }

        public function _tap_btn_showGrid(_arg_1:GTouchEvent):void
        {
            emit(GameEvent.CheckShowGrid);
        }


    }
}//package modules.mapEditor

