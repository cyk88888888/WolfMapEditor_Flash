// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.base.IAnimData

package com.core.base
{
    import com.core.IRefDispose;
    import __AS3__.vec.Vector;

    public /*dynamic*/ interface IAnimData extends IRefDispose 
    {

        function get url():String;
        function get frameRate():int;
        function get origX():int;
        function get origY():int;
        function get blendMode():String;
        function get hasOrigin():Boolean;
        function get frameDatas():Vector.<FrameData>;

    }
}//package com.core.base

