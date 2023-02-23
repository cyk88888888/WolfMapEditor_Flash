// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//traceInl0

package 
{
    import com.common.inltrace.InternalTrace;

    public function traceInl0(... _args):Boolean
    {
        var _local_2:String = _args.join(" ");
        if (trace_in_console)
        {
            doTrace(_local_2);
        };
        InternalTrace.addMsg(7, _local_2);
        return (true);
    }

}//package 

