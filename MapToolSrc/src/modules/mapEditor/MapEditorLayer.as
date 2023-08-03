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
		protected override function get pkgName():String{
			return "MapEditor";
		}
		
		private var mapComp:GComponent;
		private var txt_cellSize:GTextInput;
		private var txt_mapRect:GTextField;
		private var txt_thingSize:GTextField;
		private var txt_thingName:GTextField;
		private var txt_relationParm:GTextInput;
		private var txt_gridRange:GTextInput;
		private var list_tree:GTree;
		private var _mapThingComp:GButton;
		private var txt_taskId:GTextInput;
		private var txt_groupId:GTextInput;
		private var txt_groupIds:GTextInput;
		private var txt_subGroupIds:GTextInput;
		private var txt_x:GTextInput;
		private var txt_y:GTextInput;
		private var txt_anchorX:GTextInput;
		private var txt_anchorY:GTextInput;
		private var combo_thingkType:GComboBox;
		private var combo_triggerType:GComboBox;
		private var combo_bevelType:GComboBox;
		private var combo_relationType:GComboBox;
		private var _curSelectTypeBtn:GButton;
		private var _isInCopyMapThing:Boolean;//是否点击地图目录场景树（没做这个标识会导致点击后，拖拽物件立即被销毁了）
		private var _drawMapThingData:Object;//拖拽场景已有的物件的临时数据
		private var btn_water:GButton;
		private var btn_xAdd:GButton;
		private var btn_xReduce:GButton;
		private var btn_yAdd:GButton;
		private var btn_yReduce:GButton;
		private var btn_walk:GButton;
		private var btn_waterVert:GButton;
		private var btn_start:GButton;
		private var btn_mapThing:GButton;
		private var txt_mouseGridXY:GTextField;
		private var grp_mapThingInfo:GGroup;
		private var grp_bevel:GGroup;
		
		protected override function onEnter():void{
			var mapMgr:MapMgr = MapMgr.inst;
			txt_cellSize = view.getChild("txt_cellSize").asTextInput;
			
			txt_mapRect = view.getChild("txt_mapRect").asTextField;
			txt_thingSize = view.getChild("txt_thingSize").asTextField;
			txt_thingName = view.getChild("txt_thingName").asTextField;
			mapMgr.mouseGridTextField = txt_mouseGridXY = view.getChild("txt_mouseGridXY").asTextField;
			
			txt_gridRange = view.getChild("txt_gridRange").asTextInput;
			txt_gridRange.text = mapMgr.gridRange.toString();
			
			btn_xAdd = view.getChild("btn_xAdd").asButton;
			btn_xReduce = view.getChild("btn_xReduce").asButton;
			btn_yAdd = view.getChild("btn_yAdd").asButton;
			btn_yReduce = view.getChild("btn_yReduce").asButton;
			btn_walk = view.getChild("btn_walk").asButton;
			btn_waterVert = view.getChild("btn_waterVert").asButton;
			btn_start = view.getChild("btn_start").asButton;
			btn_mapThing = view.getChild("btn_mapThing").asButton;
			btn_water = view.getChild("btn_water").asButton;
			mapComp = view.getChild("mapComp").asCom;
			
			grp_mapThingInfo = view.getChild("grp_mapThingInfo").asGroup;
			grp_bevel = view.getChild("grp_bevel").asGroup;
			txt_taskId = view.getChild("txt_taskId").asTextInput;
			txt_taskId.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutTaskId);
			
			txt_groupId = view.getChild("txt_groupId").asTextInput;
			txt_groupId.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutGroupId);
			
			txt_groupIds = view.getChild("txt_groupIds").asTextInput;
			txt_groupIds.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutGroupIds);
			
			txt_subGroupIds = view.getChild("txt_subGroupIds").asTextInput;
			txt_subGroupIds.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutSubGroupIds);	
			
			txt_relationParm = view.getChild("txt_relationParm").asTextInput;
			txt_relationParm.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutRelationParm);
			
			txt_x = view.getChild("txt_x").asTextInput;
			txt_x.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutX);
			
			txt_y = view.getChild("txt_y").asTextInput;
			txt_y.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutY);
			
			txt_anchorX = view.getChild("txt_anchorX").asTextInput;
			txt_anchorX.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutAnchorX);
			
			txt_anchorY = view.getChild("txt_anchorY").asTextInput;
			txt_anchorY.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutAnchorY);
			
			
			txt_anchorX.restrict = txt_anchorY.restrict = txt_x.restrict = txt_y.restrict = "0-9 .\\-";
			combo_thingkType = view.getChild("combo_thingkType").asComboBox;
			combo_thingkType.addEventListener(StateChangeEvent.CHANGED,onClickThingkType);
			
			combo_bevelType = view.getChild("combo_bevelType").asComboBox;
			combo_bevelType.addEventListener(StateChangeEvent.CHANGED,onClickBevelType);
			
			combo_relationType = view.getChild("combo_relationType").asComboBox;
			combo_relationType.addEventListener(StateChangeEvent.CHANGED,onClickRelationType);
			
			combo_triggerType = view.getChild("combo_triggerType").asComboBox;
			combo_triggerType.items =  mapMgr.triggerDesc;
			combo_triggerType.values = mapMgr.triggerTypes;
			combo_triggerType.selectedIndex = 0;
			combo_triggerType.addEventListener(StateChangeEvent.CHANGED, onClickTriggerType);
			
			list_tree = view.getChild("list_tree").asTree;
			list_tree.treeNodeRender = renderTreeNode;
			list_tree.addEventListener(ItemEvent.CLICK, onClickMapTreeItem);
			
			updateMapInfo();
			Global.stage.addEventListener(Event.RESIZE, onStageResize);
			onEmitter(GameEvent.UpdateMapInfo, updateMapInfo);
			onEmitter(GameEvent.ResizeMapSucc, updateMapInfo);
			onEmitter(GameEvent.DragMapThingStart, onDragMapThingStart);
			onEmitter(GameEvent.UpdateMapTreeStruct, updateListTree);
			onEmitter(GameEvent.ImportMapThingJson, updateMapThingPram);
			onEmitter(GameEvent.ClickMapTing, onClickMapTing);
			onEmitter(GameEvent.UpdateMapScale, updateMapScale);
			mapMgr.changeMap(true);
			view.addEventListener(MouseEvent.CLICK, onClickView,true);
			view.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		protected function onStageResize(event:Event):void{
			view.width = view.viewWidth = Global.stage.stageWidth;
			view.height = view.viewHeight = Global.stage.stageHeight;
			var script:* = getScript(mapComp.name) as MapComp;
			script.checkLimitPos();
		}		
		
		/**刷新地图场景物件目录**/
		private function updateListTree():void{
			var mapMgr:MapMgr = MapMgr.inst;
			list_tree.rootNode.removeChildren();
			createNodeRecursive(mapMgr.mapDirectoryStrut, list_tree.rootNode);
			//递归创建节点
			function createNodeRecursive(fileArr:Vector.<MapFileTreeNode>, parent:GTreeNode):void{
				for each(var item:MapFileTreeNode in fileArr){
					var node: GTreeNode = new GTreeNode(item.isDir);
					node.data = item.isDir ? item.name : [item.name, BaseUT.checkIsPngOrJpg(item.path) ? item.path : mapMgr.fileIcon];
					parent.addChild(node);
					if(item.isDir) createNodeRecursive(item.fileArr, node);
				}
			}
		}
		
		private function updateMapThingPram(data:Object):void{
			var thingPramInfo:Object = data;
			var thingTypeList:Array = thingPramInfo.thingTypeList;
			var thingTypeArr:Array = [];
			var taskDescArr:Array = [];
			for(var i:int = 0; i< thingTypeList.length; i++){
				var obj:Object = thingTypeList[i];
				thingTypeArr.push(obj.type);
				taskDescArr.push(obj.desc);
			}
			combo_thingkType.items = taskDescArr;
			combo_thingkType.values = thingTypeArr;
			combo_thingkType.selectedIndex = 0;
			
			
			var bevelTypeList:Array = thingPramInfo.bevelTypeList;
			var bevelTypeArr:Array = [];
			var bevelDescArr:Array = [];
			for(i = 0; i< bevelTypeList.length; i++){
				var obj1:Object = bevelTypeList[i];
				bevelTypeArr.push(obj1.type);
				bevelDescArr.push(obj1.desc);
			}
			combo_bevelType.items = bevelDescArr;
			combo_bevelType.values = bevelTypeArr;
			combo_bevelType.selectedIndex = 0;
			
			
			var relationTypeList:Array = thingPramInfo.relationTypeList;
			var relationTypeArr:Array = [];
			var relationDescArr:Array = [];
			for(i = 0; i< relationTypeList.length; i++){
				var obj2:Object = relationTypeList[i];
				relationTypeArr.push(obj2.type);
				relationDescArr.push(obj2.desc);
			}
			combo_relationType.items = relationDescArr;
			combo_relationType.values = relationTypeArr;
			combo_relationType.selectedIndex = 0;
			
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
		
		private function updateMapInfo():void{
			var mapMgr:MapMgr = MapMgr.inst;
			txt_mapRect.text = mapMgr.mapWidth + ", " + mapMgr.mapHeight;
			txt_cellSize.text = mapMgr.cellSize.toString();
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
			newDragMapThing(data.url);
			_drawMapThingData = {
				taskId: data.taskId, 
				grpId: data.grpId, 
				type: data.type,
				relationType: data.relationType,
				bevelType: data.bevelType,
				grpIdStr: data.grpIdStr,
				subGrpIdStr: data.subGrpIdStr,
				relationParm: data.relationParm
			};
		}
		
		private function newDragMapThing(icon:String):void{
			var mapMgr:MapMgr = MapMgr.inst;
			disposeDragMapThing();
			emit(GameEvent.ChangeGridType, Enum.MapThing);
			changeGridType(Enum.MapThing, btn_mapThing);
			_mapThingComp = mapMgr.getMapThingComp(icon);
			_mapThingComp.x = Global.stage.mouseX;
			_mapThingComp.y = Global.stage.mouseY;
			_mapThingComp.setScale(mapMgr.mapScale, mapMgr.mapScale);
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
						grpId: _drawMapThingData ? _drawMapThingData.grpId : 0,
						type: _drawMapThingData ? _drawMapThingData.type : 0,
						relationType: _drawMapThingData ? _drawMapThingData.relationType : 0,
						bevelType: _drawMapThingData ? _drawMapThingData.bevelType : 0,
						grpIdStr: _drawMapThingData ? _drawMapThingData.grpIdStr : 0,
						subGrpIdStr: _drawMapThingData ? _drawMapThingData.subGrpIdStr : 0,
						relationParm: _drawMapThingData ? _drawMapThingData.relationParm : 0,
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
				txt_groupIds.text = curMapThingInfo.grpIdStr ? curMapThingInfo.grpIdStr : "";
				txt_subGroupIds.text = curMapThingInfo.subGrpIdStr ? curMapThingInfo.subGrpIdStr : "";
				combo_bevelType.selectedIndex = combo_bevelType.values.indexOf(curMapThingInfo.bevelType);
			}else{
				txt_taskId.text = curMapThingInfo.taskId+"";
				txt_groupId.text = curMapThingInfo.grpId+"";
				txt_x.text = curMapThingInfo.x+"";
				txt_y.text = curMapThingInfo.y+"";
				txt_anchorX.text = curMapThingInfo.anchorX+"";
				txt_anchorY.text = curMapThingInfo.anchorY+"";
				txt_thingSize.text = curMapThingInfo.width+","+curMapThingInfo.height;
				txt_thingName.text = curMapThingInfo.thingName;
				txt_relationParm.text = curMapThingInfo.relationParm ? curMapThingInfo.relationParm : "";
				combo_thingkType.selectedIndex = combo_thingkType.values.indexOf(curMapThingInfo.type);
				combo_relationType.selectedIndex = combo_relationType.values.indexOf(curMapThingInfo.relationType);
			}
		
			grp_mapThingInfo.visible = !isBelve;
			grp_bevel.visible = isBelve;
		}
		
		private function updateMapScale():void{
			var mapMgr:MapMgr = MapMgr.inst;
			if(_mapThingComp) _mapThingComp.setScale(mapMgr.mapScale, mapMgr.mapScale);
		}
		
		private function onFocusOutTaskId(event:Event):void{
			var mapMgr:MapMgr = MapMgr.inst;
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.taskId = int(txt_taskId.text);	
		}
		
		private function onFocusOutGroupId(event:Event):void{
			var mapMgr:MapMgr = MapMgr.inst;
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.grpId = int(txt_groupId.text);	
		}
		
		private function onFocusOutGroupIds(event:Event):void{
			var mapMgr:MapMgr = MapMgr.inst;
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.grpIdStr = txt_groupIds.text;	
			
		}
		private function onFocusOutSubGroupIds(event:Event):void{
			var mapMgr:MapMgr = MapMgr.inst;
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.subGrpIdStr = txt_subGroupIds.text;	
		}
		private function onFocusOutRelationParm(event:Event):void{
			var mapMgr:MapMgr = MapMgr.inst;
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.relationParm = txt_relationParm.text;	
		}
		private function onFocusOutX(event:Event):void{
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
		
		private function onFocusOutY(event:Event):void{
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
		
		private function onFocusOutAnchorX(event:Event):void{
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
		
		private function onFocusOutAnchorY(event:Event):void{
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
		
		private function onClickThingkType(data:Object):void{
			var mapMgr:MapMgr = MapMgr.inst;
			var type:int = combo_thingkType.values[combo_thingkType.selectedIndex];
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.type = type;	
		}
		
		private function onClickTriggerType(data:Object):void{
			var type:int = combo_triggerType.values[combo_triggerType.selectedIndex];
			MapMgr.inst.curMapThingTriggerType = type;
		}
		
		private function onClickBevelType(data:Object):void{
			var mapMgr:MapMgr = MapMgr.inst;
			var bevelType:int = combo_bevelType.values[combo_bevelType.selectedIndex];
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.bevelType = bevelType;	
		}
		
		private function onClickRelationType(data:Object):void{
			var mapMgr:MapMgr = MapMgr.inst;
			var type:int = combo_relationType.values[combo_relationType.selectedIndex];
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.relationType = type;		
		}
		
		private function disposeDragMapThing():void{
			if(_mapThingComp){
				_mapThingComp.removeFromParent();
				_mapThingComp.dispose();
				_mapThingComp = null;
			}
			_drawMapThingData = null;
		}
		
		
		public function _tap_btn_xAdd(evt:GTouchEvent):void{
			MsgMgr.ShowMsg("功能开发中!!!");
		}
		
		public function _tap_btn_xReduce(evt:GTouchEvent):void{
			MsgMgr.ShowMsg("功能开发中!!!");
		}
		
		public function _tap_btn_yAdd(evt:GTouchEvent):void{
			MsgMgr.ShowMsg("功能开发中!!!");
		}
		
		public function _tap_btn_yReduce(evt:GTouchEvent):void{
			MsgMgr.ShowMsg("功能开发中!!!");
		}
		
		public function _tap_btn_walk(evt:GTouchEvent):void{
			changeGridType(Enum.Walk, btn_walk);
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
		/**切换操作类型**/
		private function changeGridType(type:String, btn:GButton):void{
			if(_curSelectTypeBtn == btn) return;
			emit(GameEvent.ChangeGridType, type);
			if(_curSelectTypeBtn) _curSelectTypeBtn.selected = false;
			_curSelectTypeBtn = btn;
			_curSelectTypeBtn.selected = true;
			(btn.getChild("n3").asGraph).alpha = 0.5;
			(btn.getChild("n3").asGraph).color = MapMgr.inst.getColorByType(type);
			grp_mapThingInfo.visible = grp_bevel.visible = false;
		}
		public function _tap_btn_resizeGrid(evt:GTouchEvent):void{
			emit(GameEvent.ResizeGrid, int(txt_cellSize.text));
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