package modules.base
{
	/**
	 * 游戏事件 
	 * @author cyk
	 * 
	 */	
	public class GameEvent
	{
		private static var _next:int = 0;
		
		private static function get next():String {
			_next++;
			return "GameEvent_" + _next;
		}
		public static const ChangeGridType:String = next;//变更格子类型
		public static const ChangeMapThingXY:String = next;//变更场景物件坐标
		public static const ChangeMapThingTriggerType:String = next;//变更场景物件格子触发类型
		public static const ClearLineAndGrid:String  = next;//删除所有线条和格子
		public static const ChangeMap:String  = next;//切换地图
		public static const ImportMapJson:String  = next;//导入地图json数据
		public static const ImportMapThingJson:String  = next;//导入地图物件json数据
		public static const UpdateMapInfo:String  = next;//刷新地图信息
		public static const ResizeGrid:String  = next;//变更格子大小
		public static const ResizeMapSucc:String  = next;//变更地图大小成功
		public static const ScreenShoot:String  = next;//截图绘画区域
		public static const RunDemo:String  = next;//运行demo
		public static const CloseDemo:String  = next;//关闭demo
		public static const ToCenter:String  = next;//到地图中心点
		public static const ToOriginalScale:String  = next;//回归原大小缩放
		public static const ClearAllData:String  = next;//清除所有数据
		public static const DragMapThingStart:String  = next;//开始拖拽场景物件
		public static const DragMapThingDown:String  = next;//放下拖拽场景物件
		public static const ClickMapTing:String  = next;//点击场景物件
		public static const ClickDisplayItem:String  = next;//点击显示列表的场景物件
		public static const UpdateMapTreeStruct:String  = next;//更新地图目录节点
		public static const CheckShowGrid:String  = next;//显隐网格
		public static const CheckShowPath:String  = next;//显隐路点
		public static const CheckShowMapThing:String  = next;//显隐场景物件
		public static const DarwGraphic:String  = next;//绘制指定区域的所有格子
		public static const UpdateMapScale:String  = next;//地图缩放变更
		public static const AddMapThing:String  = next;//添加场景物件
		public static const RemoveMapThing:String  = next;//删除场景物件
		public static const MapThingVisibleChg:String  = next;//场景物件的显隐变更
		public static const ImportMapTingComplete:String  = next;//导入地图时，所有场景物件创建完毕
	}
}