// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.ResQueueType

package com.core.loader
{
    import flash.utils.Dictionary;

    public class ResQueueType 
    {

        public static const NORMAL:uint = 1;
        public static const SCENE:uint = 2;
        public static const MAIN:uint = 3;
        public static const UI:uint = 4;
        public static const SOUND:uint = 5;
        public static const MAP:uint = 6;
        public static const TypeList:Array = [3, 4, 1, 6, 2, 5];
        public static const totalLimit:int = 6;

        private static var _countLimit:Object;
        private static var queueTypeLoop:Array = null;
        private static var curIdx:uint = 0;


        public static function getCountLimit(_arg_1:uint):uint
        {
            if (_countLimit == null)
            {
                _countLimit = {};
                _countLimit[1] = 2;
                _countLimit[2] = 4;
                _countLimit[3] = 1;
                _countLimit[4] = 2;
                _countLimit[5] = 1;
                _countLimit[6] = 4;
            };
            return (_countLimit[_arg_1]);
        }

        public static function getQueueArrayDic():Dictionary
        {
            var _local_1:Dictionary = new Dictionary();
            _local_1[1] = [];
            _local_1[2] = [];
            _local_1[3] = [];
            _local_1[4] = [];
            _local_1[5] = [];
            _local_1[6] = [];
            return (_local_1);
        }

        public static function nextQueue():uint
        {
            var _local_5:* = null;
            var _local_6:int;
            var _local_2:uint;
            var _local_1:uint;
            var _local_4:int;
            if (queueTypeLoop == null)
            {
                _local_5 = [];
                _local_6 = 0;
                while (_local_6 < TypeList.length)
                {
                    _local_2 = TypeList[_local_6];
                    _local_1 = getCountLimit(_local_2);
                    _local_4 = 0;
                    while (_local_4 < _local_1)
                    {
                        _local_5.push(_local_2);
                        _local_4++;
                    };
                    _local_6++;
                };
                queueTypeLoop = _local_5;
            };
            var _local_3:uint = queueTypeLoop[(curIdx % queueTypeLoop.length)];
            curIdx++;
            return (_local_3);
        }


    }
}//package com.core.loader

