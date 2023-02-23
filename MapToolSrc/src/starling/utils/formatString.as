// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.formatString

package starling.utils
{
    public function formatString(_arg_1:String, ... _args):String
    {
        var _local_3:int;
        _local_3 = 0;
        while (_local_3 < _args.length)
        {
            _arg_1 = _arg_1.replace(new RegExp((("\\{" + _local_3) + "\\}"), "g"), _args[_local_3]);
            _local_3++;
        };
        return (_arg_1);
    }

}//package starling.utils

