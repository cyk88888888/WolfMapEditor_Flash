// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.textures.TextureOptions

package starling.textures
{
    import starling.core.Starling;

    public class TextureOptions 
    {

        private var mScale:Number;
        private var mFormat:String;
        private var mMipMapping:Boolean;
        private var mOptimizeForRenderToTexture:Boolean = false;
        private var mOnReady:Function = null;
        private var mRepeat:Boolean = false;

        public function TextureOptions(_arg_1:Number=1, _arg_2:Boolean=false, _arg_3:String="bgra", _arg_4:Boolean=false)
        {
            mScale = _arg_1;
            mFormat = _arg_3;
            mMipMapping = _arg_2;
            mRepeat = _arg_4;
        }

        public function clone():TextureOptions
        {
            var _local_1:TextureOptions = new TextureOptions(mScale, mMipMapping, mFormat, mRepeat);
            _local_1.mOptimizeForRenderToTexture = mOptimizeForRenderToTexture;
            _local_1.mOnReady = mOnReady;
            return (_local_1);
        }

        public function get scale():Number
        {
            return (mScale);
        }

        public function set scale(_arg_1:Number):void
        {
            mScale = ((_arg_1 > 0) ? _arg_1 : Starling.contentScaleFactor);
        }

        public function get format():String
        {
            return (mFormat);
        }

        public function set format(_arg_1:String):void
        {
            mFormat = _arg_1;
        }

        public function get mipMapping():Boolean
        {
            return (mMipMapping);
        }

        public function set mipMapping(_arg_1:Boolean):void
        {
            mMipMapping = _arg_1;
        }

        public function get optimizeForRenderToTexture():Boolean
        {
            return (mOptimizeForRenderToTexture);
        }

        public function set optimizeForRenderToTexture(_arg_1:Boolean):void
        {
            mOptimizeForRenderToTexture = _arg_1;
        }

        public function get repeat():Boolean
        {
            return (mRepeat);
        }

        public function set repeat(_arg_1:Boolean):void
        {
            mRepeat = _arg_1;
        }

        public function get onReady():Function
        {
            return (mOnReady);
        }

        public function set onReady(_arg_1:Function):void
        {
            mOnReady = _arg_1;
        }


    }
}//package starling.textures

