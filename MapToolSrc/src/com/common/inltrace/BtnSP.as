// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.common.inltrace.BtnSP

package com.common.inltrace
{
    import flash.display.Sprite;
    import flash.text.TextFormat;
    import flash.text.TextField;
    import flash.events.MouseEvent;

    public class BtnSP extends Sprite 
    {

        public static var tfm:TextFormat = new TextFormat("NSimSun", 12, 0x222222);

        public var onClickFun:Function = new Function();
        private var _tf:TextField = new TextField();
        private var _label:String = "";
        public var ctrl:Boolean = false;

        public function BtnSP(_arg_1:String, _arg_2:int, _arg_3:int, _arg_4:Function):void
        {
            this.x = _arg_2;
            this.y = _arg_3;
            this.onClickFun = _arg_4;
            tfm.color = 16764006;
            _tf.defaultTextFormat = tfm;
            _tf.text = (_label = _arg_1);
            _tf.width = (_tf.textWidth + 20);
            _tf.height = (_tf.textHeight + 10);
            _tf.mouseEnabled = false;
            _tf.x = 5;
            _tf.y = 5;
            this.addChild(_tf);
            this.graphics.beginFill(0);
            this.graphics.drawRect(0, 0, this.width, this.height);
            this.addEventListener("click", onMouseClick);
        }

        private function onMouseClick(_arg_1:MouseEvent):void
        {
            ctrl = _arg_1.ctrlKey;
            onClickFun(this._label, this); //not popped
        }

        public function get label():String
        {
            return (_label);
        }


    }
}//package com.common.inltrace

