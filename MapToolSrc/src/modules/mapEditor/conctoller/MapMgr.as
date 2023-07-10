package modules.mapEditor.conctoller
{
	import com.greensock.TweenMax;
	
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	import fairygui.GButton;
	import fairygui.GLoader;
	import fairygui.GTextField;
	import fairygui.UIPackage;
	
	import framework.base.FileUT;
	import framework.base.Global;
	import framework.mgr.ModuleMgr;
	
	import modules.base.Enum;
	import modules.base.GameEvent;
	import modules.common.JuHuaDlg;
	import modules.common.mgr.MsgMgr;
	import modules.mapEditor.joystick.JoystickLayer;

	/**
	 * 地图管理器
	 * @author cyk
	 * 
	 */
	public class MapMgr
	{
		private static var _inst: MapMgr;
		public static function get inst():MapMgr
		{
			if(!_inst){
				_inst = new MapMgr();
			}
			return _inst;
		}
		public const extensionJson:String = ".json";//保存数据后缀
		public const mapJsonName:String = "map.json";//地图json名称
		public const thingJsonName:String = "thingPram.json";//地图场景物件参数json名称
		public const fileIcon:String = "ui://Common/file";
		public const bavelResStr:String = "black.png";
		public var mapslice:int;//地图切片总列数
		public var mapWidth:int = 4000;//地图宽
		public var mapHeight:int = 4000;//地图高
		public var numCols:int;//地图列数
		public var numRows:int;//地图行数
		public var cellSize:int = 40;//格子大小
		public var gridRange:int = 0;//地图格子扩散范围大小
		public var mapScale:Number = 1;//地图缩放比例
		public var areaGraphicsSize:Number = 1;//绘制格子的单个Graphics区域大小
		public var gridDataDic:Dictionary;//格子数据
		public var mapThingDic:Dictionary;//场景物件信息数据
		public var curMapThingInfo:MapThingInfo;//当前正在编辑的场景物件
		public var curMapThingTriggerType:int = Enum.MapThingType_light;//当前场景物件的触发类型
		public var triggerDesc:Array = ["触发发亮","不可行走","犯人周围站立点","草丛范围点"]
		public var triggerTypes:Array = [Enum.MapThingType_light, Enum.MapThingTrigger_unWalk, Enum.MapThingTrigger_keyManStand, Enum.MapThingTrigger_grass];
		public var mapDirectoryStrut:Vector.<MapFileTreeNode>;//当前地图操作目录的结构
		public var mapFloorArr:Array;
		public var joystick:JoystickLayer;//摇杆
		public var mapRootUrl:String;//当前地图的根目录地址
		public var mapThingRootUrl:String;//当前地图物件的根目录地址
		public var mouseGridTextField:GTextField;
		/**根据格子类型获取颜色**/
		public function getColorByType(type:String):Number
		{
			var color:Number = 0x0000FF;
			switch (type)
			{
				case Enum.Walk:
					color = 0x00FF00;//绿
					break;
				case Enum.Block:
					color = 0x000000;//黑
					break;
				case Enum.Visible:
					color = 0x990066;//暗紫
					break;
				case Enum.BlockVerts:
					color = 0xFF0000;//红
					break;
				case Enum.Water:
					color = 0x00FFFF;//蓝
					break;
				case Enum.WaterVerts:
					color = 0xFF00FF;//紫色
					break;
				case Enum.Start:
					color = 0xFFFF00;//黄
					break;
				case Enum.MapThing1:
					color = 0x0000FF;//深蓝
					break;
				case Enum.MapThing2:
					color = 0x330000;//褐色
					break;
				case Enum.MapThing3:
					color = 0xCB00FF;//深紫
					break;
				case Enum.MapThing4:
					color = 0x00FFFF;//浅蓝
					break;
				case Enum.StartWall:
					//todo...
					break;
				case Enum.SwitchWall:
					//todo...
					break;
			}
			return color;
		}
		
		/** 当前是否存在格子数据**/
		public function hasExitGridData():Boolean{
			var isExistGrid:Boolean = false;
			for each(var gridTypeDataMap:Dictionary in gridDataDic)
			{
				for each(var areaGridDic:Dictionary in gridTypeDataMap)
				{
					for each (var gridData:String in areaGridDic)
					{
						isExistGrid = true;
						break;
					}
					if(isExistGrid) break;
				}
				if(isExistGrid) break;
			}
			
			return isExistGrid;
		}
		/**
		 * 切换地图工作目录
		 * @param isForceSelect 是否要强制选中目录
		 * 
		 */		
		public function changeMap(isForceSelect:Boolean = false):void{
			FileUT.inst.openDirectoryBrower(function(path:String,file:File):void{
				if(!path && isForceSelect){
					changeMap(isForceSelect);
					return;
				}
				if(!path) return;
				mapRootUrl = path;
				mapThingRootUrl = mapRootUrl + "\\thing";
				mapDirectoryStrut = getMapThingDirectoryStrut(file);
				mapFloorArr = getMapFloorStrut(file);
				Global.emmiter.emit(GameEvent.UpdateMapTreeStruct);
				FileUT.inst.readAllText(path + "\\" + mapJsonName, function(content:String):void{
					var mapInfo:Object = JSON.parse(content);
					cellSize = mapInfo.cellSize;
					Global.emmiter.emit(GameEvent.ImportMapJson, [mapInfo]);
				});
				
				FileUT.inst.readAllText(path + "\\" + thingJsonName, function(content:String):void{
					var thingPramObj:Object = JSON.parse(content);
					Global.emmiter.emit(GameEvent.ImportMapThingJson, [thingPramObj]);
				});
			});
		}
		
		private function getMapFloorStrut(file:File):Array{
			var rstArr:Array = [];
			mapslice = 0;
			for each(var subFile:File in file.getDirectoryListing()){
				var nativePath:String = subFile.nativePath;
				var splitPath:Array = nativePath.split("\\");
				var lastEle:String = splitPath[splitPath.length - 1];
				if(lastEle != "floor") continue;
				var firstRow:int;
				for each(var floorFile:File in subFile.getDirectoryListing()){
					var splitName:Array = floorFile.name.split(".")[0].split("_");
					var col:int = int(splitName[0]);
					var row: int = int(splitName[1]);
					if(!firstRow) firstRow = row;
					if(firstRow == row) mapslice++;
					rstArr.push(floorFile.nativePath);
				}
			}
			return rstArr;
		}
		
		/**
		 * 返回地图场景物件的文件目录结构
		 * @param file
		 * @return 
		 */		
		private function getMapThingDirectoryStrut(file:File):Vector.<MapFileTreeNode>{
			var resultArr:Vector.<MapFileTreeNode> = new Vector.<MapFileTreeNode>();
			var splitRootPath:Array = file.nativePath.split("\\");
			var rootName:String = splitRootPath[splitRootPath.length - 1];
			createNodeRecursive(file, resultArr);
			//递归创建文件节点
			function createNodeRecursive(file:File, parentArr:Vector.<MapFileTreeNode>):void{
				for each(var subFile:File in file.getDirectoryListing()){
					var nativePath:String = subFile.nativePath;
					var splitPath:Array = nativePath.split("\\");
					var lastEle:String = splitPath[splitPath.length - 1];
					var lastSecondEle:String = splitPath[splitPath.length - 2];
					//根目录只遍历场景物件目录thing
					if(lastSecondEle == rootName && lastEle != "thing") continue;
					if(!subFile.isDirectory && lastEle.indexOf("_") > -1) continue;
					var nodeInfo:MapFileTreeNode = new MapFileTreeNode();
					nodeInfo.path = nativePath;
					nodeInfo.name = lastEle;
					parentArr.push(nodeInfo);
					if(subFile.isDirectory){
						nodeInfo.fileArr = new Vector.<MapFileTreeNode>();
						nodeInfo.isDir = true;
						createNodeRecursive(subFile, nodeInfo.fileArr);
					}
				}
			}
			return resultArr;
		}
		
		public function getMapThingComp(icon:String,anchorX:Number = 0.5,anchorY:Number = 0.5,completeCb:Function = null):GButton{
			var comp:GButton = UIPackage.createObject("MapEditor", "MapThingComp").asButton;
			var loader:GLoader = comp.getChild("icon").asLoader;
			comp.icon = icon;
			comp.alpha = 0.6;
			comp.setPivot(anchorX, anchorY, true);
			comp.visible = false;
			loader.externalLoadCompleted = function():void{
				comp.width = loader.texture.width;
				comp.height = loader.texture.height;
				comp.visible = true;
				if(completeCb) completeCb.call();
			}
			return comp;
		}
		
		//通过xy获取场景已有的物件
		public function getMapThingCompByXY(x:Number,y:Number): GButton{
			var mapThingInfo:Array = mapThingDic[int(x)+"_"+int(y)];
			var mapThingComp:GButton = mapThingInfo[1];
			return mapThingComp;
		}

		/**移除对应场景物件的全部触发区域格子**/
		public function rmMapThingGrid(mapThingKey: String): void {
			var existGrid:Boolean;
			var redrawDic: Dictionary = new Dictionary();
			var areaSize: int = areaGraphicsSize;
			for (var i: int = 0; i < triggerTypes.length; i++) {
				var typeKey: String = Enum.MapThing + triggerTypes[i] + "_" + mapThingKey;
				var gridTypeDataMap: Dictionary = gridDataDic[typeKey];
				if (gridTypeDataMap) {
					for each(var areaGridMap: Dictionary in gridTypeDataMap) {
						for each(var gridKey: String in areaGridMap) {
							var splitGridPosKey: Array = gridKey.split("_");
							var gridPosX: Number = Number(splitGridPosKey[0]);
							var gridPosY: Number = Number(splitGridPosKey[1]);
							var areaKey: String = Math.floor(gridPosX / areaSize) + "_" + Math.floor(gridPosY / areaSize);
							delete gridDataDic[typeKey][areaKey][gridKey];
							redrawDic[typeKey + "|" + areaKey] = typeKey + "_" + areaKey;
							existGrid = true;
						}
					}
				}
			}
			if (existGrid) Global.emmiter.emit(GameEvent.DarwGraphic, [redrawDic]);
		}
		
		/**
		 * 根据格子idx获取格子所在的行列 
		 * @param idx
		 * @return 
		 * 
		 */		
		public function getGridXYByIdx(idx:Number):Array{
			var size:int = cellSize;
			var totLine:int = Math.ceil(mapHeight/size);//总行数
			var totCol:int = Math.ceil(mapWidth/size);//总列数
			var line:int = Math.floor(idx/totCol);
			var col:int = idx - line*totCol;
			return [col,line];
		}
		
		/**
		 * 根据格子列行获取格子所在的idx 
		 * @param x 列
		 * @param y 行
		 * @return 
		 * 
		 */			
		public function getGridIdxByXY(x:int,y:int):int{
			var size:int = cellSize;
			var totLine:int = Math.ceil(mapHeight/size);//总行数
			var totCol:int = Math.ceil(mapWidth/size);//总列数
			var idx:int = y * totCol + x;
			return idx;
		}
		
		public function pos2GridXY(x: Number, y: Number):Point{
			return new Point(Math.floor(x / cellSize), Math.floor(y / cellSize));
		}
		
		/** 导入json地图数据**/
		public function importJsonData():void{
			FileUT.inst.openFileBrowerAndReturn( "*.json", function(content:String):void{
				var mapInfo:Object = JSON.parse(content);
				mapWidth = mapInfo.mapWidth;
				mapHeight = mapInfo.mapHeight;
				cellSize = mapInfo.cellSize;
				Global.emmiter.emit(GameEvent.ImportMapJson, [mapInfo]);
			});
		}
		
		/** 导出json地图数据**/
		public function exportJsonData():void{
			var juDlg:JuHuaDlg = ModuleMgr.inst.showLayer(JuHuaDlg) as JuHuaDlg;
			if(!mapRootUrl){
				MsgMgr.ShowMsg("不存在地图工作目录，无法导出json文件！", Enum.Msg_MsgBox);
				return;
			}
			TweenMax.delayedCall(0.1, function():void{
				var fullPath:String = mapRootUrl + "\\" + mapJsonName;//保存的json文件数据完整地址
				var mapInfo:MapJsonInfo = new MapJsonInfo();
				mapInfo.mapWidth = mapWidth;
				mapInfo.mapHeight = mapHeight;
				mapInfo.cellSize = cellSize;
				/** 设置行走区域**/
				var numCols:int = Math.ceil(mapWidth / cellSize);//列
				var numRows:int = Math.ceil(mapHeight / cellSize);//行
				
				mapInfo.totRow = numRows;
				mapInfo.totCol = numCols;
				var walkGridDic:Dictionary = gridDataDic[Enum.Walk];
				var blockGridDic:Dictionary = gridDataDic[Enum.Block];
				var visibleGridDic:Dictionary = gridDataDic[Enum.Visible];
				for (var i:int = 0; i < numRows; i++)
				{
					var linewalkList:Array = [];//每一行
					mapInfo.walkList.push(linewalkList);
					for (var j:int = 0; j < numCols; j++)
					{
						var areaKey:String = Math.floor(j / areaGraphicsSize) + "_" + Math.floor(i / areaGraphicsSize);
						var walkAreaGridDataMap:Dictionary = walkGridDic ? walkGridDic[areaKey] : null;
						var blockAreaGridDataMap:Dictionary = blockGridDic ? blockGridDic[areaKey] : null;
						var visibleGridDataMap:Dictionary = visibleGridDic ? visibleGridDic[areaKey] : null;
						if ((!walkGridDic || !walkAreaGridDataMap) && (!blockGridDic || !blockAreaGridDataMap) && (!visibleGridDic || !visibleGridDataMap))
						{
							linewalkList.push(0);
						}
						else
						{
							var keys:String = j + "_" + i;
							if(visibleGridDic && visibleGridDataMap && visibleGridDataMap[keys]){//可视墙
								linewalkList.push(Enum.VisibleType);
							}else if(blockGridDic && blockGridDic && blockAreaGridDataMap[keys]){//墙壁
								linewalkList.push(Enum.BlockType);
							}else{
								var gridItem:Object = walkGridDic && walkAreaGridDataMap ? walkAreaGridDataMap[keys] : null;
								linewalkList.push(gridItem != null ? Enum.WalkType : 0);
							}
						}
					}
				}
				
				/** 设置障碍物**/
				addGridDataByType(Enum.Block);
				addGridDataByType(Enum.BlockVerts);
				addGridDataByType(Enum.Water);
				addGridDataByType(Enum.WaterVerts);
				/** 设置起始点**/
				addGridDataByType(Enum.Start);
				function addGridDataByType(gridType: String):void
				{
					var gridTypeDataMap:Dictionary = gridDataDic[gridType];
					if (gridTypeDataMap)
					{
						for each(var areaData:Dictionary in gridTypeDataMap){
							for each(var gridData:String in areaData){
								var newList:Array = [];
								if (gridType == Enum.Block) newList = mapInfo.blockList;
								else if(gridType == Enum.BlockVerts) newList = mapInfo.blockVertList;
								else if (gridType == Enum.Water) newList = mapInfo.waterList;
								else if (gridType == Enum.WaterVerts) newList = mapInfo.waterVertList;
								else if (gridType == Enum.Start) newList = mapInfo.startList;
								var splitArr:Array = gridData.split("_");
								newList.push(getGridIdxByXY(int(splitArr[0]), int(splitArr[1])));
							}
						}
					}
				}
				
				if(mapThingDic){
					for each(var item:Array in mapThingDic){
						var mapThingInfo: MapThingInfo = item[0];
						mapThingInfo.area = [];
						mapThingInfo.unWalkArea = [];
						mapThingInfo.keyManStandArea = [];
						for(i=0; i < triggerTypes.length; i++){
							var gridTypeDataMap:Dictionary = gridDataDic[Enum.MapThing + triggerTypes[i] + "_" + int(mapThingInfo.x) + "_" + int(mapThingInfo.y)];
							if(gridTypeDataMap){
								for each(var areaData:Dictionary in gridTypeDataMap){
									for each(var gridData:String in areaData){
										var splitArr:Array = gridData.split("_");
										var idx:int = getGridIdxByXY(int(splitArr[0]), int(splitArr[1]));
										if(triggerTypes[i] == Enum.MapThingType_light) mapThingInfo.area.push(idx);
										if(triggerTypes[i] == Enum.MapThingTrigger_unWalk) mapThingInfo.unWalkArea.push(idx);
										if(triggerTypes[i] == Enum.MapThingTrigger_keyManStand) mapThingInfo.keyManStandArea.push(idx);
										if(triggerTypes[i] == Enum.MapThingTrigger_grass) mapThingInfo.grassArea.push(idx);
									}
								}
							}
						}
						
						
						if(mapThingInfo.type == Enum.MapThingType_bevel){
							var splitGroupStr:Array = mapThingInfo.groupIdStr.split(",") || [];
							var groupIdList: Array = [];
							for(var ii:int = 0;ii <splitGroupStr.length;ii++){
								groupIdList.push(Number(splitGroupStr[ii]));
							}
							mapInfo.borderList.push({x:mapThingInfo.x,y:mapThingInfo.y, groupIdList: groupIdList});
						}else{
							mapInfo.mapThingList.push(mapThingInfo);
						}
					}
				}
				
				FileUT.inst.writeAllText(fullPath, JSON.stringify(mapInfo), function():void{
					TweenMax.delayedCall(0.1,function():void{
						MsgMgr.ShowMsg("导出成功!!!");
					})
					juDlg.close();
				})
			})
			
		}
		
	}
}