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
		public static const Water:String = "GridType_Water";//水域
		public static const WaterVerts:String = "GridType_WaterVerts";//落水点
		public static const Start:String = "GridType_start";
		public static const Trap:String = "GridType_Trap";
		public static const MapThing:String = "GridType_MapThing";
		
		public static const WalkType:int = 1;//可行走
		
		public static const MapThingType_bevel:int = 999;//场景物件 - 斜角顶点
		
	}
}