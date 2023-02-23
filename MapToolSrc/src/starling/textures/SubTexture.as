// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.textures.SubTexture

package starling.textures
{
    import flash.geom.Point;
    import flash.geom.Matrix;
    import flash.geom.Rectangle;
    import starling.utils.VertexData;
    import starling.utils.MatrixUtil;
    import __AS3__.vec.Vector;
    import starling.utils.RectangleUtil;
    import flash.display3D.textures.TextureBase;

    public class SubTexture extends Texture 
    {

        private static var sTexCoords:Point = new Point();
        private static var sMatrix:Matrix = new Matrix();

        private var mParent:Texture;
        private var mOwnsParent:Boolean;
        private var mRegion:Rectangle;
        private var mFrame:Rectangle;
        private var mRotated:Boolean;
        private var mWidth:Number;
        private var mHeight:Number;
        private var mTransformationMatrix:Matrix;

        public function SubTexture(_arg_1:Texture, _arg_2:Rectangle=null, _arg_3:Boolean=false, _arg_4:Rectangle=null, _arg_5:Boolean=false)
        {
            mParent = _arg_1;
            mRegion = ((_arg_2) ? _arg_2.clone() : new Rectangle(0, 0, _arg_1.width, _arg_1.height));
            mFrame = ((_arg_4) ? _arg_4.clone() : null);
            mOwnsParent = _arg_3;
            mRotated = _arg_5;
            mWidth = ((_arg_5) ? mRegion.height : mRegion.width);
            mHeight = ((_arg_5) ? mRegion.width : mRegion.height);
            mTransformationMatrix = new Matrix();
            if (_arg_5)
            {
                mTransformationMatrix.translate(0, -1);
                mTransformationMatrix.rotate((3.14159265358979 / 2));
            };
            if (((mFrame) && ((((mFrame.x > 0) || (mFrame.y > 0)) || (mFrame.right < mWidth)) || (mFrame.bottom < mHeight))))
            {
                (trace("[Starling] Warning: frames inside the texture's region are unsupported."));
            };
            mTransformationMatrix.scale((mRegion.width / mParent.width), (mRegion.height / mParent.height));
            mTransformationMatrix.translate((mRegion.x / mParent.width), (mRegion.y / mParent.height));
        }

        override public function dispose():void
        {
            if (mOwnsParent)
            {
                mParent.dispose();
            };
            super.dispose();
        }

        override public function adjustVertexData(_arg_1:VertexData, _arg_2:int, _arg_3:int):void
        {
            var _local_6:Number;
            var _local_5:Number;
            var _local_4:int = ((_arg_2 * 8) + 6);
            var _local_7:int = 6;
            adjustTexCoords(_arg_1.rawData, _local_4, _local_7, _arg_3);
            if (mFrame)
            {
                if (_arg_3 != 4)
                {
                    throw (new ArgumentError("Textures with a frame can only be used on quads"));
                };
                _local_6 = ((mFrame.width + mFrame.x) - mWidth);
                _local_5 = ((mFrame.height + mFrame.y) - mHeight);
                _arg_1.translateVertex(_arg_2, -(mFrame.x), -(mFrame.y));
                _arg_1.translateVertex((_arg_2 + 1), -(_local_6), -(mFrame.y));
                _arg_1.translateVertex((_arg_2 + 2), -(mFrame.x), -(_local_5));
                _arg_1.translateVertex((_arg_2 + 3), -(_local_6), -(_local_5));
            };
        }

        override public function adjustTexCoords(_arg_1:Vector.<Number>, _arg_2:int=0, _arg_3:int=0, _arg_4:int=-1):void
        {
            var _local_5:Number;
            var _local_6:Number;
            var _local_9:int;
            if (_arg_4 < 0)
            {
                _arg_4 = int(((((_arg_1.length - _arg_2) - 2) / (_arg_3 + 2)) + 1));
            };
            var _local_8:int = (_arg_2 + (_arg_4 * (2 + _arg_3)));
            var _local_7:* = this;
            sMatrix.identity();
            while (_local_7)
            {
                sMatrix.concat(_local_7.mTransformationMatrix);
                _local_7 = (_local_7.parent as SubTexture);
            };
            _local_9 = _arg_2;
            while (_local_9 < _local_8)
            {
                _local_6 = _arg_1[_local_9];
                _local_5 = _arg_1[(_local_9 + 1)];
                MatrixUtil.transformCoords(sMatrix, _local_6, _local_5, sTexCoords);
                _arg_1[_local_9] = sTexCoords.x;
                _arg_1[(_local_9 + 1)] = sTexCoords.y;
                _local_9 = (_local_9 + (2 + _arg_3));
            };
        }

        public function get parent():Texture
        {
            return (mParent);
        }

        public function get ownsParent():Boolean
        {
            return (mOwnsParent);
        }

        public function get rotated():Boolean
        {
            return (mRotated);
        }

        public function get region():Rectangle
        {
            return (mRegion);
        }

        public function get clipping():Rectangle
        {
            var _local_2:Point = new Point();
            var _local_1:Point = new Point();
            MatrixUtil.transformCoords(mTransformationMatrix, 0, 0, _local_2);
            MatrixUtil.transformCoords(mTransformationMatrix, 1, 1, _local_1);
            var _local_3:Rectangle = new Rectangle(_local_2.x, _local_2.y, (_local_1.x - _local_2.x), (_local_1.y - _local_2.y));
            RectangleUtil.normalize(_local_3);
            return (_local_3);
        }

        public function get transformationMatrix():Matrix
        {
            return (mTransformationMatrix);
        }

        override public function get base():TextureBase
        {
            return (mParent.base);
        }

        override public function get root():ConcreteTexture
        {
            return (mParent.root);
        }

        override public function get format():String
        {
            return (mParent.format);
        }

        override public function get width():Number
        {
            return (mWidth);
        }

        override public function get height():Number
        {
            return (mHeight);
        }

        override public function get nativeWidth():Number
        {
            return (mWidth * scale);
        }

        override public function get nativeHeight():Number
        {
            return (mHeight * scale);
        }

        override public function get mipMapping():Boolean
        {
            return (mParent.mipMapping);
        }

        override public function get premultipliedAlpha():Boolean
        {
            return (mParent.premultipliedAlpha);
        }

        override public function get scale():Number
        {
            return (mParent.scale);
        }

        override public function get repeat():Boolean
        {
            return (mParent.repeat);
        }

        override public function get frame():Rectangle
        {
            return (mFrame);
        }


    }
}//package starling.textures

