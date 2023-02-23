// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.game.SheetUtil

package com.core.game
{
    import com.core.base.TexAreaInfo;
    import flash.utils.ByteArray;

    public class SheetUtil 
    {


        public static function readFrame(_arg_1:TexAreaInfo, _arg_2:ByteArray):void
        {
            _arg_1.name = _arg_2.readUTF();
            _arg_1.x = _arg_2.readUnsignedShort();
            _arg_1.y = _arg_2.readUnsignedShort();
            _arg_1.width = _arg_2.readUnsignedShort();
            _arg_1.height = _arg_2.readUnsignedShort();
            _arg_1.frameX = _arg_2.readShort();
            _arg_1.frameY = _arg_2.readShort();
            _arg_1.frameWidth = _arg_2.readUnsignedShort();
            _arg_1.frameHeight = _arg_2.readUnsignedShort();
        }

        public static function writeFrame(_arg_1:ByteArray, _arg_2:XML):void
        {
            _arg_1.writeUTF(_arg_2.attribute("name"));
            _arg_1.writeShort(parseInt(_arg_2.attribute("x")));
            _arg_1.writeShort(parseInt(_arg_2.attribute("y")));
            _arg_1.writeShort(parseInt(_arg_2.attribute("width")));
            _arg_1.writeShort(parseInt(_arg_2.attribute("height")));
            _arg_1.writeShort(parseInt(_arg_2.attribute("frameX")));
            _arg_1.writeShort(parseInt(_arg_2.attribute("frameY")));
            _arg_1.writeShort(parseInt(_arg_2.attribute("frameWidth")));
            _arg_1.writeShort(parseInt(_arg_2.attribute("frameHeight")));
        }


    }
}//package com.core.game

