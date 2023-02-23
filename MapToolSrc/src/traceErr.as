// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//traceErr

package 
{
    import com.common.inltrace.InternalTrace;

    public function traceErr(... _args):void
    {
        var _local_2:* = null;
        try
        {
            _local_2 = _args.join(" ");
            InternalTrace.addMsg(0, _local_2, true);
        }
        catch(e:Error)
        {
        };
    }

}//package 

