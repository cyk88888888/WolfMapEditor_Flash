// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.NBlendMode

package com.core
{
    public class NBlendMode 
    {

        public static const NORMAL:uint = 0;
        public static const LAYER:uint = 1;
        public static const MULTIPLY:uint = 2;
        public static const SCREEN:uint = 3;
        public static const LIGHTEN:uint = 4;
        public static const DARKEN:uint = 5;
        public static const ADD:uint = 6;
        public static const SUBTRACT:uint = 7;
        public static const DIFFERENCE:uint = 8;
        public static const INVERT:uint = 9;
        public static const OVERLAY:uint = 10;
        public static const HARDLIGHT:uint = 11;
        public static const ALPHA:uint = 12;
        public static const ERASE:uint = 13;
        public static const SHADER:uint = 14;


        public static function getBlendMode(_arg_1:uint):String
        {
            switch (_arg_1)
            {
                case 0:
                    return ("normal");
                case 1:
                    return ("layer");
                case 2:
                    return ("multiply");
                case 3:
                    return ("screen");
                case 4:
                    return ("lighten");
                case 5:
                    return ("darken");
                case 6:
                    return ("add");
                case 7:
                    return ("subtract");
                case 8:
                    return ("difference");
                case 9:
                    return ("invert");
                case 10:
                    return ("overlay");
                case 11:
                    return ("hardlight");
                case 12:
                    return ("alpha");
                case 13:
                    return ("erase");
                case 14:
                    return ("shader");
                default:
                    return ("normal");
            };
        }

        public static function getBlendModeId(_arg_1:String):uint
        {
            switch (_arg_1)
            {
                case "normal":
                    return (0);
                case "layer":
                    return (1);
                case "multiply":
                    return (2);
                case "screen":
                    return (3);
                case "lighten":
                    return (4);
                case "darken":
                    return (5);
                case "add":
                    return (6);
                case "subtract":
                    return (7);
                case "difference":
                    return (8);
                case "invert":
                    return (9);
                case "overlay":
                    return (10);
                case "hardlight":
                    return (11);
                case "alpha":
                    return (12);
                case "erase":
                    return (13);
                case "shader":
                    return (14);
            };
            return (0);
        }


    }
}//package com.core

