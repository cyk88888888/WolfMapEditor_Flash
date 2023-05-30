﻿package modules.mapEditor
{
	import framework.ui.UILayer;
	import fairygui.GComponent;
	import fairygui.GTextInput;
	import fairygui.GTextField;
	import fairygui.GTree;
	import fairygui.GButton;
	import fairygui.GComboBox;
	import fairygui.GGroup;
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
	import modules.mapEditor.conctoller.MapThingInfo;
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
		private var txt_thingRect:GTextField;
		private var txt_gridRange:GTextInput;
		private var list_tree:GTree;
		private var _mapThingComp:GButton;
		private var txt_taskId:GTextInput;
		private var txt_groupId:GTextInput;
		private var txt_groupId2:GTextInput;
		private var txt_x:GTextInput;
		private var txt_y:GTextInput;
		private var txt_anchorX:GTextInput;
		private var txt_anchorY:GTextInput;
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
		private var grp_mapThingInfo:GGroup;
		private var grp_bevel:GGroup;
		
		
		override protected function get pkgName():String
		{
			return ("MapEditor");
		}
		
		override protected function onEnter():void
		{
			txt_cellSize = view.getChild("txt_cellSize").asTextInput;
			txt_mapRect = view.getChild("txt_mapRect").asTextField;
			txt_thingRect = view.getChild("txt_thingRect").asTextField;
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
			grp_mapThingInfo = view.getChild("grp_mapThingInfo").asGroup;
			grp_bevel = view.getChild("grp_bevel").asGroup;
			txt_taskId = view.getChild("txt_taskId").asTextInput;
			txt_taskId.addEventListener("focusOut", onFocusOutTaskId);
			txt_groupId = view.getChild("txt_groupId").asTextInput;
			txt_groupId.addEventListener("focusOut", onFocusOutGroupId);
			txt_groupId2 = view.getChild("txt_groupId2").asTextInput;
			txt_groupId2.addEventListener("focusOut", onFocusOutGroupId2);
			txt_x = view.getChild("txt_x").asTextInput;
			txt_x.addEventListener("focusOut", onFocusOutX);
			txt_y = view.getChild("txt_y").asTextInput;
			txt_y.addEventListener("focusOut", onFocusOutY);
			txt_anchorX = view.getChild("txt_anchorX").asTextInput;
			txt_anchorX.addEventListener("focusOut", onFocusOutAnchorX);
			txt_anchorY = view.getChild("txt_anchorY").asTextInput;
			txt_anchorY.addEventListener("focusOut", onFocusOutAnchorY);
			_local_1 = "0-9 .\\-";
			txt_anchorY.restrict = _local_1;
			txt_anchorX.restrict = _local_1;
			combo_taskType = view.getChild("combo_taskType").asComboBox;
			combo_taskType.addEventListener("stateChanged", onClickTaskType);
			combo_triggerType = view.getChild("combo_triggerType").asComboBox;
			combo_triggerType.items = MapMgr.inst.triggerDesc;
			combo_triggerType.values = MapMgr.inst.triggerTypes;
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
			onEmitter(GameEvent.ImportMapThingJson, updateMapThingPram);
			onEmitter(GameEvent.ClickMapTing, onClickMapTing);
			MapMgr.inst.changeMap(true);
			view.addEventListener("click", onClickView, true);
			view.addEventListener("mouseMove", mouseMove);
		}
		
		private function updateListTree(data:Object):void
		{
			function createNodeRecursive(_arg_1:Vector.<MapFileTreeNode>, _arg_2:GTreeNode):void
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
		
		private function updateMapThingPram(_arg_1:Object):void
		{
			var _local_6:int;
			var _local_4:* = null;
			var _local_3:Object = _arg_1.body[0];
			var _local_2:Array = _local_3.thingTypeList;
			var _local_7:Array = [];
			var _local_5:Array = [];
			_local_6 = 0;
			while (_local_6 < _local_2.length)
			{
				_local_4 = _local_2[_local_6];
				_local_7.push(_local_4.type);
				_local_5.push(_local_4.desc);
				_local_6++;
			};
			combo_taskType.items = _local_5;
			combo_taskType.values = _local_7;
			combo_taskType.selectedIndex = 0;
		}
		
		private function renderTreeNode(_arg_1:GTreeNode, _arg_2:GComponent):void
		{
			if (_arg_1.isFolder)
			{
				_arg_2.text = _arg_1.data+"";
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
					_arg_2.text = _arg_1.data+"";
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
			var _local_3:MapMgr = MapMgr.inst;
			var _local_4:MapThingInfo = _local_3.curMapThingInfo;
			var _local_2:* = (_local_4.type == 999);
			if (_local_2)
			{
				txt_groupId2.text = ((_local_4.groupIdStr) ? _local_4.groupIdStr : "");
			}
			else
			{
				txt_taskId.text = (_local_4.taskId + "");
				txt_groupId.text = (_local_4.groupId + "");
				txt_x.text = (_local_4.x + "");
				txt_y.text = (_local_4.y + "");
				txt_anchorX.text = (_local_4.anchorX + "");
				txt_anchorY.text = (_local_4.anchorY + "");
				txt_thingRect.text = ((_local_4.width + ",") + _local_4.height);
				combo_taskType.selectedIndex = (_local_4.type - 1);
			};
			grp_mapThingInfo.visible = (!(_local_2));
			grp_bevel.visible = _local_2;
		}
		
		private function onFocusOutTaskId(_arg_1:Event):void
		{
			if (MapMgr.inst.curMapThingInfo)
			{
				MapMgr.inst.curMapThingInfo.taskId = int(txt_taskId.text);
			};
		}
		
		private function onFocusOutGroupId(_arg_1:Event):void
		{
			if (MapMgr.inst.curMapThingInfo)
			{
				MapMgr.inst.curMapThingInfo.groupId = int(txt_groupId.text);
			};
		}
		
		private function onFocusOutGroupId2(_arg_1:Event):void
		{
			if (MapMgr.inst.curMapThingInfo)
			{
				MapMgr.inst.curMapThingInfo.groupIdStr = txt_groupId2.text;
			};
		}
		
		private function onFocusOutX(_arg_1:Event):void
		{
			var _local_5:int;
			var _local_2:* = null;
			var mapMgr:MapMgr = MapMgr.inst;
			if (mapMgr.curMapThingInfo)
			{
				_local_5 = mapMgr.curMapThingInfo.x;
				var _local_4:int = mapMgr.curMapThingInfo.y;
				_local_2 = mapMgr.getMapThingCompByXY(_local_5, _local_4);
				delete mapMgr.mapThingDic[_local_2.name];
				var _local_6:* = txt_x.text;
				mapMgr.curMapThingInfo.x = _local_6;
				_local_2.x = _local_6;
				_local_2.name = ((_local_2.x + "_") + _local_2.y);
				mapMgr.mapThingDic[_local_2.name] = [mapMgr.curMapThingInfo, _local_2];
				emit(GameEvent.ChangeMapThingXY, {
					"x":_local_2.x,
					"y":_local_2.y,
					"width":_local_2.width,
					"height":_local_2.height
				});
			};
		}
		
		private function onFocusOutY(_arg_1:Event):void
		{
			var _local_5:int;
			var _local_2:* = null;
			var _local_3:MapMgr = MapMgr.inst;
			if (_local_3.curMapThingInfo)
			{
				_local_5 = _local_3.curMapThingInfo.x;
				var _local_4:int = _local_3.curMapThingInfo.y;
				_local_2 = _local_3.getMapThingCompByXY(_local_5, _local_4);
				delete _local_3.mapThingDic[_local_2.name];
				var _local_6:* = txt_y.text;
				_local_3.curMapThingInfo.y = _local_6;
				_local_2.y = _local_6;
				_local_2.name = ((_local_2.x + "_") + _local_2.y);
				_local_3.mapThingDic[_local_2.name] = [_local_3.curMapThingInfo, _local_2];
				emit(GameEvent.ChangeMapThingXY, {
					"x":_local_2.x,
					"y":_local_2.y,
					"width":_local_2.width,
					"height":_local_2.height
				});
			};
		}
		
		private function onFocusOutAnchorX(_arg_1:Event):void
		{
			var _local_2:* = null;
			var _local_5:Number;
			var _local_3:MapMgr = MapMgr.inst;
			if (_local_3.curMapThingInfo)
			{
				_local_2 = _local_3.getMapThingCompByXY(_local_3.curMapThingInfo.x, _local_3.curMapThingInfo.y);
				delete _local_3.mapThingDic[_local_2.name];
				_local_3.curMapThingInfo.anchorX = Number(txt_anchorX.text);
				_local_5 = _local_3.curMapThingInfo.anchorX;
				var _local_4:Number = _local_3.curMapThingInfo.anchorY;
				_local_2.setPivot(_local_5, _local_4, true);
				txt_x.text = (_local_2.x + "");
				txt_y.text = (_local_2.y + "");
				_local_3.curMapThingInfo.x = _local_2.x;
				_local_3.curMapThingInfo.y = _local_2.y;
				_local_2.name = ((_local_2.x + "_") + _local_2.y);
				_local_3.mapThingDic[_local_2.name] = [_local_3.curMapThingInfo, _local_2];
			};
		}
		
		private function onFocusOutAnchorY(_arg_1:Event):void
		{
			var _local_2:* = null;
			var _local_5:Number;
			var _local_3:MapMgr = MapMgr.inst;
			if (_local_3.curMapThingInfo)
			{
				_local_2 = _local_3.getMapThingCompByXY(_local_3.curMapThingInfo.x, _local_3.curMapThingInfo.y);
				delete _local_3.mapThingDic[_local_2.name];
				_local_3.curMapThingInfo.anchorY = Number(txt_anchorY.text);
				_local_5 = _local_3.curMapThingInfo.anchorX;
				var _local_4:Number = _local_3.curMapThingInfo.anchorY;
				_local_2.setPivot(_local_5, _local_4, true);
				txt_x.text = (_local_2.x + "");
				txt_y.text = (_local_2.y + "");
				_local_3.curMapThingInfo.x = _local_2.x;
				_local_3.curMapThingInfo.y = _local_2.y;
				_local_2.name = ((_local_2.x + "_") + _local_2.y);
				_local_3.mapThingDic[_local_2.name] = [_local_3.curMapThingInfo, _local_2];
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
			if (_curSelectTypeBtn == _arg_2)
			{
				return;
			};
			emit(GameEvent.ChangeGridType, [_arg_1]);
			if (_curSelectTypeBtn)
			{
				_curSelectTypeBtn.selected = false;
			};
			_curSelectTypeBtn = _arg_2;
			_curSelectTypeBtn.selected = true;
			_arg_2.getChild("n3").asGraph.alpha = 0.5;
			_arg_2.getChild("n3").asGraph.color = MapMgr.inst.getColorByType(_arg_1);
			var _local_3:* = false;
			grp_bevel.visible = _local_3;
			grp_mapThingInfo.visible = _local_3;
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
			MapMgr.inst.gridRange = int(txt_gridRange.text);
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
		
		public function _tap_btn_showPath(_arg_1:GTouchEvent):void
		{
			emit(GameEvent.CheckShowPath);
		}
		
		
	}
}