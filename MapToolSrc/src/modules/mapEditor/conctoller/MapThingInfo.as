package modules.mapEditor.conctoller
{
	import modules.base.Enum;

	public class MapThingInfo
	{
		public var x:Number;//物件坐标X
		public var y:Number;//物件坐标Y
		public var anchorX:Number;//物件锚点X
		public var anchorY:Number;//物件锚点Y
		public var width: Number;//物件宽
		public var height: Number;//物件高
		public var thingName:String;//物件名称
		public var taskId:int;//任务id
		public var groupId:int;//组id
		public var groupIdStr:String;//斜角顶点组id(1,2)
		public var type:int;//物件类型
		public var area:Array;//物件触发范围点列表
		public var unWalkArea:Array;//不可行走范围点列表
		public var keyManStandArea:Array;//关键人物站立范围点列表(引导模式下，传送机器人用)
		public var grassArea:Array;//草丛范围点列表
		public function MapThingInfo()
		{
			x = 0;
			y = 0;
			anchorX = 0.5;
			anchorY = 0.5;
			taskId = 0;
			groupId = 0;
			groupIdStr = "";
			type = Enum.MapThingType_task;
			area = [];
			unWalkArea = [];
			keyManStandArea = [];
			grassArea = [];
		}
	}
}