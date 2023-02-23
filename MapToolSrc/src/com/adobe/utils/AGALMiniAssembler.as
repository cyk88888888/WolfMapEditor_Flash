// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.adobe.utils.AGALMiniAssembler

package com.adobe.utils
{
    import flash.utils.Dictionary;
    import flash.utils.ByteArray;
    import flash.display3D.Program3D;
    import flash.display3D.Context3D;
    import flash.utils.getTimer;
    import flash.utils.*;
    import flash.display3D.*;

    public class AGALMiniAssembler 
    {

        protected static const REGEXP_OUTER_SPACES:RegExp = /^\s+|\s+$/g;
        private static const OPMAP:Dictionary = new Dictionary();
        private static const REGMAP:Dictionary = new Dictionary();
        private static const SAMPLEMAP:Dictionary = new Dictionary();
        private static const MAX_NESTING:int = 4;
        private static const MAX_OPCODES:int = 0x0800;
        private static const FRAGMENT:String = "fragment";
        private static const VERTEX:String = "vertex";
        private static const SAMPLER_TYPE_SHIFT:uint = 8;
        private static const SAMPLER_DIM_SHIFT:uint = 12;
        private static const SAMPLER_SPECIAL_SHIFT:uint = 16;
        private static const SAMPLER_REPEAT_SHIFT:uint = 20;
        private static const SAMPLER_MIPMAP_SHIFT:uint = 24;
        private static const SAMPLER_FILTER_SHIFT:uint = 28;
        private static const REG_WRITE:uint = 1;
        private static const REG_READ:uint = 2;
        private static const REG_FRAG:uint = 32;
        private static const REG_VERT:uint = 64;
        private static const OP_SCALAR:uint = 1;
        private static const OP_SPECIAL_TEX:uint = 8;
        private static const OP_SPECIAL_MATRIX:uint = 16;
        private static const OP_FRAG_ONLY:uint = 32;
        private static const OP_VERT_ONLY:uint = 64;
        private static const OP_NO_DEST:uint = 128;
        private static const OP_VERSION2:uint = 0x0100;
        private static const OP_INCNEST:uint = 0x0200;
        private static const OP_DECNEST:uint = 0x0400;
        private static const MOV:String = "mov";
        private static const ADD:String = "add";
        private static const SUB:String = "sub";
        private static const MUL:String = "mul";
        private static const DIV:String = "div";
        private static const RCP:String = "rcp";
        private static const MIN:String = "min";
        private static const MAX:String = "max";
        private static const FRC:String = "frc";
        private static const SQT:String = "sqt";
        private static const RSQ:String = "rsq";
        private static const POW:String = "pow";
        private static const LOG:String = "log";
        private static const EXP:String = "exp";
        private static const NRM:String = "nrm";
        private static const SIN:String = "sin";
        private static const COS:String = "cos";
        private static const CRS:String = "crs";
        private static const DP3:String = "dp3";
        private static const DP4:String = "dp4";
        private static const ABS:String = "abs";
        private static const NEG:String = "neg";
        private static const SAT:String = "sat";
        private static const M33:String = "m33";
        private static const M44:String = "m44";
        private static const M34:String = "m34";
        private static const DDX:String = "ddx";
        private static const DDY:String = "ddy";
        private static const IFE:String = "ife";
        private static const INE:String = "ine";
        private static const IFG:String = "ifg";
        private static const IFL:String = "ifl";
        private static const ELS:String = "els";
        private static const EIF:String = "eif";
        private static const TED:String = "ted";
        private static const KIL:String = "kil";
        private static const TEX:String = "tex";
        private static const SGE:String = "sge";
        private static const SLT:String = "slt";
        private static const SGN:String = "sgn";
        private static const SEQ:String = "seq";
        private static const SNE:String = "sne";
        private static const VA:String = "va";
        private static const VC:String = "vc";
        private static const VT:String = "vt";
        private static const VO:String = "vo";
        private static const VI:String = "vi";
        private static const FC:String = "fc";
        private static const FT:String = "ft";
        private static const FS:String = "fs";
        private static const FO:String = "fo";
        private static const FD:String = "fd";
        private static const D2:String = "2d";
        private static const D3:String = "3d";
        private static const CUBE:String = "cube";
        private static const MIPNEAREST:String = "mipnearest";
        private static const MIPLINEAR:String = "miplinear";
        private static const MIPNONE:String = "mipnone";
        private static const NOMIP:String = "nomip";
        private static const NEAREST:String = "nearest";
        private static const LINEAR:String = "linear";
        private static const ANISOTROPIC2X:String = "anisotropic2x";
        private static const ANISOTROPIC4X:String = "anisotropic4x";
        private static const ANISOTROPIC8X:String = "anisotropic8x";
        private static const ANISOTROPIC16X:String = "anisotropic16x";
        private static const CENTROID:String = "centroid";
        private static const SINGLE:String = "single";
        private static const IGNORESAMPLER:String = "ignoresampler";
        private static const REPEAT:String = "repeat";
        private static const WRAP:String = "wrap";
        private static const CLAMP:String = "clamp";
        private static const REPEAT_U_CLAMP_V:String = "repeat_u_clamp_v";
        private static const CLAMP_U_REPEAT_V:String = "clamp_u_repeat_v";
        private static const RGBA:String = "rgba";
        private static const DXT1:String = "dxt1";
        private static const DXT5:String = "dxt5";
        private static const VIDEO:String = "video";

        private static var initialized:Boolean = false;

        private var _agalcode:ByteArray = null;
        private var _error:String = "";
        private var debugEnabled:Boolean = false;
        public var verbose:Boolean = false;

        public function AGALMiniAssembler(_arg_1:Boolean=false):void
        {
            debugEnabled = _arg_1;
            if (!initialized)
            {
                init();
            };
        }

        private static function init():void
        {
            initialized = true;
            OPMAP["mov"] = new OpCode("mov", 2, 0, 0);
            OPMAP["add"] = new OpCode("add", 3, 1, 0);
            OPMAP["sub"] = new OpCode("sub", 3, 2, 0);
            OPMAP["mul"] = new OpCode("mul", 3, 3, 0);
            OPMAP["div"] = new OpCode("div", 3, 4, 0);
            OPMAP["rcp"] = new OpCode("rcp", 2, 5, 0);
            OPMAP["min"] = new OpCode("min", 3, 6, 0);
            OPMAP["max"] = new OpCode("max", 3, 7, 0);
            OPMAP["frc"] = new OpCode("frc", 2, 8, 0);
            OPMAP["sqt"] = new OpCode("sqt", 2, 9, 0);
            OPMAP["rsq"] = new OpCode("rsq", 2, 10, 0);
            OPMAP["pow"] = new OpCode("pow", 3, 11, 0);
            OPMAP["log"] = new OpCode("log", 2, 12, 0);
            OPMAP["exp"] = new OpCode("exp", 2, 13, 0);
            OPMAP["nrm"] = new OpCode("nrm", 2, 14, 0);
            OPMAP["sin"] = new OpCode("sin", 2, 15, 0);
            OPMAP["cos"] = new OpCode("cos", 2, 16, 0);
            OPMAP["crs"] = new OpCode("crs", 3, 17, 0);
            OPMAP["dp3"] = new OpCode("dp3", 3, 18, 0);
            OPMAP["dp4"] = new OpCode("dp4", 3, 19, 0);
            OPMAP["abs"] = new OpCode("abs", 2, 20, 0);
            OPMAP["neg"] = new OpCode("neg", 2, 21, 0);
            OPMAP["sat"] = new OpCode("sat", 2, 22, 0);
            OPMAP["m33"] = new OpCode("m33", 3, 23, 16);
            OPMAP["m44"] = new OpCode("m44", 3, 24, 16);
            OPMAP["m34"] = new OpCode("m34", 3, 25, 16);
            OPMAP["ddx"] = new OpCode("ddx", 2, 26, (0x0100 | 0x20));
            OPMAP["ddy"] = new OpCode("ddy", 2, 27, (0x0100 | 0x20));
            OPMAP["ife"] = new OpCode("ife", 2, 28, (((0x80 | 0x0100) | 0x0200) | 0x01));
            OPMAP["ine"] = new OpCode("ine", 2, 29, (((0x80 | 0x0100) | 0x0200) | 0x01));
            OPMAP["ifg"] = new OpCode("ifg", 2, 30, (((0x80 | 0x0100) | 0x0200) | 0x01));
            OPMAP["ifl"] = new OpCode("ifl", 2, 31, (((0x80 | 0x0100) | 0x0200) | 0x01));
            OPMAP["els"] = new OpCode("els", 0, 32, ((((0x80 | 0x0100) | 0x0200) | 0x0400) | 0x01));
            OPMAP["eif"] = new OpCode("eif", 0, 33, (((0x80 | 0x0100) | 0x0400) | 0x01));
            OPMAP["kil"] = new OpCode("kil", 1, 39, (0x80 | 0x20));
            OPMAP["tex"] = new OpCode("tex", 3, 40, (0x20 | 0x08));
            OPMAP["sge"] = new OpCode("sge", 3, 41, 0);
            OPMAP["slt"] = new OpCode("slt", 3, 42, 0);
            OPMAP["sgn"] = new OpCode("sgn", 2, 43, 0);
            OPMAP["seq"] = new OpCode("seq", 3, 44, 0);
            OPMAP["sne"] = new OpCode("sne", 3, 45, 0);
            SAMPLEMAP["rgba"] = new Sampler("rgba", 8, 0);
            SAMPLEMAP["dxt1"] = new Sampler("dxt1", 8, 1);
            SAMPLEMAP["dxt5"] = new Sampler("dxt5", 8, 2);
            SAMPLEMAP["video"] = new Sampler("video", 8, 3);
            SAMPLEMAP["2d"] = new Sampler("2d", 12, 0);
            SAMPLEMAP["3d"] = new Sampler("3d", 12, 2);
            SAMPLEMAP["cube"] = new Sampler("cube", 12, 1);
            SAMPLEMAP["mipnearest"] = new Sampler("mipnearest", 24, 1);
            SAMPLEMAP["miplinear"] = new Sampler("miplinear", 24, 2);
            SAMPLEMAP["mipnone"] = new Sampler("mipnone", 24, 0);
            SAMPLEMAP["nomip"] = new Sampler("nomip", 24, 0);
            SAMPLEMAP["nearest"] = new Sampler("nearest", 28, 0);
            SAMPLEMAP["linear"] = new Sampler("linear", 28, 1);
            SAMPLEMAP["anisotropic2x"] = new Sampler("anisotropic2x", 28, 2);
            SAMPLEMAP["anisotropic4x"] = new Sampler("anisotropic4x", 28, 3);
            SAMPLEMAP["anisotropic8x"] = new Sampler("anisotropic8x", 28, 4);
            SAMPLEMAP["anisotropic16x"] = new Sampler("anisotropic16x", 28, 5);
            SAMPLEMAP["centroid"] = new Sampler("centroid", 16, 1);
            SAMPLEMAP["single"] = new Sampler("single", 16, 2);
            SAMPLEMAP["ignoresampler"] = new Sampler("ignoresampler", 16, 4);
            SAMPLEMAP["repeat"] = new Sampler("repeat", 20, 1);
            SAMPLEMAP["wrap"] = new Sampler("wrap", 20, 1);
            SAMPLEMAP["clamp"] = new Sampler("clamp", 20, 0);
            SAMPLEMAP["clamp_u_repeat_v"] = new Sampler("clamp_u_repeat_v", 20, 2);
            SAMPLEMAP["repeat_u_clamp_v"] = new Sampler("repeat_u_clamp_v", 20, 3);
        }


        public function get error():String
        {
            return (_error);
        }

        public function get agalcode():ByteArray
        {
            return (_agalcode);
        }

        public function assemble2(_arg_1:Context3D, _arg_2:uint, _arg_3:String, _arg_4:String):Program3D
        {
            var _local_6:ByteArray = assemble("vertex", _arg_3, _arg_2);
            var _local_7:ByteArray = assemble("fragment", _arg_4, _arg_2);
            var _local_5:Program3D = _arg_1.createProgram();
            _local_5.upload(_local_6, _local_7);
            return (_local_5);
        }

        public function assemble(_arg_1:String, _arg_2:String, _arg_3:uint=1, _arg_4:Boolean=false):ByteArray
        {
            var _local_43:int;
            var _local_30:* = null;
            var _local_22:int;
            var _local_28:int;
            var _local_5:* = null;
            var _local_34:* = null;
            var _local_10:* = null;
            var _local_17:* = null;
            var _local_44:Boolean;
            var _local_39:uint;
            var _local_29:uint;
            var _local_41:int;
            var _local_35:Boolean;
            var _local_16:* = null;
            var _local_27:* = null;
            var _local_9:* = null;
            var _local_15:* = null;
            var _local_19:uint;
            var _local_49:uint;
            var _local_50:* = null;
            var _local_33:Boolean;
            var _local_7:Boolean;
            var _local_24:uint;
            var _local_20:uint;
            var _local_8:int;
            var _local_18:uint;
            var _local_31:uint;
            var _local_42:int;
            var _local_11:* = null;
            var _local_26:* = null;
            var _local_6:* = null;
            var _local_38:* = null;
            var _local_46:uint;
            var _local_13:uint;
            var _local_12:Number;
            var _local_45:* = null;
            var _local_36:* = null;
            var _local_37:uint;
            var _local_14:uint;
            var _local_48:* = null;
            var _local_23:uint = getTimer();
            _agalcode = new ByteArray();
            _error = "";
            var _local_47:Boolean;
            if (_arg_1 == "fragment")
            {
                _local_47 = true;
            }
            else
            {
                if (_arg_1 != "vertex")
                {
                    _error = (('ERROR: mode needs to be "fragment" or "vertex" but is "' + _arg_1) + '".');
                };
            };
            agalcode.endian = "littleEndian";
            agalcode.writeByte(160);
            agalcode.writeUnsignedInt(_arg_3);
            agalcode.writeByte(161);
            agalcode.writeByte(((_local_47) ? 1 : 0));
            initregmap(_arg_3, _arg_4);
            var _local_25:Array = _arg_2.replace(/[\f\n\r\v]+/g, "\n").split("\n");
            var _local_40:int;
            var _local_21:int;
            var _local_32:int = _local_25.length;
            _local_43 = 0;
            while (((_local_43 < _local_32) && (_error == "")))
            {
                _local_30 = new String(_local_25[_local_43]);
                _local_30 = _local_30.replace(REGEXP_OUTER_SPACES, "");
                _local_22 = _local_30.search("//");
                if (_local_22 != -1)
                {
                    _local_30 = _local_30.slice(0, _local_22);
                };
                _local_28 = _local_30.search(/<.*>/g);
                if (_local_28 != -1)
                {
                    _local_5 = _local_30.slice(_local_28).match(/([\w\.\-\+]+)/gi);
                    _local_30 = _local_30.slice(0, _local_28);
                };
                _local_34 = _local_30.match(/^\w{3}/gi);
                if (!_local_34)
                {
                    if (_local_30.length >= 3)
                    {
                        (trace(((("warning: bad line " + _local_43) + ": ") + _local_25[_local_43])));
                    };
                }
                else
                {
                    _local_10 = OPMAP[_local_34[0]];
                    if (debugEnabled)
                    {
                        (trace(_local_10));
                    };
                    if (_local_10 == null)
                    {
                        if (_local_30.length >= 3)
                        {
                            (trace(((("warning: bad line " + _local_43) + ": ") + _local_25[_local_43])));
                        };
                    }
                    else
                    {
                        _local_30 = _local_30.slice((_local_30.search(_local_10.name) + _local_10.name.length));
                        if (((_local_10.flags & 0x0100) && (_arg_3 < 2)))
                        {
                            _error = "error: opcode requires version 2.";
                            break;
                        };
                        if (((_local_10.flags & 0x40) && (_local_47)))
                        {
                            _error = "error: opcode is only allowed in vertex programs.";
                            break;
                        };
                        if (((_local_10.flags & 0x20) && (!(_local_47))))
                        {
                            _error = "error: opcode is only allowed in fragment programs.";
                            break;
                        };
                        if (verbose)
                        {
                            (trace(("emit opcode=" + _local_10)));
                        };
                        agalcode.writeUnsignedInt(_local_10.emitCode);
                        if (++_local_21 > 0x0800)
                        {
                            _error = "error: too many opcodes. maximum is 2048.";
                            break;
                        };
                        _local_17 = _local_30.match(/vc\[([vof][acostdip]?)(\d*)?(\.[xyzw](\+\d{1,3})?)?\](\.[xyzw]{1,4})?|([vof][acostdip]?)(\d*)?(\.[xyzw]{1,4})?/gi);
                        if (((!(_local_17)) || (!(_local_17.length == _local_10.numRegister))))
                        {
                            _error = (((("error: wrong number of operands. found " + _local_17.length) + " but expected ") + _local_10.numRegister) + ".");
                            break;
                        };
                        _local_44 = false;
                        _local_39 = 160;
                        _local_29 = _local_17.length;
                        _local_41 = 0;
                        while (_local_41 < _local_29)
                        {
                            _local_35 = false;
                            _local_16 = _local_17[_local_41].match(/\[.*\]/gi);
                            if (((_local_16) && (_local_16.length > 0)))
                            {
                                _local_17[_local_41] = _local_17[_local_41].replace(_local_16[0], "0");
                                if (verbose)
                                {
                                    (trace("IS REL"));
                                };
                                _local_35 = true;
                            };
                            _local_27 = _local_17[_local_41].match(/^\b[A-Za-z]{1,2}/gi);
                            if (!_local_27)
                            {
                                _error = (((("error: could not parse operand " + _local_41) + " (") + _local_17[_local_41]) + ").");
                                _local_44 = true;
                                break;
                            };
                            _local_9 = REGMAP[_local_27[0]];
                            if (debugEnabled)
                            {
                                (trace(_local_9));
                            };
                            if (_local_9 == null)
                            {
                                _error = (((("error: could not find register name for operand " + _local_41) + " (") + _local_17[_local_41]) + ").");
                                _local_44 = true;
                                break;
                            };
                            if (_local_47)
                            {
                                if (!(_local_9.flags & 0x20))
                                {
                                    _error = (((("error: register operand " + _local_41) + " (") + _local_17[_local_41]) + ") only allowed in vertex programs.");
                                    _local_44 = true;
                                    break;
                                };
                                if (_local_35)
                                {
                                    _error = (((("error: register operand " + _local_41) + " (") + _local_17[_local_41]) + ") relative adressing not allowed in fragment programs.");
                                    _local_44 = true;
                                    break;
                                };
                            }
                            else
                            {
                                if (!(_local_9.flags & 0x40))
                                {
                                    _error = (((("error: register operand " + _local_41) + " (") + _local_17[_local_41]) + ") only allowed in fragment programs.");
                                    _local_44 = true;
                                    break;
                                };
                            };
                            _local_17[_local_41] = _local_17[_local_41].slice((_local_17[_local_41].search(_local_9.name) + _local_9.name.length));
                            _local_15 = ((_local_35) ? _local_16[0].match(/\d+/) : _local_17[_local_41].match(/\d+/));
                            _local_19 = 0;
                            if (_local_15)
                            {
                                _local_19 = _local_15[0];
                            };
                            if (_local_9.range < _local_19)
                            {
                                _error = (((((("error: register operand " + _local_41) + " (") + _local_17[_local_41]) + ") index exceeds limit of ") + (_local_9.range + 1)) + ".");
                                _local_44 = true;
                                break;
                            };
                            _local_49 = 0;
                            _local_50 = _local_17[_local_41].match(/(\.[xyzw]{1,4})/);
                            _local_33 = ((_local_41 == 0) && (!(_local_10.flags & 0x80)));
                            _local_7 = ((_local_41 == 2) && (_local_10.flags & 0x08));
                            _local_24 = 0;
                            _local_20 = 0;
                            _local_8 = 0;
                            if (((_local_33) && (_local_35)))
                            {
                                _error = "error: relative can not be destination";
                                _local_44 = true;
                                break;
                            };
                            if (_local_50)
                            {
                                _local_49 = 0;
                                _local_31 = _local_50[0].length;
                                _local_42 = 1;
                                while (_local_42 < _local_31)
                                {
                                    _local_18 = (_local_50[0].charCodeAt(_local_42) - "x".charCodeAt(0));
                                    if (_local_18 > 2)
                                    {
                                        _local_18 = 3;
                                    };
                                    if (_local_33)
                                    {
                                        _local_49 = (_local_49 | (1 << _local_18));
                                    }
                                    else
                                    {
                                        _local_49 = (_local_49 | (_local_18 << ((_local_42 - 1) << 1)));
                                    };
                                    _local_42++;
                                };
                                if (!_local_33)
                                {
                                    while (_local_42 <= 4)
                                    {
                                        _local_49 = (_local_49 | (_local_18 << ((_local_42 - 1) << 1)));
                                        _local_42++;
                                    };
                                };
                            }
                            else
                            {
                                _local_49 = ((_local_33) ? 15 : 228);
                            };
                            if (_local_35)
                            {
                                _local_11 = _local_16[0].match(/[A-Za-z]{1,2}/gi);
                                _local_26 = REGMAP[_local_11[0]];
                                if (_local_26 == null)
                                {
                                    _error = "error: bad index register";
                                    _local_44 = true;
                                    break;
                                };
                                _local_24 = _local_26.emitCode;
                                _local_6 = _local_16[0].match(/(\.[xyzw]{1,1})/);
                                if (_local_6.length == 0)
                                {
                                    _error = "error: bad index register select";
                                    _local_44 = true;
                                    break;
                                };
                                _local_20 = (_local_6[0].charCodeAt(1) - "x".charCodeAt(0));
                                if (_local_20 > 2)
                                {
                                    _local_20 = 3;
                                };
                                _local_38 = _local_16[0].match(/\+\d{1,3}/gi);
                                if (_local_38.length > 0)
                                {
                                    _local_8 = _local_38[0];
                                };
                                if (((_local_8 < 0) || (_local_8 > 0xFF)))
                                {
                                    _error = (("error: index offset " + _local_8) + " out of bounds. [0..255]");
                                    _local_44 = true;
                                    break;
                                };
                                if (verbose)
                                {
                                    (trace(((((((((((("RELATIVE: type=" + _local_24) + "==") + _local_11[0]) + " sel=") + _local_20) + "==") + _local_6[0]) + " idx=") + _local_19) + " offset=") + _local_8)));
                                };
                            };
                            if (verbose)
                            {
                                (trace((((((("  emit argcode=" + _local_9) + "[") + _local_19) + "][") + _local_49) + "]")));
                            };
                            if (_local_33)
                            {
                                agalcode.writeShort(_local_19);
                                agalcode.writeByte(_local_49);
                                agalcode.writeByte(_local_9.emitCode);
                                _local_39 = (_local_39 - 32);
                            }
                            else
                            {
                                if (_local_7)
                                {
                                    if (verbose)
                                    {
                                        (trace("  emit sampler"));
                                    };
                                    _local_46 = 5;
                                    _local_13 = ((_local_5 == null) ? 0 : _local_5.length);
                                    _local_12 = 0;
                                    _local_42 = 0;
                                    while (_local_42 < _local_13)
                                    {
                                        if (verbose)
                                        {
                                            (trace(("    opt: " + _local_5[_local_42])));
                                        };
                                        _local_45 = SAMPLEMAP[_local_5[_local_42]];
                                        if (_local_45 == null)
                                        {
                                            _local_12 = _local_5[_local_42];
                                            if (verbose)
                                            {
                                                (trace(("    bias: " + _local_12)));
                                            };
                                        }
                                        else
                                        {
                                            if (_local_45.flag != 16)
                                            {
                                                _local_46 = (_local_46 & (~(15 << _local_45.flag)));
                                            };
                                            _local_46 = (_local_46 | (_local_45.mask << _local_45.flag));
                                        };
                                        _local_42++;
                                    };
                                    agalcode.writeShort(_local_19);
                                    agalcode.writeByte((_local_12 * 8));
                                    agalcode.writeByte(0);
                                    agalcode.writeUnsignedInt(_local_46);
                                    if (verbose)
                                    {
                                        (trace(("    bits: " + (_local_46 - 5))));
                                    };
                                    _local_39 = (_local_39 - 64);
                                }
                                else
                                {
                                    if (_local_41 == 0)
                                    {
                                        agalcode.writeUnsignedInt(0);
                                        _local_39 = (_local_39 - 32);
                                    };
                                    agalcode.writeShort(_local_19);
                                    agalcode.writeByte(_local_8);
                                    agalcode.writeByte(_local_49);
                                    agalcode.writeByte(_local_9.emitCode);
                                    agalcode.writeByte(_local_24);
                                    agalcode.writeShort(((_local_35) ? (_local_20 | 0x8000) : 0));
                                    _local_39 = (_local_39 - 64);
                                };
                            };
                            _local_41++;
                        };
                        _local_41 = 0;
                        while (_local_41 < _local_39)
                        {
                            agalcode.writeByte(0);
                            _local_41 = (_local_41 + 8);
                        };
                        if (_local_44) break;
                    };
                };
                _local_43++;
            };
            if (_error != "")
            {
                _error = (_error + ((("\n  at line " + _local_43) + " ") + _local_25[_local_43]));
                agalcode.length = 0;
                (trace(_error));
            };
            if (debugEnabled)
            {
                _local_36 = "generated bytecode:";
                _local_37 = agalcode.length;
                _local_14 = 0;
                while (_local_14 < _local_37)
                {
                    if (!(_local_14 % 16))
                    {
                        _local_36 = (_local_36 + "\n");
                    };
                    if (!(_local_14 % 4))
                    {
                        _local_36 = (_local_36 + " ");
                    };
                    _local_48 = agalcode[_local_14].toString(16);
                    if (_local_48.length < 2)
                    {
                        _local_48 = ("0" + _local_48);
                    };
                    _local_36 = (_local_36 + _local_48);
                    _local_14++;
                };
                (trace(_local_36));
            };
            if (verbose)
            {
                (trace((("AGALMiniAssembler.assemble time: " + ((getTimer() - _local_23) / 1000)) + "s")));
            };
            return (agalcode);
        }

        private function initregmap(_arg_1:uint, _arg_2:Boolean):void
        {
            REGMAP["va"] = new Register("va", "vertex attribute", 0, ((_arg_2) ? 0x0400 : (((_arg_1 == 1) || (_arg_1 == 2)) ? 7 : 15)), (0x40 | 0x02));
            REGMAP["vc"] = new Register("vc", "vertex constant", 1, ((_arg_2) ? 0x0400 : ((_arg_1 == 1) ? 127 : 249)), (0x40 | 0x02));
            REGMAP["vt"] = new Register("vt", "vertex temporary", 2, ((_arg_2) ? 0x0400 : ((_arg_1 == 1) ? 7 : 25)), ((0x40 | 0x01) | 0x02));
            REGMAP["vo"] = new Register("vo", "vertex output", 3, ((_arg_2) ? 0x0400 : 0), (0x40 | 0x01));
            REGMAP["vi"] = new Register("vi", "varying", 4, ((_arg_2) ? 0x0400 : ((_arg_1 == 1) ? 7 : 9)), (((0x40 | 0x20) | 0x02) | 0x01));
            REGMAP["fc"] = new Register("fc", "fragment constant", 1, ((_arg_2) ? 0x0400 : ((_arg_1 == 1) ? 27 : ((_arg_1 == 2) ? 63 : 199))), (0x20 | 0x02));
            REGMAP["ft"] = new Register("ft", "fragment temporary", 2, ((_arg_2) ? 0x0400 : ((_arg_1 == 1) ? 7 : 25)), ((0x20 | 0x01) | 0x02));
            REGMAP["fs"] = new Register("fs", "texture sampler", 5, ((_arg_2) ? 0x0400 : 7), (0x20 | 0x02));
            REGMAP["fo"] = new Register("fo", "fragment output", 3, ((_arg_2) ? 0x0400 : ((_arg_1 == 1) ? 0 : 3)), (0x20 | 0x01));
            REGMAP["fd"] = new Register("fd", "fragment depth output", 6, ((_arg_2) ? 0x0400 : ((_arg_1 == 1) ? -1 : 0)), (0x20 | 0x01));
            REGMAP["op"] = REGMAP["vo"];
            REGMAP["i"] = REGMAP["vi"];
            REGMAP["v"] = REGMAP["vi"];
            REGMAP["oc"] = REGMAP["fo"];
            REGMAP["od"] = REGMAP["fd"];
            REGMAP["fi"] = REGMAP["vi"];
        }


    }
}//package com.adobe.utils

