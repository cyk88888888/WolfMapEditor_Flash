// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.common.mgr.MsgMgr

package modules.common.mgr
{
    import fairygui.GComponent;
    import fairygui.UIPackage;
    import fairygui.GTextField;
    import framework.mgr.SceneMgr;
    import com.greensock.TweenMax;
    import framework.mgr.ModuleMgr;
    import modules.common.MsgBoxDlg;
    import modules.common.info.MsgBoxInfo;

    public class MsgMgr 
    {


        public static function ShowMsg(_arg_1:String, _arg_2:String="Msg_Normal", _arg_3:Function=null, _arg_4:Function=null):void
        {
            var msg = _arg_1;
            var msgType = _arg_2;
            var onOk = _arg_3;
            var onCancel = _arg_4;
            if (msgType == "Msg_Normal")
            {
                var msgTip:GComponent = UIPackage.createObject("Common", "MsgTip").asCom;
                var txt_msg:GTextField = msgTip.getChild("txt_msg").asTextField;
                txt_msg.text = msg;
                if (txt_msg.textWidth > 300)
                {
                    msgTip.width = (txt_msg.textWidth + 20);
                };
                SceneMgr.inst.curScene.msg.addChild(msgTip);
                msgTip.setXY(((msgTip.parent.width - msgTip.width) / 2), (((msgTip.parent.height - msgTip.height) / 2) - 200));
                TweenMax.to(msgTip, 0.3, {
                    "y":(msgTip.y - 100),
                    "delay":0.5,
                    "onComplete":function ():void
                    {
                        msgTip.dispose();
                    }
                });
            }
            else
            {
                if (msgType == "Msg_MsgBox")
                {
                    ModuleMgr.inst.showLayer(MsgBoxDlg, new MsgBoxInfo(msg, onOk, onCancel));
                };
            };
        }


    }
}//package modules.common.mgr

