// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.mapEditor.conctoller.MapMgr

package modules.mapEditor.conctoller
{
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import modules.mapEditor.joystick.JoystickLayer;
    import fairygui.GTextField;
    import flash.display.Shape;
    import framework.base.FileUT;
    import framework.base.Global;
    import modules.base.GameEvent;
    import flash.filesystem.File;
    import fairygui.GButton;
    import fairygui.UIPackage;
    import fairygui.GLoader;
    import modules.mapEditor.comp.MapGridSp;
    import modules.common.JuHuaDlg;
    import framework.mgr.ModuleMgr;
    import modules.common.mgr.MsgMgr;
    import com.greensock.TweenMax;

    public class MapMgr 
    {

        private static var _inst:MapMgr;

        public const extensionJson:String = ".json";
        public const mapJsonName:String = "map.json";
        public const fileIcon:String = "ui://Common/file";
        public const bavelResStr:String = "black.png";
        public const mapslice:int = 5;

        public var mapWidth:int = 4000;
        public var mapHeight:int = 4000;
        public var cellSize:int = 40;
        public var gridRange:int = 0;
        public var mapScale:Number = 1;
        public var gridTypeDic:Dictionary;
        public var mapThingDic:Dictionary;
        public var curMapThingInfo:MapThingInfo;
        public var curMapThingTriggerType:int = 1;
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
                FileUT.inst.readAllText(((path + "\\") + "map.json"), function (_arg_1:String):void
                {
                    var _local_2:Object = JSON.parse(_arg_1);
                    cellSize = _local_2.cellSize;
                    Global.emmiter.emit(GameEvent.ImportMapJson, [_local_2]);
                });
            });
        }

        private function getMapFloorStrut(_arg_1:File):Array
        {
            var _local_6:* = null;
            var _local_2:* = null;
            var _local_5:* = null;
            var _local_3:Array = [];
            for each (var _local_7:File in _arg_1.getDirectoryListing())
            {
                _local_6 = _local_7.nativePath;
                _local_2 = _local_6.split("\\");
                _local_5 = _local_2[(_local_2.length - 1)];
                if (_local_5 == "floor")
                {
                    for each (var _local_4:File in _local_7.getDirectoryListing())
                    {
                        _local_3.push(_local_4.nativePath);
                    };
                };
            };
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

        public function getMapThingComp(_arg_1:String, _arg_2:Function=null):GButton
        {
            var icon = _arg_1;
            var imgLoadCb = _arg_2;
            var comp:GButton = UIPackage.createObject("MapEditor", "MapThingComp").asButton;
            var loader:GLoader = comp.getChild("icon").asLoader;
            comp.icon = icon;
            comp.alpha = 0.6;
            comp.setPivot(0.5, 0.5, true);
            comp.visible = false;
            loader.externalLoadCompleted = function ():void
            {
                comp.width = loader.actualWidth;
                comp.height = loader.actualHeight;
                comp.visible = true;
                if (imgLoadCb)
                {
                    imgLoadCb.call();
                };
            };
            return (comp);
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
                        mapInfo.mapThingList.push(mapThingInfo);
                        if (mapThingInfo.type == 6)
                        {
                            if (!mapInfo.bevelMap[mapThingInfo.groupId])
                            {
                                mapInfo.bevelMap[mapThingInfo.groupId] = [];
                            };
                            mapInfo.bevelMap[mapThingInfo.groupId].push({
                                "x":mapThingInfo.x,
                                "y":mapThingInfo.y
                            });
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

