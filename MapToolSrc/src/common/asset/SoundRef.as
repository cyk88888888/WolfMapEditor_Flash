// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//common.asset.SoundRef

package common.asset
{
    import flash.media.Sound;
    import flash.events.IOErrorEvent;
    import flash.events.Event;
    import common.loader.ResVer;
    import flash.net.URLRequest;

    public class SoundRef extends RefBase 
    {

        public var url:String;
        public var isLoaded:Boolean = false;

        public function SoundRef(_arg_1:Sound)
        {
            super(_arg_1);
            addEvtLsn();
        }

        public function get sound():Sound
        {
            return (this._asset);
        }

        private function addEvtLsn():void
        {
            sound.addEventListener("ioError", evtStopAndClose);
            sound.addEventListener("complete", soundLoadComplete);
        }

        private function removeEvtLsn():void
        {
            sound.removeEventListener("ioError", evtStopAndClose);
            sound.removeEventListener("complete", soundLoadComplete);
        }

        private function evtStopAndClose(_arg_1:IOErrorEvent):void
        {
        }

        protected function soundLoadComplete(_arg_1:Event):void
        {
            isLoaded = true;
            removeEvtLsn();
        }

        public function loadSnd(_arg_1:String):void
        {
            this.url = _arg_1;
            var _local_2:String = ResVer.getVer(_arg_1);
            var _local_3:String = (ResVer.prependResRoot(_arg_1) + _local_2);
            sound.load(new URLRequest(_local_3));
        }


    }
}//package common.asset

