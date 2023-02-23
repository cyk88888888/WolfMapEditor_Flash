// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.ui.UILayer

package framework.ui
{
    import framework.mgr.SceneMgr;
    import fairygui.GComponent;

    public class UILayer extends UIComp 
    {

        public var onCloseCb:Function;


        public function getParent():GComponent
        {
            return (SceneMgr.inst.curScene.layer);
        }

        public function onAddToLayer():void
        {
        }

        protected function OnOpenAnimation():void
        {
        }

        protected function onCloseAnimation(_arg_1:Function):void
        {
            if (_arg_1 != null)
            {
                _arg_1.call(this);
            };
        }

        public function close():void
        {
            onCloseAnimation(function ():void
            {
                doClose();
                if (onCloseCb)
                {
                    onCloseCb.call(this);
                };
                __dispose();
                destory();
            });
        }

        protected function doClose():void
        {
        }


    }
}//package framework.ui

