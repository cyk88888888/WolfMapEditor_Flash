// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.SystemUtil

package starling.utils
{
    import starling.errors.AbstractClassError;
    import flash.system.Capabilities;
    import flash.utils.getDefinitionByName;
    import flash.events.EventDispatcher;
    import flash.display3D.Context3D;

    public class SystemUtil 
    {

        private static var sInitialized:Boolean = false;
        private static var sApplicationActive:Boolean = true;
        private static var sWaitingCalls:Array = [];
        private static var sPlatform:String;
        private static var sVersion:String;
        private static var sAIR:Boolean;
        private static var sSupportsDepthAndStencil:Boolean = true;

        public function SystemUtil()
        {
            throw (new AbstractClassError());
        }

        public static function initialize():void
        {
            var _local_4:* = null;
            var _local_2:* = null;
            var _local_3:* = null;
            var _local_1:* = null;
            var _local_5:* = null;
            if (sInitialized)
            {
                return;
            };
            sInitialized = true;
            sPlatform = Capabilities.version.substr(0, 3);
            sVersion = Capabilities.version.substr(4);
            try
            {
                _local_4 = getDefinitionByName("flash.desktop::NativeApplication");
                _local_2 = (_local_4["nativeApplication"] as EventDispatcher);
                _local_2.addEventListener("activate", onActivate, false, 0, true);
                _local_2.addEventListener("deactivate", onDeactivate, false, 0, true);
                _local_3 = _local_2["applicationDescriptor"];
                _local_1 = _local_3.namespace();
                _local_5 = _local_3._local_1::initialWindow._local_1::depthAndStencil.toString().toLowerCase();
                sSupportsDepthAndStencil = (_local_5 == "true");
                sAIR = true;
            }
            catch(e:Error)
            {
                sAIR = false;
            };
        }

        private static function onActivate(_arg_1:Object):void
        {
            sApplicationActive = true;
            for each (var _local_2:Array in sWaitingCalls)
            {
                try
                {
                    _local_2[0].apply(null, _local_2[1]);
                }
                catch(e:Error)
                {
                    (trace("[Starling] Error in 'executeWhenApplicationIsActive' call:", e.message));
                };
            };
            sWaitingCalls = [];
        }

        private static function onDeactivate(_arg_1:Object):void
        {
            sApplicationActive = false;
        }

        public static function executeWhenApplicationIsActive(_arg_1:Function, ... _args):void
        {
            initialize();
            if (sApplicationActive)
            {
                _arg_1.apply(null, _args);
            }
            else
            {
                sWaitingCalls.push([_arg_1, _args]);
            };
        }

        public static function get isApplicationActive():Boolean
        {
            initialize();
            return (sApplicationActive);
        }

        public static function get isAIR():Boolean
        {
            initialize();
            return (sAIR);
        }

        public static function get isDesktop():Boolean
        {
            initialize();
            return (!(/(WIN|MAC|LNX)/.exec(sPlatform) == null));
        }

        public static function get platform():String
        {
            initialize();
            return (sPlatform);
        }

        public static function get version():String
        {
            initialize();
            return (sVersion);
        }

        public static function get supportsRelaxedTargetClearRequirement():Boolean
        {
            return (parseInt(/\d+/.exec(sVersion)[0]) >= 15);
        }

        public static function get supportsDepthAndStencil():Boolean
        {
            return (sSupportsDepthAndStencil);
        }

        public static function get supportsVideoTexture():Boolean
        {
            return (Context3D["supportsVideoTexture"]);
        }


    }
}//package starling.utils

