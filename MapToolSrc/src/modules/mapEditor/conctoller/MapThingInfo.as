package modules.mapEditor.conctoller
{
	public class MapThingInfo 
	{
		
		public var x:Number;
		public var y:Number;
		public var anchorX:Number;
		public var anchorY:Number;
		public var width:Number;
		public var height:Number;
		public var thingName:String;
		public var taskId:int;
		public var groupId:int;
		public var groupIdStr:String;
		public var type:int;
		public var area:Array;
		public var unWalkArea:Array;
		public var keyManStandArea:Array;
		public var grassArea:Array;
		
		public function MapThingInfo()
		{
			x = 0;
			y = 0;
			anchorX = 0.5;
			anchorY = 0.5;
			taskId = 0;
			groupId = 0;
			groupIdStr = "";
			type = 1;
			area = [];
			unWalkArea = [];
			keyManStandArea = [];
			grassArea = [];
		}
		
	}
}//package modules.mapEditor.conctoller