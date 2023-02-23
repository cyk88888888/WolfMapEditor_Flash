// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.display.QuadBatch

package starling.display
{
    import flash.geom.Matrix;
    import __AS3__.vec.Vector;
    import flash.utils.Dictionary;
    import starling.textures.Texture;
    import flash.display3D.VertexBuffer3D;
    import flash.display3D.IndexBuffer3D;
    import starling.utils.VertexData;
    import starling.core.Starling;
    import flash.errors.IllegalOperationError;
    import starling.filters.FragmentFilter;
    import starling.core.starling_internal;
    import starling.core.RenderSupport;
    import flash.utils.getQualifiedClassName;
    import flash.display3D.Context3D;
    import starling.errors.MissingContextError;
    import flash.geom.Matrix3D;
    import flash.geom.Rectangle;
    import flash.display3D.Program3D;

    use namespace starling_internal;

    public class QuadBatch extends DisplayObject 
    {

        public static const MAX_NUM_QUADS:int = 16383;
        private static const QUAD_PROGRAM_NAME:String = "QB_q";

        private static var sHelperMatrix:Matrix = new Matrix();
        private static var sRenderAlpha:Vector.<Number> = new <Number>[1, 1, 1, 1];
        private static var sProgramNameCache:Dictionary = new Dictionary();

        private var mNumQuads:int;
        private var _mSyncRequired:Boolean;
        private var mBatchable:Boolean;
        private var mForceTinted:Boolean;
        private var mOwnsTexture:Boolean;
        private var mTinted:Boolean;
        private var mTexture:Texture;
        private var mSmoothing:String;
        private var mVertexBuffer:VertexBuffer3D;
        private var mIndexData:Vector.<uint>;
        private var mIndexBuffer:IndexBuffer3D;
        protected var mVertexData:VertexData;

        public function QuadBatch(_arg_1:Boolean=false)
        {
            var _local_2:* = null;
            super();
            mVertexData = new VertexData(0, true);
            mIndexData = new Vector.<uint>(0);
            mNumQuads = 0;
            mTinted = false;
            mSyncRequired = false;
            mBatchable = false;
            mOwnsTexture = false;
            if (_arg_1)
            {
                _local_2 = Starling.current.profile;
                mForceTinted = ((!(_local_2 == "baselineConstrained")) && (!(_local_2 == "baseline")));
            };
            Starling.current.stage3D.addEventListener("context3DCreate", onContextCreated, false, 0, true);
        }

        public static function compile(_arg_1:DisplayObject, _arg_2:Vector.<QuadBatch>):void
        {
            compileObject(_arg_1, _arg_2, -1, new Matrix());
        }

        public static function optimize(_arg_1:Vector.<QuadBatch>):void
        {
            var _local_4:* = null;
            var _local_2:* = null;
            var _local_5:int;
            var _local_3:int;
            _local_5 = 0;
            while (_local_5 < _arg_1.length)
            {
                _local_2 = _arg_1[_local_5];
                _local_3 = (_local_5 + 1);
                while (_local_3 < _arg_1.length)
                {
                    _local_4 = _arg_1[_local_3];
                    if (!_local_2.isStateChange(_local_4.tinted, 1, _local_4.texture, _local_4.smoothing, _local_4.blendMode, _local_4.numQuads))
                    {
                        _local_2.addQuadBatch(_local_4);
                        _local_4.dispose();
                        _arg_1.splice(_local_3, 1);
                    }
                    else
                    {
                        _local_3++;
                    };
                };
                _local_5++;
            };
        }

        private static function compileObject(_arg_1:DisplayObject, _arg_2:Vector.<QuadBatch>, _arg_3:int, _arg_4:Matrix, _arg_5:Number=1, _arg_6:String=null, _arg_7:Boolean=false):int
        {
            var _local_15:int;
            var _local_11:* = null;
            var _local_23:int;
            var _local_19:* = null;
            var _local_16:* = null;
            var _local_14:* = null;
            var _local_8:* = null;
            var _local_10:* = null;
            var _local_13:Boolean;
            var _local_9:int;
            var _local_12:* = null;
            if ((_arg_1 is Sprite3D))
            {
                throw (new IllegalOperationError("Sprite3D objects cannot be flattened"));
            };
            var _local_21:Boolean;
            var _local_17:Number = _arg_1.alpha;
            var _local_22:DisplayObjectContainer = (_arg_1 as DisplayObjectContainer);
            var _local_18:Quad = (_arg_1 as Quad);
            var _local_20:QuadBatch = (_arg_1 as QuadBatch);
            var _local_24:FragmentFilter = _arg_1.filter;
            if (_arg_3 == -1)
            {
                _local_21 = true;
                _arg_3 = 0;
                _local_17 = 1;
                _arg_6 = _arg_1.blendMode;
                _arg_7 = true;
                if (_arg_2.length == 0)
                {
                    _arg_2[0] = new QuadBatch(true);
                }
                else
                {
                    _arg_2[0].reset();
                    _arg_2[0].ownsTexture = false;
                };
            }
            else
            {
                if (_arg_1.mask)
                {
                    (trace("[Starling] Masks are ignored on children of a flattened sprite."));
                };
                if (((_arg_1 is Sprite) && ((_arg_1 as Sprite).clipRect)))
                {
                    (trace("[Starling] ClipRects are ignored on children of a flattened sprite."));
                };
            };
            if (((_local_24) && (!(_arg_7))))
            {
                if (_local_24.mode == "above")
                {
                    _arg_3 = compileObject(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, true);
                };
                _arg_3 = compileObject(_local_24.starling_internal::compile(_arg_1), _arg_2, _arg_3, _arg_4, _arg_5, _arg_6);
                _arg_2[_arg_3].ownsTexture = true;
                if (_local_24.mode == "below")
                {
                    _arg_3 = compileObject(_arg_1, _arg_2, _arg_3, _arg_4, _arg_5, _arg_6, true);
                };
            }
            else
            {
                if (_local_22)
                {
                    _local_23 = _local_22.numChildren;
                    _local_19 = new Matrix();
                    _local_15 = 0;
                    while (_local_15 < _local_23)
                    {
                        _local_16 = _local_22.getChildAt(_local_15);
                        if (_local_16.hasVisibleArea)
                        {
                            _local_14 = ((_local_16.blendMode == "auto") ? _arg_6 : _local_16.blendMode);
                            _local_19.copyFrom(_arg_4);
                            RenderSupport.transformMatrixForObject(_local_19, _local_16);
                            _arg_3 = compileObject(_local_16, _arg_2, _arg_3, _local_19, (_arg_5 * _local_17), _local_14);
                        };
                        _local_15++;
                    };
                }
                else
                {
                    if (((_local_18) || (_local_20)))
                    {
                        if (_local_18)
                        {
                            _local_12 = (_local_18 as Image);
                            _local_8 = ((_local_12) ? _local_12.texture : null);
                            _local_10 = ((_local_12) ? _local_12.smoothing : null);
                            _local_13 = _local_18.tinted;
                            _local_9 = 1;
                        }
                        else
                        {
                            _local_8 = _local_20.mTexture;
                            _local_10 = _local_20.mSmoothing;
                            _local_13 = _local_20.mTinted;
                            _local_9 = _local_20.mNumQuads;
                        };
                        _local_11 = _arg_2[_arg_3];
                        if (_local_11.isStateChange(_local_13, (_arg_5 * _local_17), _local_8, _local_10, _arg_6, _local_9))
                        {
                            if (_arg_2.length <= ++_arg_3)
                            {
                                _arg_2.push(new QuadBatch(true));
                            };
                            _local_11 = _arg_2[_arg_3];
                            _local_11.reset();
                            _local_11.ownsTexture = false;
                        };
                        if (_local_18)
                        {
                            _local_11.addQuad(_local_18, _arg_5, _local_8, _local_10, _arg_4, _arg_6);
                        }
                        else
                        {
                            _local_11.addQuadBatch(_local_20, _arg_5, _arg_4, _arg_6);
                        };
                    }
                    else
                    {
                        throw (new Error(("Unsupported display object: " + getQualifiedClassName(_arg_1))));
                    };
                };
            };
            if (_local_21)
            {
                _local_15 = (_arg_2.length - 1);
                while (_local_15 > _arg_3)
                {
                    _arg_2.pop().dispose();
                    _local_15--;
                };
            };
            return (_arg_3);
        }

        private static function getImageProgramName(_arg_1:Boolean, _arg_2:Boolean=true, _arg_3:Boolean=false, _arg_4:String="bgra", _arg_5:String="bilinear"):String
        {
            var _local_7:uint;
            if (_arg_1)
            {
                _local_7 = (_local_7 | 0x01);
            };
            if (_arg_2)
            {
                _local_7 = (_local_7 | 0x02);
            };
            if (_arg_3)
            {
                _local_7 = (_local_7 | 0x04);
            };
            if (_arg_5 == "none")
            {
                _local_7 = (_local_7 | 0x08);
            }
            else
            {
                if (_arg_5 == "trilinear")
                {
                    _local_7 = (_local_7 | 0x10);
                };
            };
            if (_arg_4 == "compressed")
            {
                _local_7 = (_local_7 | 0x20);
            }
            else
            {
                if (_arg_4 == "compressedAlpha")
                {
                    _local_7 = (_local_7 | 0x40);
                };
            };
            var _local_6:String = sProgramNameCache[_local_7];
            if (_local_6 == null)
            {
                _local_6 = ("QB_i." + _local_7.toString(16));
                sProgramNameCache[_local_7] = _local_6;
            };
            return (_local_6);
        }


        override public function dispose():void
        {
            Starling.current.stage3D.removeEventListener("context3DCreate", onContextCreated);
            destroyBuffers();
            mVertexData.numVertices = 0;
            mIndexData.length = 0;
            mNumQuads = 0;
            if (((mTexture) && (mOwnsTexture)))
            {
                mTexture.dispose();
            };
            super.dispose();
        }

        private function onContextCreated(_arg_1:Object):void
        {
            createBuffers();
        }

        protected function onVertexDataChanged():void
        {
            mSyncRequired = true;
        }

        public function clone():QuadBatch
        {
            var _local_1:QuadBatch = new QuadBatch();
            _local_1.mVertexData = mVertexData.clone(0, (mNumQuads * 4));
            _local_1.mIndexData = mIndexData.slice(0, (mNumQuads * 6));
            _local_1.mNumQuads = mNumQuads;
            _local_1.mTinted = mTinted;
            _local_1.mTexture = mTexture;
            _local_1.ensureTexture();
            _local_1.mSmoothing = mSmoothing;
            _local_1.mSyncRequired = true;
            _local_1.mForceTinted = forceTinted;
            _local_1.blendMode = blendMode;
            _local_1.alpha = alpha;
            return (_local_1);
        }

        private function expand():void
        {
            var _local_1:int = this.capacity;
            if (_local_1 >= 16383)
            {
                throw (new Error("Exceeded maximum number of quads!"));
            };
            this.capacity = ((_local_1 < 8) ? 16 : (_local_1 * 2));
        }

        private function createBuffers():void
        {
            destroyBuffers();
            var _local_3:int = mVertexData.numVertices;
            var _local_1:int = mIndexData.length;
            var _local_2:Context3D = Starling.context;
            if (_local_3 == 0)
            {
                return;
            };
            if (_local_2 == null)
            {
                throw (new MissingContextError());
            };
            mVertexBuffer = _local_2.createVertexBuffer(_local_3, 8);
            mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, _local_3);
            mIndexBuffer = _local_2.createIndexBuffer(_local_1);
            mIndexBuffer.uploadFromVector(mIndexData, 0, _local_1);
            mSyncRequired = false;
        }

        private function destroyBuffers():void
        {
            if (mVertexBuffer)
            {
                mVertexBuffer.dispose();
                mVertexBuffer = null;
            };
            if (mIndexBuffer)
            {
                mIndexBuffer.dispose();
                mIndexBuffer = null;
            };
        }

        private function syncBuffers():void
        {
            if (mVertexBuffer == null)
            {
                createBuffers();
            }
            else
            {
                mVertexBuffer.uploadFromVector(mVertexData.rawData, 0, mVertexData.numVertices);
                mSyncRequired = false;
            };
        }

        public function renderCustom(_arg_1:Matrix3D, _arg_2:Number=1, _arg_3:String=null):void
        {
            if (mNumQuads == 0)
            {
                return;
            };
            if (_mSyncRequired)
            {
                syncBuffers();
            };
            var _local_6:Boolean = mVertexData.premultipliedAlpha;
            var _local_4:Context3D = Starling.context;
            var _local_5:Boolean = ((mTinted) || (!(_arg_2 == 1)));
            var _local_7:* = ((_local_6) ? _arg_2 : 1);
            sRenderAlpha[2] = _local_7;
            sRenderAlpha[1] = _local_7;
            sRenderAlpha[0] = _local_7;
            sRenderAlpha[3] = _arg_2;
            RenderSupport.setBlendFactors(_local_6, ((_arg_3) ? _arg_3 : this.blendMode));
            _local_4.setProgram(getProgram(_local_5));
            _local_4.setProgramConstantsFromVector("vertex", 0, sRenderAlpha, 1);
            _local_4.setProgramConstantsFromMatrix("vertex", 1, _arg_1, true);
            _local_4.setVertexBufferAt(0, mVertexBuffer, 0, "float2");
            if (((mTexture == null) || (_local_5)))
            {
                _local_4.setVertexBufferAt(1, mVertexBuffer, 2, "float4");
            };
            if (mTexture)
            {
                _local_4.setTextureAt(0, mTexture.base);
                _local_4.setVertexBufferAt(2, mVertexBuffer, 6, "float2");
            };
            _local_4.drawTriangles(mIndexBuffer, 0, (mNumQuads * 2));
            if (mTexture)
            {
                _local_4.setTextureAt(0, null);
                _local_4.setVertexBufferAt(2, null);
            };
            _local_4.setVertexBufferAt(1, null);
            _local_4.setVertexBufferAt(0, null);
        }

        public function reset():void
        {
            if (((mTexture) && (mOwnsTexture)))
            {
                mTexture.dispose();
            };
            mNumQuads = 0;
            mTexture = null;
            mSmoothing = null;
            mSyncRequired = true;
        }

        public function addImage(_arg_1:Image, _arg_2:Number=1, _arg_3:Matrix=null, _arg_4:String=null):void
        {
            addQuad(_arg_1, _arg_2, _arg_1.texture, _arg_1.smoothing, _arg_3, _arg_4);
        }

        public function addQuad(_arg_1:Quad, _arg_2:Number=1, _arg_3:Texture=null, _arg_4:String=null, _arg_5:Matrix=null, _arg_6:String=null):void
        {
            if (_arg_5 == null)
            {
                _arg_5 = _arg_1.transformationMatrix;
            };
            var _local_8:Number = (_arg_2 * _arg_1.alpha);
            var _local_7:int = (mNumQuads * 4);
            if ((mNumQuads + 1) > (mVertexData.numVertices / 4))
            {
                expand();
            };
            if (mNumQuads == 0)
            {
                this.blendMode = ((_arg_6) ? _arg_6 : _arg_1.blendMode);
                mTexture = _arg_3;
                ensureTexture();
                mTinted = (((mForceTinted) || (_arg_1.tinted)) || (!(_arg_2 == 1)));
                mSmoothing = _arg_4;
                mVertexData.setPremultipliedAlpha(_arg_1.premultipliedAlpha);
            };
            _arg_1.copyVertexDataTransformedTo(mVertexData, _local_7, _arg_5);
            if (_local_8 != 1)
            {
                mVertexData.scaleAlpha(_local_7, _local_8, 4);
            };
            mSyncRequired = true;
            mNumQuads++;
        }

        public function addQuadBatch(_arg_1:QuadBatch, _arg_2:Number=1, _arg_3:Matrix=null, _arg_4:String=null):void
        {
            if (_arg_3 == null)
            {
                _arg_3 = _arg_1.transformationMatrix;
            };
            var _local_6:Number = (_arg_2 * _arg_1.alpha);
            var _local_5:int = (mNumQuads * 4);
            var _local_7:int = _arg_1.numQuads;
            if ((mNumQuads + _local_7) > capacity)
            {
                capacity = (mNumQuads + _local_7);
            };
            if (mNumQuads == 0)
            {
                this.blendMode = ((_arg_4) ? _arg_4 : _arg_1.blendMode);
                mTexture = _arg_1.mTexture;
                ensureTexture();
                mTinted = (((mForceTinted) || (_arg_1.mTinted)) || (!(_arg_2 == 1)));
                mSmoothing = _arg_1.mSmoothing;
                mVertexData.setPremultipliedAlpha(_arg_1.mVertexData.premultipliedAlpha, false);
            };
            _arg_1.mVertexData.copyTransformedTo(mVertexData, _local_5, _arg_3, 0, (_local_7 * 4));
            if (_local_6 != 1)
            {
                mVertexData.scaleAlpha(_local_5, _local_6, (_local_7 * 4));
            };
            mSyncRequired = true;
            mNumQuads = (mNumQuads + _local_7);
        }

        private function ensureTexture():void
        {
            if (((!(mTexture === null)) && (mTexture.root.disposed)))
            {
                throw (new Error("add disposed texture to quad"));
            };
        }

        public function isStateChange(_arg_1:Boolean, _arg_2:Number, _arg_3:Texture, _arg_4:String, _arg_5:String, _arg_6:int=1):Boolean
        {
            if (mNumQuads == 0)
            {
                return (false);
            };
            if ((mNumQuads + _arg_6) > 16383)
            {
                return (true);
            };
            if (((mTexture == null) && (_arg_3 == null)))
            {
                return (!(this.blendMode == _arg_5));
            };
            if (((!(mTexture == null)) && (!(_arg_3 == null))))
            {
                return (((((!(mTexture.base == _arg_3.base)) || (!(mTexture.repeat == _arg_3.repeat))) || (!(mSmoothing == _arg_4))) || (!(mTinted == (((mForceTinted) || (_arg_1)) || (!(_arg_2 == 1)))))) || (!(this.blendMode == _arg_5)));
            };
            return (true);
        }

        public function transformQuad(_arg_1:int, _arg_2:Matrix):void
        {
            mVertexData.transformVertex((_arg_1 * 4), _arg_2, 4);
            mSyncRequired = true;
        }

        public function getVertexColor(_arg_1:int, _arg_2:int):uint
        {
            return (mVertexData.getColor(((_arg_1 * 4) + _arg_2)));
        }

        public function setVertexColor(_arg_1:int, _arg_2:int, _arg_3:uint):void
        {
            mVertexData.setColor(((_arg_1 * 4) + _arg_2), _arg_3);
            mSyncRequired = true;
        }

        public function getVertexAlpha(_arg_1:int, _arg_2:int):Number
        {
            return (mVertexData.getAlpha(((_arg_1 * 4) + _arg_2)));
        }

        public function setVertexAlpha(_arg_1:int, _arg_2:int, _arg_3:Number):void
        {
            mVertexData.setAlpha(((_arg_1 * 4) + _arg_2), _arg_3);
            mSyncRequired = true;
        }

        public function getQuadColor(_arg_1:int):uint
        {
            return (mVertexData.getColor((_arg_1 * 4)));
        }

        public function setQuadColor(_arg_1:int, _arg_2:uint):void
        {
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < 4)
            {
                mVertexData.setColor(((_arg_1 * 4) + _local_3), _arg_2);
                _local_3++;
            };
            mSyncRequired = true;
        }

        public function getQuadAlpha(_arg_1:int):Number
        {
            return (mVertexData.getAlpha((_arg_1 * 4)));
        }

        public function setQuadAlpha(_arg_1:int, _arg_2:Number):void
        {
            var _local_3:int;
            _local_3 = 0;
            while (_local_3 < 4)
            {
                mVertexData.setAlpha(((_arg_1 * 4) + _local_3), _arg_2);
                _local_3++;
            };
            mSyncRequired = true;
        }

        public function setQuad(_arg_1:Number, _arg_2:Quad):void
        {
            var _local_5:Matrix = _arg_2.transformationMatrix;
            var _local_4:Number = _arg_2.alpha;
            var _local_3:int = (_arg_1 * 4);
            _arg_2.copyVertexDataTransformedTo(mVertexData, _local_3, _local_5);
            if (_local_4 != 1)
            {
                mVertexData.scaleAlpha(_local_3, _local_4, 4);
            };
            mSyncRequired = true;
        }

        public function getQuadBounds(_arg_1:int, _arg_2:Matrix=null, _arg_3:Rectangle=null):Rectangle
        {
            return (mVertexData.getBounds(_arg_2, (_arg_1 * 4), 4, _arg_3));
        }

        override public function getBounds(_arg_1:DisplayObject, _arg_2:Rectangle=null):Rectangle
        {
            if (_arg_2 == null)
            {
                _arg_2 = new Rectangle();
            };
            var _local_3:Matrix = ((_arg_1 == this) ? null : getTransformationMatrix(_arg_1, sHelperMatrix));
            return (mVertexData.getBounds(_local_3, 0, (mNumQuads * 4), _arg_2));
        }

        override public function render(_arg_1:RenderSupport, _arg_2:Number):void
        {
            if (mNumQuads)
            {
                if (mBatchable)
                {
                    _arg_1.batchQuadBatch(this, _arg_2);
                }
                else
                {
                    _arg_1.finishQuadBatch();
                    _arg_1.raiseDrawCount();
                    renderCustom(_arg_1.mvpMatrix3D, (alpha * _arg_2), _arg_1.blendMode);
                };
            };
        }

        public function get numQuads():int
        {
            return (mNumQuads);
        }

        public function get tinted():Boolean
        {
            return ((mTinted) || (mForceTinted));
        }

        public function get texture():Texture
        {
            return (mTexture);
        }

        public function get smoothing():String
        {
            return (mSmoothing);
        }

        public function get premultipliedAlpha():Boolean
        {
            return (mVertexData.premultipliedAlpha);
        }

        public function get batchable():Boolean
        {
            return (mBatchable);
        }

        public function set batchable(_arg_1:Boolean):void
        {
            mBatchable = _arg_1;
        }

        public function get forceTinted():Boolean
        {
            return (mForceTinted);
        }

        public function set forceTinted(_arg_1:Boolean):void
        {
            mForceTinted = _arg_1;
        }

        public function get ownsTexture():Boolean
        {
            return (mOwnsTexture);
        }

        public function set ownsTexture(_arg_1:Boolean):void
        {
            mOwnsTexture = _arg_1;
        }

        public function get capacity():int
        {
            return (mVertexData.numVertices / 4);
        }

        public function set capacity(_arg_1:int):void
        {
            var _local_3:int;
            var _local_2:int = capacity;
            if (_arg_1 == _local_2)
            {
                return;
            };
            if (_arg_1 == 0)
            {
                throw (new Error("Capacity must be > 0"));
            };
            if (_arg_1 > 16383)
            {
                _arg_1 = 16383;
            };
            if (mNumQuads > _arg_1)
            {
                mNumQuads = _arg_1;
            };
            mVertexData.numVertices = (_arg_1 * 4);
            mIndexData.length = (_arg_1 * 6);
            _local_3 = _local_2;
            while (_local_3 < _arg_1)
            {
                mIndexData[(_local_3 * 6)] = ((_local_3 * 4) + 0);
                mIndexData[((_local_3 * 6) + 1)] = ((_local_3 * 4) + 1);
                mIndexData[((_local_3 * 6) + 2)] = ((_local_3 * 4) + 2);
                mIndexData[((_local_3 * 6) + 3)] = ((_local_3 * 4) + 1);
                mIndexData[((_local_3 * 6) + 4)] = ((_local_3 * 4) + 3);
                mIndexData[((_local_3 * 6) + 5)] = ((_local_3 * 4) + 2);
                _local_3++;
            };
            destroyBuffers();
            mSyncRequired = true;
        }

        private function getProgram(_arg_1:Boolean):Program3D
        {
            var _local_2:* = null;
            var _local_5:* = null;
            var _local_4:Starling = Starling.current;
            var _local_6:String = "QB_q";
            if (mTexture)
            {
                _local_6 = getImageProgramName(_arg_1, mTexture.mipMapping, mTexture.repeat, mTexture.format, mSmoothing);
            };
            var _local_3:Program3D = _local_4.getProgram(_local_6);
            if (!_local_3)
            {
                if (!mTexture)
                {
                    _local_2 = "m44 op, va0, vc1 \nmul v0, va1, vc0 \n";
                    _local_5 = "mov oc, v0       \n";
                }
                else
                {
                    _local_2 = ((_arg_1) ? "m44 op, va0, vc1 \nmul v0, va1, vc0 \nmov v1, va2      \n" : "m44 op, va0, vc1 \nmov v1, va2      \n");
                    _local_5 = ((_arg_1) ? "tex ft1,  v1, fs0 <???> \nmul  oc, ft1,  v0       \n" : "tex  oc,  v1, fs0 <???> \n");
                    _local_5 = _local_5.replace("<???>", RenderSupport.getTextureLookupFlags(mTexture.format, mTexture.mipMapping, mTexture.repeat, smoothing));
                };
                _local_3 = _local_4.registerProgramFromSource(_local_6, _local_2, _local_5);
            };
            return (_local_3);
        }

        public function set mSyncRequired(_arg_1:Boolean):void
        {
            _mSyncRequired = _arg_1;
        }


    }
}//package starling.display

