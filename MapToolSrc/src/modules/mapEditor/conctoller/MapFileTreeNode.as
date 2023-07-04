package modules.mapEditor.conctoller
{
	/**
	 * 地图资源目录节点信息 
	 * @author cyk
	 * 
	 */	
	public class MapFileTreeNode
	{
		public var isDir:Boolean;//是否为文件夹
		public var fileArr:Vector.<MapFileTreeNode>;//文件列表
		public var path:String;//文件完整路径
		public var name:String;//文件名
		public function MapFileTreeNode()
		{
			
		}
	}
}