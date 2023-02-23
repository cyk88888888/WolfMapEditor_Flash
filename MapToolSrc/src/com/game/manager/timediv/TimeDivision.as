// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.game.manager.timediv.TimeDivision

package com.game.manager.timediv
{
    import __AS3__.vec.Vector;
    import flash.utils.getTimer;
    import com.common.util.ArrayUtils;
    import common.frame.GameTime;

    public class TimeDivision 
    {

        public static const MAX_FRAME_MS:uint = 3;

        public static var throttle:Boolean;
        public static var _instance:TimeDivision;

        private var _taskList:Vector.<ITask> = new Vector.<ITask>();


        public static function getInstance():TimeDivision
        {
            if (!_instance)
            {
                _instance = new (TimeDivision)();
            };
            return (_instance);
        }


        public function add(_arg_1:ITask):void
        {
            _taskList.push(_arg_1);
        }

        public function update(_arg_1:GameTime):void
        {
            var _local_2:* = null;
            var _local_3:int;
            while (_local_3 < _taskList.length)
            {
                if (!TimeDivision.throttle)
                {
                    if ((getTimer() - _arg_1.timer) > (_arg_1.avgUpdateTime() + 3))
                    {
                        return;
                    };
                };
                _local_2 = _taskList[_local_3];
                if (_local_2.step())
                {
                    ArrayUtils.removeAt(_taskList, _local_3);
                    _local_2.complete();
                }
                else
                {
                    _local_3++;
                };
            };
        }


    }
}//package com.game.manager.timediv

