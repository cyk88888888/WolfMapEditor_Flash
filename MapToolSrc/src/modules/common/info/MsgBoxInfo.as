// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.common.info.MsgBoxInfo

package modules.common.info
{
    public class MsgBoxInfo 
    {

        public var msg:String;
        public var onOk:Function;
        public var onCancel:Function;

        public function MsgBoxInfo(_arg_1:String, _arg_2:Function=null, _arg_3:Function=null)
        {
            msg = _arg_1;
            onOk = _arg_2;
            onCancel = _arg_3;
        }

    }
}//package modules.common.info

