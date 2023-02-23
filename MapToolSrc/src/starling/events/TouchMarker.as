// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.events.TouchMarker

package starling.events
{
    import starling.display.Sprite;
    import flash.geom.Point;
    import starling.textures.Texture;
    import starling.display.Image;
    import starling.core.Starling;
    import flash.display.Shape;
    import flash.display.BitmapData;

    internal class TouchMarker extends Sprite 
    {

        private var mCenter:Point;
        private var mTexture:Texture;

        public function TouchMarker()
        {
            var _local_2:int;
            var _local_1:* = null;
            super();
            mCenter = new Point();
            mTexture = createTexture();
            _local_2 = 0;
            while (_local_2 < 2)
            {
                _local_1 = new Image(mTexture);
                _local_1.pivotX = (mTexture.width / 2);
                _local_1.pivotY = (mTexture.height / 2);
                _local_1.touchable = false;
                addChild(_local_1);
                _local_2++;
            };
        }

        override public function dispose():void
        {
            mTexture.dispose();
            super.dispose();
        }

        public function moveMarker(_arg_1:Number, _arg_2:Number, _arg_3:Boolean=false):void
        {
            if (_arg_3)
            {
                mCenter.x = (mCenter.x + (_arg_1 - realMarker.x));
                mCenter.y = (mCenter.y + (_arg_2 - realMarker.y));
            };
            realMarker.x = _arg_1;
            realMarker.y = _arg_2;
            mockMarker.x = ((2 * mCenter.x) - _arg_1);
            mockMarker.y = ((2 * mCenter.y) - _arg_2);
        }

        public function moveCenter(_arg_1:Number, _arg_2:Number):void
        {
            mCenter.x = _arg_1;
            mCenter.y = _arg_2;
            moveMarker(realX, realY);
        }

        private function createTexture():Texture
        {
            var _local_2:Number = Starling.contentScaleFactor;
            var _local_6:Number = (12 * _local_2);
            var _local_4:int = (32 * _local_2);
            var _local_3:int = (32 * _local_2);
            var _local_5:Number = (1.5 * _local_2);
            var _local_7:Shape = new Shape();
            _local_7.graphics.lineStyle(_local_5, 0, 0.3);
            _local_7.graphics.drawCircle((_local_4 / 2), (_local_3 / 2), (_local_6 + _local_5));
            _local_7.graphics.beginFill(0xFFFFFF, 0.4);
            _local_7.graphics.lineStyle(_local_5, 0xFFFFFF);
            _local_7.graphics.drawCircle((_local_4 / 2), (_local_3 / 2), _local_6);
            _local_7.graphics.endFill();
            var _local_1:BitmapData = new BitmapData(_local_4, _local_3, true, 0);
            _local_1.draw(_local_7);
            return (Texture.fromBitmapData(_local_1, false, false, _local_2));
        }

        private function get realMarker():Image
        {
            return (getChildAt(0) as Image);
        }

        private function get mockMarker():Image
        {
            return (getChildAt(1) as Image);
        }

        public function get realX():Number
        {
            return (realMarker.x);
        }

        public function get realY():Number
        {
            return (realMarker.y);
        }

        public function get mockX():Number
        {
            return (mockMarker.x);
        }

        public function get mockY():Number
        {
            return (mockMarker.y);
        }


    }
}//package starling.events

