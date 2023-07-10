package modules.mapEditor
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import fairygui.GButton;
	import fairygui.GComboBox;
	import fairygui.GComponent;
	import fairygui.GGroup;
	import fairygui.GTextField;
	import fairygui.GTextInput;
	import fairygui.GTree;
	import fairygui.GTreeNode;
	import fairygui.event.GTouchEvent;
	import fairygui.event.ItemEvent;
	import fairygui.event.StateChangeEvent;
	
	import framework.base.BaseUT;
	import framework.base.Global;
	import framework.mgr.ModuleMgr;
	import framework.mgr.SceneMgr;
	import framework.ui.UILayer;
	
	import modules.base.Enum;
	import modules.base.GameEvent;
	import modules.common.mgr.MsgMgr;
	import modules.mapEditor.conctoller.MapFileTreeNode;
	import modules.mapEditor.conctoller.MapMgr;
	import modules.mapEditor.conctoller.MapThingInfo;
	import modules.mapEditor.joystick.JoystickLayer;

	/**
	 * 地图编辑器主界面
	 * @author cyk
	 * 
	 */
	public class MapEditorLayer extends UILayer
	{
		protected override function get pkgName():String
		{
			return "MapEditor";
		}
		
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
		private var _isInCopyMapThing:Boolean;//是否点击地图目录场景树（没做这个标识会导致点击后，拖拽物件立即被销毁了）
		private var _drawMapThingData:Object;//拖拽场景已有的物件的临时数据
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
		
		protected override function onEnter():void{
			txt_cellSize = view.getChild("txt_cellSize").asTextInput;
			
			txt_mapRect = view.getChild("txt_mapRect").asTextField;
			txt_thingRect = view.getChild("txt_thingRect").asTextField;
			MapMgr.inst.mouseGridTextField = txt_mouseGridXY = view.getChild("txt_mouseGridXY").asTextField;
			
			txt_gridRange = view.getChild("txt_gridRange").asTextInput;
			txt_gridRange.text = MapMgr.inst.gridRange.toString();
			
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
			txt_taskId.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutTaskId);
			
			txt_groupId = view.getChild("txt_groupId").asTextInput;
			txt_groupId.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutGroupId);
			
			txt_groupId2 = view.getChild("txt_groupId2").asTextInput;
			txt_groupId2.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutGroupId2);	
			
			txt_x = view.getChild("txt_x").asTextInput;
			txt_x.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutX);
			
			txt_y = view.getChild("txt_y").asTextInput;
			txt_y.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutY);
			
			txt_anchorX = view.getChild("txt_anchorX").asTextInput;
			txt_anchorX.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutAnchorX);
			
			txt_anchorY = view.getChild("txt_anchorY").asTextInput;
			txt_anchorY.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutAnchorY);
			
			
			txt_anchorX.restrict = txt_anchorY.restrict = txt_x.restrict = txt_y.restrict = "0-9 .\\-";
			combo_taskType = view.getChild("combo_taskType").asComboBox;
			combo_taskType.addEventListener(StateChangeEvent.CHANGED,onClickTaskType);
			
			combo_triggerType = view.getChild("combo_triggerType").asComboBox;
			combo_triggerType.items =  MapMgr.inst.triggerDesc;
			combo_triggerType.values = MapMgr.inst.triggerTypes;
			combo_triggerType.selectedIndex = 0;
			combo_triggerType.addEventListener(StateChangeEvent.CHANGED, onClickTriggerType);
			
			list_tree = view.getChild("list_tree").asTree;
			list_tree.treeNodeRender = renderTreeNode;
			list_tree.addEventListener(ItemEvent.CLICK, onClickMapTreeItem);
			
			updateMapInfo(null);
			onEmitter(GameEvent.UpdateMapInfo, updateMapInfo);
			onEmitter(GameEvent.ResizeMapSucc, updateMapInfo);
			onEmitter(GameEvent.DragMapThingStart, onDragMapThingStart);
			onEmitter(GameEvent.UpdateMapTreeStruct, updateListTree);
			onEmitter(GameEvent.ImportMapThingJson, updateMapThingPram);
			onEmitter(GameEvent.ClickMapTing, onClickMapTing);
			MapMgr.inst.changeMap(true);
			view.addEventListener(MouseEvent.CLICK, onClickView,true);
			view.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		
		/**刷新地图场景物件目录**/
		private function updateListTree(data:Object):void{
			list_tree.rootNode.removeChildren();
			createNodeRecursive(MapMgr.inst.mapDirectoryStrut, list_tree.rootNode);
			//递归创建节点
			function createNodeRecursive(fileArr:Vector.<MapFileTreeNode>, parent:GTreeNode):void{
				for each(var item:MapFileTreeNode in fileArr){
					var node: GTreeNode = new GTreeNode(item.isDir);
					node.data = item.isDir ? item.name : [item.name, BaseUT.checkIsPngOrJpg(item.path) ? item.path : MapMgr.inst.fileIcon];
					parent.addChild(node);
					if(item.isDir) createNodeRecursive(item.fileArr, node);
				}
			}
		}
		
		private function updateMapThingPram(data:Object):void{
			var thingPramInfo:Object = data.body[0];
			var thingTypeList:Array = thingPramInfo.thingTypeList;
			var taskTypeArr:Array = [];
			var taskDescArr:Array = [];
			
			for(var i:int = 0; i< thingTypeList.length; i++){
				var obj:Object = thingTypeList[i];
				taskTypeArr.push(obj.type);
				taskDescArr.push(obj.desc);
			}

			//物件类型新增比较频繁，所以走配置
			combo_taskType.items = taskDescArr;
			combo_taskType.values = taskTypeArr;
			combo_taskType.selectedIndex = 0;
		}
		
		private function renderTreeNode(node: GTreeNode,obj :GComponent):void{
			if(node.isFolder){
				obj.text = String(node.data);
			}else if(node.data is Array){
				obj.text = String(node.data[0]);
				obj.icon = node.data[1];
			}else{
				obj.icon = MapMgr.inst.fileIcon;
				obj.text = String(node.data);
			}
		}
		
		private function updateMapInfo(data:Object=null):void{
			txt_mapRect.text = MapMgr.inst.mapWidth + ", " + MapMgr.inst.mapHeight;
			txt_cellSize.text = MapMgr.inst.cellSize.toString();
		}
		
		private function onClickMapTreeItem(evt:ItemEvent):void{
			var treeNode: GTreeNode = evt.itemObject.treeNode;
			if(!treeNode.isFolder){
				_isInCopyMapThing = true;
				newDragMapThing(treeNode.data[1]);
			}
		}
		
		/**开始拖拽场景已有的物件**/
		private function onDragMapThingStart(data:Object):void{
			newDragMapThing(data.body.url);
			_drawMapThingData = {
				taskId: data.body.taskId, 
				groupId: data.body.groupId, 
				type: data.body.type,
				groupIdStr: data.body.groupIdStr
			};
		}
		
		private function newDragMapThing(icon:String):void{
			disposeDragMapThing();
			emit(GameEvent.ChangeGridType, [Enum.MapThing]);
			changeGridType(Enum.MapThing, btn_mapThing);
			_mapThingComp = MapMgr.inst.getMapThingComp(icon);
			_mapThingComp.x = Global.stage.mouseX;
			_mapThingComp.y = Global.stage.mouseY;
			_mapThingComp.setScale(MapMgr.inst.mapScale, MapMgr.inst.mapScale);
			SceneMgr.inst.curScene.layer.addChild(_mapThingComp);
			_mapThingComp.touchable = false;
		
		}
		
		private function onClickView(evt:MouseEvent):void
		{
			if(!_isInCopyMapThing && _mapThingComp){
				if(Global.stage.mouseX <= mapComp.width){
					emit(GameEvent.DragMapThingDown,{
						url: _mapThingComp.icon,
						taskId: _drawMapThingData ? _drawMapThingData.taskId : 0,
						groupId: _drawMapThingData ? _drawMapThingData.groupId : 0,
						type: _drawMapThingData ? _drawMapThingData.type : 0,
						groupIdStr: _drawMapThingData ? _drawMapThingData.groupIdStr : 0,
						isByDrag: true
					});
				}
				disposeDragMapThing();
			}
			_isInCopyMapThing = false;
		}
		
		private function mouseMove(evt:MouseEvent):void
		{
			if(_mapThingComp){
				_mapThingComp.x = Global.stage.mouseX;
				_mapThingComp.y = Global.stage.mouseY;
			}
		}
		private function onClickMapTing(data:Object):void{
			var mapMgr:MapMgr = MapMgr.inst;
			var curMapThingInfo:MapThingInfo = mapMgr.curMapThingInfo;
			var isBelve:Boolean = curMapThingInfo.type == Enum.MapThingType_bevel;//是否为斜角顶点
			if(isBelve){
				txt_groupId2.text = curMapThingInfo.groupIdStr ? curMapThingInfo.groupIdStr : "";
			}else{
				txt_taskId.text = curMapThingInfo.taskId+"";
				txt_groupId.text = curMapThingInfo.groupId+"";
				txt_x.text = curMapThingInfo.x+"";
				txt_y.text = curMapThingInfo.y+"";
				txt_anchorX.text = curMapThingInfo.anchorX+"";
				txt_anchorY.text = curMapThingInfo.anchorY+"";
				txt_thingRect.text = curMapThingInfo.width+","+curMapThingInfo.height;
				combo_taskType.selectedIndex = curMapThingInfo.type - 1;
			}
		
			grp_mapThingInfo.visible = !isBelve;
			grp_bevel.visible = isBelve;
		}
		
		private function onFocusOutTaskId(event:Event):void
		{
			if(MapMgr.inst.curMapThingInfo) MapMgr.inst.curMapThingInfo.taskId = int(txt_taskId.text);	
		}
		
		private function onFocusOutGroupId(event:Event):void
		{
			if(MapMgr.inst.curMapThingInfo) MapMgr.inst.curMapThingInfo.groupId = int(txt_groupId.text);	
		}
		
		private function onFocusOutGroupId2(event:Event):void
		{
			if(MapMgr.inst.curMapThingInfo) MapMgr.inst.curMapThingInfo.groupIdStr = txt_groupId2.text;	
			
		}
		private function onFocusOutX(event:Event):void
		{
			var mapMgr:MapMgr = MapMgr.inst;
			if(mapMgr.curMapThingInfo){
				var oldX:Number = mapMgr.curMapThingInfo.x,oldY:Number = mapMgr.curMapThingInfo.y;
				var mapThingComp:GButton = mapMgr.getMapThingCompByXY(oldX,oldY);
				delete mapMgr.mapThingDic[mapThingComp.name];
				mapThingComp.x = mapMgr.curMapThingInfo.x = Number(txt_x.text);
				mapThingComp.name = int(mapThingComp.x) + "_" + int(mapThingComp.y);
				mapMgr.mapThingDic[mapThingComp.name] = [mapMgr.curMapThingInfo, mapThingComp];
				emit(GameEvent.ChangeMapThingXY, {x:mapThingComp.x, y:mapThingComp.y, width: mapThingComp.width, height: mapThingComp.height});
			}
		}
		
		private function onFocusOutY(event:Event):void
		{
			var mapMgr:MapMgr = MapMgr.inst;
			if(mapMgr.curMapThingInfo) {
				var oldX:Number = mapMgr.curMapThingInfo.x,oldY:Number = mapMgr.curMapThingInfo.y;
				var mapThingComp:GButton = mapMgr.getMapThingCompByXY(oldX,oldY);
				delete mapMgr.mapThingDic[mapThingComp.name];
				mapThingComp.y = mapMgr.curMapThingInfo.y = Number(txt_y.text);	
				mapThingComp.name = int(mapThingComp.x) + "_" + int(mapThingComp.y);
				mapMgr.mapThingDic[mapThingComp.name] = [mapMgr.curMapThingInfo, mapThingComp];
				emit(GameEvent.ChangeMapThingXY, {x:mapThingComp.x, y:mapThingComp.y, width: mapThingComp.width, height: mapThingComp.height});
			}
		}
		
		private function onFocusOutAnchorX(event:Event):void
		{
			var mapMgr:MapMgr = MapMgr.inst;
			if(mapMgr.curMapThingInfo){
				var mapThingComp:GButton = mapMgr.getMapThingCompByXY(mapMgr.curMapThingInfo.x,mapMgr.curMapThingInfo.y);
				delete mapMgr.mapThingDic[mapThingComp.name];
				mapMgr.curMapThingInfo.anchorX = Number(txt_anchorX.text);
				var anchorX:Number = mapMgr.curMapThingInfo.anchorX,anchorY:Number = mapMgr.curMapThingInfo.anchorY;
				mapThingComp.setPivot(anchorX,anchorY,true);
				txt_x.text = mapThingComp.x+"";
				txt_y.text = mapThingComp.y+"";
				mapMgr.curMapThingInfo.x = mapThingComp.x;
				mapMgr.curMapThingInfo.y = mapThingComp.y;
				mapThingComp.name = mapThingComp.x + "_" + mapThingComp.y;
				mapMgr.mapThingDic[mapThingComp.name] = [mapMgr.curMapThingInfo, mapThingComp];
			}
		}
		
		private function onFocusOutAnchorY(event:Event):void
		{
			var mapMgr:MapMgr = MapMgr.inst;
			if(mapMgr.curMapThingInfo){
				var mapThingComp:GButton = mapMgr.getMapThingCompByXY(mapMgr.curMapThingInfo.x,mapMgr.curMapThingInfo.y);
				delete mapMgr.mapThingDic[mapThingComp.name];
				mapMgr.curMapThingInfo.anchorY = Number(txt_anchorY.text);
				var anchorX:Number = mapMgr.curMapThingInfo.anchorX,anchorY:Number = mapMgr.curMapThingInfo.anchorY;
				mapThingComp.setPivot(anchorX,anchorY,true);
				txt_x.text = mapThingComp.x+"";
				txt_y.text = mapThingComp.y+"";
				mapMgr.curMapThingInfo.x = mapThingComp.x;
				mapMgr.curMapThingInfo.y = mapThingComp.y;
				mapThingComp.name = mapThingComp.x + "_" + mapThingComp.y;
				mapMgr.mapThingDic[mapThingComp.name] = [mapMgr.curMapThingInfo, mapThingComp];
			}
		}
		
		private function onClickTaskType(data:Object):void
		{
			var type:int = combo_taskType.values[combo_taskType.selectedIndex];
			if(MapMgr.inst.curMapThingInfo) MapMgr.inst.curMapThingInfo.type = type;	
		}
		
		private function onClickTriggerType(data:Object):void
		{
			var type:int = combo_triggerType.values[combo_triggerType.selectedIndex];
			MapMgr.inst.curMapThingTriggerType = type;
		}
		
		
		private function disposeDragMapThing():void{
			if(_mapThingComp){
				_mapThingComp.removeFromParent();
				_mapThingComp.dispose();
				_mapThingComp = null;
			}
			_drawMapThingData = null;
		}
		
		public function _tap_btn_walk(evt:GTouchEvent):void{
			changeGridType(Enum.Walk, btn_walk);
		}
		public function _tap_btn_block(evt:GTouchEvent):void{
			changeGridType(Enum.Block, btn_block);
		}
		public function _tap_btn_visible(evt:GTouchEvent):void{
			changeGridType(Enum.Visible, btn_visible);
		}
		
		public function _tap_btn_blockVert(evt:GTouchEvent):void{
			changeGridType(Enum.BlockVerts, btn_blockVert);
		}
		public function _tap_btn_water(evt:GTouchEvent):void{
			changeGridType(Enum.Water,btn_water);
		}
		public function _tap_btn_waterVert(evt:GTouchEvent):void{
			changeGridType(Enum.WaterVerts,btn_waterVert);
		}
		public function _tap_btn_mapThing(evt:GTouchEvent):void{
			changeGridType(Enum.MapThing,btn_mapThing);
		}
		public function _tap_btn_start(evt:GTouchEvent):void{
			changeGridType(Enum.Start,btn_start);
		}
		public function _tap_btn_startWall(evt:GTouchEvent):void{
			changeGridType(Enum.StartWall,btn_startWall);
		}
		public function _tap_btn_switchWall(evt:GTouchEvent):void{
			changeGridType(Enum.SwitchWall,btn_switchWall);
		}
		/**切换操作类型**/
		private function changeGridType(type:String, btn:GButton):void{
			if(_curSelectTypeBtn == btn) return;
			emit(GameEvent.ChangeGridType, [type]);
			if(_curSelectTypeBtn) _curSelectTypeBtn.selected = false;
			_curSelectTypeBtn = btn;
			_curSelectTypeBtn.selected = true;
			(btn.getChild("n3").asGraph).alpha = 0.5;
			(btn.getChild("n3").asGraph).color = MapMgr.inst.getColorByType(type);
			grp_mapThingInfo.visible = grp_bevel.visible = false;
		}
		public function _tap_btn_resizeGrid(evt:GTouchEvent):void{
			emit(GameEvent.ResizeGrid, [txt_cellSize.text]);
		}
		public function _tap_btn_gridRange(evt:GTouchEvent):void{
			MapMgr.inst.gridRange = int(txt_gridRange.text);
			MsgMgr.ShowMsg("设置格子扩散范围大小成功！");
		}
		public function _tap_btn_toCenter(evt:GTouchEvent):void{
			emit(GameEvent.ToCenter);
		}
		public function _tap_btn_originalScale(evt:GTouchEvent):void{
			emit(GameEvent.ToOriginalScale);
		}
		public function _tap_btn_exportJson(evt:GTouchEvent):void{
			MapMgr.inst.exportJsonData();
		}
		public function _tap_btn_importJson(evt:GTouchEvent):void{
			MapMgr.inst.importJsonData();
		}
		public function _tap_btn_clearAll(evt:GTouchEvent):void{
			emit(GameEvent.ClearAllData);
		}
		public function _tap_btn_changeMap(evt:GTouchEvent):void{
			MapMgr.inst.changeMap();
		}
		
		public function _tap_btn_runDemo(evt:GTouchEvent):void{
			ModuleMgr.inst.showLayer(JoystickLayer);
			emit(GameEvent.RunDemo);
		}
		
		public function _tap_btn_showGrid(evt:GTouchEvent):void{
			emit(GameEvent.CheckShowGrid);
		}
		
		public function _tap_btn_showPath(evt:GTouchEvent):void{
			emit(GameEvent.CheckShowPath);
		}
		
	}
}