// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.core.loader.task.SWFTask

package com.core.loader.task
{
    import com.core.imagedecode.ParallelDecoding;
    import com.core.loader.LoaderMgr;
    import flash.display.MovieClip;
    import com.core.loader.SwfAnimData;
    import common.util.DspUtils;
    import flash.display.LoaderInfo;
    import flash.utils.ByteArray;

    public class SWFTask extends ResTask 
    {

        private var _join:Boolean;


        override public function step():Boolean
        {
            var _local_1:Boolean;
            switch (_state)
            {
                case 0:
                    _local_1 = ((_url.indexOf("ui/") == 0) || (isApp(_url)));
                    _join = _local_1;
                    loadSwf();
                    _state = 2;
                    break;
                case 3:
                    break;
                case 4:
                    clearBytes();
                    return (true);
                default:
            };
            return (false);
        }

        private function loadSwf():void
        {
            ParallelDecoding.getInstance().decode(_bytes, _join, onImageDecoded, _url);
        }

        private function onImageDecoded(_arg_1:LoaderInfo, _arg_2:ByteArray):void
        {
            var _local_4:* = null;
            var _local_5:Boolean;
            var _local_3:* = null;
            _content = 1;
            if (!_join)
            {
                LoaderMgr.getInstance().domainCache[_url] = _arg_1.applicationDomain;
            };
            if (((isApp(_url)) || (!(_url.indexOf("swf/uiMcFx/") == -1))))
            {
                _content = _arg_1.content;
            }
            else
            {
                _local_4 = (_arg_1.content as MovieClip);
                if (_local_4)
                {
                    _local_5 = (!(_url.indexOf("swf/uiFx/") == -1));
                    if (_local_5)
                    {
                        if (((!(_join)) && (_local_4)))
                        {
                            _local_3 = new SwfAnimData();
                            _local_3.parse(_arg_1.applicationDomain, _url);
                            _content = _local_3;
                        };
                    };
                    DspUtils.playMovieClip(_local_4, false);
                };
            };
            _state = 4;
        }

        private function isApp(_arg_1:String):Boolean
        {
            return ((!(_arg_1.indexOf("modules/") == -1)) || (!(_arg_1.indexOf("xmArpg.swf") == -1)));
        }


    }
}//package com.core.loader.task

