// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//common.util.DspUtils

package common.util
{
    import flash.filters.ColorMatrixFilter;
    import com.common.util.ColorMatrixFilterUtil;
    import flash.utils.Dictionary;
    import flash.display.InteractiveObject;
    import flash.display.DisplayObject;
    import flash.display.MovieClip;
    import flash.display.Stage;
    import flash.display.DisplayObjectContainer;
    import flash.geom.Rectangle;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import com.common.util.MtxUtl;
    import com.common.util.ArrayUtils;
    import flash.display.Scene;
    import flash.display.FrameLabel;
    import com.common.util.Reflection;
    import flash.utils.getQualifiedClassName;
    import flash.display.Graphics;
    import __AS3__.vec.Vector;
    import flash.geom.Point;
    import com.simpvmc.interfaces.IUiMediator;

    public class DspUtils 
    {

        public static const colorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter([0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0.3, 0.59, 0.11, 0, 0, 0, 0, 0, 1, 0]);
        public static const bmpColorMatrixFilter:ColorMatrixFilter = new ColorMatrixFilter(ColorMatrixFilterUtil.getMatrix(-50, 0, -100, 0, 100));

        public static var dicTargetParent:Dictionary = new Dictionary(true);
        private static var stack:Array = [];
        public static var rslt:Array = [];
        public static var tmpStack:Array = [];
        public static var traceInl:Function;


        public static function enableWithFliter(_arg_1:DisplayObject, _arg_2:Boolean, _arg_3:Boolean=true, _arg_4:Array=null):void
        {
            if (!_arg_1)
            {
                return;
            };
            if (_arg_2)
            {
                if (_arg_1.filters == null)
                {
                    return;
                };
                _arg_1.filters = null;
                if (((_arg_1 is InteractiveObject) && (_arg_3)))
                {
                    (_arg_1 as InteractiveObject).mouseEnabled = true;
                };
            }
            else
            {
                if (!_arg_4)
                {
                    _arg_4 = [colorMatrixFilter];
                };
                if (((!(_arg_1.filters == null)) && (_arg_1.filters[0] == _arg_4[0])))
                {
                    return;
                };
                _arg_1.filters = _arg_4;
                if (((_arg_1 is InteractiveObject) && (_arg_3)))
                {
                    (_arg_1 as InteractiveObject).mouseEnabled = false;
                };
            };
        }

        public static function setBmpFilter(_arg_1:DisplayObject, _arg_2:Boolean):void
        {
            if (_arg_2)
            {
                if (((!(_arg_1.filters == null)) && (_arg_1.filters[0] == bmpColorMatrixFilter)))
                {
                    return;
                };
                _arg_1.filters = [bmpColorMatrixFilter];
            }
            else
            {
                if (_arg_1.filters == null)
                {
                    return;
                };
                _arg_1.filters = null;
            };
        }

        public static function attachCtrls(_arg_1:MovieClip, _arg_2:Object=null):Object
        {
            var _local_3:int;
            var _local_4:* = null;
            ((_arg_2 == null) ? {} : _arg_2);
            _local_3 = 0;
            while (_local_3 < _arg_1.numChildren)
            {
                _local_4 = _arg_1.getChildAt(_local_3);
                _arg_2[_local_4.name] = _local_4;
                _local_3++;
            };
            return (_arg_2);
        }

        public static function isVisible(_arg_1:DisplayObject):Boolean
        {
            var _local_2:* = _arg_1;
            var _local_3:* = _arg_1;
            while (_local_2)
            {
                if (_local_2.visible == false)
                {
                    return (false);
                };
                _local_3 = _local_2;
                _local_2 = _local_2.parent;
            };
            if ((_local_3 is Stage))
            {
                return (true);
            };
            return (false);
        }

        public static function removeChilds(_arg_1:DisplayObjectContainer, _arg_2:Array):void
        {
            var _local_4:int;
            var _local_3:* = null;
            _local_4 = 0;
            while (_local_4 < _arg_2.length)
            {
                _local_3 = _arg_2[_local_4];
                _arg_1.removeChild(_local_3);
                _local_4++;
            };
        }

        public static function showDsp(_arg_1:Boolean, _arg_2:DisplayObject, _arg_3:DisplayObjectContainer=null, _arg_4:int=-1):void
        {
            if (!_arg_1)
            {
                removeChild(_arg_2);
                return;
            };
            if (((!(_arg_2)) || (!(_arg_3))))
            {
                return;
            };
            if (_arg_4 == -1)
            {
                _arg_3.addChild(_arg_2);
            }
            else
            {
                _arg_3.addChildAt(_arg_2, _arg_4);
            };
        }

        public static function visible(_arg_1:DisplayObject, _arg_2:Boolean):void
        {
            var _local_3:* = null;
            _arg_1.visible = _arg_2;
            if (_arg_2)
            {
                _local_3 = (dicTargetParent[_arg_1] as DisplayObjectContainer);
                if (_local_3)
                {
                    if (_local_3 != _arg_1.parent)
                    {
                        _local_3.addChild(_arg_1);
                    };
                    delete dicTargetParent[_arg_1];
                };
            }
            else
            {
                _local_3 = _arg_1.parent;
                if (_local_3)
                {
                    _local_3.removeChild(_arg_1);
                    dicTargetParent[_arg_1] = _local_3;
                };
            };
        }

        public static function getMovieClipBounds(_arg_1:MovieClip):Rectangle
        {
            var _local_2:Rectangle = _arg_1.getBounds(_arg_1);
            _local_2.x = Math.floor(_local_2.x);
            _local_2.y = Math.floor(_local_2.y);
            _local_2.width = Math.ceil(_local_2.width);
            _local_2.height = Math.ceil(_local_2.height);
            return (_local_2);
        }

        public static function removeChild(_arg_1:*):void
        {
            if (((_arg_1) && (_arg_1.parent)))
            {
                _arg_1.parent.removeChild(_arg_1);
            };
        }

        public static function removeAllExcept(_arg_1:DisplayObjectContainer, _arg_2:DisplayObject=null):void
        {
            var _local_3:int;
            _local_3 = (_arg_1.numChildren - 1);
            while (_local_3 > -1)
            {
                if (_arg_2 != _arg_1.getChildAt(_local_3))
                {
                    _arg_1.removeChildAt(_local_3);
                };
                _local_3--;
            };
        }

        public static function removeAll(_arg_1:DisplayObjectContainer, _arg_2:Class=null):void
        {
            var _local_4:* = null;
            var _local_5:uint;
            if (_arg_2 == null)
            {
                while (_arg_1.numChildren > 0)
                {
                    _arg_1.removeChildAt(0);
                };
            }
            else
            {
                _local_4 = [];
                _local_5 = 0;
                while (_local_5 < _arg_1.numChildren)
                {
                    if ((_arg_1.getChildAt(_local_5) is _arg_2))
                    {
                        _local_4.push(_arg_1.getChildAt(_local_5));
                    };
                    _local_5++;
                };
                for each (var _local_3:DisplayObject in _local_4)
                {
                    removeChild(_local_3);
                };
            };
        }

        public static function getDisplayOrderRelate2Main(_arg_1:DisplayObject):String
        {
            var _local_3:* = null;
            var _local_2:String = "";
            var _local_4:String = (2147483647).toString();
            while (_arg_1.parent)
            {
                _local_3 = _arg_1.parent;
                _local_2 = ((_local_3.getChildIndex(_arg_1) + "_") + _local_2);
                _arg_1 = _arg_1.parent;
            };
            if ((_arg_1 is Stage))
            {
                return (_local_2);
            };
            return (_local_4);
        }

        public static function getBitmapData(_arg_1:DisplayObject):BitmapData
        {
            var _local_3:* = null;
            var _local_2:int;
            var _local_5:* = null;
            if ((_arg_1 is DisplayObjectContainer))
            {
                _local_3 = (_arg_1 as DisplayObjectContainer);
                _local_2 = 0;
                while (_local_2 < _local_3.numChildren)
                {
                    _local_5 = _local_3.getChildAt(_local_2);
                    if ((_local_5 is Bitmap))
                    {
                        return ((_local_5 as Bitmap).bitmapData);
                    };
                    _local_2++;
                };
            };
            var _local_4:BitmapData = new BitmapData(_arg_1.width, _arg_1.height, true, 0);
            _local_4.draw(_arg_1, MtxUtl.New(1, 0, 0, 1, 0, 0));
            return (_local_4);
        }

        public static function playMovieClip(_arg_1:DisplayObjectContainer, _arg_2:Boolean):void
        {
            var _local_5:* = null;
            var _local_7:* = null;
            var _local_4:* = null;
            var _local_6:int;
            var _local_3:* = null;
            ArrayUtils.ePush(stack, _arg_1);
            while (ArrayUtils.eLen(stack))
            {
                _local_5 = ArrayUtils.ePop(stack);
                if ((_local_5 is DisplayObjectContainer))
                {
                    if ((_local_5 is MovieClip))
                    {
                        _local_7 = (_local_5 as MovieClip);
                        if (_arg_2)
                        {
                            _local_7.play();
                        }
                        else
                        {
                            _local_7.stop();
                        };
                    };
                    _local_4 = (_local_5 as DisplayObjectContainer);
                    _local_6 = 0;
                    while (_local_6 < _local_4.numChildren)
                    {
                        _local_3 = _local_4.getChildAt(_local_6);
                        ArrayUtils.ePush(stack, _local_3);
                        _local_6++;
                    };
                };
            };
        }

        public static function gotoNstop(_arg_1:MovieClip, _arg_2:int):void
        {
            if (_arg_1.currentFrame != _arg_2)
            {
                _arg_1.gotoAndStop(_arg_2);
            }
            else
            {
                _arg_1.stop();
            };
        }

        public static function bringToFront(_arg_1:DisplayObject):void
        {
            var _local_2:* = null;
            if (_arg_1 == null)
            {
                return;
            };
            if (((!(_arg_1.parent == null)) && (_arg_1.parent is DisplayObjectContainer)))
            {
                _local_2 = _arg_1.parent;
                _local_2.setChildIndex(_arg_1, (_local_2.numChildren - 1));
            };
        }

        public static function addLabelScript(_arg_1:MovieClip, _arg_2:*, _arg_3:Function=null, _arg_4:Array=null):void
        {
            var _local_9:* = null;
            var _local_6:* = null;
            var _local_10:int;
            var _local_5:uint;
            var _local_11:Array = [];
            if ((_arg_2 is Number))
            {
                _local_11.push(_arg_2);
            }
            else
            {
                if ((_arg_2 is String))
                {
                    _local_9 = _arg_1.scenes;
                    for each (var _local_7:Scene in _local_9)
                    {
                        _local_6 = _local_7.labels;
                        for each (var _local_8:FrameLabel in _local_6)
                        {
                            if (_local_8.name == _arg_2)
                            {
                                _local_11.push(_local_8.frame);
                            };
                        };
                    };
                };
            };
            _local_10 = 0;
            while (_local_10 < _local_11.length)
            {
                _local_5 = _local_11[_local_10];
                if (((_local_5 > 0) && (_local_5 <= _arg_1.totalFrames)))
                {
                    _arg_1.addFrameScript(_local_5, _arg_3);
                };
                _local_10++;
            };
        }

        private static function getChildByClass(_arg_1:DisplayObjectContainer, _arg_2:Class):DisplayObject
        {
            var _local_4:int;
            var _local_3:* = null;
            _local_4 = 0;
            while (_local_4 < _arg_1.numChildren)
            {
                _local_3 = _arg_1.getChildAt(_local_4);
                if (Reflection.getObjCls(_local_3) == _arg_2)
                {
                    return (_local_3);
                };
                _local_4++;
            };
            return (null);
        }

        public static function enumChild(_arg_1:DisplayObject, _arg_2:Class):Array
        {
            var _local_6:* = null;
            var _local_3:* = null;
            var _local_4:int;
            var _local_5:* = null;
            rslt.length = 0;
            tmpStack.length = 0;
            tmpStack.push(_arg_1);
            while (tmpStack.length)
            {
                _local_6 = tmpStack.pop();
                if ((_local_6 is _arg_2))
                {
                    rslt.push(_local_6);
                };
                if ((_local_6 is DisplayObjectContainer))
                {
                    _local_3 = (_local_6 as DisplayObjectContainer);
                    _local_4 = 0;
                    while (_local_4 < _local_3.numChildren)
                    {
                        _local_5 = _local_3.getChildAt(_local_4);
                        tmpStack.push(_local_5);
                        _local_4++;
                    };
                }
                else
                {
                    if (Reflection.getObjCls(_local_6) == _arg_2)
                    {
                        rslt.push(_local_6);
                    };
                };
            };
            return (rslt);
        }

        public static function getChilds(_arg_1:*, _arg_2:Array=null):Array
        {
            if (_arg_2 == null)
            {
                _arg_2 = [];
            }
            else
            {
                _arg_2.length = 0;
            };
            var _local_3:uint;
            while (_local_3 < _arg_1.numChildren)
            {
                _arg_2.push(_arg_1.getChildAt(_local_3));
                _local_3++;
            };
            return (_arg_2);
        }

        public static function getChidsByName(_arg_1:*, _arg_2:String=null, _arg_3:Array=null):Array
        {
            var _local_6:*;
            var _local_5:* = null;
            if (_arg_3 == null)
            {
                _arg_3 = [];
            }
            else
            {
                _arg_3.length = 0;
            };
            var _local_4:uint;
            while (_local_4 < _arg_1.numChildren)
            {
                _local_6 = _arg_1.getChildAt(_local_4);
                _local_5 = _local_6["name"];
                if (_arg_2 == null)
                {
                    _arg_3.push(_local_6);
                }
                else
                {
                    if (_local_5.indexOf(_arg_2) != -1)
                    {
                        _arg_3.push(_local_6);
                    };
                };
                _local_4++;
            };
            return (_arg_3);
        }

        public static function getDspId(_arg_1:DisplayObject):String
        {
            var _local_3:String = getQualifiedClassName(_arg_1);
            if (_local_3.indexOf("::") != -1)
            {
                _local_3 = _local_3.substr((_local_3.indexOf("::") + 2));
            };
            var _local_2:String = _arg_1.name;
            if (((_local_2 == null) || (_local_2.match(/instance[0-9]+/g).length == 1)))
            {
                _local_2 = "inst";
            };
            return ((_local_2 + ":") + _local_3);
        }

        public static function moveTo(_arg_1:DisplayObject, _arg_2:DisplayObject):void
        {
            _arg_1.x = _arg_2.x;
            _arg_1.y = _arg_2.y;
        }

        public static function replaceDis(_arg_1:DisplayObject, _arg_2:DisplayObject):void
        {
            moveTo(_arg_2, _arg_1);
            var _local_3:int = _arg_1.parent.getChildIndex(_arg_1);
            _arg_1.parent.addChildAt(_arg_2, _local_3);
            _arg_1.visible = false;
        }

        public static function enable(_arg_1:DisplayObjectContainer, _arg_2:Boolean):void
        {
            var _local_3:* = _arg_2;
            _arg_1.mouseChildren = _local_3;
            _arg_1.mouseEnabled = _local_3;
        }

        public static function drawShapeList(_arg_1:Graphics, _arg_2:Vector.<Point>, _arg_3:int=0xFF00):void
        {
            var _local_8:int;
            var _local_4:* = null;
            var _local_6:int;
            var _local_5:* = null;
            var _local_7:* = null;
            _arg_1.clear();
            _arg_1.beginFill(0xFF0000);
            _local_8 = 0;
            while (_local_8 < _arg_2.length)
            {
                _local_4 = _arg_2[_local_8];
                _arg_1.drawRect((_local_4.x - 1), (_local_4.y - 1), 2, 2);
                _local_8++;
            };
            _arg_1.endFill();
            _local_6 = 0;
            while (_local_6 < _arg_2.length)
            {
                _local_5 = _arg_2[_local_6];
                _arg_1.lineStyle(1, _arg_3);
                if (_local_6 == 0)
                {
                    _arg_1.moveTo(_local_5.x, _local_5.y);
                }
                else
                {
                    _arg_1.lineTo(_local_5.x, _local_5.y);
                };
                _local_6++;
            };
            if (_arg_2.length)
            {
                _local_7 = _arg_2[0];
                _arg_1.lineTo(_local_7.x, _local_7.y);
            };
        }

        public static function alignCenter(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:DisplayObjectContainer=null, _arg_4:int=-1):void
        {
            _arg_1.x = (_arg_2.x + ((_arg_2.width - _arg_1.width) * 0.5));
            _arg_1.y = (_arg_2.y + ((_arg_2.height - _arg_1.height) * 0.5));
            var _local_5:DisplayObjectContainer = ((_arg_3) ? _arg_3 : _arg_2.parent);
            if (_local_5)
            {
                _arg_4 = ((_arg_4 == -1) ? _local_5.numChildren : _arg_4);
                _local_5.addChildAt(_arg_1, _arg_4);
            };
        }

        public static function flushDataMdr(_arg_1:IUiMediator, _arg_2:IUiMediator, _arg_3:Boolean=false, _arg_4:Array=null):IUiMediator
        {
            if ((((!(_arg_1)) || (!(_arg_1 == _arg_2))) || (!(_arg_3))))
            {
                if (_arg_1)
                {
                    _arg_1.hide();
                };
                _arg_1 = _arg_2;
                if (_arg_1)
                {
                    _arg_1.show(_arg_4);
                };
            }
            else
            {
                _arg_1 = _arg_2;
                _arg_1.flushData(_arg_4);
            };
            return (_arg_1);
        }

        public static function toTop(_arg_1:DisplayObject):void
        {
            var _local_2:int;
            if (((_arg_1) && (_arg_1.parent)))
            {
                _local_2 = _arg_1.parent.numChildren;
                _arg_1.parent.setChildIndex(_arg_1, (_local_2 - 1));
            };
        }

        public static function localToTarget(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:Point=null):Point
        {
            if (!_arg_3)
            {
                _arg_3 = new Point();
            };
            while ((((_arg_1.parent) && (!(_arg_1 == _arg_2))) && (!(_arg_1 is Stage))))
            {
                _arg_3.x = (_arg_3.x + _arg_1.x);
                _arg_3.y = (_arg_3.y + _arg_1.y);
                _arg_1 = _arg_1.parent;
            };
            return (_arg_3);
        }

        public static function isChildren(_arg_1:DisplayObject, _arg_2:DisplayObject):Boolean
        {
            var _local_3:Boolean;
            while ((((!(_local_3)) && (_arg_1)) && (!(_arg_1 is Stage))))
            {
                _local_3 = (_arg_1 == _arg_2);
                _arg_1 = _arg_1.parent;
            };
            return (_local_3);
        }


    }
}//package common.util

