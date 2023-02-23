// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.display.Image

package starling.display
{
    import starling.textures.Texture;
    import starling.utils.VertexData;
    import flash.display.Bitmap;
    import flash.geom.Rectangle;
    import flash.geom.Point;
    import flash.geom.Matrix;
    import starling.textures.TextureSmoothing;
    import starling.core.RenderSupport;

    public class Image extends Quad 
    {

        private var mTexture:Texture;
        private var mSmoothing:String;
        private var mVertexDataCache:VertexData;
        private var mVertexDataCacheInvalid:Boolean;

        public function Image(_arg_1:Texture)
        {
            var _local_4:Number;
            var _local_3:Number;
            var _local_2:* = null;
            var _local_5:Boolean;
            if (_arg_1)
            {
                _local_2 = _arg_1.frame;
                _local_4 = ((_local_2) ? _local_2.width : _arg_1.width);
                _local_3 = ((_local_2) ? _local_2.height : _arg_1.height);
                _local_5 = _arg_1.premultipliedAlpha;
                mTexture = _arg_1;
            };
            super(_local_4, _local_3, 0xFFFFFF, _local_5);
            mVertexData.setTexCoords(0, 0, 0);
            mVertexData.setTexCoords(1, 1, 0);
            mVertexData.setTexCoords(2, 0, 1);
            mVertexData.setTexCoords(3, 1, 1);
            mSmoothing = "bilinear";
            mVertexDataCache = new VertexData(4, _local_5);
            mVertexDataCacheInvalid = true;
        }

        public static function fromBitmap(_arg_1:Bitmap, _arg_2:Boolean=true, _arg_3:Number=1):Image
        {
            return (new Image(Texture.fromBitmap(_arg_1, _arg_2, false, _arg_3)));
        }


        override protected function onVertexDataChanged():void
        {
            mVertexDataCacheInvalid = true;
        }

        public function readjustSize():void
        {
            var _local_2:Rectangle = texture.frame;
            var _local_3:Number = ((_local_2) ? _local_2.width : texture.width);
            var _local_1:Number = ((_local_2) ? _local_2.height : texture.height);
            if (((_local_3 == _local_3) && (_local_1 == _local_1)))
            {
                adjustSize(_local_3, _local_1);
            };
            onVertexDataChanged();
        }

        public function setTexCoords(_arg_1:int, _arg_2:Point):void
        {
            mVertexData.setTexCoords(_arg_1, _arg_2.x, _arg_2.y);
            onVertexDataChanged();
        }

        public function setTexCoordsTo(_arg_1:int, _arg_2:Number, _arg_3:Number):void
        {
            mVertexData.setTexCoords(_arg_1, _arg_2, _arg_3);
            onVertexDataChanged();
        }

        public function getTexCoords(_arg_1:int, _arg_2:Point=null):Point
        {
            if (_arg_2 == null)
            {
                _arg_2 = new Point();
            };
            mVertexData.getTexCoords(_arg_1, _arg_2);
            return (_arg_2);
        }

        override public function copyVertexDataTo(_arg_1:VertexData, _arg_2:int=0):void
        {
            copyVertexDataTransformedTo(_arg_1, _arg_2, null);
        }

        override public function copyVertexDataTransformedTo(_arg_1:VertexData, _arg_2:int=0, _arg_3:Matrix=null):void
        {
            if (mVertexDataCacheInvalid)
            {
                mVertexDataCacheInvalid = false;
                mVertexData.copyTo(mVertexDataCache);
                mTexture.adjustVertexData(mVertexDataCache, 0, 4);
            };
            mVertexDataCache.copyTransformedTo(_arg_1, _arg_2, _arg_3, 0, 4);
        }

        public function get texture():Texture
        {
            return (mTexture);
        }

        public function set texture(_arg_1:Texture):void
        {
            var _local_2:Boolean;
            if (_arg_1 == null)
            {
                this.mTexture = null;
            }
            else
            {
                if (_arg_1 != mTexture)
                {
                    _local_2 = (mTexture == null);
                    mTexture = _arg_1;
                    mVertexData.setPremultipliedAlpha(mTexture.premultipliedAlpha);
                    mVertexDataCache.setPremultipliedAlpha(mTexture.premultipliedAlpha, false);
                    if (_local_2)
                    {
                        this.readjustSize();
                    };
                    onVertexDataChanged();
                };
            };
        }

        override public function get hasVisibleArea():Boolean
        {
            return ((!(mTexture == null)) && (super.hasVisibleArea));
        }

        public function get smoothing():String
        {
            return (mSmoothing);
        }

        public function set smoothing(_arg_1:String):void
        {
            if (TextureSmoothing.isValid(_arg_1))
            {
                mSmoothing = _arg_1;
            }
            else
            {
                throw (new ArgumentError(("Invalid smoothing mode: " + _arg_1)));
            };
        }

        override public function render(_arg_1:RenderSupport, _arg_2:Number):void
        {
            _arg_1.batchQuad(this, _arg_2, mTexture, mSmoothing);
        }


    }
}//package starling.display

