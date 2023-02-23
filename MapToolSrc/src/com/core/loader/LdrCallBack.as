// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.LdrCallBack

package com.core.loader
{
    import core.utils.ObjectPoolList;

    public class LdrCallBack 
    {

        public static var ObjectPool:ObjectPoolList;

        private var _method:Function;
        private var _params:Array;
        private var _url:String;


        public static function NEW():LdrCallBack
        {
            if (!ObjectPool)
            {
                ObjectPool = new ObjectPoolList(LdrCallBack);
            };
            return (ObjectPool.Alloc(LdrCallBack) as LdrCallBack);
        }

        public static function FREE(_arg_1:LdrCallBack):void
        {
            _arg_1.dispose();
            ObjectPool.Release(_arg_1);
        }


        public function setVals(_arg_1:String, _arg_2:Function, _arg_3:Array):void
        {
            _url = _arg_1;
            _method = _arg_2;
            _params = _arg_3;
        }

        public function execute():void
        {
            if (_params)
            {
                _params.unshift(_url);
                if (_method != null)
                {
                    _method.apply(null, _params);
                };
            }
            else
            {
                if (_method != null)
                {
                    (_method(_url));
                };
            };
        }

        public function equal(_arg_1:Function):Boolean
        {
            return (_method == _arg_1);
        }

        public function dispose():void
        {
            if (_params)
            {
                _params.length = 0;
            };
            _params = null;
            _method = null;
            _url = null;
        }


    }
}//package com.core.loader

