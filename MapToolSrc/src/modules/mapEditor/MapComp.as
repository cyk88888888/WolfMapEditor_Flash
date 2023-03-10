// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.mapEditor.MapComp

package modules.mapEditor
{
    import framework.ui.UIComp;
    import fairygui.GComponent;
    import fairygui.GLoader;
    import fairygui.GGraph;
    import framework.base.ObjectPool;
    import flash.display.Shape;
    import flash.display.Sprite;
    import modules.mapEditor.comp.MapThingSelectSp;
    import fairygui.GButton;
    import modules.mapEditor.comp.MapGridSp;
    import modules.mapEditor.conctoller.MapMgr;
    import modules.base.GameEvent;
    import framework.base.Global;
    import flash.utils.Dictionary;
    import modules.common.mgr.MsgMgr;
    import flash.events.MouseEvent;
    import com.greensock.TweenMax;
    import modules.common.JuHuaDlg;
    import framework.mgr.ModuleMgr;
    import modules.mapEditor.conctoller.MapThingInfo;
    import framework.base.BaseUT;
    import fairygui.ScrollPane;
    import flash.events.Event;
    import modules.mapEditor.comp.MapRemindSp;
    import fairygui.event.GTouchEvent;
    import flash.geom.Point;
    import modules.mapEditor.joystick.JoystickLayer;
    import flash.events.KeyboardEvent;

    public class MapComp extends UIComp 
    {

        private const offY:int = 100;

        private var grp_map:GComponent;
        private var grp_container:GComponent;
        private var lineContainer:GComponent;
        private var gridContainer:GComponent;
        private var mapThingContainer:GComponent;
        private var remindContainer:GComponent;
        private var grp_floor:GComponent;
        private var pet:GLoader;
        private var grp_bg:GGraph;
        private var center:GGraph;
        private var _cellSize:int;
        private var _gridType:String = "GridType_None";
        private var _gridCompPool:ObjectPool;
        private var lineShape:Shape;
        private var gridSprite:Sprite;
        private var _isCtrlDown:Boolean;
        private var speed:int = 5;
        private var mapThingSelectSp:MapThingSelectSp;
        private var _isRightDown:Boolean;
        private var curScale:Number = 1;
        private var scaleDelta:Number = 0.03;
        private var _isRightDownDrawing:Boolean;
        private var _lastSelectMapThingComp:GButton;


        override protected function onFirstEnter():void
        {
            grp_map = view.getChild("grp_map").asCom;
            grp_container = grp_map.getChild("grp_container").asCom;
            remindContainer = grp_container.getChild("remindContainer").asCom;
            mapThingContainer = grp_container.getChild("mapThingContainer").asCom;
            lineContainer = grp_container.getChild("lineContainer").asCom;
            gridContainer = grp_container.getChild("gridContainer").asCom;
            grp_bg = view.getChild("grp_bg").asGraph;
            grp_floor = grp_map.getChild("grp_floor").asCom;
            pet = grp_container.getChild("pet").asLoader;
            center = grp_container.getChild("center").asGraph;
            _gridCompPool = new ObjectPool(function ():MapGridSp
            {
                return (new MapGridSp());
            }, function (_arg_1:MapGridSp):void
            {
                _arg_1.parent.removeChild(_arg_1);
            });
            mapThingSelectSp = new MapThingSelectSp();
            view.addEventListener("click", onClick);
            view.addEventListener("rightMouseDown", onRightDown);
            view.addEventListener("rightMouseUp", onRightUp);
            view.addEventListener("mouseMove", mouseMove);
            view.addEventListener("mouseWheel", onMouseWheel);
            view.addEventListener("middleClick", onMouseMiddleClick);
            _cellSize = MapMgr.inst.cellSize;
            lineShape = new Shape();
            lineContainer.displayListContainer.addChild(lineShape);
            gridSprite = new Sprite();
            gridContainer.displayListContainer.addChild(gridSprite);
            init();
        }

        override protected function onEnter():void
        {
            onEmitter(GameEvent.CheckShowGrid, onCheckShowGrid);
            onEmitter(GameEvent.ChangeGridType, onChangeGridType);
            onEmitter(GameEvent.ClearGridType, onClearGridType);
            onEmitter(GameEvent.ImportMapJson, onImportMapJson);
            onEmitter(GameEvent.ResizeGrid, onResizeGrid);
            onEmitter(GameEvent.ResizeMap, onResizeMap);
            onEmitter(GameEvent.RunDemo, onRunDemo);
            onEmitter(GameEvent.CloseDemo, onCloseDemo);
            onEmitter(GameEvent.ToCenter, onToCenter);
            onEmitter(GameEvent.ToOriginalScale, onToOriginalScale);
            onEmitter(GameEvent.ClearAllData, onClearAllData);
            onEmitter(GameEvent.DragMapThingDown, onDragMapThingDown);
            Global.stage.addEventListener("keyDown", onKeyDown);
            Global.stage.addEventListener("keyUp", onKeyUp);
        }

        private function init(_arg_1:Boolean=false):void
        {
            var _local_7:int;
            var _local_4:int;
            var _local_2:int = MapMgr.inst.mapWidth;
            var _local_3:int = MapMgr.inst.mapHeight;
            var _local_6:int = int(Math.ceil((_local_2 / _cellSize)));
            var _local_5:int = int(Math.ceil((_local_3 / _cellSize)));
            (trace(((("行：" + _local_5) + ", 列：") + _local_6)));
            if (!_arg_1)
            {
                onToOriginalScale(null);
                removeAllGrid();
                removeAllMapThing();
            }
            else
            {
                updateContainerSize();
            };
            center.setXY(((_local_2 - center.width) / 2), ((_local_3 - center.height) / 2));
            lineShape.graphics.clear();
            lineShape.graphics.lineStyle(1, 0);
            _local_7 = 0;
            while (_local_7 < _local_5)
            {
                lineShape.graphics.moveTo(0, (_local_7 * _cellSize));
                lineShape.graphics.lineTo(_local_2, (_local_7 * _cellSize));
                _local_7++;
            };
            _local_4 = 0;
            while (_local_4 < _local_6)
            {
                lineShape.graphics.moveTo((_local_4 * _cellSize), 0);
                lineShape.graphics.lineTo((_local_4 * _cellSize), _local_3);
                _local_4++;
            };
        }

        private function removeAllGrid():void
        {
            var _local_1:int;
            _local_1 = (gridSprite.numChildren - 1);
            while (_local_1 >= 0)
            {
                _gridCompPool.releaseObject(gridSprite.getChildAt(_local_1), false);
                _local_1--;
            };
            gridSprite.removeChildren();
            MapMgr.inst.gridTypeDic = new Dictionary();
        }

        private function removeAllMapThing():void
        {
            mapThingContainer.removeChildren();
            mapThingSelectSp.rmSelf();
            MapMgr.inst.curMapThingInfo = null;
            MapMgr.inst.mapThingDic = new Dictionary();
        }

        private function onResizeGrid(_arg_1:Object):void
        {
            var data = _arg_1;
            var onOk = function ():void
            {
                _cellSize = cellSize;
                MapMgr.inst.cellSize = cellSize;
                init();
            };
            var cellSize:int = data.body[0];
            if (cellSize == MapMgr.inst.cellSize)
            {
                MsgMgr.ShowMsg("格子大小没有变化！！！");
                return;
            };
            if (MapMgr.inst.hasExitGridData())
            {
                MsgMgr.ShowMsg("当前存在格子数据，重置格子大小会清除全部数据，是否确定重置？", "Msg_MsgBox", function ():void
                {
                    onOk(); //not popped
                }, function ():void
                {
                });
            }
            else
            {
                (onOk());
            };
        }

        private function onChangeGridType(_arg_1:Object):void
        {
            var _local_2:String = _arg_1.body[0];
            _gridType = _local_2;
            if (_gridType != "GridType_MapThing")
            {
                mapThingSelectSp.rmSelf();
            };
        }

        private function onRightDown(_arg_1:MouseEvent):void
        {
            if (((_gridType == "GridType_MapThing") && (!(mapThingSelectSp.isShow))))
            {
                return;
            };
            if (_gridType == "GridType_None")
            {
                MsgMgr.ShowMsg("请先选择操作类型!!!");
                return;
            };
            _isRightDown = true;
        }

        protected function onRightUp(_arg_1:MouseEvent):void
        {
            var event = _arg_1;
            _isRightDown = false;
            TweenMax.delayedCall(0.1, function ():void
            {
                _isRightDownDrawing = false;
            });
        }

        protected function mouseMove(_arg_1:MouseEvent):void
        {
            var _local_3:* = null;
            var _local_5:int;
            var _local_4:int;
            var _local_7:* = null;
            var _local_8:int;
            var _local_9:int;
            var _local_6:* = null;
            var _local_2:* = null;
            if (_isRightDown)
            {
                if (_gridType == "GridType_None")
                {
                    return;
                };
                _isRightDownDrawing = true;
                _local_3 = getGridInfoByMousePos();
                _local_5 = _local_3[0];
                _local_4 = _local_3[1];
                _local_7 = _local_3[4];
                _local_8 = _local_3[2];
                _local_9 = _local_3[3];
                _local_6 = MapMgr.inst.gridTypeDic[_gridType];
                if (_isCtrlDown)
                {
                    addOrRmRangeGrid(Global.stage.mouseX, Global.stage.mouseY, false);
                    return;
                };
                addOrRmRangeGrid(Global.stage.mouseX, Global.stage.mouseY);
            };
        }

        private function onClick(_arg_1:MouseEvent):void
        {
            if (((_gridType == "GridType_MapThing") && (!(mapThingSelectSp.isShow))))
            {
                return;
            };
            if (_gridType == "GridType_None")
            {
                MsgMgr.ShowMsg("请先选择操作类型!!!");
                return;
            };
            var _local_2:Array = getGridInfoByMousePos();
            var _local_4:int = _local_2[0];
            var _local_3:int = _local_2[1];
            var _local_5:String = _local_2[4];
            var _local_6:int = _local_2[2];
            var _local_8:int = _local_2[3];
            var _local_7:int;
            if (_isCtrlDown)
            {
                addOrRmRangeGrid(Global.stage.mouseX, Global.stage.mouseY, false);
                return;
            };
            addOrRmRangeGrid(Global.stage.mouseX, Global.stage.mouseY);
        }

        private function getGridInfoByMousePos():Array
        {
            var _local_2:int = int(Math.floor(((Global.stage.mouseX + view.scrollPane.posX) / (_cellSize * curScale))));
            var _local_1:int = int(Math.floor((((Global.stage.mouseY + view.scrollPane.posY) - (100 * curScale)) / (_cellSize * curScale))));
            var _local_3:String = ((_local_2 + "_") + _local_1);
            var _local_4:int = (_local_2 * _cellSize);
            var _local_5:int = (_local_1 * _cellSize);
            return ([_local_2, _local_1, _local_4, _local_5, _local_3]);
        }

        private function addOrRmRangeGrid(_arg_1:Number, _arg_2:Number, _arg_3:Boolean=true):void
        {
            var _local_8:int;
            var _local_7:int;
            var _local_5:int;
            var _local_4:int;
            var _local_15:int;
            var _local_16:int;
            var _local_11:Array = [];
            var _local_13:Array = getGridInfoByMousePos();
            var _local_6:int = MapMgr.inst.gridRange;
            var _local_9:int = (_local_13[0] - _local_6);
            var _local_10:int = (_local_13[1] - _local_6);
            var _local_12:int = ((2 * _local_6) + 1);
            _local_8 = 0;
            while (_local_8 < _local_12)
            {
                _local_7 = 0;
                while (_local_7 < _local_12)
                {
                    _local_11.push([(_local_9 + _local_8), (_local_10 + _local_7)]);
                    _local_7++;
                };
                _local_8++;
            };
            var _local_14:Dictionary = MapMgr.inst.gridTypeDic[_gridType];
            _local_8 = 0;
            while (_local_8 < _local_11.length)
            {
                _local_5 = _local_11[_local_8][0];
                _local_4 = _local_11[_local_8][1];
                _local_15 = (_local_5 * _cellSize);
                _local_16 = (_local_4 * _cellSize);
                if (!((((_local_15 < 0) || (_local_16 < 0)) || (_local_15 >= MapMgr.inst.mapWidth)) || (_local_16 >= MapMgr.inst.mapHeight)))
                {
                    if (_arg_3)
                    {
                        addGrid(_gridType, _local_5, _local_4, _local_15, _local_16);
                    }
                    else
                    {
                        rmGrid(_gridType, _local_5, _local_4);
                    };
                };
                _local_8++;
            };
        }

        private function addGrid(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:int, _arg_5:int):void
        {
            var _local_8:* = null;
            var _local_9:* = null;
            if (((((_arg_4 < 0) || (_arg_5 < 0)) || (_arg_4 >= MapMgr.inst.mapWidth)) || (_arg_5 >= MapMgr.inst.mapHeight)))
            {
                return;
            };
            var _local_7:* = _arg_1;
            var _local_11:* = ((_arg_1.indexOf("GridType_MapThing") > -1) ? ((_arg_1 == "GridType_MapThing") ? (_arg_1 + MapMgr.inst.curMapThingTriggerType) : _arg_1) : _arg_1);
            if (_arg_1.indexOf("GridType_MapThing") > -1)
            {
                _local_8 = MapMgr.inst.curMapThingInfo;
                _local_9 = ((_local_8.x + "_") + _local_8.y);
                _local_7 = ((_arg_1 == "GridType_MapThing") ? (((_arg_1 + MapMgr.inst.curMapThingTriggerType) + "_") + _local_9) : ((_arg_1 + "_") + _local_9));
            };
            if (!MapMgr.inst.gridTypeDic[_local_7])
            {
                MapMgr.inst.gridTypeDic[_local_7] = new Dictionary();
            };
            var _local_12:Dictionary = MapMgr.inst.gridTypeDic[_local_7];
            var _local_13:String = ((_arg_2 + "_") + _arg_3);
            if (_local_12[_local_13])
            {
                return;
            };
            var _local_10:Number = MapMgr.inst.getColorByType(_local_11);
            var _local_6:MapGridSp = (_gridCompPool.getObject() as MapGridSp);
            if (_arg_1 == "GridType_blockVerts")
            {
                _local_6.drawCircle((_arg_4 + (_cellSize / 2)), (_arg_5 + (_cellSize / 2)), (_cellSize / 2), _local_10);
            }
            else
            {
                _local_6.drawRect((_arg_4 + 0.5), (_arg_5 + 0.5), _cellSize, _cellSize, _local_10);
            };
            gridSprite.addChild(_local_6);
            _local_12[_local_13] = _local_6;
        }

        private function rmGrid(_arg_1:String, _arg_2:int, _arg_3:int):void
        {
            var _local_4:* = null;
            var _local_8:* = null;
            var _local_5:* = _arg_1;
            if (_arg_1.indexOf("GridType_MapThing") > -1)
            {
                _local_4 = MapMgr.inst.curMapThingInfo;
                _local_8 = ((_local_4.x + "_") + _local_4.y);
                _local_5 = (((_arg_1 + MapMgr.inst.curMapThingTriggerType) + "_") + _local_8);
            };
            var _local_6:Dictionary = MapMgr.inst.gridTypeDic[_local_5];
            var _local_7:String = ((_arg_2 + "_") + _arg_3);
            if (((_local_6) && (_local_6[_local_7])))
            {
                _gridCompPool.releaseObject(_local_6[_local_7]);
                delete _local_6[_local_7];
            };
        }

        private function onClearGridType(_arg_1:Object):void
        {
            var _local_4:String = _arg_1.body[0];
            if (!MapMgr.inst.gridTypeDic[_local_4])
            {
                return;
            };
            var _local_2:Dictionary = MapMgr.inst.gridTypeDic[_local_4];
            for (var _local_3:String in _local_2)
            {
                _gridCompPool.releaseObject(_local_2[_local_3]);
                delete MapMgr.inst.gridTypeDic[_local_4];
            };
        }

        private function onImportMapJson(_arg_1:Object):void
        {
            var data = _arg_1;
            var juahua:JuHuaDlg = (ModuleMgr.inst.showLayer(JuHuaDlg) as JuHuaDlg);
            var mapInfo:Object = data.body[0];
            _cellSize = mapInfo.cellSize;
            importFloorBg(function ():void
            {
                var addGridDataByType = function (_arg_1:String, _arg_2:Array):void
                {
                    var _local_4:int;
                    var _local_3:int;
                    var _local_8:* = null;
                    var _local_6:int;
                    var _local_7:int;
                    for each (var _local_5:Object in _arg_2)
                    {
                        if ((_local_5 is Array))
                        {
                            _local_4 = _local_5[0];
                            _local_3 = _local_5[1];
                        }
                        else
                        {
                            _local_8 = MapMgr.inst.getGridXYByIdx(int(_local_5));
                            _local_4 = _local_8[0];
                            _local_3 = _local_8[1];
                        };
                        _local_6 = (_local_4 * _cellSize);
                        _local_7 = (_local_3 * _cellSize);
                        addGrid(_arg_1, _local_4, _local_3, _local_6, _local_7);
                    };
                };
                init();
                var i:int;
                while (i < mapInfo.walkList.length)
                {
                    var lineList:Array = mapInfo.walkList[i];
                    var j:int = 0;
                    while (j < lineList.length)
                    {
                        if (lineList[j] != 0)
                        {
                            var gridPosX:int = j;
                            var gridPosY:int = i;
                            var gridX:int = (gridPosX * _cellSize);
                            var gridY:int = (gridPosY * _cellSize);
                            if (lineList[j] == 1)
                            {
                                var gridType:String = "GridType_walk";
                            }
                            else
                            {
                                if (lineList[j] == 2)
                                {
                                    gridType = "GridType_block";
                                }
                                else
                                {
                                    gridType = "GridType_visible";
                                };
                            };
                            addGrid(gridType, gridPosX, gridPosY, gridX, gridY);
                        };
                        j++;
                    };
                    i++;
                };
                (addGridDataByType("GridType_block", mapInfo.blockList));
                (addGridDataByType("GridType_blockVerts", mapInfo.blockVertList));
                (addGridDataByType("GridType_water", mapInfo.waterList));
                (addGridDataByType("GridType_WaterVerts", mapInfo.waterVertList));
                (addGridDataByType("GridType_start", mapInfo.startList));
                if (mapInfo.mapThingList)
                {
                    for each (var mapThingData:Object in mapInfo.mapThingList)
                    {
                        var tempMapThingInfo:MapThingInfo = new MapThingInfo();
                        tempMapThingInfo.x = mapThingData.x;
                        tempMapThingInfo.y = mapThingData.y;
                        MapMgr.inst.curMapThingInfo = tempMapThingInfo;
                        (addGridDataByType(("GridType_MapThing" + 1), mapThingData.area));
                        if (mapThingData.unWalkArea)
                        {
                            (addGridDataByType(("GridType_MapThing" + 2), mapThingData.unWalkArea));
                        };
                        if (mapThingData.keyManStandArea)
                        {
                            (addGridDataByType(("GridType_MapThing" + 3), mapThingData.keyManStandArea));
                        };
                        if (mapThingData.grassArea)
                        {
                            (addGridDataByType(("GridType_MapThing" + 4), mapThingData.grassArea));
                        };
                        onDragMapThingDown({"body":{
                                "isImportJson":true,
                                "url":((BaseUT.checkIsPngOrJpg(mapThingData.thingName)) ? ((MapMgr.inst.mapThingRootUrl + "\\") + mapThingData.thingName) : "ui://Common/file"),
                                "x":mapThingData.x,
                                "y":mapThingData.y,
                                "taskId":mapThingData.taskId,
                                "groupId":mapThingData.groupId,
                                "type":mapThingData.type,
                                "isByDrag":false
                            }});
                    };
                };
                MsgMgr.ShowMsg("导入成功!!!");
                juahua.close();
            });
        }

        private function importFloorBg(_arg_1:Function):void
        {
            var itemWidth:int;
            var cb = _arg_1;
            var showFloorItor = function ():void
            {
                if (mapFloorArr.length > 0)
                {
                    var url:String = mapFloorArr.shift();
                    var loader:GLoader = new GLoader();
                    loader.autoSize = true;
                    loader.icon = url;
                    loader.x = tempX;
                    loader.y = tempY;
                    loader.externalLoadCompleted = function ():void
                    {
                        index++;
                        (trace(url));
                        tempX = (tempX + loader.width);
                        if (!itemWidth)
                        {
                            itemWidth = loader.width;
                        };
                        if (index == mapslice)
                        {
                            index = 0;
                            tempX = 0;
                            tempY = (tempY + loader.height);
                            totHeight = (totHeight + loader.height);
                        };
                        showFloorItor(); //not popped
                    };
                    grp_floor.addChild(loader);
                }
                else
                {
                    MapMgr.inst.mapWidth = (mapslice * itemWidth);
                    MapMgr.inst.mapHeight = totHeight;
                    Global.emmiter.emit(GameEvent.UpdateMapInfo);
                    (trace(((("宽高:" + MapMgr.inst.mapWidth) + ",") + MapMgr.inst.mapHeight)));
                    if (cb)
                    {
                        cb.call();
                    };
                };
            };
            var mapslice:int = 5;
            var mapFloorArr:Array = MapMgr.inst.mapFloorArr;
            var tempX:int;
            var tempY:int;
            var index:int;
            var totHeight:int;
            showFloorItor(); //not popped
        }

        private function onCheckShowGrid(_arg_1:Object):void
        {
            lineContainer.visible = (!(lineContainer.visible));
        }

        private function onToCenter(_arg_1:Object):void
        {
            var _local_2:ScrollPane = view.scrollPane;
            _local_2.setPosX((((center.x * curScale) - (_local_2.viewWidth / 2)) + ((center.width / 2) * curScale)), true);
            _local_2.setPosY(((((center.y * curScale) - (_local_2.viewHeight / 2)) + ((center.height / 2) * curScale)) + (100 * curScale)), true);
        }

        private function onMouseWheel(_arg_1:MouseEvent):void
        {
            var _local_3:ScrollPane = view.scrollPane;
            if (_arg_1.delta < 0)
            {
                if (((Math.floor(grp_bg.width) <= view.viewWidth) && (Math.floor(grp_bg.height) <= view.viewHeight)))
                {
                    return;
                };
                curScale = (curScale - scaleDelta);
            }
            else
            {
                if (((Math.floor(grp_bg.width) >= MapMgr.inst.mapWidth) && (Math.floor(grp_bg.height) >= MapMgr.inst.mapHeight)))
                {
                    return;
                };
                curScale = (curScale + scaleDelta);
            };
            MapMgr.inst.mapScale = curScale;
            var _local_4:Number = _local_3.scrollingPosX;
            var _local_2:Number = _local_3.scrollingPosY;
            (trace("oldScrollingPos：", _local_4, _local_2, "pos：", _local_3.posX, _local_3.posY));
            updateContainerSize();
        }

        private function updateContainerSize():void
        {
            grp_map.setScale(curScale, curScale);
            grp_bg.setSize((curScale * MapMgr.inst.mapWidth), ((curScale * MapMgr.inst.mapHeight) + (100 * curScale)));
        }

        private function onToOriginalScale(_arg_1:Object):void
        {
            MapMgr.inst.mapScale = (curScale = 1);
            updateContainerSize();
        }

        private function onMouseMiddleClick(_arg_1:Event):void
        {
            var _local_2:Array = getGridInfoByMousePos();
            var _local_3:int = _local_2[2];
            var _local_4:int = _local_2[3];
            if (((((_local_3 < 0) || (_local_4 < 0)) || (_local_3 >= MapMgr.inst.mapWidth)) || (_local_4 >= MapMgr.inst.mapHeight)))
            {
                return;
            };
            if (MapMgr.inst.mouseGridTextField)
            {
                MapMgr.inst.mouseGridTextField.text = ((_local_2[1] + ", ") + _local_2[0]);
            };
        }

        private function onClearAllData(_arg_1:Object):void
        {
            var _local_3:Boolean;
            for (var _local_4:String in MapMgr.inst.gridTypeDic)
            {
                for (var _local_2:String in MapMgr.inst.gridTypeDic[_local_4])
                {
                    _local_3 = true;
                    break;
                };
                if (_local_3) break;
            };
            MsgMgr.ShowMsg("数据已全部清除！！！");
            if (_local_3)
            {
                init();
            };
        }

        private function onResizeMap(_arg_1:Object):void
        {
            var isLimit:Boolean;
            var data = _arg_1;
            var checkIsLimit = function (_arg_1:String, _arg_2:Array):void
            {
                var _local_4:* = null;
                var _local_13:* = null;
                var _local_6:* = null;
                var _local_7:int;
                var _local_8:int;
                var _local_9:int = ((_arg_2[0]) ? (_cellSize * _arg_2[0]) : MapMgr.inst.mapWidth);
                var _local_3:int = ((_arg_2[1]) ? (_cellSize * _arg_2[1]) : MapMgr.inst.mapHeight);
                var _local_5:Array = [0, 0, _local_9, _local_3];
                var _local_10:Array = [((_arg_2[0]) ? (mapWidth - _local_9) : 0), ((_arg_2[1]) ? (mapHeight - _local_3) : 0), _local_9, _local_3];
                for each (var _local_12:Array in mapThingDic)
                {
                    _local_4 = _local_12[1];
                    if ((((_arg_1 == "top") || (_arg_1 == "left")) && ((_local_4.x < (_arg_2[0] * _cellSize)) || (_local_4.y < (_arg_2[1] * _cellSize)))))
                    {
                        isLimit = true;
                        if (tempDrawRemindArr.indexOf(_local_5) == -1)
                        {
                            tempDrawRemindArr.push(_local_5);
                        };
                        break;
                    };
                    if ((((_arg_1 == "right") || (_arg_1 == "bottom")) && (((_local_4.x + _local_4.width) >= (mapWidth - (_arg_2[0] * _cellSize))) || ((_local_4.y + _local_4.height) >= (mapHeight - (_arg_2[1] * _cellSize))))))
                    {
                        isLimit = true;
                        if (tempDrawRemindArr.indexOf(_local_10) == -1)
                        {
                            tempDrawRemindArr.push(_local_10);
                        };
                        break;
                    };
                };
                if ((((_arg_1 == "top") || (_arg_1 == "left")) && (tempDrawRemindArr.indexOf(_local_5) > -1)))
                {
                    return;
                };
                if ((((_arg_1 == "right") || (_arg_1 == "bottom")) && (tempDrawRemindArr.indexOf(_local_10) > -1)))
                {
                    return;
                };
                for (var _local_14:String in gridTypeDic)
                {
                    _local_13 = gridTypeDic[_local_14];
                    for (var _local_11:String in _local_13)
                    {
                        _local_6 = _local_11.split("_");
                        _local_7 = _local_6[0];
                        _local_8 = _local_6[1];
                        if ((((_arg_1 == "top") || (_arg_1 == "left")) && ((_local_7 < _arg_2[0]) || (_local_8 < _arg_2[1]))))
                        {
                            isLimit = true;
                            if (tempDrawRemindArr.indexOf(_local_5) == -1)
                            {
                                tempDrawRemindArr.push(_local_5);
                            };
                            break;
                        };
                        if ((((_arg_1 == "right") || (_arg_1 == "bottom")) && ((_local_7 >= (numCols - _arg_2[0])) || (_local_8 >= (numRows - _arg_2[1])))))
                        {
                            isLimit = true;
                            if (tempDrawRemindArr.indexOf(_local_10) == -1)
                            {
                                tempDrawRemindArr.push(_local_10);
                            };
                            break;
                        };
                    };
                    if (isLimit) break;
                };
            };
            var top:int = data.body[0];
            var bottom:int = data.body[1];
            var left:int = data.body[2];
            var right:int = data.body[3];
            if (((((top == 0) && (bottom == 0)) && (left == 0)) && (right == 0)))
            {
                MsgMgr.ShowMsg("地图大小未发生变化！！！");
                return;
            };
            var gridTypeDic:Dictionary = MapMgr.inst.gridTypeDic;
            var mapThingDic:Dictionary = MapMgr.inst.mapThingDic;
            var mapWidth:int = MapMgr.inst.mapWidth;
            var mapHeight:int = MapMgr.inst.mapHeight;
            var numCols:int = int(Math.ceil((mapWidth / _cellSize)));
            var numRows:int = int(Math.ceil((mapHeight / _cellSize)));
            var tempDrawRemindArr:Array = [];
            if (top < 0)
            {
                (checkIsLimit("top", [0, Math.abs(top)]));
            };
            if (left < 0)
            {
                (checkIsLimit("left", [Math.abs(left), 0]));
            };
            if (right < 0)
            {
                (checkIsLimit("right", [Math.abs(right), 0]));
            };
            if (bottom < 0)
            {
                (checkIsLimit("bottom", [0, Math.abs(bottom)]));
            };
            if (tempDrawRemindArr.length > 0)
            {
                var i:int = (remindContainer.displayListContainer.numChildren - 1);
                while (i >= 0)
                {
                    (remindContainer.displayListContainer.getChildAt(i) as MapRemindSp).rmSelf();
                    i--;
                };
                for each (var item:Array in tempDrawRemindArr)
                {
                    var shape:MapRemindSp = new MapRemindSp();
                    shape.drawRect(item[0], item[1], item[2], item[3]);
                    remindContainer.displayListContainer.addChild(shape);
                };
                MsgMgr.ShowMsg("当前裁剪区域存在数据，请检查！！！");
                return;
            };
            var tempGridTypeDic:Dictionary = new Dictionary();
            for (var gridType:String in gridTypeDic)
            {
                if (!tempGridTypeDic[gridType])
                {
                    tempGridTypeDic[gridType] = new Dictionary();
                };
                var curGridTypeDic:Dictionary = gridTypeDic[gridType];
                for (var subKey:String in curGridTypeDic)
                {
                    tempGridTypeDic[gridType][subKey] = curGridTypeDic[subKey];
                };
            };
            MapMgr.inst.gridTypeDic = new Dictionary();
            for (var gridType1:String in tempGridTypeDic)
            {
                if (!MapMgr.inst.gridTypeDic[gridType1])
                {
                    MapMgr.inst.gridTypeDic[gridType1] = new Dictionary();
                };
                var curGridTypeDic1:Dictionary = tempGridTypeDic[gridType1];
                var color:Number = MapMgr.inst.getColorByType(gridType1);
                for (var subKey1:String in curGridTypeDic1)
                {
                    var splitArr:Array = subKey1.split("_");
                    var gridX:int = (splitArr[0] + left);
                    var gridY:int = (splitArr[1] + top);
                    var gridComp:MapGridSp = curGridTypeDic1[subKey1];
                    if (gridType1 == "GridType_blockVerts")
                    {
                        gridComp.drawCircle(((gridX * _cellSize) + (_cellSize / 2)), ((gridY * _cellSize) + (_cellSize / 2)), (_cellSize / 2), color);
                    }
                    else
                    {
                        gridComp.drawRect(((gridX * _cellSize) + 0.5), ((gridY * _cellSize) + 0.5), _cellSize, _cellSize, color);
                    };
                    MapMgr.inst.gridTypeDic[gridType1][((gridX + "_") + gridY)] = gridComp;
                };
            };
            var tempMapThingDic:Dictionary = new Dictionary();
            for (var mapThingKey:String in mapThingDic)
            {
                tempMapThingDic[mapThingKey] = mapThingDic[mapThingKey];
            };
            MapMgr.inst.mapThingDic = new Dictionary();
            for (var mapThingKey1:String in tempMapThingDic)
            {
                var mapThingInfo:MapThingInfo = tempMapThingDic[mapThingKey1][0];
                var mapThingComp:GButton = tempMapThingDic[mapThingKey1][1];
                var _local_4:* = (mapThingInfo.x + (left * _cellSize));
                mapThingInfo.x = _local_4;
                mapThingComp.x = _local_4;
                var _local_3:* = (mapThingInfo.y + (top * _cellSize));
                mapThingInfo.y = _local_3;
                mapThingComp.y = _local_3;
                mapThingComp.name = ((mapThingComp.x + "_") + mapThingComp.y);
                MapMgr.inst.mapThingDic[mapThingComp.name] = [mapThingInfo, mapThingComp];
            };
            mapThingSelectSp.rmSelf();
            numCols = (numCols + (left + right));
            numRows = (numRows + (top + bottom));
            MapMgr.inst.mapWidth = (numCols * _cellSize);
            MapMgr.inst.mapHeight = (numRows * _cellSize);
            init(true);
            emit(GameEvent.ResizeMapSucc);
        }

        private function onDragMapThingDown(_arg_1:Object):void
        {
            var data = _arg_1;
            var imgLoaded = function ():void
            {
                mapThingInfo.width = mapThingComp.width;
                mapThingInfo.height = mapThingComp.height;
                if (!isImportJson)
                {
                    TweenMax.delayedCall(0.1, function ():void
                    {
                        mapThingSelectSp.drawRectLine((mapThingX - (mapThingComp.width / 2)), (mapThingY - (mapThingComp.height / 2)), mapThingComp.width, mapThingComp.height);
                        mapThingContainer.displayListContainer.addChild(mapThingSelectSp);
                    });
                };
            };
            var body:Object = data.body;
            var url:String = body.url;
            var isImportJson:Boolean = body.isImportJson;
            var mapThingX:int = int(((isImportJson) ? body.x : ((Global.stage.mouseX + view.scrollPane.posX) / curScale)));
            var mapThingY:int = int(((isImportJson) ? body.y : (((Global.stage.mouseY + view.scrollPane.posY) - (100 * curScale)) / curScale)));
            if (((((mapThingX < 0) || (mapThingY < 0)) || (mapThingX >= MapMgr.inst.mapWidth)) || (mapThingY >= MapMgr.inst.mapHeight)))
            {
                return;
            };
            if (!MapMgr.inst.mapThingDic)
            {
                MapMgr.inst.mapThingDic = new Dictionary();
            };
            var splitUrl:Array = url.split((MapMgr.inst.mapThingRootUrl + "\\"));
            var elementName:String = splitUrl[(splitUrl.length - 1)];
            var mapThingInfo:MapThingInfo = new MapThingInfo();
            var mapThingComp:GButton = MapMgr.inst.getMapThingComp(url, imgLoaded);
            var isBelve:Boolean = (elementName.indexOf("black.png") > -1);
            if (((isBelve) && (!(isImportJson))))
            {
                var gridInfo:Array = getGridInfoByMousePos();
                var gridPosX:int = gridInfo[0];
                var gridPosY:int = gridInfo[1];
                var pointArr:Array = [[(gridPosX * _cellSize), (gridPosY * _cellSize)], [((gridPosX * _cellSize) + _cellSize), (gridPosY * _cellSize)], [((gridPosX * _cellSize) + _cellSize), ((gridPosY * _cellSize) + _cellSize)], [(gridPosX * _cellSize), ((gridPosY * _cellSize) + _cellSize)]];
                var distArr:Array = [];
                distArr.push(BaseUT.distance(mapThingX, mapThingY, pointArr[0][0], pointArr[0][1]));
                distArr.push(BaseUT.distance(mapThingX, mapThingY, pointArr[1][0], pointArr[1][1]));
                distArr.push(BaseUT.distance(mapThingX, mapThingY, pointArr[2][0], pointArr[2][1]));
                distArr.push(BaseUT.distance(mapThingX, mapThingY, pointArr[3][0], pointArr[3][1]));
                var i:int = 0;
                while (i < distArr.length)
                {
                    if (!minDist)
                    {
                        var minDist:Number = distArr[i];
                    }
                    else
                    {
                        if (distArr[i] < minDist)
                        {
                            minDist = distArr[i];
                        };
                    };
                    i++;
                };
                var minIndex:int = distArr.indexOf(minDist);
                mapThingX = pointArr[minIndex][0];
                mapThingY = pointArr[minIndex][1];
            };
            var _local_3:* = mapThingX;
            mapThingInfo.x = _local_3;
            mapThingComp.x = _local_3;
            _local_3 = mapThingY;
            mapThingInfo.y = _local_3;
            mapThingComp.y = _local_3;
            mapThingComp.name = ((mapThingX + "_") + mapThingY);
            mapThingInfo.thingName = elementName;
            mapThingContainer.addChild(mapThingComp);
            MapMgr.inst.mapThingDic[mapThingComp.name] = [mapThingInfo, mapThingComp];
            mapThingSelectSp.rmSelf();
            if (body.taskId)
            {
                mapThingInfo.taskId = body.taskId;
            };
            if (body.groupId)
            {
                mapThingInfo.groupId = body.groupId;
            };
            if (body.isByDrag)
            {
                if (isBelve)
                {
                    mapThingInfo.type = 6;
                };
            };
            if (body.type)
            {
                mapThingInfo.type = body.type;
            };
            if (!isImportJson)
            {
                _lastSelectMapThingComp = mapThingComp;
                MapMgr.inst.curMapThingInfo = mapThingInfo;
                emit(GameEvent.ClickMapTing);
            };
            mapThingComp.addClickListener(function (_arg_1:GTouchEvent):void
            {
                var evt = _arg_1;
                if (_gridType != "GridType_MapThing")
                {
                    return;
                };
                var btn:GButton = (evt.currentTarget as GButton);
                var typeKey:String = ((("GridType_MapThing_" + btn.x) + "_") + btn.y);
                var mapThingGridDic:Dictionary = MapMgr.inst.gridTypeDic[typeKey];
                var gridInfo:Array = getGridInfoByMousePos();
                var gridPosX:int = gridInfo[0];
                var gridPosY:int = gridInfo[1];
                if ((((_isCtrlDown) && (mapThingGridDic)) && (mapThingGridDic[((gridPosX + "_") + gridPosY)])))
                {
                    return;
                };
                MapMgr.inst.curMapThingInfo = MapMgr.inst.mapThingDic[btn.name][0];
                if (_isCtrlDown)
                {
                    if (((mapThingSelectSp.curX == btn.x) && (mapThingSelectSp.curY == btn.y)))
                    {
                        mapThingSelectSp.rmSelf();
                    };
                    btn.dispose();
                    mapThingSelectSp.rmSelf();
                    MapMgr.inst.curMapThingInfo = null;
                    MapMgr.inst.rmMapThingGrid(((btn.x + "_") + btn.y));
                    delete MapMgr.inst.mapThingDic[btn.name]; //not popped
                    return;
                };
                if (_lastSelectMapThingComp != btn)
                {
                    mapThingSelectSp.rmSelf();
                    _lastSelectMapThingComp = btn;
                };
                TweenMax.delayedCall(0.1, function ():void
                {
                    mapThingSelectSp.drawRectLine((btn.x - (btn.width / 2)), (btn.y - (btn.height / 2)), btn.width, btn.height);
                    if (((!(mapThingSelectSp.parent)) || (!(mapThingSelectSp.parent.contains(mapThingSelectSp)))))
                    {
                        mapThingContainer.displayListContainer.addChild(mapThingSelectSp);
                    };
                });
                emit(GameEvent.ClickMapTing);
            });
            mapThingComp.addEventListener("rightClick", function (_arg_1:MouseEvent):void
            {
                if (_gridType != "GridType_MapThing")
                {
                    return;
                };
                if (_isRightDownDrawing)
                {
                    return;
                };
                var _local_2:GButton = (_arg_1.currentTarget as GButton);
                var _local_3:MapThingInfo = MapMgr.inst.mapThingDic[_local_2.name][0];
                if (!_local_3)
                {
                    return;
                };
                emit(GameEvent.DragMapThingStart, {
                    "url":_local_2.icon,
                    "taskId":_local_3.taskId,
                    "groupId":_local_3.groupId,
                    "type":_local_3.type
                });
                _local_2.dispose();
                mapThingSelectSp.rmSelf();
                MapMgr.inst.curMapThingInfo = null;
                MapMgr.inst.rmMapThingGrid(((_local_2.x + "_") + _local_2.y));
                delete MapMgr.inst.mapThingDic[_local_2.name]; //not popped
            });
        }

        private function onCloseDemo(_arg_1:Object):void
        {
            pet.visible = false;
            view.removeEventListener("enterFrame", onUpdate);
        }

        private function onRunDemo(_arg_1:Object):void
        {
            var _local_5:* = null;
            var _local_2:Dictionary = MapMgr.inst.gridTypeDic["GridType_walk"];
            if (((!(_local_2)) || (!(BaseUT.getDictionaryCount(_local_2)))))
            {
                MsgMgr.ShowMsg("没有找到可行走的格子");
                return;
            };
            var _local_3:Point = new Point();
            for (var _local_4:String in _local_2)
            {
                _local_5 = _local_4.split("_");
                _local_3.x = _local_5[0];
                _local_3.y = _local_5[1];
                break;
            };
            pet.visible = true;
            setPetPosAndRollCamera((_local_3.x * _cellSize), ((_local_3.y * _cellSize) + _cellSize), true);
            view.addEventListener("enterFrame", onUpdate);
        }

        protected function onUpdate(_arg_1:Event):void
        {
            var _local_6:JoystickLayer = MapMgr.inst.joystick;
            if (!_local_6.isMoving())
            {
                return;
            };
            var _local_8:Point = _local_6.vector;
            var _local_7:Point = BaseUT.angle_to_vector(_local_6.curDegree);
            var _local_2:Number = (_local_7.x * speed);
            var _local_4:Number = (_local_7.y * speed);
            pet.scaleX = ((_local_8.x > 0) ? 1 : -1);
            var _local_3:Number = (pet.x + _local_2);
            var _local_5:Number = (pet.y + _local_4);
            setPetPosAndRollCamera(_local_3, _local_5);
        }

        private function setPetPosAndRollCamera(_arg_1:Number, _arg_2:Number, _arg_3:Boolean=false):void
        {
            if (_arg_1 < 0)
            {
                _arg_1 = 0;
            };
            if (_arg_1 > (MapMgr.inst.mapWidth - (pet.width / 2)))
            {
                _arg_1 = (MapMgr.inst.mapWidth - (pet.width / 2));
            };
            if (_arg_2 < 37)
            {
                _arg_2 = 37;
            };
            if (_arg_2 > (MapMgr.inst.mapHeight - pet.height))
            {
                _arg_2 = (MapMgr.inst.mapHeight - pet.height);
            };
            pet.setXY(_arg_1, _arg_2);
            var _local_4:ScrollPane = view.scrollPane;
            _local_4.setPosX((pet.x - (_local_4.viewWidth / 2)), _arg_3);
            _local_4.setPosY(((pet.y - (_local_4.viewHeight / 2)) + (100 * curScale)), _arg_3);
        }

        protected function onKeyUp(_arg_1:KeyboardEvent):void
        {
            if (_arg_1.keyCode == 17)
            {
                _isCtrlDown = false;
            };
        }

        private function onKeyDown(_arg_1:KeyboardEvent):void
        {
            if (((_arg_1.keyCode == 17) && (!(_isCtrlDown))))
            {
                _isCtrlDown = true;
            };
        }

        override protected function onExit():void
        {
            Global.stage.removeEventListener("keyDown", onKeyDown);
            Global.stage.removeEventListener("keyUp", onKeyUp);
            view.removeEventListener("enterFrame", onUpdate);
        }


    }
}//package modules.mapEditor

