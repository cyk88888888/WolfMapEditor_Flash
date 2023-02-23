// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//common.frame.GameTime

package common.frame
{
    import flash.utils.getTimer;

    public class GameTime 
    {

        public var elapseTime:int;
        public var elapseSec:Number;
        private var _gameTime:int;
        private var _startTime:int = getTimer();
        public var timer:int = getTimer();
        private var lastUpdateCostTime:Array = [0, 0, 0, 0, 0];
        private var _avgTime:uint = 0;
        private var invalidAvgTime:Boolean = true;


        public function update(_arg_1:int):void
        {
            this._gameTime = (_arg_1 - _startTime);
            this.elapseTime = (_arg_1 - timer);
            this.elapseSec = (this.elapseTime / 1000);
            timer = _arg_1;
        }

        public function get gameTime():int
        {
            return (_gameTime);
        }

        public function avgUpdateTime():uint
        {
            var _local_1:uint;
            var _local_2:int;
            if (invalidAvgTime)
            {
                _local_1 = 0;
                _local_2 = 0;
                while (_local_2 < lastUpdateCostTime.length)
                {
                    _local_1 = lastUpdateCostTime[_local_2];
                    _local_2++;
                };
                _avgTime = (_local_1 / lastUpdateCostTime.length);
                invalidAvgTime = false;
            };
            return (_avgTime);
        }

        public function pushUpdateTime(_arg_1:int):void
        {
            lastUpdateCostTime.shift();
            lastUpdateCostTime.push(_arg_1);
            invalidAvgTime = true;
        }


    }
}//package common.frame