class OpCode 
{

    /*private*/ var _emitCode:uint;
    /*private*/ var _flags:uint;
    /*private*/ var _name:String;
    /*private*/ var _numRegister:uint;

    public function OpCode(_arg_1:String, _arg_2:uint, _arg_3:uint, _arg_4:uint)
    {
        _name = _arg_1;
        _numRegister = _arg_2;
        _emitCode = _arg_3;
        _flags = _arg_4;
    }

    public function get emitCode():uint
    {
        return (_emitCode);
    }

    public function get flags():uint
    {
        return (_flags);
    }

    public function get name():String
    {
        return (_name);
    }

    public function get numRegister():uint
    {
        return (_numRegister);
    }

    public function toString():String
    {
        return (((((((('[OpCode name="' + _name) + '", numRegister=') + _numRegister) + ", emitCode=") + _emitCode) + ", flags=") + _flags) + "]");
    }


}

class Register 
{

    /*private*/ var _emitCode:uint;
    /*private*/ var _name:String;
    /*private*/ var _longName:String;
    /*private*/ var _flags:uint;
    /*private*/ var _range:uint;

    public function Register(_arg_1:String, _arg_2:String, _arg_3:uint, _arg_4:uint, _arg_5:uint)
    {
        _name = _arg_1;
        _longName = _arg_2;
        _emitCode = _arg_3;
        _range = _arg_4;
        _flags = _arg_5;
    }

    public function get emitCode():uint
    {
        return (_emitCode);
    }

    public function get longName():String
    {
        return (_longName);
    }

    public function get name():String
    {
        return (_name);
    }

    public function get flags():uint
    {
        return (_flags);
    }

    public function get range():uint
    {
        return (_range);
    }

    public function toString():String
    {
        return (((((((((('[Register name="' + _name) + '", longName="') + _longName) + '", emitCode=') + _emitCode) + ", range=") + _range) + ", flags=") + _flags) + "]");
    }


}

class Sampler 
{

    /*private*/ var _flag:uint;
    /*private*/ var _mask:uint;
    /*private*/ var _name:String;

    public function Sampler(_arg_1:String, _arg_2:uint, _arg_3:uint)
    {
        _name = _arg_1;
        _flag = _arg_2;
        _mask = _arg_3;
    }

    public function get flag():uint
    {
        return (_flag);
    }

    public function get mask():uint
    {
        return (_mask);
    }

    public function get name():String
    {
        return (_name);
    }

    public function toString():String
    {
        return (((((('[Sampler name="' + _name) + '", flag="') + _flag) + '", mask=') + mask) + "]");
    }


}


