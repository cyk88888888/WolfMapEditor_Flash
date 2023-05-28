package modules.mapEditor.conctoller
{
	import __AS3__.vec.Vector;
	
	public class MapJsonInfo 
	{
		
		public var mapWidth:int;
		public var mapHeight:int;
		public var totRow:int;
		public var totCol:int;
		public var cellSize:int;
		public var walkList:Array;
		public var blockList:Array;
		public var blockVertList:Array;
		public var waterList:Array;
		public var waterVertList:Array;
		public var startList:Array;
		public var mapThingList:Vector.<MapThingInfo>;
		public var borderList:Array;
		
		public function MapJsonInfo()
		{
			walkList = [];
			blockList = [];
			blockVertList = [];
			waterList = [];
			waterVertList = [];
			startList = [];
			mapThingList = new Vector.<MapThingInfo>();
			borderList = [];
		}
		
	}
}//package modules.mapEditor.conctoller
