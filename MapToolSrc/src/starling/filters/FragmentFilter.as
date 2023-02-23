// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.filters.FragmentFilter

package starling.filters
{
    import flash.geom.Rectangle;
    import flash.geom.Matrix;
    import __AS3__.vec.Vector;
    import starling.textures.Texture;
    import starling.utils.VertexData;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import starling.display.QuadBatch;
    import flash.geom.Matrix3D;
    import flash.utils.getQualifiedClassName;
    import flash.system.Capabilities;
    import starling.errors.AbstractClassError;
    import starling.core.Starling;
    import starling.display.DisplayObject;
    import starling.core.RenderSupport;
    import flash.display3D.Context3D;
    import starling.display.Stage;
    import starling.errors.MissingContextError;
    import starling.utils.SystemUtil;
    import flash.errors.IllegalOperationError;
    import starling.display.Image;
    import starling.utils.MatrixUtil;
    import starling.utils.RectangleUtil;
    import starling.utils.getNextPowerOfTwo;
    import flash.display3D.Program3D;
    import starling.core.starling_internal;

    use namespace starling_internal;

    public class FragmentFilter 
    {

        private static var sStageBounds:Rectangle = new Rectangle();
        private static var sTransformationMatrix:Matrix = new Matrix();

        private const MIN_TEXTURE_SIZE:int = 64;
        protected const PMA:Boolean = true;
        protected const STD_VERTEX_SHADER:String = "m44 op, va0, vc0 \nmov v0, va1      \n";
        protected const STD_FRAGMENT_SHADER:String = "tex oc, v0, fs0 <2d, clamp, linear, mipnone>";

        private var mVertexPosAtID:int = 0;
        private var mTexCoordsAtID:int = 1;
        private var mBaseTextureID:int = 0;
        private var mMvpConstantID:int = 0;
        private var mNumPasses:int;
        private var mPassTextures:Vector.<Texture>;
        private var mMode:String;
        private var mResolution:Number;
        private var mMarginX:Number;
        private var mMarginY:Number;
        private var mOffsetX:Number;
        private var mOffsetY:Number;
        private var mVertexData:VertexData;
        private var mVertexBuffer:VertexBuffer3D;
        private var mIndexData:Vector.<uint>;
        private var mIndexBuffer:IndexBuffer3D;
        private var mCacheRequested:Boolean;
        private var mCache:QuadBatch;
        private var mHelperMatrix:Matrix = new Matrix();
        private var mHelperMatrix3D:Matrix3D = new Matrix3D();
        private var mHelperRect:Rectangle = new Rectangle();
        private var mHelperRect2:Rectangle = new Rectangle();

        public function FragmentFilter(_arg_1:int=1, _arg_2:Number=1)
        {
            if (((Capabilities.isDebugger) && (getQualifiedClassName(this) == "starling.filters::FragmentFilter")))
            {
                throw (new AbstractClassError());
            };
            if (_arg_1 < 1)
            {
                throw (new ArgumentError("At least one pass is required."));
            };
            mNumPasses = _arg_1;
            mMarginX = (mMarginY = 0);
            mOffsetX = (mOffsetY = 0);
            mResolution = _arg_2;
            mPassTextures = new Vector.<Texture>(0);
            mMode = "replace";
            mVertexData = new VertexData(4);
            mVertexData.setTexCoords(0, 0, 0);
            mVertexData.setTexCoords(1, 1, 0);
            mVertexData.setTexCoords(2, 0, 1);
            mVertexData.setTexCoords(3, 1, 1);
            mIndexData = new <uint>[0, 1, 2, 1, 3, 2];
            mIndexData.fixed = true;
            if (Starling.current.contextValid)
            {
                createPrograms();
            };
            Starling.current.stage3D.addEventListener("context3DCreate", onContextCreated, false, 0, true);
        }

        public function dispose():void
        {
            Starling.current.stage3D.removeEventListener("context3DCreate", onContextCreated);
            if (mVertexBuffer)
            {
                mVertexBuffer.dispose();
            };
            if (mIndexBuffer)
            {
                mIndexBuffer.dispose();
            };
            disposePassTextures();
            disposeCache();
        }

        private function onContextCreated(_arg_1:Object):void
        {
            mVertexBuffer = null;
            mIndexBuffer = null;
            disposePassTextures();
            createPrograms();
            if (mCache)
            {
                cache();
            };
        }

        public function render(_arg_1:DisplayObject, _arg_2:RenderSupport, _arg_3:Number):void
        {
            if (mode == "above")
            {
                _arg_1.render(_arg_2, _arg_3);
            };
            if (mCacheRequested)
            {
                mCacheRequested = false;
                mCache = renderPasses(_arg_1, _arg_2, 1, true);
                disposePassTextures();
            };
            if (mCache)
            {
                mCache.render(_arg_2, _arg_3);
            }
            else
            {
                renderPasses(_arg_1, _arg_2, _arg_3, false);
            };
            if (mode == "below")
            {
                _arg_1.render(_arg_2, _arg_3);
            };
        }

        private function renderPasses(_arg_1:DisplayObject, _arg_2:RenderSupport, _arg_3:Number, _arg_4:Boolean=false):QuadBatch
        {
            var _local_8:* = null;
            var _local_18:uint;
            var _local_16:* = null;
            var _local_19:Boolean;
            var _local_11:int;
            var _local_6:* = null;
            var _local_7:* = null;
            var _local_12:Texture;
            var _local_20:Context3D = Starling.context;
            var _local_15:DisplayObject = _arg_1.stage;
            var _local_10:Stage = Starling.current.stage;
            var _local_5:Number = Starling.current.contentScaleFactor;
            var _local_17:Matrix = mHelperMatrix;
            var _local_9:Matrix3D = mHelperMatrix3D;
            var _local_13:Rectangle = mHelperRect;
            var _local_14:Rectangle = mHelperRect2;
            if (_local_20 == null)
            {
                throw (new MissingContextError());
            };
            _local_19 = (((!(_arg_4)) && (mOffsetX == 0)) && (mOffsetY == 0));
            calculateBounds(_arg_1, _local_15, (mResolution * _local_5), _local_19, _local_13, _local_14);
            if (_local_13.isEmpty())
            {
                disposePassTextures();
                return ((_arg_4) ? new QuadBatch() : null);
            };
            updateBuffers(_local_20, _local_14);
            updatePassTextures(_local_14.width, _local_14.height, (mResolution * _local_5));
            _arg_2.finishQuadBatch();
            _arg_2.raiseDrawCount(mNumPasses);
            _arg_2.pushMatrix();
            _arg_2.pushMatrix3D();
            _arg_2.pushClipRect(_local_14, false);
            _local_17.copyFrom(_arg_2.projectionMatrix);
            _local_9.copyFrom(_arg_2.projectionMatrix3D);
            _local_16 = _arg_2.renderTarget;
            _local_18 = _arg_2.stencilReferenceValue;
            if (((_local_16) && (!(SystemUtil.supportsRelaxedTargetClearRequirement))))
            {
                throw (new IllegalOperationError("To nest filters, you need at least Flash Player / AIR version 15."));
            };
            if (_arg_4)
            {
                _local_12 = Texture.empty(_local_14.width, _local_14.height, true, false, true, (mResolution * _local_5));
            };
            _arg_2.renderTarget = mPassTextures[0];
            _arg_2.clear();
            _arg_2.blendMode = "normal";
            _arg_2.stencilReferenceValue = 0;
            _arg_2.setProjectionMatrix(_local_13.x, _local_13.y, _local_14.width, _local_14.height, _local_10.stageWidth, _local_10.stageHeight, _local_10.cameraPosition);
            _arg_1.render(_arg_2, _arg_3);
            _arg_2.finishQuadBatch();
            RenderSupport.setBlendFactors(true);
            _arg_2.loadIdentity();
            _local_20.setVertexBufferAt(mVertexPosAtID, mVertexBuffer, 0, "float2");
            _local_20.setVertexBufferAt(mTexCoordsAtID, mVertexBuffer, 6, "float2");
            _local_11 = 0;
            while (_local_11 < mNumPasses)
            {
                if (_local_11 < (mNumPasses - 1))
                {
                    _arg_2.renderTarget = getPassTexture((_local_11 + 1));
                    _arg_2.clear();
                }
                else
                {
                    if (_arg_4)
                    {
                        _arg_2.renderTarget = _local_12;
                        _arg_2.clear();
                    }
                    else
                    {
                        _arg_2.popClipRect();
                        _arg_2.projectionMatrix = _local_17;
                        _arg_2.projectionMatrix3D = _local_9;
                        _arg_2.renderTarget = _local_16;
                        _arg_2.translateMatrix(mOffsetX, mOffsetY);
                        _arg_2.stencilReferenceValue = _local_18;
                        _arg_2.blendMode = _arg_1.blendMode;
                        _arg_2.applyBlendMode(true);
                    };
                };
                _local_8 = getPassTexture(_local_11);
                _local_20.setProgramConstantsFromMatrix("vertex", mMvpConstantID, _arg_2.mvpMatrix3D, true);
                _local_20.setTextureAt(mBaseTextureID, _local_8.base);
                activate(_local_11, _local_20, _local_8);
                _local_20.drawTriangles(mIndexBuffer, 0, 2);
                deactivate(_local_11, _local_20, _local_8);
                _local_11++;
            };
            _local_20.setVertexBufferAt(mVertexPosAtID, null);
            _local_20.setVertexBufferAt(mTexCoordsAtID, null);
            _local_20.setTextureAt(mBaseTextureID, null);
            _arg_2.popMatrix();
            _arg_2.popMatrix3D();
            if (_arg_4)
            {
                _arg_2.projectionMatrix.copyFrom(_local_17);
                _arg_2.projectionMatrix3D.copyFrom(_local_9);
                _arg_2.renderTarget = _local_16;
                _arg_2.popClipRect();
                _local_6 = new QuadBatch();
                _local_7 = new Image(_local_12);
                _arg_1.getTransformationMatrix(_local_15, sTransformationMatrix).invert();
                MatrixUtil.prependTranslation(sTransformationMatrix, (_local_13.x + mOffsetX), (_local_13.y + mOffsetY));
                _local_6.addImage(_local_7, 1, sTransformationMatrix);
                _local_6.ownsTexture = true;
                return (_local_6);
            };
            return (null);
        }

        private function updateBuffers(_arg_1:Context3D, _arg_2:Rectangle):void
        {
            mVertexData.setPosition(0, _arg_2.x, _arg_2.y);
            mVertexData.setPosition(1, _arg_2.right, _arg_2.y);
            mVertexData.setPosition(2, _arg_2.x, _arg_2.bottom);
            mVertexData.setPosition(3, _arg_2.right, _arg_2.bottom);
            if (mVertexBuffer == null)
            {
                mVertexBuffer = _arg_1.createVertexBuffer(4, 8);
                mIndexBuffer = _arg_1.createIndexBuffer(6);
                mIndexBuffer.uploadFromVector(mIndexData, 0, 6);
            };
            mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, 4);
        }

        private function updatePassTextures(_arg_1:Number, _arg_2:Number, _arg_3:Number):void
        {
            var _local_6:int;
            var _local_4:int = ((mNumPasses > 1) ? 2 : 1);
            var _local_5:Boolean = (((!(mPassTextures.length == _local_4)) || (Math.abs((mPassTextures[0].nativeWidth - (_arg_1 * _arg_3))) > 0.1)) || (Math.abs((mPassTextures[0].nativeHeight - (_arg_2 * _arg_3))) > 0.1));
            if (_local_5)
            {
                disposePassTextures();
                _local_6 = 0;
                while (_local_6 < _local_4)
                {
                    mPassTextures[_local_6] = Texture.empty(_arg_1, _arg_2, true, false, true, _arg_3);
                    _local_6++;
                };
            };
        }

        private function getPassTexture(_arg_1:int):Texture
        {
            return (mPassTextures[(_arg_1 % 2)]);
        }

        private function calculateBounds(_arg_1:DisplayObject, _arg_2:DisplayObject, _arg_3:Number, _arg_4:Boolean, _arg_5:Rectangle, _arg_6:Rectangle):void
        {
            var _local_10:* = null;
            var _local_8:int;
            var _local_9:Number;
            var _local_7:Number;
            var _local_12:Number = mMarginX;
            var _local_11:Number = mMarginY;
            if ((_arg_2 is Stage))
            {
                _local_10 = (_arg_2 as Stage);
                if (((_arg_1 == _local_10) || (_arg_1 == _arg_1.root)))
                {
                    _local_11 = 0;
                    _local_12 = _local_11;
                    _arg_5.setTo(0, 0, _local_10.stageWidth, _local_10.stageHeight);
                }
                else
                {
                    _arg_1.getBounds(_local_10, _arg_5);
                };
                if (_arg_4)
                {
                    sStageBounds.setTo(0, 0, _local_10.stageWidth, _local_10.stageHeight);
                    RectangleUtil.intersect(_arg_5, sStageBounds, _arg_5);
                };
            }
            else
            {
                _arg_1.getBounds(_arg_2, _arg_5);
            };
            if (!_arg_5.isEmpty())
            {
                _arg_5.inflate(_local_12, _local_11);
                _local_8 = int((64 / _arg_3));
                _local_9 = ((_arg_5.width > _local_8) ? _arg_5.width : _local_8);
                _local_7 = ((_arg_5.height > _local_8) ? _arg_5.height : _local_8);
                _arg_6.setTo(_arg_5.x, _arg_5.y, (getNextPowerOfTwo((_local_9 * _arg_3)) / _arg_3), (getNextPowerOfTwo((_local_7 * _arg_3)) / _arg_3));
            };
        }

        private function disposePassTextures():void
        {
            for each (var _local_1:Texture in mPassTextures)
            {
                _local_1.dispose();
            };
            mPassTextures.length = 0;
        }

        private function disposeCache():void
        {
            if (mCache)
            {
                mCache.dispose();
                mCache = null;
            };
        }

        protected function createPrograms():void
        {
            throw (new Error("Method has to be implemented in subclass!"));
        }

        protected function activate(_arg_1:int, _arg_2:Context3D, _arg_3:Texture):void
        {
            throw (new Error("Method has to be implemented in subclass!"));
        }

        protected function deactivate(_arg_1:int, _arg_2:Context3D, _arg_3:Texture):void
        {
        }

        protected function assembleAgal(_arg_1:String=null, _arg_2:String=null):Program3D
        {
            if (_arg_1 == null)
            {
                _arg_1 = "tex oc, v0, fs0 <2d, clamp, linear, mipnone>";
            };
            if (_arg_2 == null)
            {
                _arg_2 = "m44 op, va0, vc0 \nmov v0, va1      \n";
            };
            return (RenderSupport.assembleAgal(_arg_2, _arg_1));
        }

        public function cache():void
        {
            mCacheRequested = true;
            disposeCache();
        }

        public function clearCache():void
        {
            mCacheRequested = false;
            disposeCache();
        }

        starling_internal function compile(_arg_1:DisplayObject):QuadBatch
        {
            var _local_2:* = null;
            var _local_3:* = null;
            var _local_4:Stage = _arg_1.stage;
            _local_2 = new RenderSupport();
            _arg_1.getTransformationMatrix(_local_4, _local_2.modelViewMatrix);
            _local_3 = renderPasses(_arg_1, _local_2, 1, true);
            _local_2.dispose();
            return (_local_3);
        }

        public function get isCached():Boolean
        {
            return ((!(mCache == null)) || (mCacheRequested));
        }

        public function get resolution():Number
        {
            return (mResolution);
        }

        public function set resolution(_arg_1:Number):void
        {
            if (_arg_1 <= 0)
            {
                throw (new ArgumentError("Resolution must be > 0"));
            };
            mResolution = _arg_1;
        }

        public function get mode():String
        {
            return (mMode);
        }

        public function set mode(_arg_1:String):void
        {
            mMode = _arg_1;
        }

        public function get offsetX():Number
        {
            return (mOffsetX);
        }

        public function set offsetX(_arg_1:Number):void
        {
            mOffsetX = _arg_1;
        }

        public function get offsetY():Number
        {
            return (mOffsetY);
        }

        public function set offsetY(_arg_1:Number):void
        {
            mOffsetY = _arg_1;
        }

        protected function get marginX():Number
        {
            return (mMarginX);
        }

        protected function set marginX(_arg_1:Number):void
        {
            mMarginX = _arg_1;
        }

        protected function get marginY():Number
        {
            return (mMarginY);
        }

        protected function set marginY(_arg_1:Number):void
        {
            mMarginY = _arg_1;
        }

        protected function set numPasses(_arg_1:int):void
        {
            mNumPasses = _arg_1;
        }

        protected function get numPasses():int
        {
            return (mNumPasses);
        }

        final protected function get vertexPosAtID():int
        {
            return (mVertexPosAtID);
        }

        final protected function set vertexPosAtID(_arg_1:int):void
        {
            mVertexPosAtID = _arg_1;
        }

        final protected function get texCoordsAtID():int
        {
            return (mTexCoordsAtID);
        }

        final protected function set texCoordsAtID(_arg_1:int):void
        {
            mTexCoordsAtID = _arg_1;
        }

        final protected function get baseTextureID():int
        {
            return (mBaseTextureID);
        }

        final protected function set baseTextureID(_arg_1:int):void
        {
            mBaseTextureID = _arg_1;
        }

        final protected function get mvpConstantID():int
        {
            return (mMvpConstantID);
        }

        final protected function set mvpConstantID(_arg_1:int):void
        {
            mMvpConstantID = _arg_1;
        }


    }
}//package starling.filters

