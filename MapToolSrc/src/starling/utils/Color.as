// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.Color

package starling.utils
{
    import starling.errors.AbstractClassError;

    public class Color 
    {

        public static const WHITE:uint = 0xFFFFFF;
        public static const SILVER:uint = 0xC0C0C0;
        public static const GRAY:uint = 0x808080;
        public static const BLACK:uint = 0;
        public static const RED:uint = 0xFF0000;
        public static const MAROON:uint = 0x800000;
        public static const YELLOW:uint = 0xFFFF00;
        public static const OLIVE:uint = 0x808000;
        public static const LIME:uint = 0xFF00;
        public static const GREEN:uint = 0x8000;
        public static const AQUA:uint = 0xFFFF;
        public static const TEAL:uint = 0x8080;
        public static const BLUE:uint = 0xFF;
        public static const NAVY:uint = 128;
        public static const FUCHSIA:uint = 0xFF00FF;
        public static const PURPLE:uint = 0x800080;

        public function Color()
        {
            throw (new AbstractClassError());
        }

        public static function getAlpha(_arg_1:uint):int
        {
            return ((_arg_1 >> 24) & 0xFF);
        }

        public static function getRed(_arg_1:uint):int
        {
            return ((_arg_1 >> 16) & 0xFF);
        }

        public static function getGreen(_arg_1:uint):int
        {
            return ((_arg_1 >> 8) & 0xFF);
        }

        public static function getBlue(_arg_1:uint):int
        {
            return (_arg_1 & 0xFF);
        }

        public static function rgb(_arg_1:int, _arg_2:int, _arg_3:int):uint
        {
            return (((_arg_1 << 16) | (_arg_2 << 8)) | _arg_3);
        }

        public static function argb(_arg_1:int, _arg_2:int, _arg_3:int, _arg_4:int):uint
        {
            return ((((_arg_1 << 24) | (_arg_2 << 16)) | (_arg_3 << 8)) | _arg_4);
        }


    }
}//package starling.utils

