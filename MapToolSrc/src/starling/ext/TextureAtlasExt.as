// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.ext.TextureAtlasExt

package starling.ext
{
    import starling.textures.TextureAtlas;
    import __AS3__.vec.Vector;
    import starling.textures.Texture;
    import flash.geom.Rectangle;

    public class TextureAtlasExt extends TextureAtlas 
    {

        private var _subTextureNames:Vector.<String>;

        public function TextureAtlasExt(_arg_1:Texture, _arg_2:XML=null)
        {
            super(_arg_1, _arg_2);
            _subTextureNames = new Vector.<String>();
        }

        override public function getNames(_arg_1:String="", _arg_2:Vector.<String>=null):Vector.<String>
        {
            return (_subTextureNames);
        }

        override public function addRegion(_arg_1:String, _arg_2:Rectangle, _arg_3:Rectangle=null, _arg_4:Boolean=false):void
        {
            super.addRegion(_arg_1, _arg_2, _arg_3, _arg_4);
            _subTextureNames.push(_arg_1);
        }

        override public function removeRegion(_arg_1:String):void
        {
            throw (new Error("不能删除"));
        }

        public function getTexturesByPrefix(_arg_1:Vector.<Texture>=null):Vector.<Texture>
        {
            var _local_4:int;
            var _local_2:* = null;
            var _local_3:* = null;
            if (_arg_1 == null)
            {
                _arg_1 = new Vector.<Texture>(0);
            };
            _local_4 = 0;
            while (_local_4 < _subTextureNames.length)
            {
                _local_2 = _subTextureNames[_local_4];
                _local_3 = getTexture(_local_2);
                _arg_1[_arg_1.length] = _local_3;
                _local_4++;
            };
            return (_arg_1);
        }

        public function set atlasTexture(_arg_1:Texture):void
        {
            mAtlasTexture = _arg_1;
        }


    }
}//package starling.ext

