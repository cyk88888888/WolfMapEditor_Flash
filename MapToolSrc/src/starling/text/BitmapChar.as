// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.text.BitmapChar

package starling.text
{
    import starling.textures.Texture;
    import flash.utils.Dictionary;
    import starling.display.Image;

    public class BitmapChar 
    {

        private var mTexture:Texture;
        private var mCharID:int;
        private var mXOffset:Number;
        private var mYOffset:Number;
        private var mXAdvance:Number;
        private var mKernings:Dictionary;

        public function BitmapChar(_arg_1:int, _arg_2:Texture, _arg_3:Number, _arg_4:Number, _arg_5:Number)
        {
            mCharID = _arg_1;
            mTexture = _arg_2;
            mXOffset = _arg_3;
            mYOffset = _arg_4;
            mXAdvance = _arg_5;
            mKernings = null;
        }

        public function addKerning(_arg_1:int, _arg_2:Number):void
        {
            if (mKernings == null)
            {
                mKernings = new Dictionary();
            };
            mKernings[_arg_1] = _arg_2;
        }

        public function getKerning(_arg_1:int):Number
        {
            if (((mKernings == null) || (mKernings[_arg_1] == undefined)))
            {
                return (0);
            };
            return (mKernings[_arg_1]);
        }

        public function createImage():Image
        {
            return (new Image(mTexture));
        }

        public function get charID():int
        {
            return (mCharID);
        }

        public function get xOffset():Number
        {
            return (mXOffset);
        }

        public function get yOffset():Number
        {
            return (mYOffset);
        }

        public function get xAdvance():Number
        {
            return (mXAdvance);
        }

        public function get texture():Texture
        {
            return (mTexture);
        }

        public function get width():Number
        {
            return (mTexture.width);
        }

        public function get height():Number
        {
            return (mTexture.height);
        }


    }
}//package starling.text

