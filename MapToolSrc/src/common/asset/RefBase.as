// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//common.asset.RefBase

package common.asset
{
    import com.core.IRefDispose;
    import flash.utils.getTimer;
    import core.utils.DbgUtil;

    public class RefBase implements IRefDispose 
    {

        private var _refCount:int = 0;
        public var lastRefTime:int = -1;
        public var deRefTime:int = -1;
        protected var _asset:*;

        public function RefBase(_arg_1:*)
        {
            this._asset = _arg_1;
        }

        public function dispose():void
        {
            _asset = null;
            lastRefTime = -1;
        }

        public function addRef():void
        {
            lastRefTime = getTimer();
            deRefTime = -1;
            _refCount++;
        }

        public function decRef():void
        {
            _refCount--;
            if (_refCount == 0)
            {
                deRefTime = getTimer();
            };
            DbgUtil.assert(((_refCount >= 0) || ("decRefError")));
        }

        public function getRefCount():int
        {
            return (_refCount);
        }


    }
}//package common.asset

