// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//starling.utils.getNextPowerOfTwo

package starling.utils
{
    public function getNextPowerOfTwo(_arg_1:Number):int
    {
        var _local_2:int;
        if ((((_arg_1 is int) && (_arg_1 > 0)) && ((_arg_1 & (_arg_1 - 1)) == 0)))
        {
            return (_arg_1);
        };
        _local_2 = 1;
        _arg_1 = (_arg_1 - 1E-9);
        while (_local_2 < _arg_1)
        {
            _local_2 = (_local_2 << 1);
        };
        return (_local_2);
    }

}//package starling.utils

