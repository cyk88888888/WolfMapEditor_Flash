// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//core.utils.DbgUtil

package core.utils
{
    import flash.system.Capabilities;
    import flash.external.ExternalInterface;

    public class DbgUtil 
    {

        public static var loaderAppendQueueType:Boolean = false;
        public static var traceTilePosChangeReason:Boolean = false;
        public static var enableAssert:Boolean = false;
        public static var dbgLifeCircle:Boolean = false;
        public static var logNetMsg:Boolean = false;
        public static var tryExec:Boolean = true;
        public static var _reportError:Function;
        private static var _Plt:String = null;
        private static var _Ver:String = null;
        private static var _UA:String = null;


        public static function assert(_arg_1:*):int
        {
            if (_arg_1 != true)
            {
                traceInl0(("ERROR: " + _arg_1));
                if (enableAssert)
                {
                    throw (new Error(_arg_1));
                };
            };
            return (0);
        }

        public static function nop():void
        {
        }

        public static function splitStackTrace(_arg_1:Error):String
        {
            var _local_2:* = null;
            var _local_5:* = null;
            var _local_3:* = null;
            var _local_4:String = "ESST";
            if (_arg_1 != null)
            {
                _local_2 = "";
                _local_5 = _arg_1.getStackTrace();
                if (_local_5)
                {
                    _local_3 = _local_5.split(/[\n\r]+/);
                    _local_2 = _local_3.join("|");
                };
                _local_4 = ((_arg_1.message + " ") + _local_2);
            };
            return (_local_4);
        }

        public static function reportErr(_arg_1:String):void
        {
            if (_reportError != null)
            {
                (_reportError(_arg_1));
            };
        }

        private static function initVerInfo():void
        {
            var _local_2:String = Capabilities.version;
            var _local_1:Array = _local_2.split(" ");
            _Plt = _local_1[0];
            _Ver = _local_1[1];
            if (_UA == null)
            {
                if (ExternalInterface.available)
                {
                    try
                    {
                        _UA = ExternalInterface.call("function () {return window.navigator.userAgent;}");
                    }
                    catch(err)
                    {
                    };
                }
                else
                {
                    _UA = "";
                };
            };
        }

        public static function get Ver():String
        {
            if (_Ver == null)
            {
                initVerInfo();
            };
            return (_Ver);
        }

        public static function get Plt():String
        {
            if (_Plt == null)
            {
                initVerInfo();
            };
            return (_Plt);
        }

        public static function get UA():String
        {
            if (_UA == null)
            {
                initVerInfo();
            };
            return (_UA);
        }


    }
}//package core.utils

