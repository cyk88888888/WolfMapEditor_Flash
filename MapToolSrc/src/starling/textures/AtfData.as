// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.textures.AtfData

package starling.textures
{
    import flash.utils.ByteArray;

    public class AtfData 
    {

        public static var _instance:AtfData;

        private var mFormat:String;
        private var mWidth:int;
        private var mHeight:int;
        private var mNumTextures:int;
        private var mIsCubeMap:Boolean;
        private var mData:ByteArray;


        public static function getInstance():AtfData
        {
            if (!_instance)
            {
                _instance = new (AtfData)();
            };
            return (_instance);
        }

        public static function isAtfData(_arg_1:ByteArray):Boolean
        {
            var _local_2:Boolean;
            if (_arg_1.length < 3)
            {
                return (false);
            };
            return (((65 == _arg_1[0]) && (84 == _arg_1[1])) && (70 == _arg_1[2]));
        }


        public function parse(_arg_1:ByteArray):void
        {
            var _local_3:Boolean;
            var _local_2:int;
            if (!isAtfData(_arg_1))
            {
                throw (new ArgumentError("Invalid ATF data"));
            };
            if (_arg_1[6] == 0xFF)
            {
                _arg_1.position = 12;
            }
            else
            {
                _arg_1.position = 6;
            };
            var _local_4:uint = _arg_1.readUnsignedByte();
            switch ((_local_4 & 0x7F))
            {
                case 0:
                case 1:
                    mFormat = "bgra";
                    break;
                case 2:
                case 3:
                case 12:
                    mFormat = "compressed";
                    break;
                case 4:
                case 5:
                case 13:
                    mFormat = "compressedAlpha";
                    break;
                default:
                    throw (new Error("Invalid ATF format"));
            };
            mWidth = Math.pow(2, _arg_1.readUnsignedByte());
            mHeight = Math.pow(2, _arg_1.readUnsignedByte());
            mNumTextures = _arg_1.readUnsignedByte();
            mIsCubeMap = (!((_local_4 & 0x80) == 0));
            mData = _arg_1;
            if (((!(_arg_1[5] == 0)) && (_arg_1[6] == 0xFF)))
            {
                _local_3 = ((_arg_1[5] & 0x01) == 1);
                _local_2 = ((_arg_1[5] >> 1) & 0x7F);
                mNumTextures = ((_local_3) ? 1 : _local_2);
            };
        }

        public function get format():String
        {
            return (mFormat);
        }

        public function get width():int
        {
            return (mWidth);
        }

        public function get height():int
        {
            return (mHeight);
        }

        public function get numTextures():int
        {
            return (mNumTextures);
        }

        public function get isCubeMap():Boolean
        {
            return (mIsCubeMap);
        }

        public function get data():ByteArray
        {
            return (mData);
        }


    }
}//package starling.textures

