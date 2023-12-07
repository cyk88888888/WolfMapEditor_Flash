package modules.mapEditor
{
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.utils.Dictionary;
	
	import fairygui.GButton;
	import fairygui.GComponent;
	import fairygui.GGraph;
	import fairygui.GLoader;
	import fairygui.event.GTouchEvent;
	
	import framework.base.BaseUT;
	import framework.base.Global;
	import framework.mgr.ModuleMgr;
	import framework.ui.UIComp;
	
	import modules.base.Enum;
	import modules.base.GameEvent;
	import modules.common.JuHuaDlg;
	import modules.common.mgr.MsgMgr;
	import modules.mapEditor.comp.MapGridSp;
	import modules.mapEditor.comp.MapRemindSp;
	import modules.mapEditor.comp.MapThingSelectSp;
	import modules.mapEditor.conctoller.MapMgr;
	import modules.mapEditor.conctoller.MapThingDisplay;
	import modules.mapEditor.conctoller.MapThingInfo;
	import modules.mapEditor.joystick.JoystickLayer;

	/**
	 * 地图编辑组件 
	 * @author cyk
	 * 
	 */	
	public class MapComp extends UIComp
	{
		private const offY:int = 100;//预留刘海屏偏移像素
		
		private var grp_map:GComponent;
		private var grp_container:GComponent;
		private var lineContainer:GComponent;
		private var gridContainer:GComponent;
		private var mapThingContainer: GComponent;
		private var bevelContainer: GComponent;
		private var remindContainer:GComponent;
		private var grp_floor:GComponent;
		private var pet:GLoader;
		private var center:GGraph;
		
		private var _cellSize:int;
		private var _gridType:String = Enum.None;//格子类型
		private var lineShape:Shape;//线条shape
		private var gridSprite: Sprite;//格子容器
		private var _isCtrlDown:Boolean;//ctrl键是否处于按下状态
		private var speed:int = 5;//角色移动速度
		private var mapThingSelectSp: MapThingSelectSp;//场景物件选中框
		private var mapRemindSp: MapRemindSp;//场景物件提示选中框
		private var _isLeftDown:Boolean;
		private var curScale:Number = 1;
		private var _lastSelectMapThingComp:GButton;//上一次选中的场景物件
		private var mapMgr: MapMgr;
		private var _isPressSpace: Boolean;
		private var _preMousePos: Point;
		private var _colorTypeDic: Dictionary;
		private var _graphicsDic:Dictionary;
		private var _redrawDic:Dictionary;
		protected override function onFirstEnter():void
		{
			grp_map = view.getChild("grp_map").asCom;
			grp_container = grp_map.getChild("grp_container").asCom;
			remindContainer = grp_container.getChild("remindContainer").asCom;
			mapThingContainer = grp_container.getChild("mapThingContainer").asCom;
			bevelContainer = grp_container.getChild("bevelContainer").asCom;
			lineContainer = grp_container.getChild("lineContainer").asCom;
			gridContainer = grp_container.getChild("gridContainer").asCom;
			grp_floor = grp_map.getChild("grp_floor").asCom;
			pet = grp_container.getChild("pet").asLoader;
			center = grp_container.getChild("center").asGraph;
			mapThingSelectSp = new MapThingSelectSp();
			mapThingSelectSp.mouseChildren = mapThingSelectSp.mouseEnabled = false;
			
			mapRemindSp = new MapRemindSp();
			mapRemindSp.mouseChildren = mapRemindSp.mouseEnabled = false;
			
			view.addEventListener(MouseEvent.CLICK, onClick);
			view.addEventListener(MouseEvent.MOUSE_DOWN, mouseDown);
			view.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
			view.addEventListener(MouseEvent.MOUSE_WHEEL,onMouseWheel);
			view.addEventListener(MouseEvent.MIDDLE_CLICK,onMouseMiddleClick);
			
			Global.stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			Global.stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			_cellSize = mapMgr.cellSize;
			lineShape = new Shape();
			lineContainer.displayListContainer.addChild(lineShape);
			gridSprite = new Sprite();
			gridContainer.displayListContainer.addChild(gridSprite);
			init();
		}
		
		protected override function onEnter():void{
			onEmitter(GameEvent.ImportMapJson, onImportMapJson);
			onEmitter(GameEvent.CheckShowGrid, onCheckShowGrid);
			onEmitter(GameEvent.CheckShowMapThing, onCheckShowMapThing);
			onEmitter(GameEvent.ChangeGridType, onChangeGridType);
			onEmitter(GameEvent.ResizeGrid, onResizeGrid);
			onEmitter(GameEvent.RunDemo, onRunDemo);
			onEmitter(GameEvent.CloseDemo, onCloseDemo);
			onEmitter(GameEvent.ToCenter, onToCenter);
			onEmitter(GameEvent.ToOriginalScale, onToOriginalScale);
			onEmitter(GameEvent.ClearAllData, onClearAllData);
			onEmitter(GameEvent.DragMapThingDown, onDragMapThingDown);
			onEmitter(GameEvent.ChangeMapThingXY, onChangeMapThingXY);
			onEmitter(GameEvent.CheckShowPath, onCheckShowPath);
			onEmitter(GameEvent.ChangeMapThingTriggerType, onChangeMapThingTriggerType);
			onEmitter(GameEvent.DarwGraphic, onDarwGraphic);
			onEmitter(GameEvent.ClickDisplayItem, onClickDisplayItem);
			onEmitter(GameEvent.MapThingVisibleChg, checkOneGridGraphicVsb);
			mapMgr = MapMgr.inst;
		}
		
		private function init():void{
			var mapWidth:int = mapMgr.mapWidth;
			var mapHeight:int = mapMgr.mapHeight;
			var numCols:int = mapMgr.numCols = Math.ceil(mapWidth / _cellSize);
			var numRows:int = mapMgr.numRows = Math.ceil(mapHeight / _cellSize);
			var totGrid:Number = numCols * numRows; 
			mapMgr.areaGraphicsSize = totGrid < 65536 ? 16 : totGrid < 300000 ? 32 : 64;
			trace("行：" + numRows + ", 列：" + numCols);
			onToOriginalScale();
			removeAllGrid();
			removeAllMapThing();
			center.setXY((mapWidth - center.width) / 2, (mapHeight - center.height) / 2);
			lineShape.alpha = 0.5;
			lineShape.graphics.clear();
			lineShape.graphics.lineStyle(1,0x000000);
			
			//画横线
			for(var i:int = 0; i < numRows; i++){
				lineShape.graphics.moveTo(0, i * _cellSize);
				lineShape.graphics.lineTo(mapWidth, i * _cellSize);
			}
			
			//画列线
			for(var j:int = 0; j < numCols; j++){
				lineShape.graphics.moveTo(j * _cellSize, 0);
				lineShape.graphics.lineTo(j * _cellSize, mapHeight);
			}
		}
		
		/** 清除所有格子**/
		private function removeAllGrid():void
		{
			gridSprite.removeChildren();
			mapMgr.gridDataDic = new Dictionary();
			_graphicsDic = new Dictionary();
			_colorTypeDic = new Dictionary();
		}
		
		/** 清除所有场景物件**/
		private function removeAllMapThing():void{
			mapThingContainer.removeChildren();
			bevelContainer.removeChildren();
			mapThingSelectSp.rmSelf();
			mapMgr.curMapThingInfo = null;
			mapMgr.mapThingDic = new Dictionary();
			mapMgr.mapThingArr = new Vector.<MapThingDisplay>();
		}
		
		/** 格子大小变化**/
		private function onResizeGrid(cellSize:int): void
		{
			if (cellSize == mapMgr.cellSize)
			{
				MsgMgr.ShowMsg("格子大小没有变化！！！");
				return;
			}
			if(mapMgr.hasExitGridData()){
				MsgMgr.ShowMsg("当前存在格子数据，重置格子大小会清除全部数据，是否确定重置？",Enum.Msg_MsgBox,function():void{
					onOk();
				},function():void{})
			}else{
				onOk();
			}
			
			function onOk():void{
				_cellSize = cellSize;
				mapMgr.cellSize = cellSize;
				init();
			}
		}
		
		private function onChangeGridType(data:String): void
		{
			var gridType:String = data;
			_gridType = gridType;
			if(_gridType!=Enum.MapThing){
				mapThingSelectSp.rmSelf();
			}
		}
		
		protected function mouseDown(evt:MouseEvent):void
		{
			_isLeftDown = true;
			_preMousePos = new Point(Global.stage.mouseX, Global.stage.mouseY);
			view.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		protected function mouseUp(evt:MouseEvent):void
		{
			_isLeftDown = false;
			view.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		protected function mouseMove(evt:MouseEvent):void
		{
			if(_isPressSpace){ 
				var mousePos:Point = new Point(Global.stage.mouseX, Global.stage.mouseY);
				var deltaX:Number = mousePos.x - _preMousePos.x;
				var deltaY:Number = mousePos.y - _preMousePos.y;
				var toX: Number = grp_map.x + deltaX;
				var toY: Number = grp_map.y + deltaY;
				grp_map.setXY(toX, toY);
				_preMousePos = mousePos;
				checkLimitPos();
			}else if(_isLeftDown){
				if (_gridType == Enum.None) return;
				addOrRmRangeGrid(Global.stage.mouseX, Global.stage.mouseY, !_isCtrlDown);//Ctrl键按下状态，只减不加
			}
		}
		
		private function onClick(evt:MouseEvent):void
		{
			if (_isPressSpace) return;
			if (_gridType == Enum.MapThing && !mapThingSelectSp.isShow) return;
			if (_gridType == Enum.None) {
				MsgMgr.ShowMsg("请先选择操作类型!!!");
				return;
			}
			addOrRmRangeGrid(Global.stage.mouseX, Global.stage.mouseY, !_isCtrlDown);
		}
		
		/**获取当前鼠标下的格子信息 [格子所在的列, 格子所在的行, 绘制颜色格子的坐标X, 绘制颜色格子的坐标Y, gridKey]**/
		private function getGridInfoByMousePos(): Array {
			var localPos: Point = grp_map.globalToLocal(Global.stage.mouseX, Global.stage.mouseY);
			var gridXY: Point = mapMgr.pos2GridXY(localPos.x, localPos.y - offY);
			var gridPosX: int = gridXY.x;//格子所在的列
			var gridPosY: int = gridXY.y;//格子所在的行
			var gridKey: String = gridPosX + "_" + gridPosY;
			var gridX: int = gridPosX * _cellSize;//绘制颜色格子的坐标X
			var gridY: int = gridPosY * _cellSize;//绘制颜色格子的坐标Y
			return [gridPosX, gridPosY, gridX, gridY, gridKey];
		}
		
		/**添加or删除以鼠标为中心点的范围格子**/
		private function addOrRmRangeGrid(mouseX:Number, mouseY:Number,isAdd:Boolean = true):void{
			var curCenterGridInfo:Array = getGridInfoByMousePos();
			var gridPosX: int = curCenterGridInfo[0];//格子所在的列
			var gridPosY: int = curCenterGridInfo[1];//格子所在的行
			var gridRange: int = mapMgr.gridRange;
			_redrawDic = new Dictionary();
			var gridType: String = _gridType == Enum.MapThing ? Enum.MapThing + mapMgr.curMapThingTriggerType : _gridType;
			if (gridRange == 0) {
				if (isAdd) addGrid(gridType, gridPosX, gridPosY);
				else rmGrid(gridType, gridPosX, gridPosY);
			} else {
				var startCol: int = Math.max(0, gridPosX - gridRange);
				var endCol: int = Math.min(mapMgr.numCols - 1, gridPosX + gridRange);
				var startRow: int = Math.max(0, gridPosY - gridRange);
				var endRow: int = Math.min(mapMgr.numRows - 1, gridPosY + gridRange);
				for (var i: int = startCol; i <= endCol; i++) {
					for (var j: int = startRow; j <= endRow; j++) {
						if (isAdd) addGrid(gridType, i, j);
						else rmGrid(gridType, i, j);
					}
				}
			}
			if(!isAdd) drawGraphics();
		}
		/**
		 * 添加一个指定类型的格子 
		 * @param gridType 格子类型
		 * @param gridPosX 格子所在的列
		 * @param gridPosY 格子所在的行
		 */		
		private function addGrid(gridType:String, gridPosX:int,gridPosY:int):void
		{	
			var gridSubType:String = gridType;
			var colorType:String = gridType;
			var isMapThing: Boolean = gridType.indexOf(Enum.MapThing) > -1;
			if(isMapThing){//场景物件格子有归属关系，这里特殊处理，方便物件删除时，把格子一起删除
				var mapThingInfo:MapThingInfo = mapMgr.curMapThingInfo;
				if(!mapThingInfo || mapThingInfo.type == Enum.MapThingType_bevel) return;//顶点格子不需要绘制颜色格子
				var mapThingComp:GButton = mapMgr.getMapThingCompByXY(mapThingInfo.x,mapThingInfo.y);
				if(mapThingComp && (!mapThingComp.touchable || !mapThingComp.visible)) return;//不可点击||不可见状态下，不可以绘制格子
				var mapThingKey:String = int(mapThingInfo.x)+"_" + int(mapThingInfo.y);
				if(gridType == Enum.MapThing){
					gridType;
				}
				gridSubType = gridType +"_"+ mapThingKey;
			}
			var gridKey:String = gridPosX + "_" + gridPosY;
			var areaSize: int = mapMgr.areaGraphicsSize;
			var areaKey:String = Math.floor(gridPosX / areaSize) + "_" + Math.floor(gridPosY / areaSize);
			var gridDataDic: Dictionary = mapMgr.gridDataDic;
			if(!gridDataDic[gridSubType]) gridDataDic[gridSubType] = new Dictionary();
			if(!gridDataDic[gridSubType][areaKey]) gridDataDic[gridSubType][areaKey] = new Dictionary();
			if(gridDataDic[gridSubType][areaKey][gridKey]) return;//该行列已绘制格子
			gridDataDic[gridSubType][areaKey][gridKey] = gridKey;
			var color:Number = _colorTypeDic[gridSubType] = mapMgr.getColorByType(colorType);
			var graphickey:String = gridSubType + "_" + areaKey;
			var graphic: MapGridSp = getGraphics(graphickey);
			if(isMapThing){
				graphic.visible = gridType == Enum.MapThing + mapMgr.curMapThingTriggerType;
			}
			var gridX: int = gridPosX * _cellSize;//绘制颜色格子的坐标X
			var gridY: int = gridPosY * _cellSize;//绘制颜色格子的坐标Y
			graphic.drawRect(gridX + 0.5, gridY + 0.5, _cellSize, _cellSize, color);
		}
		
		/**
		 * 移除一个指定类型的格子 
		 * @param gridType 格子类型
		 * @param gridPosX 格子所在的列
		 * @param gridPosY 格子所在的行
		 */
		private function rmGrid(gridType: String, gridPosX: int, gridPosY: int): void {
			var gridSubType: String = gridType;
			if (gridType.indexOf(Enum.MapThing) > -1) {//场景物件格子有归属关系，这里特殊处理，方便物件删除时，把格子一起删除
				var mapThingInfo: MapThingInfo = mapMgr.curMapThingInfo;
				var mapThingComp:GButton = mapMgr.getMapThingCompByXY(mapThingInfo.x,mapThingInfo.y);
				if(mapThingComp && (!mapThingComp.touchable || !mapThingComp.visible)) return;//不可点击||不可见状态下，不可以绘制格子
				var mapThingKey: String = int(mapThingInfo.x) + "_" + int(mapThingInfo.y);
				gridSubType = gridType + "_" + mapThingKey;
			}
			var gridKey: String = gridPosX + "_" + gridPosY;
			var areaSize: int = mapMgr.areaGraphicsSize;
			var areaKey:String = Math.floor(gridPosX / areaSize) + "_" + Math.floor(gridPosY / areaSize);
			var gridDataDic: Dictionary = mapMgr.gridDataDic;
			if(gridDataDic[gridSubType] && gridDataDic[gridSubType][areaKey] && gridDataDic[gridSubType][areaKey][gridKey]){
				delete gridDataDic[gridSubType][areaKey][gridKey];
				_redrawDic[gridSubType + "|" + areaKey] = gridSubType + "_" + areaKey;
			}
		}
		
		/**
		 * 移除格子删除数据后，重新绘制感兴趣区域的所有格子
		 */
		private function drawGraphics(): void {
			var gridDataDic: Dictionary = mapMgr.gridDataDic;
			for(var key:String in _redrawDic){
				var splitKey:Array = key.split("|");
				var gridType: String = splitKey[0];
				var areaKey:String = splitKey[1];
				var graphickey:String = _redrawDic[key];
				var graphic: MapGridSp = getGraphics(graphickey);
				graphic.clear();
				var color:Number = _colorTypeDic[gridType];
				var areaGridDataMap: Dictionary = gridDataDic[gridType][areaKey];
				if (areaGridDataMap) {
					for (var gridKey: String in areaGridDataMap) {
						var splitGridPosKey: Array = gridKey.split("_");
						var gridX: Number = Number(splitGridPosKey[0]) * _cellSize;
						var gridY: Number = Number(splitGridPosKey[1]) * _cellSize;
						graphic.drawRect(gridX + 0.5, gridY + 0.5, _cellSize, _cellSize, color);
					}
				}
			}
		}
		
		private function getGraphics(key: String): MapGridSp {
			if (!_graphicsDic[key]) {
				var gridSp: MapGridSp = new MapGridSp();
				gridSprite.addChild(gridSp);
				_graphicsDic[key] = gridSp;
			}
			return _graphicsDic[key];
		}
		
		private function onDarwGraphic(redrawDic:Dictionary): void {
			_redrawDic = redrawDic;
			drawGraphics();
		}
		
		/**导入地图json数据**/
		private function onImportMapJson(data: Object): void {
			var juahua: JuHuaDlg = ModuleMgr.inst.showLayer(JuHuaDlg) as JuHuaDlg;
			var mapInfo: Object = data;//MapJsonInfo
			_cellSize = mapInfo.cellSize;
			importFloorBg(function (): void {
				init();
				/** 设置可行走节点**/
				var walkMap:Object = mapInfo.walkMap;
				if(walkMap){
					for(var key:String in walkMap){
						var row:int = Number(key);
						var lineArr:Array = walkMap[key];
						for(var line:int=0;line<lineArr.length;line++){
							var itemArr:Array = lineArr[line];
							var startCol: int = itemArr[0];
							var endCol: int = itemArr[1];
							for(var col:int=startCol;col<=endCol;col++){
								addGrid(Enum.Walk, col, row);
							}
						}
					}
				}
			
				var walkList:Array = mapInfo.walkList;
				if(walkList){//为了兼容旧版地图数据，待删todo...
					for (var i: int = 0; i < walkList.length; i++) {
						var lineList: Array = walkList[i];
						for (var j: int = 0; j < lineList.length; j++) {
							if (lineList[j] != 0) {
								var gridPosX: int = j;//所在格子位置x
								var gridPosY: int = i;//所在格子位置y
								var gridType: String;
								if (lineList[j] == Enum.WalkType)//可行走
								{
									gridType = Enum.Walk;
								} 
								addGrid(gridType, gridPosX, gridPosY);
							}
							
						}
					}
				}
			
				/** 设置水域和落水点**/
				addGridDataByType(Enum.Water, mapInfo.waterList);
				addGridDataByType(Enum.WaterVerts, mapInfo.waterVertList);
				addGridDataByType(Enum.Start, mapInfo.startList);
				addGridDataByType(Enum.Trap, mapInfo.trapList);
				/** 设置场景物件触发区域和场景物件**/
				if (mapInfo.mapThingList) {
					for each(var mapThingData: Object in mapInfo.mapThingList) {//mapThingData -> MapThingInfo
						var tempMapThingInfo: MapThingInfo = new MapThingInfo();
						tempMapThingInfo.x = mapThingData.x;
						tempMapThingInfo.y = mapThingData.y;
						mapMgr.curMapThingInfo = tempMapThingInfo;//这里创建的临时mapthingInfo是为了导入地图数据时往gridDataDic里塞格子数据用
						for(var k:int = 0, len:int = mapMgr.triggerTypes.length; k < len; k++){
							var triggerObj: Object = mapMgr.triggerTypes[k];
							var fieldName: String = triggerObj["fieldName"];
							if(mapThingData[fieldName]) addGridDataByType(Enum.MapThing + triggerObj["type"], mapThingData[fieldName]);
						}
						var relationParm: String = parseData(mapThingData.relationParm);
						var extData:String = parseData(mapThingData.extData);
						onDragMapThingDown({
							isImportJson: true,
							url: BaseUT.checkIsPngOrJpg(mapThingData.thingName) ? mapMgr.mapThingRootUrl + "\\" + mapThingData.thingName : mapMgr.fileIcon,
							x: mapThingData.x,
							y: mapThingData.y,
							anchorX: mapThingData.anchorX,
							anchorY: mapThingData.anchorY,
							taskId: mapThingData.taskId,
							grpId: mapThingData.grpId,
							type: mapThingData.type,
							relationType: mapThingData.relationType,
							relationParm: relationParm,
							extData: extData,
							isByDrag: false
						});
					}
				}
				
				
				if (mapInfo.borderList) {
					for each(var mapThingData2: Object in mapInfo.borderList) {//mapThingData2 -> MapThingInfo
						var grpIds: Array = mapThingData2.grpIds || [];
						var grpIdStr: String = "";
						for (var ii: int = 0; ii < grpIds.length; ii++) {
							grpIdStr += grpIds[ii] + (ii == grpIds.length - 1 ? "" : ",");
						}
						
						var subGrpIds: Array = mapThingData2.subGrpIds || [];
						var subGrpIdStr: String = "";
						for (ii = 0; ii < subGrpIds.length; ii++) {
							subGrpIdStr += subGrpIds[ii] + (ii == subGrpIds.length - 1 ? "" : ",");
						}
						onDragMapThingDown({
							isImportJson: true,
							url: BaseUT.checkIsPngOrJpg(mapMgr.bavelResStr) ? mapMgr.mapThingRootUrl + "\\" + mapMgr.bavelResStr : mapMgr.fileIcon,
							x: mapThingData2.x,
							y: mapThingData2.y,
							anchorX: mapThingData2.anchorX,
							anchorY: mapThingData2.anchorY,
							bevelType: mapThingData2.bevelType,
							grpIdStr: grpIdStr,
							subGrpIdStr: subGrpIdStr,
							isByDrag: true
						});
					}
				}
				
				emit(GameEvent.ImportMapTingComplete);
				
				function parseData(data: Object): String{
					var dataStr: String = "";
					if(data){
						var objArr:Array = [];
						for(var key:String in data){
							objArr.push([key,Number(data[key])]);
							
						}
						var len:int = objArr.length;
						for(var jj:int = 0;jj<len;jj++){
							dataStr += objArr[jj][0]+":"+objArr[jj][1] + (jj != len-1 ? "," : "");
						}
					}
					return dataStr;
				}
				
				function addGridDataByType(gridType: String, gridList: Array): void {
					for each (var item: Object in gridList) {
						var gridPosX: int//所在格子位置x
						var gridPosY: int//所在格子位置y
						if (item is Array) {
							gridPosX = item[0];
							gridPosY = item[1];
						} else {
							var xy: Array = mapMgr.getGridXYByIdx(int(item));
							gridPosX = xy[0];
							gridPosY = xy[1];
						}
						
						addGrid(gridType, gridPosX, gridPosY);
					}
				}
				MsgMgr.ShowMsg("导入成功!!!");
				juahua.close();
			});
		}
		
		private function importFloorBg(cb:Function):void{
			var mapslice:int = mapMgr.mapslice;
			//导入背景图
			var mapFloorArr:Array = mapMgr.mapFloorArr;
			var tempX:int = 0;
			var tempY:int = 0;
			var index:int = 0;
			var hasFinishOnLine:Boolean;//是否已经完成一行
			var totWidth: int = 0;//总宽
			var totHeight:int = 0;//总高
			showFloorItor();
			function showFloorItor():void{
				if(mapFloorArr.length > 0){
					var url:String = mapFloorArr.shift();
					var loader:GLoader = new GLoader();
					loader.autoSize = true;
					loader.icon = url;
					loader.x = tempX;
					loader.y = tempY;
					loader.externalLoadCompleted = function():void{
						index++;
						trace(url);
						tempX += loader.texture.width;
						if(!hasFinishOnLine) totWidth += loader.texture.width;
						if(index == mapslice){
							index = 0;
							tempX = 0;
							tempY += loader.texture.height;
							totHeight += loader.texture.height;
							hasFinishOnLine = true;
						}
						showFloorItor();
					}
					grp_floor.addChild(loader);
				}else{
					mapMgr.mapWidth = totWidth;
					mapMgr.mapHeight = totHeight;
					Global.emmiter.emit(GameEvent.UpdateMapInfo);
					trace("宽高:" + mapMgr.mapWidth + "," + mapMgr.mapHeight);
					if(cb) cb.call();
				}
			}
		}
		
		private function onCheckShowGrid():void
		{
			lineContainer.visible = !lineContainer.visible;
		}
		
		private function onCheckShowPath():void{
			gridContainer.visible = !gridContainer.visible;
		}
		
		private function onCheckShowMapThing():void{
			mapThingContainer.visible = !mapThingContainer.visible;
			bevelContainer.visible = !bevelContainer.visible;
		}
		
		private function onToCenter():void
		{
			var toX:Number = -center.x * curScale + view.viewWidth / 2 - center.width / 2 * curScale;
			var toY:Number = -center.y * curScale + view.viewHeight / 2 - center.height / 2 * curScale - offY * curScale;
			grp_map.setXY(toX, toY);
			checkLimitPos(); 
		}
		
		private function onMouseWheel(evt:MouseEvent):void
		{
			var mousePos: Point = new Point(Global.stage.mouseX, Global.stage.mouseY);
			evt.delta > 0 ? scaleMap(0.1, mousePos) : scaleMap(-0.1, mousePos);
		}
		
		private function scaleMap(deltaScale: Number, mousePos: Point):void{
			var scale: Number = grp_map.scaleX + deltaScale;
			var minScale:Number = Math.max(view.viewWidth / mapMgr.mapWidth, view.viewHeight / mapMgr.mapHeight);
			if(scale > 2) scale = 2;
			if(scale < minScale) scale = minScale;
			var localUIPos: Point = grp_map.globalToLocal(mousePos.x, mousePos.y);
			grp_map.setScale(scale, scale);
			mapMgr.mapScale = curScale = scale;
			var globalPos: Point = grp_map.localToGlobal(localUIPos.x, localUIPos.y);
			var moveDelta: Point = new Point(mousePos.x - globalPos.x, mousePos.y - globalPos.y);
			var toX:Number = grp_map.x + moveDelta.x;
			var toY:Number = grp_map.y + moveDelta.y;
			grp_map.setXY(toX, toY);
			checkLimitPos();
			emit(GameEvent.UpdateMapScale);
		}
		
		public function checkLimitPos():void{
			var maxScrollX:Number = stageWidth - view.viewWidth;
			var maxScrollY:Number = stageHeight - view.viewHeight;
			if(grp_map.x > 0) grp_map.x = 0;
			if(grp_map.x < -maxScrollX) grp_map.x = -maxScrollX;
			if(grp_map.y > 0) grp_map.y = 0;
			if(grp_map.y < -maxScrollY) grp_map.y = -maxScrollY;
		}
		
		private function get stageWidth():Number{
			return mapMgr.mapWidth * curScale;
		}
		
		private function get stageHeight():Number{
			return mapMgr.mapHeight * curScale;
		}
		
		private function onToOriginalScale():void
		{
			if(curScale == 1) return;
			var mousePos:Point = new Point(this.x + view.viewWidth / 2, this.y + view.viewHeight/2);
			scaleMap(1 - curScale, mousePos);
		}
		
		private function onMouseMiddleClick(event:Event):void
		{
			var localPos:Point = grp_map.globalToLocal(Global.stage.mouseX, Global.stage.mouseY);
			if (localPos.y <= offY) return;//点击的是顶部预留的区域
			var gridXY: Point = mapMgr.pos2GridXY(localPos.x, localPos.y - 100);
			if(mapMgr.mouseGridTextField) mapMgr.mouseGridTextField.text = gridXY.y + ", " + gridXY.x + "\n" + "x: " + (gridXY.x * mapMgr.cellSize) + ", y: " + (gridXY.y * mapMgr.cellSize); 
		}
		
		private function onClearAllData():void
		{
			var existData:Boolean = mapMgr.hasExitGridData();
			MsgMgr.ShowMsg("数据已全部清除！！！");
			if(existData) init();
		}
		
		private function onChangeMapThingXY(data:Object):void{
			if(mapThingSelectSp.isShow) mapThingSelectSp.drawRectLine(data.x - data.width/2, data.y - data.height/2, data.width, data.height);
		}
		
		private function onChangeMapThingTriggerType(data:Object):void{
			var oldType: int = data.oldType;
			var type: int = data.type;
			var areaSize: int = mapMgr.areaGraphicsSize;
			var mapThingDic:Dictionary = mapMgr.mapThingDic;
			var gridDataDic: Dictionary = mapMgr.gridDataDic;
			//先把上一次的触发类型格子隐藏
			checkAllGridGraphicVsb({type: oldType, isShow: false});
			
			//再显示当前触发类型的格子
			checkAllGridGraphicVsb({type: type, isShow: true});
		}
		
		private function checkAllGridGraphicVsb(data: Object): void{
			var mapThingDic:Dictionary = mapMgr.mapThingDic;
			for each(var item:Array in mapThingDic){
				var mapThingInfo: MapThingInfo = item[0];
				var mapThingKey: String = int(mapThingInfo.x) +"_"+ int(mapThingInfo.y);
				data["mapThingKey"] = mapThingKey;
				checkOneGridGraphicVsb(data);
			}
		}
		
		private function checkOneGridGraphicVsb(data: Object): void{
			var type: int = data.type;
			var isShow: Boolean = data.isShow;
			var areaSize: int = mapMgr.areaGraphicsSize;
			var gridDataDic: Dictionary = mapMgr.gridDataDic;
			var mapThingKey: String = data.mapThingKey;
			var typeKey: String = Enum.MapThing + type + "_" + mapThingKey;
			var gridTypeDataMap: Dictionary = gridDataDic[typeKey];
			if (gridTypeDataMap) {
				for each(var areaGridMap: Dictionary in gridTypeDataMap) {
					for each(var gridKey: String in areaGridMap) {
						var splitGridPosKey: Array = gridKey.split("_");
						var gridPosX: Number = Number(splitGridPosKey[0]);
						var gridPosY: Number = Number(splitGridPosKey[1]);
						var areaKey: String = Math.floor(gridPosX / areaSize) + "_" + Math.floor(gridPosY / areaSize);
						var graphicKey:String = typeKey + "_" + areaKey;
						var graphic: MapGridSp = getGraphics(graphicKey);
						graphic.visible = isShow;
					}
				}
			}
		}
		
		/** 场景物件拖拽放下时**/
		private function onDragMapThingDown(data:Object):void
		{
			var url:String = data.url;
			var isImportJson:Boolean = data.isImportJson;//是否为导入json进来
			var localPos:Point = grp_map.globalToLocal(Global.stage.mouseX, Global.stage.mouseY);
			var mapThingX:Number = isImportJson ? data.x : localPos.x;//场景物件坐标X
			var mapThingY:Number = isImportJson ? data.y : localPos.y - offY;//场景物件坐标Y
			var anchorX:Number = data.anchorX == undefined ? 0.5 : data.anchorX;
			var anchorY:Number = data.anchorY == undefined ? 0.5 : data.anchorY;
			if (mapThingX < 0 || mapThingY < 0 ||mapThingX >= mapMgr.mapWidth || mapThingY >= mapMgr.mapHeight) return;//超出边界
			
			var splitUrl:Array = url.split(mapMgr.mapThingRootUrl + "\\");
			var elementName:String = splitUrl[splitUrl.length - 1];
			var mapThingInfo:MapThingInfo = new MapThingInfo();
			var mapThingComp:GButton = mapMgr.getMapThingComp(url,anchorX,anchorY,imgLoaded);
			if(data.taskId) mapThingInfo.taskId = data.taskId;
			if(data.grpId) mapThingInfo.grpId = data.grpId;
			if(data.grpIdStr) mapThingInfo.grpIdStr = data.grpIdStr;
			if(data.subGrpIdStr) mapThingInfo.subGrpIdStr = data.subGrpIdStr;
			if(data.relationParm) mapThingInfo.relationParm = data.relationParm;
			if(data.extData) mapThingInfo.extData = data.extData;
			if(data.bevelType) mapThingInfo.bevelType = data.bevelType;
			if(data.type) mapThingInfo.type = data.type;
			if(data.relationType) mapThingInfo.relationType = data.relationType;
			var isBelve:Boolean = elementName.indexOf(mapMgr.bavelResStr) > -1;//是否为斜角顶点
			if(isBelve){
				if(!isImportJson){
					var gridInfo:Array = getGridInfoByMousePos();
					var gridPosX:int = gridInfo[0];//格子所在的列
					var gridPosY:int =  gridInfo[1];//格子所在的行
					var pointArr:Array = [
						[gridPosX * _cellSize, gridPosY * _cellSize],
						[gridPosX * _cellSize + _cellSize, gridPosY * _cellSize],
						[gridPosX * _cellSize + _cellSize, gridPosY * _cellSize + _cellSize],
						[gridPosX * _cellSize, gridPosY * _cellSize + _cellSize],
					];
					var minDist: Number;//最小距离
					var distArr:Array = [];
					distArr.push(BaseUT.distance(int(mapThingX),int(mapThingY),pointArr[0][0],pointArr[0][1]));
					distArr.push(BaseUT.distance(int(mapThingX),int(mapThingY),pointArr[1][0],pointArr[1][1]));
					distArr.push(BaseUT.distance(int(mapThingX),int(mapThingY),pointArr[2][0],pointArr[2][1]));
					distArr.push(BaseUT.distance(int(mapThingX),int(mapThingY),pointArr[3][0],pointArr[3][1]));
					for(var i:int = 0;i < distArr.length; i++){
						if(!minDist) minDist = distArr[i];
						else if(distArr[i] < minDist) minDist = distArr[i];
					}
					var minIndex: int = distArr.indexOf(minDist);
					mapThingX = pointArr[minIndex][0];
					mapThingY = pointArr[minIndex][1];
				}
				if(data.isByDrag){
					mapThingInfo.type = Enum.MapThingType_bevel;
				}
				bevelContainer.addChild(mapThingComp);
			}else{
				mapThingContainer.addChild(mapThingComp);
			}
			
			mapThingComp.x = mapThingInfo.x = mapThingX;
			mapThingComp.y = mapThingInfo.y = mapThingY;
			mapThingComp.setPivot(anchorX, anchorY, true);
			mapThingComp.name = int(mapThingX) + "_" + int(mapThingY);
			mapThingInfo.thingName = elementName;
			mapThingInfo.anchorX = anchorX;
			mapThingInfo.anchorY = anchorY;
		
			mapMgr.mapThingDic[mapThingComp.name] = [mapThingInfo, mapThingComp];
			if(!isBelve){
				var mapThingDisplay: MapThingDisplay = new MapThingDisplay();
				mapThingDisplay.mapThing = mapThingComp;
				mapThingDisplay.data = mapThingInfo;
				mapThingDisplay.name = mapThingComp.name;
				mapMgr.mapThingArr.push(mapThingDisplay);
			}
		
			mapThingSelectSp.rmSelf();
			if(!isImportJson){
				_lastSelectMapThingComp = mapThingComp;
				mapMgr.curMapThingInfo = mapThingInfo;
			}
			function imgLoaded():void{
				mapThingInfo.width = mapThingComp.width;
				mapThingInfo.height = mapThingComp.height;
				if(!isImportJson){
					if(!isBelve) emit(GameEvent.AddMapThing, mapThingComp);
					emit(GameEvent.ClickMapTing, mapThingComp);
					//物件选中框
					TweenMax.delayedCall(0.1, function():void{
						mapThingSelectSp.drawRectLine(mapThingX - mapThingComp.width/2, mapThingY - mapThingComp.height/2, mapThingComp.width, mapThingComp.height);
						grp_container.displayListContainer.addChild(mapThingSelectSp);
					});
				}
			}
			/** 点击选中场景物件**/
			mapThingComp.addClickListener(function(evt:GTouchEvent):void{
				if (_gridType != Enum.MapThing || _isPressSpace) return;
				if(_isCtrlDown) return;
				var btn:GButton = evt.currentTarget as GButton;
				onClickMapthing({btn: btn, data: mapMgr.mapThingDic[btn.name][0]});
			});
			
			/**点击右键重新拖拽物件、按住ctrl+鼠标右键删除场景物件**/ 
			mapThingComp.addEventListener(MouseEvent.RIGHT_CLICK, function(evt:MouseEvent):void{
				if (_gridType != Enum.MapThing || _isPressSpace || _isLeftDown) return;
				var btn:GButton = evt.currentTarget as GButton;
				var curMapThingInfo:MapThingInfo = mapMgr.mapThingDic[btn.name][0];
				if(!curMapThingInfo) return;
				var btnPos:Point = new Point(int(btn.x), int(btn.y));
				if(!_isCtrlDown){//重新拖拽物件
					emit(GameEvent.DragMapThingStart,{
						url:btn.icon, 
						taskId:curMapThingInfo.taskId,
						grpId:curMapThingInfo.grpId, 
						type:curMapThingInfo.type,
						relationType:curMapThingInfo.relationType,
						bevelType: curMapThingInfo.bevelType,
						grpIdStr: curMapThingInfo.grpIdStr,
						subGrpIdStr: curMapThingInfo.subGrpIdStr,
						relationParm: curMapThingInfo.relationParm,
						extData: curMapThingInfo.extData
					});
				}
				if(mapMgr.curMapThingInfo && mapMgr.curMapThingInfo.x == btn.x && mapMgr.curMapThingInfo.y == btn.y){
					mapThingSelectSp.rmSelf();
					mapMgr.curMapThingInfo = null;
				}
				var rmIndex:Number = btn.parent.getChildIndex(btn);
				btn.dispose();
				mapMgr.rmMapThingGrid(btnPos.x + "_" + btnPos.y);
				delete mapMgr.mapThingDic[btn.name];
				if(rmIndex > -1) {
					mapMgr.mapThingArr.splice(rmIndex, 1);
					emit(GameEvent.RemoveMapThing, rmIndex);
				}
			})
		}
		
		private function onClickMapthing(obj: Object):void{
			var btn:GButton = obj.btn;
			var data: MapThingInfo = obj.data;
			if(_lastSelectMapThingComp != btn) {//这样做是为了再切换选中不同场景物件时，不会选中后就马上绘制触发区域格子
				mapThingSelectSp.rmSelf();
				_lastSelectMapThingComp = btn;
			}
			TweenMax.delayedCall(0.1,function(): void{//延迟0.1秒，这样做是为了在切换选中不同场景物件时，不会选中后就马上绘制触发区域格子
				//物件选中框
				mapThingSelectSp.drawRectLine(btn.x-btn.width/2, btn.y-btn.height/2, btn.width, btn.height);
				if(obj.playTween) {
					mapRemindSp.drawRect(btn.x-btn.width/2, btn.y-btn.height/2, btn.width, btn.height);
					grp_container.displayListContainer.addChild(mapRemindSp);
				}
				if(!mapThingSelectSp.parent || !mapThingSelectSp.parent.contains(mapThingSelectSp)){
					grp_container.displayListContainer.addChild(mapThingSelectSp);
				}
			});
			mapMgr.curMapThingInfo = data;
			emit(GameEvent.ClickMapTing, btn);
		}
		
		private function onClickDisplayItem(obj: Object):void{
			obj["playTween"] = true;
			onClickMapthing(obj);
			var btn:GButton = obj.btn;
			var toX:Number = -btn.x * curScale + view.viewWidth / 2
			var toY:Number = -btn.y * curScale + view.viewHeight / 2 - offY * curScale;
			grp_map.setXY(toX, toY);
			checkLimitPos();
		}
		
		private function onCloseDemo():void
		{
			pet.visible = false;
			view.removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		private function onRunDemo():void
		{
			var gridTypeDataMap:Dictionary = mapMgr.gridDataDic[Enum.Walk];
			if (!gridTypeDataMap)
			{
				MsgMgr.ShowMsg("没有找到可行走的格子");
				return;
			}
			var firstWalkGridVec:Point = new Point();
			var isExistGrid:Boolean;
			for each(var areaData:Dictionary in gridTypeDataMap){
				for each(var gridData:String in areaData){
					var splitKey:Array = gridData.split("_");
					firstWalkGridVec.x = int(splitKey[0]);
					firstWalkGridVec.y = int(splitKey[1]);
					isExistGrid = true;
					break;
				}
				if(isExistGrid) break;
			}
			pet.visible = true;
			setPetPosAndRollCamera(firstWalkGridVec.x * _cellSize, firstWalkGridVec.y * _cellSize + _cellSize, true);
			view.addEventListener(Event.ENTER_FRAME, onUpdate);
		}
		
		protected function onUpdate(event:Event):void
		{
			var joystick:JoystickLayer = mapMgr.joystick;
			
			if (!joystick.isMoving()) return;
			//摇杆坐标
			var joysticPos:Point = joystick.vector;
			//向量归一化
			var dir:Point = BaseUT.angle_to_vector(joystick.curDegree);
			//乘速度
			var dir_x:Number = dir.x * speed;
			var dir_y:Number = dir.y * speed;
			//角色方向
			pet.scaleX = joysticPos.x > 0 ? 1 : -1;
			//角色坐标加上方向
			var toX:Number = pet.x + dir_x;
			var toY:Number = pet.y + dir_y;
			
			setPetPosAndRollCamera(toX, toY);
		}
		
		
		/** 滚动摄像机视野 && 移动镜头 **/
		private function setPetPosAndRollCamera(toX:Number, toY:Number, needAni:Boolean = false):void
		{
			//判断行走界限 && 设置角色位置
			if (toX < 0) toX = 0;
			if (toX > mapMgr.mapWidth - pet.width/2) toX = mapMgr.mapWidth - pet.width/2;
			if (toY < 37) toY = 37;
			if (toY > mapMgr.mapHeight - pet.height) toY = mapMgr.mapHeight - pet.height;
			pet.setXY(toX, toY);
			
			//移动镜头
			grp_map.setXY(-pet.x + view.viewWidth / 2, -pet.y + view.viewHeight / 2 - offY*curScale);
		}
		
		protected function onKeyUp(event:KeyboardEvent):void
		{
			if(event.keyCode == 17){
				_isCtrlDown = false;
			}else if(event.keyCode == 32){
				if(_isPressSpace){
					_isPressSpace = false;
					Mouse.cursor = MouseCursor.AUTO;
					Mouse.hide();
					TweenMax.delayedCall(0.01,function():void{
						Mouse.show();
					});
				}
			}
		}
		
		private function onKeyDown(event:KeyboardEvent):void
		{
			
			if(event.keyCode == 17){
				_isCtrlDown = true;
			}else if(event.keyCode == 32){
				if(!_isPressSpace){
					_isPressSpace = true;
					Mouse.cursor = MouseCursor.HAND;
					//这里一定得先hide(),再show()，不然鼠标样式不会马上生效，得等移动鼠标后才会生效，延迟0.01s再show()是为了切换样式时更丝滑
					Mouse.hide();
					TweenMax.delayedCall(0.01,function():void{
						Mouse.show();
					});
				}
			}
		}
		
		protected override function onExit():void{
			Global.stage.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown);
			Global.stage.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp);
			view.removeEventListener(Event.ENTER_FRAME, onUpdate);
		}
	}
}