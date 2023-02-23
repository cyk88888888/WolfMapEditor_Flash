// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.ui.UIDlg

package framework.ui
{
    import flash.display.Sprite;
    import framework.mgr.SceneMgr;
    import fairygui.GComponent;
    import fairygui.GRoot;
    import fairygui.GButton;
    import flash.events.MouseEvent;
    import com.greensock.TimelineLite;
    import com.greensock.TweenLite;

    public class UIDlg extends UILayer 
    {

        protected var isBgMaskClick:Boolean = true;
        protected var needOpenAnimation:Boolean = true;
        private var bgMask:Sprite;
        public var onClickBtnClose:Function;


        override public function getParent():GComponent
        {
            return (SceneMgr.inst.curScene.dlg);
        }

        override public function onAddToLayer():void
        {
            bgMask = new Sprite();
            bgMask.graphics.beginFill(0, 0.4);
            bgMask.graphics.drawRect(0, 0, GRoot.inst.width, GRoot.inst.height);
            bgMask.graphics.endFill();
            if (isBgMaskClick)
            {
                bgMask.addEventListener("click", onBgMaskClick);
            };
            this.displayListContainer.addChildAt(bgMask, 0);
            var frame:GComponent = ((view.getChild("frame")) ? view.getChild("frame").asCom : null);
            var btn_close:GButton = ((frame) ? frame.getChild("closeButton").asButton : null);
            if (btn_close)
            {
                btn_close.addClickListener(function ():void
                {
                    if (onClickBtnClose)
                    {
                        onClickBtnClose.call(this);
                    };
                    close();
                });
            };
            if (needOpenAnimation)
            {
                OnOpenAnimation();
            };
        }

        private function onBgMaskClick(_arg_1:MouseEvent):void
        {
            close();
        }

        override protected function doClose():void
        {
            if (isBgMaskClick)
            {
                bgMask.removeEventListener("click", onBgMaskClick);
            };
        }

        override protected function OnOpenAnimation():void
        {
            view.setPivot(0.5, 0.5);
            var _local_1:TimelineLite = new TimelineLite();
            _local_1.append(new TweenLite(view, 0.15, {
                "scaleX":1.1,
                "scaleY":1.1
            }));
            _local_1.append(new TweenLite(view, 0.15, {
                "scaleX":1,
                "scaleY":1
            }));
            _local_1.play();
        }


    }
}//package framework.ui

