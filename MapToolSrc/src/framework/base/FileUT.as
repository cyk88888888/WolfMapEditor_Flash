package framework.base
{
	import com.core.loader.LoaderMgr;
	import com.core.loader.ResContent;
	
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	
	/**
	 * 文件I/O工具 
	 * @author cyk
	 * 
	 */	
	public class FileUT
	{
		private static var _inst: FileUT;
		public static function get inst():FileUT
		{
			if(!_inst){
				_inst = new FileUT();
			}
			return _inst;
		}
		
		/**
		 * 打开文件夹选择弹窗并且选中文件夹后返回文件夹目录的完整路径 
		 * @param cb
		 * 
		 */		
		public function openDirectoryBrower(cb:Function = null):void{
			
			var openfile:File = new File();
			openfile.addEventListener(Event.SELECT, onFileSelected);
			openfile.addEventListener(Event.CANCEL, onFileSelected);
			openfile.browseForDirectory("请选择地图文件夹工作目录：");
			function onFileSelected(e:Event):void {
				var path:String;
				if(e.type == Event.SELECT) path = e.currentTarget.nativePath;
				if(cb) cb.call(null, path, e.currentTarget);
			}
		}		
		
		/**
		 * 
		 * 打开文件选择弹窗并且选中文件后返回文件所在目录的完整路径
		 * @param filterStr  文件显示过滤字符串,例如："*.pdf;*.doc;*.txt"
		 * @param cb 选中回调方法
		 * 
		 */		
		public function openFileBrower(filterStr:String = null, cb:Function = null):void{
			var openfile:File = new File();
			openfile.addEventListener(Event.SELECT, onFileSelected);
			openfile.browseForOpen("请选择要导入的json文件：", filterStr ? [new FileFilter(filterStr, filterStr)] : null);
			function onFileSelected(e:Event):void {
				if(cb) cb.call(null, e.currentTarget.nativePath);
			}
		}
		
		/**
		 * 打开文件选择弹窗并且选中文件后返回文件内容 
		 * @param filterStr 文件显示过滤字符串,例如："*.pdf;*.doc;*.txt"
		 * @param cb 选中回调方法
		 * 
		 */		
		public function openFileBrowerAndReturn(filterStr:String, cb:Function = null):void{
			var fileRef:FileReference = new FileReference();
			fileRef.browse([new FileFilter(filterStr, filterStr)]);
			fileRef.addEventListener(Event.SELECT, onFileSelected);
			
			function onFileSelected(e:Event):void {
				fileRef.addEventListener(Event.COMPLETE, onFileLoaded);
				fileRef.load();
			}
			
			function onFileLoaded(e:Event):void {
				if(cb) cb.call(null, e.target.data);
			}
		}
		
		/** 保存json文件*/
		public function saveFileBrower(cb:Function = null):void
		{
			var openfile:File = new File();
			openfile.addEventListener(Event.SELECT, onFileSelected);
			openfile.browseForSave("导出当前地图json数据：");
			function onFileSelected(e:Event):void {
				if(cb) cb.call(null, e.currentTarget.nativePath);
			}
		}
		
		
		/**
		 * 读取文件内容 
		 * @param path 文件所在目录的完整路径
		 * @param cb 回调方法，返回文件内容
		 * @param onError 加载失败回调
		 */		
		public function readAllText(path:String, cb:Function, onError:Function=null):void{
			LoaderMgr.getInstance().removeResource(path);//点击json文件。先移除缓存里的资源，去重新加载
			LoaderMgr.getInstance().load(path,onLoadComplete,true,null,1,100000,null,onErrorComplete);
			
			function onLoadComplete(url:String):void
			{
				var res:ResContent = LoaderMgr.getInstance().getResource(url);
				cb.call(null, String(res.content));
			}
			function onErrorComplete(url:String):void{
				if(onError) onError.call(null, url);
			}
		}
		
		/**
		 * 写入内容到指定文件完整路径
		 * @param path 文件所在目录的完整路径
		 * @param content 写入内容
		 * @param cb
		 * 
		 */		
		public function writeAllText(path:String, content:String, cb:Function = null):void{
			var file:File = new File(path);
			var fs:FileStream = new FileStream();
			fs.open(file,FileMode.WRITE);
			fs.writeUTFBytes(content);
			fs.close();	
			if(cb) cb.call();
		}
		
	}
}