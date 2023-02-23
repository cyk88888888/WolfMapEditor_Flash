// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.core.StatsDisplay

package starling.core
{
    import starling.display.Sprite;
    import starling.display.Quad;
    import starling.text.TextField;
    import starling.events.EnterFrameEvent;
    import flash.system.System;
    import starling.core.RenderSupport;

    internal class StatsDisplay extends Sprite 
    {

        private const UPDATE_INTERVAL:Number = 0.5;

        private var mBackground:Quad;
        private var mTextField:TextField;
        private var mFrameCount:int = 0;
        private var mTotalTime:Number = 0;
        private var mFps:Number = 0;
        private var mMemory:Number = 0;
        private var mDrawCount:int = 0;

        public function StatsDisplay()
        {
            mBackground = new Quad(50, 25, 0);
            mTextField = new TextField(48, 25, "", "mini", -1, 0xFFFFFF);
            mTextField.x = 2;
            mTextField.hAlign = "left";
            mTextField.vAlign = "top";
            addChild(mBackground);
            addChild(mTextField);
            blendMode = "none";
            addEventListener("addedToStage", onAddedToStage);
            addEventListener("removedFromStage", onRemovedFromStage);
        }

        private function onAddedToStage():void
        {
            addEventListener("enterFrame", onEnterFrame);
            mTotalTime = (mFrameCount = 0);
            update();
        }

        private function onRemovedFromStage():void
        {
            removeEventListener("enterFrame", onEnterFrame);
        }

        private function onEnterFrame(_arg_1:EnterFrameEvent):void
        {
            mTotalTime = (mTotalTime + _arg_1.passedTime);
            mFrameCount++;
            if (mTotalTime > 0.5)
            {
                update();
                mFrameCount = (mTotalTime = 0);
            };
        }

        public function update():void
        {
            mFps = ((mTotalTime > 0) ? (mFrameCount / mTotalTime) : 0);
            mMemory = (System.totalMemory * 9.54E-7);
            mTextField.text = ((((("FPS: " + mFps.toFixed(((mFps < 100) ? 1 : 0))) + "\nMEM: ") + mMemory.toFixed(((mMemory < 100) ? 1 : 0))) + "\nDRW: ") + ((mTotalTime > 0) ? (mDrawCount - 2) : mDrawCount));
        }

        override public function render(_arg_1:RenderSupport, _arg_2:Number):void
        {
            _arg_1.finishQuadBatch();
            super.render(_arg_1, _arg_2);
        }

        public function get drawCount():int
        {
            return (mDrawCount);
        }

        public function set drawCount(_arg_1:int):void
        {
            mDrawCount = _arg_1;
        }

        public function get fps():Number
        {
            return (mFps);
        }

        public function set fps(_arg_1:Number):void
        {
            mFps = _arg_1;
        }

        public function get memory():Number
        {
            return (mMemory);
        }

        public function set memory(_arg_1:Number):void
        {
            mMemory = _arg_1;
        }


    }
}//package starling.core

