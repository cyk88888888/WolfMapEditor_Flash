package modules.mapEditor.conctoller
{
	public class MapJsonInfo
	{
		public var mapWidth:int;//地图宽
		public var mapHeight:int;//地图高
		public var totRow:int;//总行数
		public var totCol:int;//总列数
		public var cellSize:int;//格子大小
		public var walkList: Array;//可行走和不可行走列表，1为可行走，0为不可行走
		public var waterList:Array;//水域格子列表
		public var waterVertList:Array;//落水点列表
		public var startList:Array;//起始点列表
		public var trapList:Array;//陷阱点列表
		public var mapThingList:Array;//场景物件信息列表MapThingInfo
		public var borderList: Array;//边界顶点列表 => [{x:1, y:1, grpIds:[1,2], subGrpIds:[1,2]},{x:2, y2, grpIds:[1], subGrpIds:[1,2]}]
		public function MapJsonInfo()
		{
			walkList = [];
			waterList = [];
			waterVertList = [];
			trapList = [];
			startList = [];
			mapThingList = [];
			borderList = [];
		}
	}
}