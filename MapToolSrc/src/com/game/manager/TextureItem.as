// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.game.manager.TextureItem

package com.game.manager
{
    import com.core.IRefDispose;
    import core.utils.ObjectPoolList;
    import starling.textures.ConcreteTexture;
    import __AS3__.vec.Vector;
    import com.common.util.ArrayUtils;
    import flash.utils.getTimer;
    import core.utils.DbgUtil;

    public class TextureItem implements IRefDispose 
    {

        public static var ObjectPool:ObjectPoolList;

        private var _tex:ConcreteTexture;
        public var url:String;
        public var state:uint = 0;
        public var hold:Boolean = false;
        public var lastRefTime:int;
        public var deRefTime:int = -1;
        public var cbksUpload:Vector.<Function> = new Vector.<Function>();
        public var cbksLoad:Vector.<Function> = new Vector.<Function>();
        public var cbksError:Vector.<Function> = new Vector.<Function>();


        public static function NEW():TextureItem
        {
            if (!ObjectPool)
            {
                ObjectPool = new ObjectPoolList(TextureItem);
            };
            return (ObjectPool.Alloc(TextureItem));
        }

        public static function FREE(_arg_1:TextureItem):void
        {
            _arg_1.dispose();
            ObjectPool.Release(_arg_1);
        }


        public function dispose():void
        {
            if (((trace_load) && (2 == state)))
            {
                traceInlLDR(("Texture is remove while Uploading:" + url));
            };
            if (_tex)
            {
                _tex.dispose();
                tex = null;
            };
            url = null;
            deRefTime = -1;
            state = 0;
            hold = false;
            lastRefTime = 0;
            clearCallBack();
        }

        private function addCallBack(_arg_1:Vector.<Function>, _arg_2:Function):void
        {
            if (_arg_2 == null)
            {
                return;
            };
            if (_arg_1.indexOf(_arg_2) == -1)
            {
                ArrayUtils_ePush(_arg_1, _arg_2);
            };
        }

        private function ArrayUtils_ePush(_arg_1:Vector.<Function>, _arg_2:Function):void
        {
            ArrayUtils.ePush(_arg_1, _arg_2);
        }

        private function ArrayUtils_eClear(_arg_1:Vector.<Function>):void
        {
            _arg_1.length = 0;
        }

        public function clearCallBack():void
        {
            ArrayUtils_eClear(this.cbksUpload);
            ArrayUtils_eClear(this.cbksLoad);
            ArrayUtils_eClear(this.cbksError);
        }

        public function addUploadCallBack(_arg_1:Function):void
        {
            addCallBack(this.cbksUpload, _arg_1);
        }

        public function removeUploadCallBack(_arg_1:Function):void
        {
            var _local_2:int = this.cbksUpload.indexOf(_arg_1);
            if (_local_2 != -1)
            {
                this.cbksUpload[_local_2] = null;
            };
        }

        public function addLoadedCallBack(_arg_1:Function):void
        {
            addCallBack(this.cbksLoad, _arg_1);
        }

        public function addErrorCallBack(_arg_1:Function):void
        {
            addCallBack(this.cbksError, _arg_1);
        }

        public function onLoaded():void
        {
            var _local_2:int;
            var _local_1:* = null;
            _local_2 = 0;
            while (_local_2 < this.cbksLoad.length)
            {
                _local_1 = this.cbksLoad[_local_2];
                if (_local_1 != null)
                {
                    (_local_1(url));
                };
                _local_2++;
            };
            ArrayUtils_eClear(this.cbksLoad);
        }

        public function onUploaded(_arg_1:String):void
        {
            var _local_3:int;
            var _local_2:* = null;
            _local_3 = 0;
            while (_local_3 < this.cbksUpload.length)
            {
                _local_2 = this.cbksUpload[_local_3];
                if (_local_2 != null)
                {
                    (_local_2(_arg_1, this));
                };
                _local_3++;
            };
            ArrayUtils_eClear(this.cbksUpload);
            ArrayUtils_eClear(this.cbksError);
        }

        public function onError():void
        {
            var _local_1:* = null;
            var _local_2:int = this.cbksError.length;
            while (--_local_2 > -1)
            {
                _local_1 = this.cbksError[_local_2];
                if (_local_1 != null)
                {
                    (_local_1(url));
                };
            };
            ArrayUtils_eClear(this.cbksError);
        }

        private function onRefChange(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                deRefTime = 0;
                lastRefTime = getTimer();
            }
            else
            {
                if (getRefCount() == 0)
                {
                    deRefTime = getTimer();
                    if (this._tex)
                    {
                        this._tex.freeVertex();
                    };
                };
            };
        }

        public function addRef():void
        {
        }

        public function decRef():void
        {
        }

        public function getRefCount():int
        {
            if (this._tex == null)
            {
                return (0);
            };
            return (this._tex.root.getRefCount());
        }

        public function setTextureVal(_arg_1:ConcreteTexture):void
        {
            DbgUtil.assert(((this.tex == null) || ("texture duplicate assignment " + this.url)));
            this.tex = _arg_1;
        }

        public function get tex():ConcreteTexture
        {
            return (_tex);
        }

        public function set tex(_arg_1:ConcreteTexture):void
        {
            if (_tex == _arg_1)
            {
                return;
            };
            if (_arg_1)
            {
                _arg_1.texItem = this;
                _arg_1.onRefChange = onRefChange;
            };
            if (_tex)
            {
                _tex.texItem = null;
                _tex.onRefChange = null;
            };
            _tex = _arg_1;
        }


    }
}//package com.game.manager

