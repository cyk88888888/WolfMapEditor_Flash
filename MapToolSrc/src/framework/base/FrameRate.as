// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.base.FrameRate

package framework.base
{
    import flash.display.Sprite;
    import flash.utils.Timer;
    import flash.text.TextField;
    import flash.text.TextFormat;
    import flash.filters.DropShadowFilter;
    import flash.events.TimerEvent;
    import flash.events.Event;

    public class FrameRate extends Sprite 
    {

        private var _timer:Timer;
        private var _text:TextField;
        private var _tf:TextFormat;
        private var _c:uint = 0;
        private var _dropShadow:DropShadowFilter;
        private var _graph:Sprite;
        private var _graphBox:Sprite;
        private var _graphCounter:uint;
        private var _showGraph:Boolean;
        private var _graphColor:uint;

        public function FrameRate(_arg_1:uint=0, _arg_2:Boolean=false, _arg_3:Boolean=true, _arg_4:uint=0xFF0000)
        {
            var _local_5:* = false;
            this.mouseChildren = _local_5;
            this.mouseEnabled = _local_5;
            _showGraph = _arg_3;
            _graphColor = _arg_4;
            if (_showGraph)
            {
                initGraph();
            };
            _dropShadow = new DropShadowFilter(1, 90, 0, 1, 2, 2);
            _tf = new TextFormat();
            _tf.color = _arg_1;
            _tf.font = "_sans";
            _tf.size = 11;
            _text = new TextField();
            _text.width = 100;
            _text.height = 20;
            _text.x = 3;
            if (_arg_2)
            {
                _text.filters = [_dropShadow];
            };
            addChild(_text);
            _timer = new Timer(500);
            _timer.addEventListener("timer", onTimer);
            _timer.start();
            addEventListener("enterFrame", onFrame);
        }

        protected function onTimer(_arg_1:TimerEvent):void
        {
            var _local_2:Number = computeTime();
            _text.text = (Math.floor(_local_2).toString() + " fps");
            _text.setTextFormat(_tf);
            _text.autoSize = "left";
            if (_showGraph)
            {
                updateGraph(_local_2);
            };
        }

        protected function onFrame(_arg_1:Event):void
        {
            _c++;
        }

        private function computeTime():Number
        {
            var _local_1:uint = _c;
            _c = 0;
            return ((_local_1 * 2) - 1);
        }

        public function updateGraph(_arg_1:Number):void
        {
            if (_graphCounter > 30)
            {
                _graph.x--;
            };
            _graphCounter++;
            _graph.graphics.lineTo(_graphCounter, (1 + ((stage.frameRate - _arg_1) / 2)));
        }

        private function initGraph():void
        {
            _graphCounter = 0;
            _graph = new Sprite();
            _graphBox = new Sprite();
            _graphBox.graphics.beginFill(0xFF0000);
            _graphBox.graphics.drawRect(0, 0, 36, 100);
            _graphBox.graphics.endFill();
            _graph.mask = _graphBox;
            var _local_1:* = 5;
            _graphBox.x = _local_1;
            _graph.x = _local_1;
            _local_1 = 20;
            _graphBox.y = _local_1;
            _graph.y = _local_1;
            _graph.graphics.lineStyle(1, _graphColor);
            addChild(_graph);
            addChild(_graphBox);
        }


    }
}//package framework.base

