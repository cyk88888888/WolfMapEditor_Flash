// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//traceInlLDR

package 
{
    import com.common.inltrace.InternalTrace;

    public function traceInlLDR(... _args):void
    {
        var _local_2:String = _args.join(" ");
        if (trace_in_console)
        {
            doTrace(_local_2);
        };
        InternalTrace.addMsg(1, _local_2);
    }

}//package 

