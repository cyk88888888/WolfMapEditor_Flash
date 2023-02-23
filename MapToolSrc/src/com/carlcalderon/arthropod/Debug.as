// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.carlcalderon.arthropod.Debug

package com.carlcalderon.arthropod
{
    import flash.net.LocalConnection;
    import flash.display.BitmapData;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import flash.display.Stage;
    import flash.system.System;
    import flash.events.StatusEvent;

    public class Debug 
    {

        public static const NAME:String = "Debug";
        public static const VERSION:String = "0.74";
        private static const DOMAIN:String = "com.carlcalderon.Arthropod";
        private static const CHECK:String = ".161E714B6C1A76DE7B9865F88B32FCCE8FABA7B5.1";
        private static const TYPE:String = "app";
        private static const CONNECTION:String = "arthropod";
        private static const LOG_OPERATION:String = "debug";
        private static const ERROR_OPERATION:String = "debugError";
        private static const WARNING_OPERATION:String = "debugWarning";
        private static const ARRAY_OPERATION:String = "debugArray";
        private static const BITMAP_OPERATION:String = "debugBitmapData";
        private static const OBJECT_OPERATION:String = "debugObject";
        private static const MEMORY_OPERATION:String = "debugMemory";
        private static const CLEAR_OPERATION:String = "debugClear";

        public static var password:String = "CDC309AF";
        public static var RED:uint = 0xCC0000;
        public static var GREEN:uint = 0xCC00;
        public static var BLUE:uint = 6710988;
        public static var PINK:uint = 0xCC00CC;
        public static var YELLOW:uint = 0xCCCC00;
        public static var LIGHT_BLUE:uint = 0xCCCC;
        public static var ignoreStatus:Boolean = true;
        public static var secure:Boolean = false;
        public static var secureDomain:String = "*";
        public static var allowLog:Boolean = true;
        private static var lc:LocalConnection = new LocalConnection();
        private static var hasEventListeners:Boolean = false;


        public static function log(_arg_1:*, _arg_2:uint=0xFEFEFE):Boolean
        {
            return (send("debug", _arg_1, _arg_2));
        }

        public static function error(_arg_1:*):Boolean
        {
            return (send("debugError", _arg_1, 0xCC0000));
        }

        public static function warning(_arg_1:*):Boolean
        {
            return (send("debugWarning", _arg_1, 0xCCCC00));
        }

        public static function clear():Boolean
        {
            return (send("debugClear", 0, 0));
        }

        public static function array(_arg_1:Array):Boolean
        {
            return (send("debugArray", _arg_1, null));
        }

        public static function bitmap(_arg_1:*, _arg_2:String=null):Boolean
        {
            var _local_5:BitmapData = new BitmapData(100, 100, true, 0xFFFFFF);
            var _local_6:Matrix = new Matrix();
            var _local_4:Number = (100 / ((_arg_1.width >= _arg_1.height) ? _arg_1.width : _arg_1.height));
            _local_6.scale(_local_4, _local_4);
            _local_5.draw(_arg_1, _local_6, null, null, null, true);
            var _local_3:Rectangle = new Rectangle(0, 0, Math.floor((_arg_1.width * _local_4)), Math.floor((_arg_1.height * _local_4)));
            return (send("debugBitmapData", _local_5.getPixels(_local_3), {
                "bounds":_local_3,
                "lbl":_arg_2
            }));
        }

        public static function snapshot(_arg_1:Stage, _arg_2:String=null):Boolean
        {
            if (_arg_1)
            {
                return (bitmap(_arg_1, _arg_2));
            };
            return (false);
        }

        public static function object(_arg_1:*):Boolean
        {
            return (send("debugObject", _arg_1, null));
        }

        public static function memory():Boolean
        {
            return (send("debugMemory", System.totalMemory, null));
        }

        private static function send(_arg_1:String, _arg_2:*, _arg_3:*):Boolean
        {
            if (!secure)
            {
                lc.allowInsecureDomain("*");
            }
            else
            {
                lc.allowDomain(secureDomain);
            };
            if (!hasEventListeners)
            {
                if (ignoreStatus)
                {
                    lc.addEventListener("status", ignore);
                }
                else
                {
                    lc.addEventListener("status", status);
                };
                hasEventListeners = true;
            };
            if (allowLog)
            {
                try
                {
                    lc.send("app#com.carlcalderon.Arthropod.161E714B6C1A76DE7B9865F88B32FCCE8FABA7B5.1:arthropod", _arg_1, password, _arg_2, _arg_3);
                    var _local_5:Boolean = true;
                    return (_local_5);
                }
                catch(e)
                {
                    return (false);
                };
            };
            return (false);
        }

        private static function status(_arg_1:StatusEvent):void
        {
            doTrace(("Arthropod status:\n" + _arg_1.toString()));
        }

        private static function ignore(_arg_1:StatusEvent):void
        {
        }


    }
}//package com.carlcalderon.arthropod

