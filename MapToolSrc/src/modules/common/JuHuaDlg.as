package modules.common
{
	import fairygui.GGraph;
	
	import framework.base.Global;
	import framework.ui.UIMsg;

	public class JuHuaDlg extends UIMsg
	{
		protected override function get pkgName():String
		{
			return "Common";
		}
		
		protected override function onEnter():void{
			var mask_gray: GGraph = view.getChild("mask_gray").asGraph;
			mask_gray.width = Global.stage.stageWidth + 500;
			mask_gray.height = Global.stage.stageHeight + 500;
		}
	}
}