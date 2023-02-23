// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.base.ObjectPool

package framework.base
{
    public class ObjectPool 
    {

        private var buffer:Array;
        private var createFunc:Function;
        private var releaseFunc:Function;
        private var capacity:int;

        public function ObjectPool(_arg_1:Function, _arg_2:Function, _arg_3:int=-1)
        {
            createFunc = _arg_1;
            releaseFunc = _arg_2;
            capacity = _arg_3;
            buffer = [];
        }

        public function get count():int
        {
            return (buffer.length);
        }

        public function getObject():Object
        {
            if (buffer.length == 0)
            {
                return (createFunc());
            };
            return (buffer.shift());
        }

        public function releaseObject(_arg_1:Object, _arg_2:Boolean=true):void
        {
            if (((_arg_2) && (releaseFunc)))
            {
                releaseFunc.call(this, _arg_1);
            };
            if (((!(capacity == -1)) && (count >= capacity)))
            {
                return;
            };
            buffer.push(_arg_1);
        }


    }
}//package framework.base

