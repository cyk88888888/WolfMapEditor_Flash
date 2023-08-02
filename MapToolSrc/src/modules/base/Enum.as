package modules.base
{
	/**
	 * 公共模块枚举
	 * @author cyk
	 * 
	 */	
	public class Enum
	{
		public static const Msg_Normal:String = "Msg_Normal";
		public static const Msg_MsgBox:String = "Msg_MsgBox";
		public static const None:String = "GridType_None";
		public static const Walk:String = "GridType_walk";
		public static const WaterVerts:String = "GridType_WaterVerts";//落水点
		public static const Start:String = "GridType_start";
		public static const MapThing:String = "GridType_MapThing";
		public static const MapThing1:String = "GridType_MapThing" + MapThingType_light;
		public static const MapThing2:String = "GridType_MapThing" + MapThingTrigger_unWalk;
		public static const MapThing3:String = "GridType_MapThing" + MapThingTrigger_keyManStand;
		public static const MapThing4:String = "GridType_MapThing" + MapThingTrigger_grass;
		
		public static const WalkType:int = 1;//可行走
		
		
		public static const MapThingType_task:int = 1;//场景物件 - 任务
		public static const MapThingType_fence:int = 2;//场景物件 - 围栏
		public static const MapThingType_queen:int = 3;//场景物件 - 皇后
		public static const MapThingType_keyMan:int = 4;//场景物件 - 关键人物
		public static const MapThingType_grass:int = 5;//场景物件 - 草丛
		public static const MapThingType_tree:int = 6;//场景物件 - 树
		public static const MapThingType_beeNest:int = 7;//场景物件 - 蜂窝
		public static const MapThingType_dungeon:int = 8;//场景物件 - 地牢
		public static const MapThingType_dungeonSwitch:int = 9;//场景物件 - 地牢开关
		public static const MapThingType_bevel:int = 999;//场景物件 - 斜角顶点
		
		
		public static const MapThingType_light:int = 1;//场景物件触发类型 - 发亮
		public static const MapThingTrigger_unWalk:int = 2;//场景物件触发类型 - 不可行走范围点列表
		public static const MapThingTrigger_keyManStand:int = 3;//场景物件触发类型 - 关键人物站立范围点列表(引导模式下，传送机器人用)
		public static const MapThingTrigger_grass:int = 4;//场景物件触发类型 - 草丛范围点列表
	}
}