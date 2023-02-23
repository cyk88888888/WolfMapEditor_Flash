// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.execute

package starling.utils
{
    public function execute(_arg_1:Function, ... _args):void
    {
        var _local_4:int;
        var _local_3:int;
        if (_arg_1 != null)
        {
            _local_3 = _arg_1.length;
            _local_4 = _args.length;
            while (_local_4 < _local_3)
            {
                _args[_local_4] = null;
                _local_4++;
            };
            switch (_local_3)
            {
                case 0:
                    (_arg_1());
                    return;
                case 1:
                    (_arg_1(_args[0]));
                    return;
                case 2:
                    (_arg_1(_args[0], _args[1]));
                    return;
                case 3:
                    (_arg_1(_args[0], _args[1], _args[2]));
                    return;
                case 4:
                    (_arg_1(_args[0], _args[1], _args[2], _args[3]));
                    return;
                case 5:
                    (_arg_1(_args[0], _args[1], _args[2], _args[3], _args[4]));
                    return;
                case 6:
                    (_arg_1(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5]));
                    return;
                case 7:
                    (_arg_1(_args[0], _args[1], _args[2], _args[3], _args[4], _args[5], _args[6]));
                    return;
                default:
                    _arg_1.apply(null, _args.slice(0, _local_3));
            };
        };
    }

}//package starling.utils

