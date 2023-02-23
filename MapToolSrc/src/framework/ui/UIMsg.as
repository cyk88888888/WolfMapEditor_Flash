// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.ui.UIMsg

package framework.ui
{
    import framework.mgr.SceneMgr;
    import fairygui.GComponent;

    public class UIMsg extends UILayer 
    {


        override public function getParent():GComponent
        {
            return (SceneMgr.inst.curScene.msg);
        }


    }
}//package framework.ui

