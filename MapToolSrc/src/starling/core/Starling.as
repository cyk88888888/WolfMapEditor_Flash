﻿// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.core.Starling

package starling.core
{
    import starling.events.EventDispatcher;
    import flash.utils.Dictionary;
    import __AS3__.vec.Vector;
    import flash.display.Stage3D;
    import starling.display.Stage;
    import starling.display.DisplayObject;
    import starling.animation.Juggler;
    import starling.events.TouchProcessor;
    import flash.display3D.Context3D;
    import flash.geom.Rectangle;
    import flash.display.Stage;
    import flash.display.Sprite;
    import starling.utils.SystemUtil;
    import flash.utils.getTimer;
    import flash.utils.setTimeout;
    import flash.ui.Multitouch;
    import flash.errors.IllegalOperationError;
    import starling.utils.execute;
    import flash.events.Event;
    import flash.display.Shape;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.system.Capabilities;
    import flash.events.ErrorEvent;
    import starling.events.KeyboardEvent;
    import flash.events.KeyboardEvent;
    import starling.events.ResizeEvent;
    import flash.events.MouseEvent;
    import flash.events.TouchEvent;
    import flash.ui.Mouse;
    import flash.display3D.Program3D;
    import flash.utils.ByteArray;

    public class Starling extends EventDispatcher 
    {

        public static const VERSION:String = "1.8";
        private static const PROGRAM_DATA_NAME:String = "Starling.programs";

        private static var sCurrent:Starling;
        private static var sHandleLostContext:Boolean = true;
        private static var sContextData:Dictionary = new Dictionary(true);
        private static var sAll:Vector.<Starling> = new Vector.<Starling>(0);
        public static var traceInl:Function;
        public static var reportError:Function;
        public static var _throwError:Function;

        private var mStage3D:Stage3D;
        private var mStage:starling.display.Stage;
        private var mRootClass:Class;
        private var mRoot:DisplayObject;
        private var mJuggler:Juggler;
        private var mSupport:RenderSupport;
        private var mTouchProcessor:TouchProcessor;
        private var mAntiAliasing:int;
        private var mSimulateMultitouch:Boolean;
        private var mEnableErrorChecking:Boolean;
        private var mLastFrameTimestamp:Number;
        private var mLeftMouseDown:Boolean;
        private var mStatsDisplay:StatsDisplay;
        private var mShareContext:Boolean;
        private var mProfile:String;
        private var mContext:Context3D;
        private var mStarted:Boolean;
        private var mRendering:Boolean;
        private var mSupportHighResolutions:Boolean;
        private var mBroadcastKeyboardEvents:Boolean;
        private var mViewPort:Rectangle;
        private var mPreviousViewPort:Rectangle;
        private var mClippedViewPort:Rectangle;
        private var mNativeStage:flash.display.Stage;
        private var mNativeOverlay:Sprite;
        private var mNativeStageContentScaleFactor:Number;

        public function Starling(_arg_1:Class, _arg_2:flash.display.Stage, _arg_3:Rectangle=null, _arg_4:Stage3D=null, _arg_5:String="auto", _arg_6:Object="baselineConstrained")
        {
            if (_arg_2 == null)
            {
                throw (new ArgumentError("Stage must not be null"));
            };
            if (_arg_3 == null)
            {
                _arg_3 = new Rectangle(0, 0, _arg_2.stageWidth, _arg_2.stageHeight);
            };
            if (_arg_4 == null)
            {
                _arg_4 = _arg_2.stage3Ds[0];
            };
            SystemUtil.initialize();
            sAll.push(this);
            makeCurrent();
            mRootClass = _arg_1;
            mViewPort = _arg_3;
            mPreviousViewPort = new Rectangle();
            mStage3D = _arg_4;
            mStage = new starling.display.Stage(_arg_3.width, _arg_3.height, _arg_2.color);
            mNativeOverlay = new Sprite();
            mNativeStage = _arg_2;
            mNativeStage.addChild(mNativeOverlay);
            mNativeStageContentScaleFactor = 1;
            mTouchProcessor = new TouchProcessor(mStage);
            mJuggler = new Juggler();
            mAntiAliasing = 0;
            mSimulateMultitouch = false;
            mEnableErrorChecking = false;
            mSupportHighResolutions = false;
            mBroadcastKeyboardEvents = true;
            mLastFrameTimestamp = (getTimer() / 1000);
            mSupport = new RenderSupport();
            sContextData[_arg_4] = new Dictionary();
            sContextData[_arg_4]["Starling.programs"] = new Dictionary();
            _arg_2.scaleMode = "noScale";
            _arg_2.align = "TL";
            for each (var _local_7:String in touchEventTypes)
            {
                _arg_2.addEventListener(_local_7, onTouch, false, 0, true);
            };
            _arg_2.addEventListener("enterFrame", onEnterFrame, false, 0, true);
            _arg_2.addEventListener("keyDown", onKey, false, 0, true);
            _arg_2.addEventListener("keyUp", onKey, false, 0, true);
            _arg_2.addEventListener("resize", onResize, false, 0, true);
            _arg_2.addEventListener("mouseLeave", onMouseLeave, false, 0, true);
            mStage3D.addEventListener("context3DCreate", onContextCreated, false, 10, true);
            mStage3D.addEventListener("error", onStage3DError, false, 10, true);
            if (((mStage3D.context3D) && (!(mStage3D.context3D.driverInfo == "Disposed"))))
            {
                if (((_arg_6 == "auto") || (_arg_6 is Array)))
                {
                    throw (new ArgumentError("When sharing the context3D, the actual profile has to be supplied"));
                };
                mProfile = (("profile" in mStage3D.context3D) ? mStage3D.context3D["profile"] : (_arg_6 as String));
                mShareContext = true;
                (setTimeout(initialize, 1));
            }
            else
            {
                if (!SystemUtil.supportsDepthAndStencil)
                {
                    (trace("[Starling] Mask support requires 'depthAndStencil' to be enabled in the application descriptor."));
                };
                mShareContext = false;
                requestContext3D(_arg_4, _arg_5, _arg_6);
            };
        }

        public static function get current():Starling
        {
            return (sCurrent);
        }

        public static function get all():Vector.<Starling>
        {
            return (sAll);
        }

        public static function get context():Context3D
        {
            return ((sCurrent) ? sCurrent.context : null);
        }

        public static function get juggler():Juggler
        {
            return ((sCurrent) ? sCurrent.juggler : null);
        }

        public static function get contentScaleFactor():Number
        {
            return ((sCurrent) ? sCurrent.contentScaleFactor : 1);
        }

        public static function get multitouchEnabled():Boolean
        {
            return (Multitouch.inputMode == "touchPoint");
        }

        public static function set multitouchEnabled(_arg_1:Boolean):void
        {
            if (sCurrent)
            {
                throw (new IllegalOperationError("'multitouchEnabled' must be set before Starling instance is created"));
            };
            Multitouch.inputMode = ((_arg_1) ? "touchPoint" : "none");
        }

        public static function get handleLostContext():Boolean
        {
            return (sHandleLostContext);
        }

        public static function set handleLostContext(_arg_1:Boolean):void
        {
            if (sCurrent)
            {
                throw (new IllegalOperationError("'handleLostContext' must be set before Starling instance is created"));
            };
            sHandleLostContext = _arg_1;
        }

        public static function splitStackTrace(_arg_1:String):String
        {
            var _local_2:Array = _arg_1.split(/[\n\r]+/);
            return (_local_2.join("|"));
        }

        public static function LogMgr_reportErr(_arg_1:String):void
        {
            if (reportError != null)
            {
                (reportError(_arg_1));
            };
        }

        public static function dbgThrowError(_arg_1:Error):void
        {
            if (_throwError)
            {
                (_throwError(_arg_1));
            };
        }


        public function dispose():void
        {
            stop(true);
            mNativeStage.removeEventListener("enterFrame", onEnterFrame, false);
            mNativeStage.removeEventListener("keyDown", onKey, false);
            mNativeStage.removeEventListener("keyUp", onKey, false);
            mNativeStage.removeEventListener("resize", onResize, false);
            mNativeStage.removeEventListener("mouseLeave", onMouseLeave, false);
            mNativeStage.removeChild(mNativeOverlay);
            mStage3D.removeEventListener("context3DCreate", onContextCreated, false);
            mStage3D.removeEventListener("error", onStage3DError, false);
            for each (var _local_1:String in touchEventTypes)
            {
                mNativeStage.removeEventListener(_local_1, onTouch, false);
            };
            if (mStage)
            {
                mStage.dispose();
            };
            if (mSupport)
            {
                mSupport.dispose();
            };
            if (mTouchProcessor)
            {
                mTouchProcessor.dispose();
            };
            if (sCurrent == this)
            {
                sCurrent = null;
            };
            if (((mContext) && (!(mShareContext))))
            {
                execute(mContext.dispose, false);
            };
            var _local_2:int = sAll.indexOf(this);
            if (_local_2 != -1)
            {
                sAll.splice(_local_2, 1);
            };
        }

        private function requestContext3D(stage3D:Stage3D, renderMode:String, profile:Object):void
        {
            var currentProfile:String;
			function requestNextProfile():void
            {
                currentProfile = profiles.shift();
                try
                {
                    execute(mStage3D.requestContext3D, renderMode, currentProfile);
                }
                catch(error:Error)
                {
                    if (traceInl != null)
                    {
                        (traceInl((("requestContext3D with " + currentProfile) + " failed")));
                    };
                    if (profiles.length != 0)
                    {
                        (setTimeout(requestNextProfile, 1));
                    }
                    else
                    {
                        throw (error);
                    };
                };
            };
			function onCreated(_arg_1:Event):void
            {
                var _local_2:Context3D = internal::stage3D.context3D;
                if ((((renderMode == "auto") && (!(profiles.length == 0))) && (!(_local_2.driverInfo.indexOf("Software") == -1))))
                {
                    (onError(_arg_1));
                }
                else
                {
                    mProfile = currentProfile;
                    (onFinished());
                };
            };
			function onError(_arg_1:Event):void
            {
                if (profiles.length != 0)
                {
                    _arg_1.stopImmediatePropagation();
                    (setTimeout(requestNextProfile, 1));
                }
                else
                {
                    (onFinished());
                    if (traceInl != null)
                    {
                        (traceInl((("requestContext3D with " + currentProfile) + " failed")));
                    };
                };
            };
			function onFinished():void
            {
                mStage3D.removeEventListener("context3DCreate", onCreated);
                mStage3D.removeEventListener("error", onError);
            };
            if (internal::profile == "auto")
            {
                var profiles:Array = ["standardExtended", "standard", "standardConstrained", "baselineExtended", "baseline", "baselineConstrained"];
            }
            else
            {
                if ((internal::profile is String))
                {
                    profiles = [(internal::profile as String)];
                }
                else
                {
                    if ((internal::profile is Array))
                    {
                        profiles = (internal::profile as Array);
                    }
                    else
                    {
                        throw (new ArgumentError("Profile must be of type 'String' or 'Array'"));
                    };
                };
            };
            mStage3D.addEventListener("context3DCreate", onCreated, false, 100);
            mStage3D.addEventListener("error", onError, false, 100);
            requestNextProfile(); //not popped
        }

        private function initialize():void
        {
            makeCurrent();
            initializeGraphicsAPI();
            initializeRoot();
            mTouchProcessor.simulateMultitouch = mSimulateMultitouch;
            mLastFrameTimestamp = (getTimer() / 1000);
        }

        private function initializeGraphicsAPI():void
        {
            var _local_1:Boolean;
            if (mContext != null)
            {
                _local_1 = true;
            };
            mContext = mStage3D.context3D;
            mContext.enableErrorChecking = mEnableErrorChecking;
            contextData["Starling.programs"] = new Dictionary();
            (trace("[Starling] Initialization complete."));
            (trace("[Starling] Display Driver:", mContext.driverInfo));
            if (traceInl != null)
            {
                (traceInl("[Starling] Initialization complete."));
                (traceInl("[Starling] Display Driver:", mContext.driverInfo));
            };
            if (_local_1)
            {
                dispatchEventWith("dvlst", false, mContext);
            };
            updateViewPort(true);
            dispatchEventWith("context3DCreate", false, mContext);
        }

        private function initializeRoot():void
        {
            if (((mRoot == null) && (!(mRootClass == null))))
            {
                mRoot = (new mRootClass() as DisplayObject);
                if (mRoot == null)
                {
                    throw (new Error(("Invalid root class: " + mRootClass)));
                };
                mStage.addChildAt(mRoot, 0);
                dispatchEventWith("rootCreated", false, mRoot);
            };
        }

        public function nextFrame():void
        {
            var _local_1:Number = (getTimer() / 1000);
            var _local_2:Number = (_local_1 - mLastFrameTimestamp);
            mLastFrameTimestamp = _local_1;
            if (_local_2 > 1)
            {
                _local_2 = 1;
            };
            if (_local_2 < 0)
            {
                _local_2 = (1 / mNativeStage.frameRate);
            };
            advanceTime(_local_2);
            render();
        }

        public function advanceTime(_arg_1:Number):void
        {
            if (!contextValid)
            {
                return;
            };
            makeCurrent();
            mTouchProcessor.advanceTime(_arg_1);
            mStage.advanceTime(_arg_1);
            mJuggler.advanceTime(_arg_1);
        }

        public function render():void
        {
            if (!contextValid)
            {
                return;
            };
            makeCurrent();
            updateViewPort();
            dispatchEventWith("render");
            var _local_1:Number = (mViewPort.width / mStage.stageWidth);
            var _local_2:Number = (mViewPort.height / mStage.stageHeight);
            mContext.setDepthTest(false, "always");
            mContext.setCulling("none");
            mSupport.nextFrame();
            mSupport.stencilReferenceValue = 0;
            mSupport.renderTarget = null;
            mSupport.setProjectionMatrix(((mViewPort.x < 0) ? (-(mViewPort.x) / _local_1) : 0), ((mViewPort.y < 0) ? (-(mViewPort.y) / _local_2) : 0), (mClippedViewPort.width / _local_1), (mClippedViewPort.height / _local_2), mStage.stageWidth, mStage.stageHeight, mStage.cameraPosition);
            if (!mShareContext)
            {
                RenderSupport.clear(mStage.color, 1);
            };
            mStage.render(mSupport, 1);
            mSupport.finishQuadBatch();
            if (mStatsDisplay)
            {
                mStatsDisplay.drawCount = mSupport.drawCount;
            };
            if (!mShareContext)
            {
                mContext.present();
            };
        }

        private function updateViewPort(_arg_1:Boolean=false):void
        {
            if ((((((_arg_1) || (!(mPreviousViewPort.width == mViewPort.width))) || (!(mPreviousViewPort.height == mViewPort.height))) || (!(mPreviousViewPort.x == mViewPort.x))) || (!(mPreviousViewPort.y == mViewPort.y))))
            {
                mPreviousViewPort.setTo(mViewPort.x, mViewPort.y, mViewPort.width, mViewPort.height);
                mClippedViewPort = mViewPort.intersection(new Rectangle(0, 0, mNativeStage.stageWidth, mNativeStage.stageHeight));
                if (!mShareContext)
                {
                    if (mProfile == "baselineConstrained")
                    {
                        configureBackBuffer(32, 32, mAntiAliasing, true);
                    };
                    mStage3D.x = mClippedViewPort.x;
                    mStage3D.y = mClippedViewPort.y;
                    configureBackBuffer(mClippedViewPort.width, mClippedViewPort.height, mAntiAliasing, true, mSupportHighResolutions);
                    if (((mSupportHighResolutions) && ("contentsScaleFactor" in mNativeStage)))
                    {
                        mNativeStageContentScaleFactor = mNativeStage["contentsScaleFactor"];
                    }
                    else
                    {
                        mNativeStageContentScaleFactor = 1;
                    };
                };
            };
        }

        private function configureBackBuffer(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:Boolean, _arg_5:Boolean=false):void
        {
            if (_arg_4)
            {
                _arg_4 = SystemUtil.supportsDepthAndStencil;
            };
            _arg_1 = ((_arg_1 < 32) ? 32 : _arg_1);
            _arg_2 = ((_arg_2 < 32) ? 32 : _arg_2);
            var _local_6:Function = mContext.configureBackBuffer;
            var _local_7:Array = [_arg_1, _arg_2, _arg_3, _arg_4];
            if (_local_6.length > 4)
            {
                _local_7.push(_arg_5);
            };
            try
            {
                _local_6.apply(mContext, _local_7);
            }
            catch(e:Error)
            {
                LogMgr_reportErr((((("W:" + _arg_1) + " H:") + _arg_2) + splitStackTrace(e.getStackTrace())));
            };
        }

        private function updateNativeOverlay():void
        {
            mNativeOverlay.x = mViewPort.x;
            mNativeOverlay.y = mViewPort.y;
            mNativeOverlay.scaleX = (mViewPort.width / mStage.stageWidth);
            mNativeOverlay.scaleY = (mViewPort.height / mStage.stageHeight);
        }

        public function stopWithFatalError(_arg_1:String):void
        {
            var _local_3:Shape = new Shape();
            _local_3.graphics.beginFill(0, 0.8);
            _local_3.graphics.drawRect(0, 0, mStage.stageWidth, mStage.stageHeight);
            _local_3.graphics.endFill();
            var _local_4:TextField = new TextField();
            var _local_2:TextFormat = new TextFormat("Verdana", 14, 0xFFFFFF);
            _local_2.align = "center";
            _local_4.defaultTextFormat = _local_2;
            _local_4.wordWrap = true;
            _local_4.width = (mStage.stageWidth * 0.75);
            _local_4.autoSize = "center";
            _local_4.text = _arg_1;
            _local_4.x = ((mStage.stageWidth - _local_4.width) / 2);
            _local_4.y = ((mStage.stageHeight - _local_4.height) / 2);
            _local_4.background = true;
            _local_4.backgroundColor = 0x550000;
            updateNativeOverlay();
            nativeOverlay.addChild(_local_3);
            nativeOverlay.addChild(_local_4);
            stop(true);
            (trace("[Starling]", _arg_1));
            dispatchEventWith("fatalError", false, _arg_1);
        }

        public function makeCurrent():void
        {
            sCurrent = this;
        }

        public function start():void
        {
            mStarted = (mRendering = true);
            mLastFrameTimestamp = (getTimer() / 1000);
        }

        public function stop(_arg_1:Boolean=false):void
        {
            mStarted = false;
            mRendering = (!(_arg_1));
        }

        private function onStage3DError(_arg_1:ErrorEvent):void
        {
            var _local_2:* = null;
            if (_arg_1.errorID == 3702)
            {
                _local_2 = ((Capabilities.playerType == "Desktop") ? "renderMode" : "wmode");
                stopWithFatalError((("Context3D not available! Possible reasons: wrong " + _local_2) + " or missing device support."));
            }
            else
            {
                stopWithFatalError(("Stage3D error: " + _arg_1.text));
            };
        }

        private function onContextCreated(_arg_1:Event):void
        {
            if (((!(Starling.handleLostContext)) && (mContext)))
            {
                _arg_1.stopImmediatePropagation();
                stopWithFatalError("The application lost the device context!");
                (trace("[Starling] Enable 'Starling.handleLostContext' to avoid this error."));
            }
            else
            {
                initialize();
            };
        }

        private function onEnterFrame(_arg_1:Event):void
        {
            if (!mShareContext)
            {
                if (mStarted)
                {
                    nextFrame();
                }
                else
                {
                    if (mRendering)
                    {
                        render();
                    };
                };
            };
            updateNativeOverlay();
        }

        private function onKey(_arg_1:flash.events.KeyboardEvent):void
        {
            if (!mStarted)
            {
                return;
            };
            var _local_2:starling.events.KeyboardEvent = new starling.events.KeyboardEvent(_arg_1.type, _arg_1.charCode, _arg_1.keyCode, _arg_1.keyLocation, _arg_1.ctrlKey, _arg_1.altKey, _arg_1.shiftKey);
            makeCurrent();
            if (mBroadcastKeyboardEvents)
            {
                mStage.broadcastEvent(_local_2);
            }
            else
            {
                mStage.dispatchEvent(_local_2);
            };
            if (_local_2.isDefaultPrevented())
            {
                _arg_1.preventDefault();
            };
        }

        private function onResize(event:Event):void
        {
			function dispatchResizeEvent():void
            {
                makeCurrent();
                removeEventListener("context3DCreate", dispatchResizeEvent);
                mStage.dispatchEvent(new ResizeEvent("resize", stageWidth, stageHeight));
            };
            var stageWidth:int = event.target.stageWidth;
            var stageHeight:int = event.target.stageHeight;
            if (contextValid)
            {
                (dispatchResizeEvent());
            }
            else
            {
                addEventListener("context3DCreate", dispatchResizeEvent);
            };
        }

        private function onMouseLeave(_arg_1:Event):void
        {
            mTouchProcessor.enqueueMouseLeftStage();
        }

        private function onTouch(_arg_1:Event):void
        {
            var _local_6:Number;
            var _local_9:Number;
            var _local_3:int;
            var _local_10:* = null;
            var _local_2:* = null;
            var _local_7:* = null;
            if (!mStarted)
            {
                return;
            };
            var _local_5:* = 1;
            var _local_8:* = 1;
            var _local_4:* = 1;
            if ((_arg_1 is MouseEvent))
            {
                _local_2 = (_arg_1 as MouseEvent);
                _local_6 = _local_2.stageX;
                _local_9 = _local_2.stageY;
                _local_3 = 0;
                if (_arg_1.type == "mouseDown")
                {
                    mLeftMouseDown = true;
                }
                else
                {
                    if (_arg_1.type == "mouseUp")
                    {
                        mLeftMouseDown = false;
                    };
                };
            }
            else
            {
                _local_7 = (_arg_1 as TouchEvent);
                if (((Mouse.supportsCursor) && (_local_7.isPrimaryTouchPoint)))
                {
                    return;
                };
                _local_6 = _local_7.stageX;
                _local_9 = _local_7.stageY;
                _local_3 = _local_7.touchPointID;
                _local_5 = _local_7.pressure;
                _local_8 = _local_7.sizeX;
                _local_4 = _local_7.sizeY;
            };
            switch (_arg_1.type)
            {
                case "touchBegin":
                    _local_10 = "began";
                    break;
                case "touchMove":
                    _local_10 = "moved";
                    break;
                case "touchEnd":
                    _local_10 = "ended";
                    break;
                case "mouseDown":
                    _local_10 = "began";
                    break;
                case "mouseUp":
                    _local_10 = "ended";
                    break;
                case "mouseMove":
                    _local_10 = ((mLeftMouseDown) ? "moved" : "hover");
            };
            _local_6 = ((mStage.stageWidth * (_local_6 - mViewPort.x)) / mViewPort.width);
            _local_9 = ((mStage.stageHeight * (_local_9 - mViewPort.y)) / mViewPort.height);
            mTouchProcessor.enqueue(_local_3, _local_10, _local_6, _local_9, _local_5, _local_8, _local_4);
            if (((_arg_1.type == "mouseUp") && (Mouse.supportsCursor)))
            {
                mTouchProcessor.enqueue(_local_3, "hover", _local_6, _local_9);
            };
        }

        private function get touchEventTypes():Array
        {
            return ([]);
        }

        public function registerProgram(_arg_1:String, _arg_2:ByteArray, _arg_3:ByteArray):Program3D
        {
            deleteProgram(_arg_1);
            var _local_4:Program3D = mContext.createProgram();
            _local_4.upload(_arg_2, _arg_3);
            programs[_arg_1] = _local_4;
            return (_local_4);
        }

        public function registerProgramFromSource(_arg_1:String, _arg_2:String, _arg_3:String):Program3D
        {
            deleteProgram(_arg_1);
            var _local_4:Program3D = RenderSupport.assembleAgal(_arg_2, _arg_3);
            programs[_arg_1] = _local_4;
            return (_local_4);
        }

        public function deleteProgram(_arg_1:String):void
        {
            var _local_2:Program3D = getProgram(_arg_1);
            if (_local_2)
            {
                _local_2.dispose();
                delete programs[_arg_1];
            };
        }

        public function getProgram(_arg_1:String):Program3D
        {
            return (programs[_arg_1] as Program3D);
        }

        public function hasProgram(_arg_1:String):Boolean
        {
            return (_arg_1 in programs);
        }

        private function get programs():Dictionary
        {
            return (contextData["Starling.programs"]);
        }

        public function get isStarted():Boolean
        {
            return (mStarted);
        }

        public function get juggler():Juggler
        {
            return (mJuggler);
        }

        public function get context():Context3D
        {
            return (mContext);
        }

        public function get contextData():Dictionary
        {
            return (sContextData[mStage3D] as Dictionary);
        }

        public function get backBufferWidth():int
        {
            return (mClippedViewPort.width);
        }

        public function get backBufferHeight():int
        {
            return (mClippedViewPort.height);
        }

        public function get backBufferPixelsPerPoint():int
        {
            return (mNativeStageContentScaleFactor);
        }

        public function get simulateMultitouch():Boolean
        {
            return (mSimulateMultitouch);
        }

        public function set simulateMultitouch(_arg_1:Boolean):void
        {
            mSimulateMultitouch = _arg_1;
            if (mContext)
            {
                mTouchProcessor.simulateMultitouch = _arg_1;
            };
        }

        public function get enableErrorChecking():Boolean
        {
            return (mEnableErrorChecking);
        }

        public function set enableErrorChecking(_arg_1:Boolean):void
        {
            mEnableErrorChecking = _arg_1;
            if (mContext)
            {
                mContext.enableErrorChecking = _arg_1;
            };
        }

        public function get antiAliasing():int
        {
            return (mAntiAliasing);
        }

        public function set antiAliasing(_arg_1:int):void
        {
            if (mAntiAliasing != _arg_1)
            {
                mAntiAliasing = _arg_1;
                if (contextValid)
                {
                    updateViewPort(true);
                };
            };
        }

        public function get viewPort():Rectangle
        {
            return (mViewPort);
        }

        public function set viewPort(_arg_1:Rectangle):void
        {
            mViewPort = _arg_1.clone();
        }

        public function get contentScaleFactor():Number
        {
            return ((mViewPort.width * mNativeStageContentScaleFactor) / mStage.stageWidth);
        }

        public function get nativeOverlay():Sprite
        {
            return (mNativeOverlay);
        }

        public function get showStats():Boolean
        {
            return ((mStatsDisplay) && (mStatsDisplay.parent));
        }

        public function set showStats(_arg_1:Boolean):void
        {
            if (_arg_1 == showStats)
            {
                return;
            };
            if (_arg_1)
            {
                if (mStatsDisplay)
                {
                    mStage.addChild(mStatsDisplay);
                }
                else
                {
                    showStatsAt();
                };
            }
            else
            {
                mStatsDisplay.removeFromParent();
            };
        }

        public function showStatsAt(hAlign:String="left", vAlign:String="top", scale:Number=1):void
        {
			function onRootCreated():void
            {
                showStatsAt(hAlign, vAlign, scale);
                removeEventListener("rootCreated", onRootCreated);
            };
            if (mContext == null)
            {
                addEventListener("rootCreated", onRootCreated);
            }
            else
            {
                var stageWidth:int = mStage.stageWidth;
                var stageHeight:int = mStage.stageHeight;
                if (mStatsDisplay == null)
                {
                    mStatsDisplay = new StatsDisplay();
                    mStatsDisplay.touchable = false;
                };
                mStage.addChild(mStatsDisplay);
                var _local_5:* = scale;
                mStatsDisplay.scaleY = _local_5;
                mStatsDisplay.scaleX = _local_5;
                if (hAlign == "left")
                {
                    mStatsDisplay.x = 0;
                }
                else
                {
                    if (hAlign == "right")
                    {
                        mStatsDisplay.x = (stageWidth - mStatsDisplay.width);
                    }
                    else
                    {
                        mStatsDisplay.x = int(((stageWidth - mStatsDisplay.width) / 2));
                    };
                };
                if (vAlign == "top")
                {
                    mStatsDisplay.y = 0;
                }
                else
                {
                    if (vAlign == "bottom")
                    {
                        mStatsDisplay.y = (stageHeight - mStatsDisplay.height);
                    }
                    else
                    {
                        mStatsDisplay.y = int(((stageHeight - mStatsDisplay.height) / 2));
                    };
                };
            };
        }

        public function get stage():starling.display.Stage
        {
            return (mStage);
        }

        public function get stage3D():Stage3D
        {
            return (mStage3D);
        }

        public function get nativeStage():flash.display.Stage
        {
            return (mNativeStage);
        }

        public function get root():DisplayObject
        {
            return (mRoot);
        }

        public function get rootClass():Class
        {
            return (mRootClass);
        }

        public function set rootClass(_arg_1:Class):void
        {
            if (((!(mRootClass == null)) && (!(mRoot == null))))
            {
                throw (new Error("Root class may not change after root has been instantiated"));
            };
            if (mRootClass == null)
            {
                mRootClass = _arg_1;
                if (mContext)
                {
                    initializeRoot();
                };
            };
        }

        public function get shareContext():Boolean
        {
            return (mShareContext);
        }

        public function set shareContext(_arg_1:Boolean):void
        {
            mShareContext = _arg_1;
        }

        public function get profile():String
        {
            return (mProfile);
        }

        public function get supportHighResolutions():Boolean
        {
            return (mSupportHighResolutions);
        }

        public function set supportHighResolutions(_arg_1:Boolean):void
        {
            if (mSupportHighResolutions != _arg_1)
            {
                mSupportHighResolutions = _arg_1;
                if (contextValid)
                {
                    updateViewPort(true);
                };
            };
        }

        public function get broadcastKeyboardEvents():Boolean
        {
            return (mBroadcastKeyboardEvents);
        }

        public function set broadcastKeyboardEvents(_arg_1:Boolean):void
        {
            mBroadcastKeyboardEvents = _arg_1;
        }

        public function get touchProcessor():TouchProcessor
        {
            return (mTouchProcessor);
        }

        public function set touchProcessor(_arg_1:TouchProcessor):void
        {
            if (_arg_1 != mTouchProcessor)
            {
                mTouchProcessor.dispose();
                mTouchProcessor = _arg_1;
            };
        }

        public function get contextValid():Boolean
        {
            var _local_1:* = null;
            var _local_2:Boolean;
            if (mStage3D.context3D == null)
            {
                return (false);
            };
            if (mContext)
            {
                _local_1 = mContext.driverInfo;
                if (_local_1 == null)
                {
                    return (false);
                };
                return (((!(_local_1.indexOf("DirectX") == -1)) || (!(_local_1.indexOf("OpenGL") == -1))) || (!(_local_1.indexOf("Software") == -1)));
            };
            return (false);
        }


    }
}//package starling.core

