package modules.mapEditor.conctoller
{
	import fairygui.GButton;

	/**
	 * 场景物件显示列表数据 
	 * @author cyk
	 * 
	 */	
	public class MapThingDisplay
	{
		public var mapThing:GButton;//场景物件实体
		public var data:MapThingInfo;//物件数据
		public var name: String;//物件名称
		public var isLock: Boolean;//是否锁住（为true时，不可点击）
		public var visible: Boolean;//是否可见
		public function MapThingDisplay()
		{
			visible = true;
		}
	}
}