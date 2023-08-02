package framework.base
{
	import flash.utils.Dictionary;
	
	public class Emiter 
	{
		
		private var _msgHandler:Dictionary = new Dictionary();
		
		
		public function emit(event:String, ... _args):void
		{
			var _local_4:int;
			var _local_3:* = null;
			var _local_5:Array = _msgHandler[event];
			if (!_local_5)
			{
				return;
			};
			_local_4 = 0;
			while (_local_4 < _local_5.length)
			{
				_local_3 = _local_5[_local_4];
				if (_local_3.callBack.length > 0)
				{
					_local_3.callBack.apply(_local_3.ctx, _args);
				}
				else
				{
					_local_3.callBack.apply(_local_3.ctx);
				};
				_local_4++;
			};
		}
		
		public function on(event:String, callBack:Function, ctx:*):void{
			if (!_msgHandler[event]){
				_msgHandler[event] = [];
			};
			_msgHandler[event].push({"callBack":callBack,"ctx":ctx});
		}
		
		public function off(event:String, callBack:Function, ctx:*):void
		{
			var _local_6:int;
			var _local_5:* = null;
			var _local_7:Array = _msgHandler[event];
			if (!_local_7)
			{
				return;
			};
			var _local_4:int = -1;
			_local_6 = 0;
			while (_local_6 < _local_7.length)
			{
				_local_5 = _local_7[_local_6];
				if (((_local_5.callBack == callBack) && (_local_5.ctx == ctx)))
				{
					_local_4 = _local_6;
					break;
				};
				_local_6++;
			};
			if (_local_4 < 0)
			{
				return;
			};
			_local_7.splice(_local_4, 1);
		}
		
		
	}
}//package framework.base
