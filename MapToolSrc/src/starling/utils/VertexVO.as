// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.VertexVO

package starling.utils
{
    import flash.display3D.VertexBuffer3D;
    import flash.geom.Rectangle;
    import starling.textures.SubTexture;
    import starling.textures.Texture;
    import starling.core.Starling;
    import starling.errors.MissingContextError;

    public class VertexVO 
    {

        public static const SIZE:int = 128;

        public var vertexData:VertexData;
        public var vertexBuffer:VertexBuffer3D;
        public var texId:uint;
        private var width:Number;
        private var height:Number;
        private var isSubTexture:Boolean;
        public var used:int;

        public function VertexVO()
        {
            this.vertexData = new VertexData(4);
            this.vertexData.setUniformColor(0xFFFFFF);
            this.vertexData.setTexCoords(0, 0, 0);
            this.vertexData.setTexCoords(1, 1, 0);
            this.vertexData.setTexCoords(2, 0, 1);
            this.vertexData.setTexCoords(3, 1, 1);
            var _local_1:* = 0;
            this.height = _local_1;
            this.width = _local_1;
            this.createBuffer();
        }

        public function setTexture(_arg_1:Texture):void
        {
            var _local_3:Rectangle = _arg_1.frame;
            var _local_2:Number = ((_local_3) ? _local_3.width : _arg_1.width);
            var _local_4:Number = ((_local_3) ? _local_3.height : _arg_1.height);
            vertexData.setPremultipliedAlpha(_arg_1.premultipliedAlpha);
            this.width = _local_2;
            this.height = _local_4;
            this.vertexData.setPosition(0, 0, 0);
            this.vertexData.setPosition(1, _local_2, 0);
            this.vertexData.setPosition(2, 0, _local_4);
            this.vertexData.setPosition(3, _local_2, _local_4);
            if (this.isSubTexture)
            {
                this.vertexData.setTexCoords(0, 0, 0);
                this.vertexData.setTexCoords(1, 1, 0);
                this.vertexData.setTexCoords(2, 0, 1);
                this.vertexData.setTexCoords(3, 1, 1);
            };
            if ((_arg_1 is SubTexture))
            {
                _arg_1.adjustVertexData(this.vertexData, 0, 4);
                this.isSubTexture = true;
            }
            else
            {
                this.isSubTexture = false;
            };
            this.syncBuffer();
        }

        private function syncBuffer():void
        {
            if (((this.vertexBuffer) && (Starling.current.contextValid)))
            {
                try
                {
                    this.vertexBuffer.uploadFromVector(this.vertexData.rawData, 0, this.vertexData.numVertices);
                }
                catch(e:Error)
                {
                    if (e.errorID == 3694)
                    {
                        Starling.dbgThrowError(e);
                    }
                    else
                    {
                        throw (e);
                    };
                };
            };
        }

        public function reset():void
        {
            this.destroyBuffer();
            this.createBuffer();
            this.syncBuffer();
        }

        public function dispose():void
        {
            this.destroyBuffer();
            this.vertexData = null;
            this.texId = 0;
        }

        private function createBuffer():void
        {
            if (Starling.context == null)
            {
                throw (new MissingContextError());
            };
            if (!Starling.current.contextValid)
            {
                return;
            };
            this.vertexBuffer = Starling.context.createVertexBuffer(this.vertexData.numVertices, 8);
        }

        private function destroyBuffer():void
        {
            if (this.vertexBuffer)
            {
                this.vertexBuffer.dispose();
                this.vertexBuffer = null;
            };
        }


    }
}//package starling.utils

