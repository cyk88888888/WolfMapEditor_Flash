// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.textures.TextureAtlas

package starling.textures
{
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import flash.geom.Rectangle;
    import starling.utils.cleanMasterString;

    public class TextureAtlas 
    {

        private static var sNames:Vector.<String> = new Vector.<String>(0);

        protected var mAtlasTexture:Texture;
        private var mSubTextures:Dictionary;
        private var mSubTextureNames:Vector.<String>;

        public function TextureAtlas(_arg_1:Texture, _arg_2:XML=null)
        {
            mSubTextures = new Dictionary();
            mAtlasTexture = _arg_1;
            if (_arg_2)
            {
                parseAtlasXml(_arg_2);
            };
        }

        private static function parseBool(_arg_1:String):Boolean
        {
            return (_arg_1.toLowerCase() == "true");
        }


        public function dispose():void
        {
            mAtlasTexture.dispose();
        }

        protected function parseAtlasXml(_arg_1:XML):void
        {
            var _local_7:* = null;
            var _local_15:Number;
            var _local_11:Number;
            var _local_4:Number;
            var _local_6:Number;
            var _local_9:Number;
            var _local_10:Number;
            var _local_8:Number;
            var _local_13:Number;
            var _local_12:Boolean;
            var _local_3:Number = mAtlasTexture.scale;
            var _local_2:Rectangle = new Rectangle();
            var _local_5:Rectangle = new Rectangle();
            for each (var _local_14:XML in _arg_1.SubTexture)
            {
                _local_7 = cleanMasterString(_local_14.@name);
                _local_15 = (parseFloat(_local_14.@x) / _local_3);
                _local_11 = (parseFloat(_local_14.@y) / _local_3);
                _local_4 = (parseFloat(_local_14.@width) / _local_3);
                _local_6 = (parseFloat(_local_14.@height) / _local_3);
                _local_9 = (parseFloat(_local_14.@frameX) / _local_3);
                _local_10 = (parseFloat(_local_14.@frameY) / _local_3);
                _local_8 = (parseFloat(_local_14.@frameWidth) / _local_3);
                _local_13 = (parseFloat(_local_14.@frameHeight) / _local_3);
                _local_12 = parseBool(_local_14.@rotated);
                _local_2.setTo(_local_15, _local_11, _local_4, _local_6);
                _local_5.setTo(_local_9, _local_10, _local_8, _local_13);
                if (((_local_8 > 0) && (_local_13 > 0)))
                {
                    addRegion(_local_7, _local_2, _local_5, _local_12);
                }
                else
                {
                    addRegion(_local_7, _local_2, null, _local_12);
                };
            };
        }

        public function getTexture(_arg_1:String):Texture
        {
            return (mSubTextures[_arg_1]);
        }

        public function getTextures(_arg_1:String="", _arg_2:Vector.<Texture>=null):Vector.<Texture>
        {
            if (_arg_2 == null)
            {
                _arg_2 = new Vector.<Texture>(0);
            };
            for each (var _local_3:String in getNames(_arg_1, sNames))
            {
                _arg_2[_arg_2.length] = getTexture(_local_3);
            };
            sNames.length = 0;
            return (_arg_2);
        }

        public function getNames(_arg_1:String="", _arg_2:Vector.<String>=null):Vector.<String>
        {
            var _local_3:* = null;
            if (_arg_2 == null)
            {
                _arg_2 = new Vector.<String>(0);
            };
            if (mSubTextureNames == null)
            {
                mSubTextureNames = new Vector.<String>(0);
                for (_local_3 in mSubTextures)
                {
                    mSubTextureNames[mSubTextureNames.length] = _local_3;
                };
                mSubTextureNames.sort(1);
            };
            for each (_local_3 in mSubTextureNames)
            {
                if (_local_3.indexOf(_arg_1) == 0)
                {
                    _arg_2[_arg_2.length] = _local_3;
                };
            };
            return (_arg_2);
        }

        public function getRegion(_arg_1:String):Rectangle
        {
            var _local_2:SubTexture = mSubTextures[_arg_1];
            return ((_local_2) ? _local_2.region : null);
        }

        public function getFrame(_arg_1:String):Rectangle
        {
            var _local_2:SubTexture = mSubTextures[_arg_1];
            return ((_local_2) ? _local_2.frame : null);
        }

        public function getRotation(_arg_1:String):Boolean
        {
            var _local_2:SubTexture = mSubTextures[_arg_1];
            return ((_local_2) ? _local_2.rotated : false);
        }

        public function addRegion(_arg_1:String, _arg_2:Rectangle, _arg_3:Rectangle=null, _arg_4:Boolean=false):void
        {
            mSubTextures[_arg_1] = new SubTexture(mAtlasTexture, _arg_2, false, _arg_3, _arg_4);
            mSubTextureNames = null;
        }

        public function removeRegion(_arg_1:String):void
        {
            var _local_2:SubTexture = mSubTextures[_arg_1];
            if (_local_2)
            {
                _local_2.dispose();
            };
            delete mSubTextures[_arg_1];
            mSubTextureNames = null;
        }

        public function get texture():Texture
        {
            return (mAtlasTexture);
        }


    }
}//package starling.textures

