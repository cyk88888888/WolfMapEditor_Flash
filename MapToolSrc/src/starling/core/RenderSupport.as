// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.core.RenderSupport

package starling.core
{
    import flash.geom.Point;
    import flash.geom.Vector3D;
    import flash.geom.Rectangle;
    import com.adobe.utils.AGALMiniAssembler;
    import flash.geom.Matrix3D;
    import __AS3__.vec.Vector;
    import flash.geom.Matrix;
    import starling.display.QuadBatch;
    import starling.textures.Texture;
    import starling.display.DisplayObject;
    import starling.utils.MatrixUtil;
    import starling.display.BlendMode;
    import starling.utils.Color;
    import starling.errors.MissingContextError;
    import flash.display3D.Program3D;
    import starling.display.Stage;
    import starling.utils.SystemUtil;
    import starling.utils.RectangleUtil;
    import flash.display3D.Context3D;
    import starling.display.Quad;

    public class RenderSupport 
    {

        private static const RENDER_TARGET_NAME:String = "Starling.renderTarget";

        private static var sPoint:Point = new Point();
        private static var sPoint3D:Vector3D = new Vector3D();
        private static var sClipRect:Rectangle = new Rectangle();
        private static var sBufferRect:Rectangle = new Rectangle();
        private static var sScissorRect:Rectangle = new Rectangle();
        private static var sAssembler:AGALMiniAssembler = new AGALMiniAssembler();
        private static var sMatrix3D:Matrix3D = new Matrix3D();
        private static var sMatrixData:Vector.<Number> = new <Number>[0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
        private static var sourceFactor:String;
        private static var destinationFactor:String;
        private static var blendFactorPremultipliedAlpha:Boolean = false;
        private static var blendFactorblendMode:String = "";

        private var mProjectionMatrix:Matrix;
        private var mModelViewMatrix:Matrix;
        private var mMvpMatrix:Matrix;
        private var mMatrixStack:Vector.<Matrix>;
        private var mMatrixStackSize:int;
        private var mProjectionMatrix3D:Matrix3D;
        private var mModelViewMatrix3D:Matrix3D;
        private var mMvpMatrix3D:Matrix3D;
        private var mMatrixStack3D:Vector.<Matrix3D>;
        private var mMatrixStack3DSize:int;
        private var mDrawCount:int;
        private var mBlendMode:String;
        private var mClipRectStack:Vector.<Rectangle>;
        private var mClipRectStackSize:int;
        private var mQuadBatches:Vector.<QuadBatch>;
        private var mCurrentQuadBatchID:int;
        private var _renderTarget:Texture;
        private var mMasks:Vector.<DisplayObject> = new Vector.<DisplayObject>(0);
        private var mStencilReferenceValue:uint = 0;

        public function RenderSupport()
        {
            mProjectionMatrix = new Matrix();
            mModelViewMatrix = new Matrix();
            mMvpMatrix = new Matrix();
            mMatrixStack = new Vector.<Matrix>(0);
            mMatrixStackSize = 0;
            mProjectionMatrix3D = new Matrix3D();
            mModelViewMatrix3D = new Matrix3D();
            mMvpMatrix3D = new Matrix3D();
            mMatrixStack3D = new Vector.<Matrix3D>(0);
            mMatrixStack3DSize = 0;
            mDrawCount = 0;
            mBlendMode = "normal";
            mClipRectStack = new Vector.<Rectangle>(0);
            mCurrentQuadBatchID = 0;
            mQuadBatches = new <QuadBatch>[new QuadBatch(true)];
            loadIdentity();
            setProjectionMatrix(0, 0, 400, 300);
        }

        public static function transformMatrixForObject(_arg_1:Matrix, _arg_2:DisplayObject):void
        {
            MatrixUtil.prependMatrix(_arg_1, _arg_2.transformationMatrix);
        }

        public static function setDefaultBlendFactors(_arg_1:Boolean):void
        {
            setBlendFactors(_arg_1);
        }

        public static function resetBlendFactors():void
        {
            blendFactorblendMode = "";
            blendFactorPremultipliedAlpha = false;
        }

        public static function setBlendFactors(_arg_1:Boolean, _arg_2:String="normal"):void
        {
            var _local_3:* = null;
            if (((!(blendFactorblendMode === _arg_2)) || (!(blendFactorPremultipliedAlpha === _arg_1))))
            {
                blendFactorblendMode = _arg_2;
                blendFactorPremultipliedAlpha = _arg_1;
                _local_3 = BlendMode.getBlendFactors(_arg_2, _arg_1);
                Starling.context.setBlendFactors(_local_3[0], _local_3[1]);
            };
        }

        public static function clear(_arg_1:uint=0, _arg_2:Number=0):void
        {
            Starling.context.clear((Color.getRed(_arg_1) / 0xFF), (Color.getGreen(_arg_1) / 0xFF), (Color.getBlue(_arg_1) / 0xFF), _arg_2);
        }

        public static function assembleAgal(_arg_1:String, _arg_2:String, _arg_3:Program3D=null):Program3D
        {
            var _local_4:* = null;
            if (_arg_3 == null)
            {
                _local_4 = Starling.context;
                if (_local_4 == null)
                {
                    throw (new MissingContextError());
                };
                _arg_3 = _local_4.createProgram();
            };
            _arg_3.upload(sAssembler.assemble("vertex", _arg_1), sAssembler.assemble("fragment", _arg_2));
            return (_arg_3);
        }

        public static function getTextureLookupFlags(_arg_1:String, _arg_2:Boolean, _arg_3:Boolean=false, _arg_4:String="bilinear"):String
        {
            var _local_5:Array = ["2d", ((_arg_3) ? "repeat" : "clamp")];
            if (_arg_1 == "compressed")
            {
                _local_5.push("dxt1");
            }
            else
            {
                if (_arg_1 == "compressedAlpha")
                {
                    _local_5.push("dxt5");
                };
            };
            if (_arg_4 == "none")
            {
                _local_5.push("nearest", ((_arg_2) ? "mipnearest" : "mipnone"));
            }
            else
            {
                if (_arg_4 == "bilinear")
                {
                    _local_5.push("linear", ((_arg_2) ? "mipnearest" : "mipnone"));
                }
                else
                {
                    _local_5.push("linear", ((_arg_2) ? "miplinear" : "mipnone"));
                };
            };
            return (("<" + _local_5.join()) + ">");
        }


        public function dispose():void
        {
            for each (var _local_1:QuadBatch in mQuadBatches)
            {
                _local_1.dispose();
            };
        }

        public function setProjectionMatrix(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number, _arg_5:Number=0, _arg_6:Number=0, _arg_7:Vector3D=null):void
        {
            var _local_14:Number;
            _local_14 = 1;
            if (_arg_5 <= 0)
            {
                _arg_5 = _arg_3;
            };
            if (_arg_6 <= 0)
            {
                _arg_6 = _arg_4;
            };
            if (_arg_7 == null)
            {
                _arg_7 = sPoint3D;
                _arg_7.setTo((_arg_5 / 2), (_arg_6 / 2), ((_arg_5 / Math.tan(0.5)) * 0.5));
            };
            mProjectionMatrix.setTo((2 / _arg_3), 0, 0, (-2 / _arg_4), (-((2 * _arg_1) + _arg_3) / _arg_3), (((2 * _arg_2) + _arg_4) / _arg_4));
            var _local_13:Number = Math.abs(_arg_7.z);
            var _local_11:Number = (_arg_7.x - (_arg_5 / 2));
            var _local_10:Number = (_arg_7.y - (_arg_6 / 2));
            var _local_12:Number = (_local_13 * 20);
            var _local_8:Number = (_arg_5 / _arg_3);
            var _local_9:Number = (_arg_6 / _arg_4);
            sMatrixData[0] = ((2 * _local_13) / _arg_5);
            sMatrixData[5] = ((-2 * _local_13) / _arg_6);
            sMatrixData[10] = (_local_12 / (_local_12 - 1));
            sMatrixData[14] = ((-(_local_12) * 1) / (_local_12 - 1));
            sMatrixData[11] = 1;
            var _local_15:int;
            var _local_16:* = (sMatrixData[_local_15] * _local_8);
            sMatrixData[_local_15] = _local_16;
            _local_16 = 5;
            _local_15 = (sMatrixData[_local_16] * _local_9);
            sMatrixData[_local_16] = _local_15;
            sMatrixData[8] = ((_local_8 - 1) - (((2 * _local_8) * (_arg_1 - _local_11)) / _arg_5));
            sMatrixData[9] = ((-(_local_9) + 1) + (((2 * _local_9) * (_arg_2 - _local_10)) / _arg_6));
            mProjectionMatrix3D.copyRawDataFrom(sMatrixData);
            mProjectionMatrix3D.prependTranslation(((-(_arg_5) / 2) - _local_11), ((-(_arg_6) / 2) - _local_10), _local_13);
            applyClipRect();
        }

        public function setOrthographicProjection(_arg_1:Number, _arg_2:Number, _arg_3:Number, _arg_4:Number):void
        {
            var _local_5:Stage = Starling.current.stage;
            sClipRect.setTo(_arg_1, _arg_2, _arg_3, _arg_4);
            setProjectionMatrix(_arg_1, _arg_2, _arg_3, _arg_4, _local_5.stageWidth, _local_5.stageHeight, _local_5.cameraPosition);
        }

        public function loadIdentity():void
        {
            mModelViewMatrix.identity();
            mModelViewMatrix3D.identity();
        }

        public function translateMatrix(_arg_1:Number, _arg_2:Number):void
        {
            MatrixUtil.prependTranslation(mModelViewMatrix, _arg_1, _arg_2);
        }

        public function rotateMatrix(_arg_1:Number):void
        {
            MatrixUtil.prependRotation(mModelViewMatrix, _arg_1);
        }

        public function scaleMatrix(_arg_1:Number, _arg_2:Number):void
        {
            MatrixUtil.prependScale(mModelViewMatrix, _arg_1, _arg_2);
        }

        public function prependMatrix(_arg_1:Matrix):void
        {
            MatrixUtil.prependMatrix(mModelViewMatrix, _arg_1);
        }

        public function transformMatrix(_arg_1:DisplayObject):void
        {
            MatrixUtil.prependMatrix(mModelViewMatrix, _arg_1.transformationMatrix);
        }

        public function pushMatrix():void
        {
            if (mMatrixStack.length < (mMatrixStackSize + 1))
            {
                mMatrixStack.push(new Matrix());
            };
            mMatrixStack[mMatrixStackSize++].copyFrom(mModelViewMatrix);
        }

        public function popMatrix():void
        {
            mModelViewMatrix.copyFrom(mMatrixStack[--mMatrixStackSize]);
        }

        public function resetMatrix():void
        {
            mMatrixStackSize = 0;
            mMatrixStack3DSize = 0;
            loadIdentity();
        }

        public function get mvpMatrix():Matrix
        {
            mMvpMatrix.copyFrom(mModelViewMatrix);
            mMvpMatrix.concat(mProjectionMatrix);
            return (mMvpMatrix);
        }

        public function get modelViewMatrix():Matrix
        {
            return (mModelViewMatrix);
        }

        public function get projectionMatrix():Matrix
        {
            return (mProjectionMatrix);
        }

        public function set projectionMatrix(_arg_1:Matrix):void
        {
            mProjectionMatrix.copyFrom(_arg_1);
            applyClipRect();
        }

        public function transformMatrix3D(_arg_1:DisplayObject):void
        {
            mModelViewMatrix3D.prepend(MatrixUtil.convertTo3D(mModelViewMatrix, sMatrix3D));
            mModelViewMatrix3D.prepend(_arg_1.transformationMatrix3D);
            mModelViewMatrix.identity();
        }

        public function pushMatrix3D():void
        {
            if (mMatrixStack3D.length < (mMatrixStack3DSize + 1))
            {
                mMatrixStack3D.push(new Matrix3D());
            };
            mMatrixStack3D[mMatrixStack3DSize++].copyFrom(mModelViewMatrix3D);
        }

        public function popMatrix3D():void
        {
            mModelViewMatrix3D.copyFrom(mMatrixStack3D[--mMatrixStack3DSize]);
        }

        public function get mvpMatrix3D():Matrix3D
        {
            if (mMatrixStack3DSize == 0)
            {
                MatrixUtil.convertTo3D(mvpMatrix, mMvpMatrix3D);
            }
            else
            {
                mMvpMatrix3D.copyFrom(mProjectionMatrix3D);
                mMvpMatrix3D.prepend(mModelViewMatrix3D);
                mMvpMatrix3D.prepend(MatrixUtil.convertTo3D(mModelViewMatrix, sMatrix3D));
            };
            return (mMvpMatrix3D);
        }

        public function get projectionMatrix3D():Matrix3D
        {
            return (mProjectionMatrix3D);
        }

        public function set projectionMatrix3D(_arg_1:Matrix3D):void
        {
            mProjectionMatrix3D.copyFrom(_arg_1);
        }

        public function applyBlendMode(_arg_1:Boolean):void
        {
            setBlendFactors(_arg_1, mBlendMode);
        }

        public function get blendMode():String
        {
            return (mBlendMode);
        }

        public function set blendMode(_arg_1:String):void
        {
            if (_arg_1 != "auto")
            {
                mBlendMode = _arg_1;
            };
        }

        public function get renderTarget():Texture
        {
            return (_renderTarget);
        }

        public function set renderTarget(_arg_1:Texture):void
        {
            setRenderTarget(_arg_1);
        }

        public function setRenderTarget(_arg_1:Texture, _arg_2:int=0):void
        {
            _renderTarget = _arg_1;
            applyClipRect();
            if (_arg_1)
            {
                Starling.context.setRenderToTexture(_arg_1.base, SystemUtil.supportsDepthAndStencil, _arg_2);
            }
            else
            {
                Starling.context.setRenderToBackBuffer();
            };
        }

        public function pushClipRect(_arg_1:Rectangle, _arg_2:Boolean=true):Rectangle
        {
            if (mClipRectStack.length < (mClipRectStackSize + 1))
            {
                mClipRectStack.push(new Rectangle());
            };
            mClipRectStack[mClipRectStackSize].copyFrom(_arg_1);
            _arg_1 = mClipRectStack[mClipRectStackSize];
            if (((_arg_2) && (mClipRectStackSize > 0)))
            {
                RectangleUtil.intersect(_arg_1, mClipRectStack[(mClipRectStackSize - 1)], _arg_1);
            };
            mClipRectStackSize++;
            applyClipRect();
            return (_arg_1);
        }

        public function popClipRect():void
        {
            if (mClipRectStackSize > 0)
            {
                mClipRectStackSize--;
                applyClipRect();
            };
        }

        public function applyClipRect():void
        {
            var _local_1:int;
            var _local_3:int;
            var _local_5:* = null;
            var _local_2:* = null;
            finishQuadBatch();
            var _local_4:Context3D = Starling.context;
            if (_local_4 == null)
            {
                return;
            };
            if (mClipRectStackSize > 0)
            {
                _local_5 = mClipRectStack[(mClipRectStackSize - 1)];
                _local_2 = this.renderTarget;
                if (_local_2)
                {
                    _local_3 = _local_2.root.nativeWidth;
                    _local_1 = _local_2.root.nativeHeight;
                }
                else
                {
                    _local_3 = Starling.current.backBufferWidth;
                    _local_1 = Starling.current.backBufferHeight;
                };
                MatrixUtil.transformCoords(mProjectionMatrix, _local_5.x, _local_5.y, sPoint);
                sClipRect.x = (((sPoint.x * 0.5) + 0.5) * _local_3);
                sClipRect.y = ((0.5 - (sPoint.y * 0.5)) * _local_1);
                MatrixUtil.transformCoords(mProjectionMatrix, _local_5.right, _local_5.bottom, sPoint);
                sClipRect.right = (((sPoint.x * 0.5) + 0.5) * _local_3);
                sClipRect.bottom = ((0.5 - (sPoint.y * 0.5)) * _local_1);
                sBufferRect.setTo(0, 0, _local_3, _local_1);
                RectangleUtil.intersect(sClipRect, sBufferRect, sScissorRect);
                if (((sScissorRect.width < 1) || (sScissorRect.height < 1)))
                {
                    sScissorRect.setTo(0, 0, 1, 1);
                };
                _local_4.setScissorRectangle(sScissorRect);
            }
            else
            {
                _local_4.setScissorRectangle(null);
            };
        }

        public function pushMask(_arg_1:DisplayObject):void
        {
            mMasks[mMasks.length] = _arg_1;
            mStencilReferenceValue++;
            var _local_2:Context3D = Starling.context;
            if (_local_2 == null)
            {
                return;
            };
            finishQuadBatch();
            _local_2.setStencilActions("frontAndBack", "equal", "incrementSaturate");
            drawMask(_arg_1);
            _local_2.setStencilReferenceValue(mStencilReferenceValue);
            _local_2.setStencilActions("frontAndBack", "equal", "keep");
        }

        public function popMask():void
        {
            var _local_2:DisplayObject = mMasks.pop();
            mStencilReferenceValue--;
            var _local_1:Context3D = Starling.context;
            if (_local_1 == null)
            {
                return;
            };
            finishQuadBatch();
            _local_1.setStencilActions("frontAndBack", "equal", "decrementSaturate");
            drawMask(_local_2);
            _local_1.setStencilReferenceValue(mStencilReferenceValue);
            _local_1.setStencilActions("frontAndBack", "equal", "keep");
        }

        private function drawMask(_arg_1:DisplayObject):void
        {
            pushMatrix();
            var _local_2:Stage = _arg_1.stage;
            if (_local_2)
            {
                _arg_1.getTransformationMatrix(_local_2, mModelViewMatrix);
            }
            else
            {
                transformMatrix(_arg_1);
            };
            _arg_1.render(this, 0);
            finishQuadBatch();
            popMatrix();
        }

        public function get stencilReferenceValue():uint
        {
            return (mStencilReferenceValue);
        }

        public function set stencilReferenceValue(_arg_1:uint):void
        {
            mStencilReferenceValue = _arg_1;
            Starling.context.setStencilReferenceValue(_arg_1);
        }

        public function batchQuad(_arg_1:Quad, _arg_2:Number, _arg_3:Texture=null, _arg_4:String=null):void
        {
            if (mQuadBatches[mCurrentQuadBatchID].isStateChange(_arg_1.tinted, _arg_2, _arg_3, _arg_4, mBlendMode))
            {
                finishQuadBatch();
            };
            mQuadBatches[mCurrentQuadBatchID].addQuad(_arg_1, _arg_2, _arg_3, _arg_4, mModelViewMatrix, mBlendMode);
        }

        public function batchQuadBatch(_arg_1:QuadBatch, _arg_2:Number):void
        {
            if (mQuadBatches[mCurrentQuadBatchID].isStateChange(_arg_1.tinted, _arg_2, _arg_1.texture, _arg_1.smoothing, mBlendMode, _arg_1.numQuads))
            {
                finishQuadBatch();
            };
            mQuadBatches[mCurrentQuadBatchID].addQuadBatch(_arg_1, _arg_2, mModelViewMatrix, mBlendMode);
        }

        public function finishQuadBatch():void
        {
            var _local_1:QuadBatch = mQuadBatches[mCurrentQuadBatchID];
            if (_local_1.numQuads != 0)
            {
                if (mMatrixStack3DSize == 0)
                {
                    _local_1.renderCustom(mProjectionMatrix3D);
                }
                else
                {
                    mMvpMatrix3D.copyFrom(mProjectionMatrix3D);
                    mMvpMatrix3D.prepend(mModelViewMatrix3D);
                    _local_1.renderCustom(mMvpMatrix3D);
                };
                _local_1.reset();
                mCurrentQuadBatchID++;
                mDrawCount++;
                if (mQuadBatches.length <= mCurrentQuadBatchID)
                {
                    mQuadBatches.push(new QuadBatch(true));
                };
            };
        }

        public function nextFrame():void
        {
            resetMatrix();
            trimQuadBatches();
            mMasks.length = 0;
            mCurrentQuadBatchID = 0;
            mBlendMode = "normal";
            mDrawCount = 0;
        }

        private function trimQuadBatches():void
        {
            var _local_2:int;
            var _local_4:int;
            var _local_3:int = (mCurrentQuadBatchID + 1);
            var _local_1:int = mQuadBatches.length;
            if (((_local_1 >= 16) && (_local_1 > (2 * _local_3))))
            {
                _local_2 = (_local_1 - _local_3);
                _local_4 = 0;
                while (_local_4 < _local_2)
                {
                    mQuadBatches.pop().dispose();
                    _local_4++;
                };
            };
        }

        public function clear(_arg_1:uint=0, _arg_2:Number=0):void
        {
            RenderSupport.clear(_arg_1, _arg_2);
        }

        public function raiseDrawCount(_arg_1:uint=1):void
        {
            mDrawCount = (mDrawCount + _arg_1);
        }

        public function get drawCount():int
        {
            return (mDrawCount);
        }


    }
}//package starling.core

