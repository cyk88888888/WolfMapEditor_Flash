// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.URLLoaderExt

package com.core.loader
{
    import flash.net.URLLoader;
    import core.utils.ObjectPoolList;
    import flash.net.URLRequest;
    import flash.utils.getTimer;

    public class URLLoaderExt extends URLLoader 
    {

        public static var ObjectPool:ObjectPoolList;

        private var urlRequset:URLRequest;


        public static function NEW():URLLoaderExt
        {
            if (!ObjectPool)
            {
                ObjectPool = new ObjectPoolList(URLLoaderExt);
            };
            return (ObjectPool.Alloc(URLLoaderExt));
        }

        public static function FREE(_arg_1:URLLoaderExt):void
        {
            ObjectPool.Release(_arg_1);
        }


        public function loadUrl(_arg_1:String):void
        {
            if (!urlRequset)
            {
                urlRequset = new URLRequest();
            };
            urlRequset.url = _arg_1;
            ((trace_load) && (traceInlLDR(((("Loading :" + _arg_1) + " t:") + getTimer()))));
            this.dataFormat = "binary";
            load(urlRequset);
        }


    }
}//package com.core.loader

