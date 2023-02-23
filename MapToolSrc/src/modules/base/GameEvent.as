// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//modules.base.GameEvent

package modules.base
{
    public class GameEvent 
    {

        public static const ChangeGridType:String = next;
        public static const ClearGridType:String = next;
        public static const ClearLineAndGrid:String = next;
        public static const ChangeMap:String = next;
        public static const ImportMapJson:String = next;
        public static const UpdateMapInfo:String = next;
        public static const ResizeGrid:String = next;
        public static const ResizeMap:String = next;
        public static const ResizeMapSucc:String = next;
        public static const ScreenShoot:String = next;
        public static const RunDemo:String = next;
        public static const CloseDemo:String = next;
        public static const ToCenter:String = next;
        public static const ToOriginalScale:String = next;
        public static const ClearAllData:String = next;
        public static const DragMapThingStart:String = next;
        public static const DragMapThingDown:String = next;
        public static const ClickMapTing:String = next;
        public static const UpdateMapTreeStruct:String = next;
        public static const CheckShowGrid:String = next;

        private static var _next:int = 0;


        private static function get next():String
        {
            _next++;
            return ("GameEvent_" + _next);
        }


    }
}//package modules.base

