// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.base.ModuleCfgInfo

package framework.base
{
    public class ModuleCfgInfo 
    {

        public var targetClass:Class;
        public var cacheEnabled:Boolean;
        public var preResList:Array;
        public var name:String;

        public function ModuleCfgInfo(_arg_1:Class, _arg_2:Array, _arg_3:Boolean)
        {
            targetClass = _arg_1;
            name = BaseUT.getClassNameByObj(_arg_1);
            cacheEnabled = _arg_3;
            preResList = _arg_2;
        }

    }
}//package framework.base

