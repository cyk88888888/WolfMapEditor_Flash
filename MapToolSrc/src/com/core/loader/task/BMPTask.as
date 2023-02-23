// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.task.BMPTask

package com.core.loader.task
{
    import com.core.imagedecode.ParallelDecoding;
    import flash.display.Bitmap;
    import flash.display.LoaderInfo;
    import flash.utils.ByteArray;

    public class BMPTask extends ResTask 
    {


        override public function step():Boolean
        {
            switch (_state)
            {
                case 0:
                    _state = 2;
                    ParallelDecoding.getInstance().decode(_bytes, false, onLoadComplete, _url);
                    break;
                case 2:
                    break;
                case 4:
                    clearBytes();
                    return (true);
                default:
            };
            return (false);
        }

        private function onLoadComplete(_arg_1:LoaderInfo, _arg_2:ByteArray):void
        {
            _content = (_arg_1.content as Bitmap).bitmapData;
            _state = 4;
        }


    }
}//package com.core.loader.task

