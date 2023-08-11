package modules.mapEditor.conctoller
{
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
		public var grpId:int;//组id
		public var grpIdStr:String;//斜角顶点组id(1,2)
		public var subGrpIdStr:String;//斜角顶点组id(1,2)
		public var type:int;//物件类型
		public var bevelType:int;//顶点类型
		public var relationType:int;//关联类型
		public var relationParm:String;//关联参数(1,2)
		public var extData: String;//拓展数据
		public var area:Array;//物件触发范围点列表
		public var unWalkArea:Array;//不可行走范围点列表
		public var keyManStandArea:Array;//关键人物站立范围点列表(引导模式下，传送机器人用)
		public var grassArea:Array;//草丛范围点列表
		public function MapThingInfo(){
			x = 0;
			y = 0;
			anchorX = 0.5;
			anchorY = 0.5;
			taskId = 0;
			grpId = 0;
			grpIdStr = "";
			subGrpIdStr = "";
			relationParm = "",
			extData = "",
			type = 0;
			bevelType = 0;
			relationType = 0;
			area = [];
			unWalkArea = [];
			keyManStandArea = [];
			grassArea = [];
		}
	}
}