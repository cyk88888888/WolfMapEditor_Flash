package modules.mapEditor.conctoller
{
	import com.greensock.TweenMax;
	
	import flash.display.Shape;
	import flash.filesystem.File;
	import flash.utils.Dictionary;
	
	import __AS3__.vec.Vector;
	
	import fairygui.GButton;
	import fairygui.GLoader;
	import fairygui.GTextField;
	import fairygui.UIPackage;
	
	import framework.base.FileUT;
	import framework.base.Global;
	import framework.mgr.ModuleMgr;
	
	import modules.base.GameEvent;
	import modules.common.JuHuaDlg;
	import modules.common.mgr.MsgMgr;
	import modules.mapEditor.comp.MapGridSp;
	import modules.mapEditor.joystick.JoystickLayer;
	
	public class MapMgr 
	{
		
		private static var _inst:MapMgr;
		
		public const extensionJson:String = ".json";
		public const mapJsonName:String = "map.json";
		public const thingJsonName:String = "thingPram.json";
		public const fileIcon:String = "ui://Common/file";
		public const bavelResStr:String = "black.png";
		public const mapslice:int = 13;
		
		public var mapWidth:int = 4000;
		public var mapHeight:int = 4000;
		public var cellSize:int = 40;
		public var gridRange:int = 0;
		public var mapScale:Number = 1;
		public var gridTypeDic:Dictionary;
		public var mapThingDic:Dictionary;
		public var curMapThingInfo:MapThingInfo;
		public var curMapThingTriggerType:int = 1;
		public var triggerDesc:Array = ["触发发亮", "不可行走", "犯人周围站立点", "草丛范围点"];
		public var triggerTypes:Array = [1, 2, 3, 4];
		public var mapDirectoryStrut:Vector.<MapFileTreeNode>;
		public var mapFloorArr:Array;
		public var joystick:JoystickLayer;
		public var mapRootUrl:String;
		public var mapThingRootUrl:String;
		public var mouseGridTextField:GTextField;
		
		
		public static function get inst():MapMgr
		{
			if (!_inst)
			{
				_inst = new (MapMgr)();
			};
			return (_inst);
		}
		
		
		public function getColorByType(_arg_1:String):Number
		{
			var _local_2:Number = 0xFF;
			switch (_arg_1)
			{
				case "GridType_walk":
					_local_2 = 0xFF00;
					break;
				case "GridType_block":
					_local_2 = 0;
					break;
				case "GridType_visible":
					_local_2 = 0x990066;
					break;
				case "GridType_blockVerts":
					_local_2 = 0xFF0000;
					break;
				case "GridType_water":
					_local_2 = 0xFFFF;
					break;
				case "GridType_WaterVerts":
					_local_2 = 0xFF00FF;
					break;
				case "GridType_start":
					_local_2 = 0xFFFF00;
					break;
				case "GridType_MapThing1":
					_local_2 = 0xFF;
					break;
				case "GridType_MapThing2":
					_local_2 = 0x330000;
					break;
				case "GridType_MapThing3":
					_local_2 = 0xCB00FF;
					break;
				case "GridType_MapThing4":
					_local_2 = 0xFFFF;
					break;
				case "GridType_startWall":
					break;
				case "GridType_switchWall":
			};
			return (_local_2);
		}
		
		public function hasExitGridData():Boolean
		{
			var _local_3:Boolean;
			for each (var _local_2:Dictionary in gridTypeDic)
			{
				for each (var _local_1:Shape in _local_2)
				{
					_local_3 = true;
					break;
				};
				if (_local_3) break;
			};
			return (_local_3);
		}
		
		public function changeMap(_arg_1:Boolean=false):void
		{
			var isForceSelect = _arg_1;
			FileUT.inst.openDirectoryBrower(function (_arg_1:String, _arg_2:File):void
			{
				var path = _arg_1;
				var file = _arg_2;
				if (((!(path)) && (isForceSelect)))
				{
					changeMap(isForceSelect);
					return;
				};
				if (!path)
				{
					return;
				};
				mapRootUrl = path;
				mapThingRootUrl = (mapRootUrl + "\\thing");
				mapDirectoryStrut = getMapThingDirectoryStrut(file);
				mapFloorArr = getMapFloorStrut(file);
				Global.emmiter.emit(GameEvent.UpdateMapTreeStruct);
				FileUT.inst.readAllText(((path + "\\") + mapJsonName), function (_arg_1:String):void
				{
					var _local_2:Object = JSON.parse(_arg_1);
					cellSize = _local_2.cellSize;
					Global.emmiter.emit(GameEvent.ImportMapJson, [_local_2]);
				});
				FileUT.inst.readAllText(((path + "\\") + thingJsonName), function (_arg_1:String):void
				{
					var _local_2:Object = JSON.parse(_arg_1);
					Global.emmiter.emit(GameEvent.ImportMapThingJson, [_local_2]);
				});
			});
		}
		
		private function getMapFloorStrut(file:File):Array
		{
			var _local_6:* = null;
			var _local_2:* = null;
			var _local_5:* = null;
			var _local_3:Array = [];
			for each (var _local_7:File in file.getDirectoryListing())
			{
				_local_6 = _local_7.nativePath;
				_local_2 = _local_6.split("\\");
				_local_5 = _local_2[(_local_2.length - 1)];
				if (_local_5 == "floor")
				{
					for each (var _local_4:File in _local_7.getDirectoryListing())
					{
						var splitNameArr:Array = _local_4.name.split(".")[0].split("_");
						var col: int = int(splitNameArr[0]);//列
						var row: int = int(splitNameArr[1]);//行
						_local_3.push({col: col, row:row, nativePath: _local_4.nativePath});
					};
				};
			};
			_local_3.sort(function(a: Object, b: Object):int{
				if(a.col > b.col){
					return -1;
				}else if(a.col < b.col){
					return 1;
				}else{
					if(a.row > b.row){
						return 1;
					}else {
						return -1;
					}
				}
			})
			return (_local_3);
		}
		
		private function getMapThingDirectoryStrut(_arg_1:File):Vector.<MapFileTreeNode>
		{
			var file = _arg_1;
			var createNodeRecursive = function (_arg_1:File, _arg_2:Vector.<MapFileTreeNode>):void
			{
				var _local_6:* = null;
				var _local_4:* = null;
				var _local_5:* = null;
				var _local_3:* = null;
				var _local_8:* = null;
				for each (var _local_7:File in _arg_1.getDirectoryListing())
				{
					_local_6 = _local_7.nativePath;
					_local_4 = _local_6.split("\\");
					_local_5 = _local_4[(_local_4.length - 1)];
					_local_3 = _local_4[(_local_4.length - 2)];
					if (!((_local_3 == rootName) && (!(_local_5 == "thing"))))
					{
						if (!((!(_local_7.isDirectory)) && (_local_5.indexOf("_") > -1)))
						{
							_local_8 = new MapFileTreeNode();
							_local_8.path = _local_6;
							_local_8.name = _local_5;
							_arg_2.push(_local_8);
							if (_local_7.isDirectory)
							{
								_local_8.fileArr = new Vector.<MapFileTreeNode>();
								_local_8.isDir = true;
								(createNodeRecursive(_local_7, _local_8.fileArr));
							};
						};
					};
				};
			};
			var resultArr:Vector.<MapFileTreeNode> = new Vector.<MapFileTreeNode>();
			var splitRootPath:Array = file.nativePath.split("\\");
			var rootName:String = splitRootPath[(splitRootPath.length - 1)];
			(createNodeRecursive(file, resultArr));
			return (resultArr);
		}
		
		public function getMapThingComp(_arg_1:String, _arg_2:Number=0.5, _arg_3:Number=0.5, _arg_4:Function=null):GButton
		{
			var icon = _arg_1;
			var anchorX = _arg_2;
			var anchorY = _arg_3;
			var completeCb = _arg_4;
			var comp:GButton = UIPackage.createObject("MapEditor", "MapThingComp").asButton;
			var loader:GLoader = comp.getChild("icon").asLoader;
			comp.icon = icon;
			comp.alpha = 0.6;
			comp.setPivot(anchorX, anchorY, true);
			comp.visible = false;
			loader.externalLoadCompleted = function ():void
			{
				comp.width = loader.texture.width;
				comp.height = loader.texture.height;
				comp.visible = true;
				if (completeCb)
				{
					completeCb.call();
				};
			};
			return (comp);
		}
		
		public function getMapThingCompByXY(_arg_1:int, _arg_2:int):GButton
		{
			var _local_4:Array = mapThingDic[((_arg_1 + "_") + _arg_2)];
			return (_local_4[1]);
		}
		
		public function rmMapThingGrid(_arg_1:String):void
		{
			var _local_5:int;
			var _local_3:* = null;
			var _local_4:* = null;
			_local_5 = 0;
			while (_local_5 < triggerTypes.length)
			{
				_local_3 = ((("GridType_MapThing" + triggerTypes[_local_5]) + "_") + _arg_1);
				_local_4 = gridTypeDic[_local_3];
				if (_local_4)
				{
					for each (var _local_2:MapGridSp in _local_4)
					{
						_local_2.parent.removeChild(_local_2);
					};
				};
				delete MapMgr.inst.gridTypeDic[_local_3];
				_local_5++;
			};
		}
		
		public function getGridXYByIdx(_arg_1:Number):Array
		{
			var _local_6:int = cellSize;
			var _local_5:int = int(Math.ceil((mapHeight / _local_6)));
			var _local_3:int = int(Math.ceil((mapWidth / _local_6)));
			var _local_4:int = int(Math.floor((_arg_1 / _local_3)));
			var _local_2:int = (_arg_1 - (_local_4 * _local_3));
			return ([_local_2, _local_4]);
		}
		
		public function getGridIdxByXY(_arg_1:int, _arg_2:int):int
		{
			var _local_6:int = cellSize;
			var _local_5:int = int(Math.ceil((mapHeight / _local_6)));
			var _local_4:int = int(Math.ceil((mapWidth / _local_6)));
			return ((_arg_2 * _local_4) + _arg_1);
		}
		
		public function importJsonData():void
		{
			FileUT.inst.openFileBrowerAndReturn("*.json", function (_arg_1:String):void
			{
				var _local_2:Object = JSON.parse(_arg_1);
				mapWidth = _local_2.mapWidth;
				mapHeight = _local_2.mapHeight;
				cellSize = _local_2.cellSize;
				Global.emmiter.emit(GameEvent.ImportMapJson, [_local_2]);
			});
		}
		
		public function exportJsonData():void
		{
			var juDlg:JuHuaDlg = (ModuleMgr.inst.showLayer(JuHuaDlg) as JuHuaDlg);
			if (!mapRootUrl)
			{
				MsgMgr.ShowMsg("不存在地图工作目录，无法导出json文件！", "Msg_MsgBox");
				return;
			};
			TweenMax.delayedCall(0.1, function ():void
			{
				var addGridDataByType = function (_arg_1:String):void
				{
					var _local_4:* = null;
					var _local_3:* = null;
					var _local_2:Dictionary = gridTypeDic[_arg_1];
					if (_local_2)
					{
						for (var _local_5:String in _local_2)
						{
							_local_4 = [];
							if (_arg_1 == "GridType_block")
							{
								_local_4 = mapInfo.blockList;
							}
							else
							{
								if (_arg_1 == "GridType_blockVerts")
								{
									_local_4 = mapInfo.blockVertList;
								}
								else
								{
									if (_arg_1 == "GridType_water")
									{
										_local_4 = mapInfo.waterList;
									}
									else
									{
										if (_arg_1 == "GridType_WaterVerts")
										{
											_local_4 = mapInfo.waterVertList;
										}
										else
										{
											if (_arg_1 == "GridType_start")
											{
												_local_4 = mapInfo.startList;
											};
										};
									};
								};
							};
							_local_3 = _local_5.split("_");
							_local_4.push(getGridIdxByXY(_local_3[0], _local_3[1]));
						};
					};
				};
				var fullPath:String = ((mapRootUrl + "\\") + "map.json");
				var mapInfo:MapJsonInfo = new MapJsonInfo();
				mapInfo.mapWidth = mapWidth;
				mapInfo.mapHeight = mapHeight;
				mapInfo.cellSize = cellSize;
				var numCols:int = int(Math.ceil((mapWidth / cellSize)));
				var numRows:int = int(Math.ceil((mapHeight / cellSize)));
				mapInfo.totRow = numRows;
				mapInfo.totCol = numCols;
				var walkGridDic:Dictionary = gridTypeDic["GridType_walk"];
				var blockGridDic:Dictionary = gridTypeDic["GridType_block"];
				var visibleGridDic:Dictionary = gridTypeDic["GridType_visible"];
				var i:int;
				while (i < numRows)
				{
					var linewalkList:Array = [];
					mapInfo.walkList.push(linewalkList);
					var j:int = 0;
					while (j < numCols)
					{
						if ((((!(walkGridDic)) && (!(blockGridDic))) && (!(visibleGridDic))))
						{
							linewalkList.push(0);
						}
						else
						{
							var keys:String = ((j + "_") + i);
							if (((visibleGridDic) && (visibleGridDic[keys])))
							{
								linewalkList.push(3);
							}
							else
							{
								if (((blockGridDic) && (blockGridDic[keys])))
								{
									linewalkList.push(2);
								}
								else
								{
									var gridItem:Object = ((walkGridDic) ? walkGridDic[keys] : null);
									linewalkList.push(((gridItem != null) ? 1 : 0));
								};
							};
						};
						j++;
					};
					i++;
				};
				(addGridDataByType("GridType_block"));
				(addGridDataByType("GridType_blockVerts"));
				(addGridDataByType("GridType_water"));
				(addGridDataByType("GridType_WaterVerts"));
				(addGridDataByType("GridType_start"));
				if (mapThingDic)
				{
					for each (var item:Array in mapThingDic)
					{
						var mapThingInfo:MapThingInfo = item[0];
						mapThingInfo.area = [];
						mapThingInfo.unWalkArea = [];
						mapThingInfo.keyManStandArea = [];
						i = 0;
						while (i < triggerTypes.length)
						{
							var mapThingGridDic:Dictionary = gridTypeDic[((((("GridType_MapThing" + triggerTypes[i]) + "_") + mapThingInfo.x) + "_") + mapThingInfo.y)];
							if (mapThingGridDic)
							{
								for (var key:String in mapThingGridDic)
								{
									var splitArr:Array = key.split("_");
									var idx:int = getGridIdxByXY(splitArr[0], splitArr[1]);
									if (triggerTypes[i] == 1)
									{
										mapThingInfo.area.push(idx);
									};
									if (triggerTypes[i] == 2)
									{
										mapThingInfo.unWalkArea.push(idx);
									};
									if (triggerTypes[i] == 3)
									{
										mapThingInfo.keyManStandArea.push(idx);
									};
									if (triggerTypes[i] == 4)
									{
										mapThingInfo.grassArea.push(idx);
									};
								};
							};
							i++;
						};
						if (mapThingInfo.type == 999)
						{
							var splitGroupStr:Array = ((mapThingInfo.groupIdStr.split(",")) || ([]));
							var groupIdList:Array = [];
							var ii:int = 0;
							while (ii < splitGroupStr.length)
							{
								groupIdList.push(splitGroupStr[ii]);
								ii++;
							};
							mapInfo.borderList.push({
								"x":mapThingInfo.x,
								"y":mapThingInfo.y,
								"groupIdList":groupIdList
							});
						}
						else
						{
							mapInfo.mapThingList.push(mapThingInfo);
						};
					};
				};
				FileUT.inst.writeAllText(fullPath, JSON.stringify(mapInfo), function ():void
				{
					TweenMax.delayedCall(0.1, function ():void
					{
						MsgMgr.ShowMsg("导出成功!!!");
					});
					juDlg.close();
				});
			});
		}
		
		
	}
}//package modules.mapEditor.conctoller
