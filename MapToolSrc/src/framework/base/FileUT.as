// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//framework.base.FileUT

package framework.base
{
    import flash.events.Event;
    import flash.filesystem.File;
    import flash.net.FileFilter;
    import flash.net.FileReference;
    import com.core.loader.LoaderMgr;
    import com.core.loader.ResContent;
    import flash.filesystem.FileStream;

    public class FileUT 
    {

        private static var _inst:FileUT;


        public static function get inst():FileUT
        {
            if (!_inst)
            {
                _inst = new (FileUT)();
            };
            return (_inst);
        }


        public function openDirectoryBrower(_arg_1:Function=null):void
        {
            var cb = _arg_1;
            var onFileSelected = function (_arg_1:Event):void
            {
                var _local_2:* = null;
                if (_arg_1.type == "select")
                {
                    _local_2 = _arg_1.currentTarget.nativePath;
                };
                if (cb)
                {
                    cb.call(null, _local_2, _arg_1.currentTarget);
                };
            };
            var openfile:File = new File();
            openfile.addEventListener("select", onFileSelected);
            openfile.addEventListener("cancel", onFileSelected);
            openfile.browseForDirectory("请选择地图文件夹工作目录：");
        }

        public function openFileBrower(_arg_1:String=null, _arg_2:Function=null):void
        {
            var filterStr = _arg_1;
            var cb = _arg_2;
            var onFileSelected = function (_arg_1:Event):void
            {
                if (cb)
                {
                    cb.call(null, _arg_1.currentTarget.nativePath);
                };
            };
            var openfile:File = new File();
            openfile.addEventListener("select", onFileSelected);
            openfile.browseForOpen("请选择要导入的json文件：", ((filterStr) ? [new FileFilter(filterStr, filterStr)] : null));
        }

        public function openFileBrowerAndReturn(_arg_1:String, _arg_2:Function=null):void
        {
            var filterStr = _arg_1;
            var cb = _arg_2;
            var onFileSelected = function (_arg_1:Event):void
            {
                fileRef.addEventListener("complete", onFileLoaded);
                fileRef.load();
            };
            var onFileLoaded = function (_arg_1:Event):void
            {
                if (cb)
                {
                    cb.call(null, _arg_1.target.data);
                };
            };
            var fileRef:FileReference = new FileReference();
            fileRef.browse([new FileFilter(filterStr, filterStr)]);
            fileRef.addEventListener("select", onFileSelected);
        }

        public function saveFileBrower(_arg_1:Function=null):void
        {
            var cb = _arg_1;
            var onFileSelected = function (_arg_1:Event):void
            {
                if (cb)
                {
                    cb.call(null, _arg_1.currentTarget.nativePath);
                };
            };
            var openfile:File = new File();
            openfile.addEventListener("select", onFileSelected);
            openfile.browseForSave("导出当前地图json数据：");
        }

        public function readAllText(_arg_1:String, _arg_2:Function, _arg_3:Function=null):void
        {
            var path = _arg_1;
            var cb = _arg_2;
            var onError = _arg_3;
            var onLoadComplete = function (_arg_1:String):void
            {
                var _local_2:ResContent = LoaderMgr.getInstance().getResource(_arg_1);
                cb.call(null, _local_2.content);
            };
            var onErrorComplete = function (_arg_1:String):void
            {
                if (onError)
                {
                    onError.call(null, _arg_1);
                };
            };
            LoaderMgr.getInstance().removeResource(path);
            LoaderMgr.getInstance().load(path, onLoadComplete, true, null, 1, 100000, null, onErrorComplete);
        }

        public function writeAllText(_arg_1:String, _arg_2:String, _arg_3:Function=null):void
        {
            var _local_4:File = new File(_arg_1);
            var _local_5:FileStream = new FileStream();
            _local_5.open(_local_4, "write");
            _local_5.writeUTFBytes(_arg_2);
            _local_5.close();
            if (_arg_3)
            {
                _arg_3.call();
            };
        }


    }
}//package framework.base

