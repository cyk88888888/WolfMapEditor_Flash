package modules.mapEditor
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	
	import fairygui.GButton;
	import fairygui.GComboBox;
	import fairygui.GComponent;
	import fairygui.GGroup;
	import fairygui.GList;
	import fairygui.GLoader;
	import fairygui.GTextField;
	import fairygui.GTextInput;
	import fairygui.GTree;
	import fairygui.GTreeNode;
	import fairygui.event.GTouchEvent;
	import fairygui.event.ItemEvent;
	import fairygui.event.StateChangeEvent;
	import fairygui.utils.GTimers;
	
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
	import modules.mapEditor.conctoller.MapThingDisplay;
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
		private var txt_thingExtData:GTextInput;
		private var txt_gridRange:GTextInput;
		private var list_tree:GTree;
		private var lbl_displayCount:GTextField;
		private var list_display:GList;
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
		private var btn_trap:GButton;
		private var btn_mapThing:GButton;
		private var txt_mouseGridXY:GTextField;
		private var grp_mapThingInfo:GGroup;
		private var grp_bevel:GGroup;
		
		private var mapMgr: MapMgr;
		private var _lastSelectIndex:Number;//上一次选中的场景物件索引
		protected override function onEnter():void{
			mapMgr = MapMgr.inst;
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
			btn_trap = view.getChild("btn_trap").asButton;
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
			
			txt_thingExtData = view.getChild("txt_thingExtData").asTextInput;
			txt_thingExtData.addEventListener(FocusEvent.FOCUS_OUT, onFocusOutThingExtData);
			
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
			
			lbl_displayCount = view.getChild("lbl_displayCount").asTextField;
			list_display = view.getChild("list_display").asList;
			list_display.addEventListener(ItemEvent.CLICK, clickDisplayItem);
			list_display.itemRenderer = renderMapItem;
			
			updateMapInfo();
			mapMgr.changeMap(true);
			
			Global.stage.addEventListener(Event.RESIZE, onStageResize);
			onEmitter(GameEvent.UpdateMapInfo, updateMapInfo);
			onEmitter(GameEvent.ResizeMapSucc, updateMapInfo);
			onEmitter(GameEvent.DragMapThingStart, onDragMapThingStart);
			onEmitter(GameEvent.UpdateMapTreeStruct, updateListTree);
			onEmitter(GameEvent.ImportMapThingJson, updateMapThingPram);
			onEmitter(GameEvent.ClickMapTing, onClickMapTing);
			onEmitter(GameEvent.UpdateMapScale, updateMapScale);
			onEmitter(GameEvent.ImportMapTingComplete, refreshDisplayList);
			onEmitter(GameEvent.AddMapThing, refreshDisplayList);
			onEmitter(GameEvent.RemoveMapThing, onRemoveMapThing);
			onEmitter(GameEvent.ImportMapJson, onImportMapJson);
			
			view.addEventListener(MouseEvent.CLICK, onClickView,true);
			view.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			
			btn_xAdd.addEventListener(GTouchEvent.BEGIN, addX);
			btn_xAdd.addEventListener(GTouchEvent.END, stopAddX);
			btn_xReduce.addEventListener(GTouchEvent.BEGIN, reduceX);
			btn_xReduce.addEventListener(GTouchEvent.END, stopReduceX);
			btn_yAdd.addEventListener(GTouchEvent.BEGIN, addY);
			btn_yAdd.addEventListener(GTouchEvent.END, stopAddY);
			btn_yReduce.addEventListener(GTouchEvent.BEGIN, reduceY);
			btn_yReduce.addEventListener(GTouchEvent.END, stopReduceY);
		}
		
		protected function onStageResize(event:Event):void{
			view.width = view.viewWidth = Global.stage.stageWidth;
			view.height = view.viewHeight = Global.stage.stageHeight;
			var script:* = getScript(mapComp.name) as MapComp;
			script.checkLimitPos();
		}		
		
		/**刷新地图场景物件目录**/
		private function updateListTree():void{
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
				obj.icon = mapMgr.fileIcon;
				obj.text = String(node.data);
			}
		}
		
		private function onImportMapJson(data: Object): void {
			list_display.selectedIndex = -1;
			_lastSelectIndex = -1;
			grp_mapThingInfo.visible = grp_bevel.visible = false;
		}
		
		private function updateMapInfo():void{
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
				relationParm: data.relationParm,
				extData: data.extData
			};
		}
		
		private function newDragMapThing(icon:String):void{
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
						relationParm: _drawMapThingData ? _drawMapThingData.relationParm : "",
						extData: _drawMapThingData ? _drawMapThingData.extData : "",
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
		private function onClickMapTing(btn:GButton):void{
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
				txt_thingExtData.text = curMapThingInfo.extData ? curMapThingInfo.extData : "";
				combo_thingkType.selectedIndex = combo_thingkType.values.indexOf(curMapThingInfo.type);
				combo_relationType.selectedIndex = combo_relationType.values.indexOf(curMapThingInfo.relationType);
			}
		
			grp_mapThingInfo.visible = !isBelve;
			grp_bevel.visible = isBelve;
			
			if(!isBelve){
				var index:int = btn.parent.getChildIndex(btn);
				list_display.selectedIndex = index;
				list_display.scrollToView(index);
				_lastSelectIndex = index;
			}else{
				list_display.selectedIndex = -1;
				_lastSelectIndex = -1;
			}
		}
		
		private function updateMapScale():void{
			if(_mapThingComp) _mapThingComp.setScale(mapMgr.mapScale, mapMgr.mapScale);
		}
		
		
		private function onRemoveMapThing(rmIndex: Number):void{
			if(_lastSelectIndex == rmIndex){
				_lastSelectIndex = -1;
				list_display.selectedIndex = -1;
				grp_mapThingInfo.visible = false;
			}else{
				var curMapThingInfo:MapThingInfo = mapMgr.curMapThingInfo;
				if(curMapThingInfo){
					var mapThingComp:GButton = mapMgr.getMapThingCompByXY(curMapThingInfo.x, curMapThingInfo.y);
					var newIndex:Number = mapThingComp.parent.getChildIndex(mapThingComp);
					_lastSelectIndex = newIndex;
					list_display.selectedIndex = newIndex;
				}
			}
			refreshDisplayList();
		} 
		
		private function refreshDisplayList():void{
			var len:int = mapMgr.mapThingArr.length;
			lbl_displayCount.text = len+"";
			list_display.numItems = len;
		} 
		
		private function renderMapItem(index:int, button:GButton):void{
			var data: MapThingDisplay = mapMgr.mapThingArr[index];
			var title:GTextField = button.getChild("title").asTextField;
			var icon: GLoader = button.getChild("icon").asLoader;
			var url: String = mapMgr.mapThingRootUrl + "\\" + data.data.thingName;
			var compUnLock: GComponent = button.getChild("compUnLock").asCom;
			var compLock: GComponent = button.getChild("compLock").asCom;
			var compVisible: GComponent = button.getChild("compVisible").asCom;
			compVisible.addClickListener(onClickDisplayComp);
			compUnLock.addClickListener(onClickDisplayComp);
			compLock.addClickListener(onClickDisplayComp);
			title.text = data.name + " ("+ (index+1) + ")";
			icon.icon = url;
			compLock.visible = data.isLock;
			compUnLock.visible = !data.isLock;
			icon.alpha = title.alpha = data.visible ? 1 : 0.5;
			data.mapThing.visible = data.visible;
		}
		
		private function clickDisplayItem(evt:ItemEvent):void
		{
			var button:GButton = GButton(evt.itemObject);
			var parent:GList = button.parent.asList;
			var clickIdx:int = parent.getChildIndex(button);
			var data: MapThingDisplay = mapMgr.mapThingArr[clickIdx];
			if(_lastSelectIndex == clickIdx) return;           
			_lastSelectIndex = clickIdx;
			changeGridType(Enum.MapThing, btn_mapThing);
			emit(GameEvent.ClickDisplayItem, {btn: data.mapThing, data: data.data});
		}
		
		private function onClickDisplayComp(evt:GTouchEvent): void{
			var currentTarget: GComponent = evt.currentTarget as GComponent;
			var IR: GComponent = currentTarget.parent;
			var title:GTextField = IR.getChild("title").asTextField;
			var icon: GLoader = IR.getChild("icon").asLoader;
			var compUnLock: GComponent = IR.getChild("compUnLock").asCom;
			var compLock: GComponent = IR.getChild("compLock").asCom;
			var index:int = IR.parent.getChildIndex(IR);
			var data: MapThingDisplay = mapMgr.mapThingArr[index]; 
			switch(currentTarget.name){
				case "compVisible":
					data.visible = !data.visible;
					icon.alpha = title.alpha = currentTarget.alpha = data.visible ? 1 : 0.5;
					data.mapThing.visible = data.visible;
					var mapThingKey: String = int(data.data.x) +"_"+ int(data.data.y);
					emit(GameEvent.MapThingVisibleChg, {type: mapMgr.curMapThingTriggerType, isShow: data.visible, mapThingKey: mapThingKey});
					break;
				
				case "compLock":
					data.isLock = false;
					data.mapThing.touchable = true;
					compUnLock.visible = true;
					compLock.visible = false;
					break;
				
				case "compUnLock":
					data.isLock = true;
					data.mapThing.touchable = false;
					compUnLock.visible = false;
					compLock.visible = true;
					break;
			}
			
		}
		
		private function onFocusOutTaskId(event:Event):void{
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.taskId = int(txt_taskId.text);	
		}
		
		private function onFocusOutGroupId(event:Event):void{
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.grpId = int(txt_groupId.text);	
		}
		
		private function onFocusOutGroupIds(event:Event):void{
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.grpIdStr = txt_groupIds.text;	
			
		}
		private function onFocusOutSubGroupIds(event:Event):void{
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.subGrpIdStr = txt_subGroupIds.text;	
		}
		private function onFocusOutRelationParm(event:Event):void{
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.relationParm = txt_relationParm.text;	
		}
		
		private function onFocusOutThingExtData(event:Event):void{
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.extData = txt_thingExtData.text;	
		}
		
		private function onFocusOutX(event:Event):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(Number(txt_x.text), curMapThingInfo.y);
			}
		}
		
		private function onFocusOutY(event:Event):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(curMapThingInfo.x, Number(txt_y.text));
			}
		}
		
		private function onFocusOutAnchorX(event:Event):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingAnchor(Number(txt_anchorX.text), curMapThingInfo.anchorY);
			}
		}
		
		private function onFocusOutAnchorY(event:Event):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingAnchor(curMapThingInfo.anchorX, Number(txt_anchorY.text));
			}
		}
		
		private function addX(evt:GTouchEvent):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(curMapThingInfo.x + 1, curMapThingInfo.y);
				GTimers.inst.callDelay(200, delayAddX);	
			}
		}
		private function stopAddX(evt:GTouchEvent):void{
			GTimers.inst.remove(delayAddX);	
			GTimers.inst.remove(intervalAddX);
		}
		
		private function delayAddX():void{
			GTimers.inst.add(50, 0, intervalAddX);	
		}
		
		private function intervalAddX():void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(curMapThingInfo.x + 1, curMapThingInfo.y);
			}
		}
		
		private function reduceX(evt:GTouchEvent):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(curMapThingInfo.x - 1, curMapThingInfo.y);
				GTimers.inst.callDelay(200, delayReduceX);
			}
		}
		
		private function stopReduceX(evt:GTouchEvent):void{
			GTimers.inst.remove(delayReduceX);	
			GTimers.inst.remove(intervalReduceX);
		}
		
		private function delayReduceX():void{
			GTimers.inst.add(50, 0, intervalReduceX);	
		}
		
		private function intervalReduceX():void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(curMapThingInfo.x - 1, curMapThingInfo.y);
			}
		}
		
		private function addY(evt:GTouchEvent):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(curMapThingInfo.x, curMapThingInfo.y+1);
				GTimers.inst.callDelay(200, delayAddY);
			}
		}
		
		private function stopAddY(evt:GTouchEvent):void{
			GTimers.inst.remove(delayAddY);	
			GTimers.inst.remove(intervalAddY);
		}
		
		private function delayAddY():void{
			GTimers.inst.add(50, 0, intervalAddY);	
		}
		
		private function intervalAddY():void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(curMapThingInfo.x, curMapThingInfo.y+1);
			}
		}
		
		private function reduceY(evt:GTouchEvent):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(curMapThingInfo.x, curMapThingInfo.y-1);
				GTimers.inst.callDelay(200, delayReduceY);
			}
		}
		private function stopReduceY(evt:GTouchEvent):void{
			GTimers.inst.remove(delayReduceY);	
			GTimers.inst.remove(intervalReduceY);
		}
		
		private function delayReduceY():void{
			GTimers.inst.add(50, 0, intervalReduceY);	
		}
		
		private function intervalReduceY():void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo){
				setMapThingPos(curMapThingInfo.x, curMapThingInfo.y-1);
			}
		}
		
		private function setMapThingPos(newX: Number, newY:Number):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo) {
				var oldX: Number = curMapThingInfo.x, oldY:Number = curMapThingInfo.y;
				var mapThingComp:GButton = mapMgr.getMapThingCompByXY(oldX,oldY);
				delete mapMgr.mapThingDic[mapThingComp.name];
				txt_x.text = newX + "";
				txt_y.text = newY + "";
				mapThingComp.x = curMapThingInfo.x = newX;
				mapThingComp.y = curMapThingInfo.y = newY;
				mapThingComp.name = int(mapThingComp.x) + "_" + int(mapThingComp.y);
				mapMgr.mapThingDic[mapThingComp.name] = [mapMgr.curMapThingInfo, mapThingComp];
				emit(GameEvent.ChangeMapThingXY, {x:mapThingComp.x, y:mapThingComp.y, width: mapThingComp.width, height: mapThingComp.height});
			}
		}
		
		private function setMapThingAnchor(newAnchorX: Number, newAnchorY:Number):void{
			var curMapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
			if(curMapThingInfo) {
				var mapThingComp:GButton = mapMgr.getMapThingCompByXY(curMapThingInfo.x,curMapThingInfo.y);
				curMapThingInfo.anchorX = newAnchorX;
				curMapThingInfo.anchorY = newAnchorY;
				mapThingComp.setPivot(newAnchorX,newAnchorY,true);
			}
		}
		
		private function onClickThingkType(data:Object):void{
			var type:int = combo_thingkType.values[combo_thingkType.selectedIndex];
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.type = type;	
		}
		
		private function onClickTriggerType(data:Object):void{
			var type:int = combo_triggerType.values[combo_triggerType.selectedIndex];
			var oldType: int = mapMgr.curMapThingTriggerType;
			mapMgr.curMapThingTriggerType = type;
			emit(GameEvent.ChangeMapThingTriggerType,{oldType: oldType, type: type});
		}
		
		private function onClickBevelType(data:Object):void{
			var bevelType:int = combo_bevelType.values[combo_bevelType.selectedIndex];
			if(mapMgr.curMapThingInfo) mapMgr.curMapThingInfo.bevelType = bevelType;	
		}
		
		private function onClickRelationType(data:Object):void{
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
		public function _tap_btn_trap(evt:GTouchEvent):void{
			changeGridType(Enum.Trap,btn_trap);
		}
		
		/**切换操作类型**/
		private function changeGridType(type:String, btn:GButton):void{
			if(_curSelectTypeBtn == btn) return;
			emit(GameEvent.ChangeGridType, type);
			if(_curSelectTypeBtn) _curSelectTypeBtn.selected = false;
			_curSelectTypeBtn = btn;
			_curSelectTypeBtn.selected = true;
			(btn.getChild("n3").asGraph).alpha = 0.5;
			(btn.getChild("n3").asGraph).color = mapMgr.getColorByType(type);
			grp_mapThingInfo.visible = grp_bevel.visible = false;
			if(type != Enum.MapThing){
				list_display.selectedIndex = -1;
				_lastSelectIndex = -1;
			}
		}
		public function _tap_btn_resizeGrid(evt:GTouchEvent):void{
			emit(GameEvent.ResizeGrid, int(txt_cellSize.text));
		}
		public function _tap_btn_gridRange(evt:GTouchEvent):void{
			mapMgr.gridRange = int(txt_gridRange.text);
			MsgMgr.ShowMsg("设置格子扩散范围大小成功！");
		}
		public function _tap_btn_toCenter(evt:GTouchEvent):void{
			emit(GameEvent.ToCenter);
		}
		public function _tap_btn_originalScale(evt:GTouchEvent):void{
			emit(GameEvent.ToOriginalScale);
		}
		public function _tap_btn_exportJson(evt:GTouchEvent):void{
			mapMgr.exportJsonData();
		}
		public function _tap_btn_importJson(evt:GTouchEvent):void{
			mapMgr.importJsonData();
		}
		public function _tap_btn_clearAll(evt:GTouchEvent):void{
			emit(GameEvent.ClearAllData);
		}
		public function _tap_btn_changeMap(evt:GTouchEvent):void{
			mapMgr.changeMap();
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
		
		public function _tap_btn_showMapThing(evt:GTouchEvent):void{
			emit(GameEvent.CheckShowMapThing);
		}
		
		
	}
}