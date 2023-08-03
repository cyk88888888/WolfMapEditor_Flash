package framework.base {
	
	import flash.utils.Dictionary;
	
	/**
	 * 消息发射器
	 * @author CYK
	 *
	 */
	public class Emiter {
		private var _msgHandler: Dictionary = new Dictionary();
		
		public function Emiter() {
		}
		
		public function emit(event: String, ...args): void {
			var handlers: Array = _msgHandler[event];
			if (!handlers) return;
			for (var i: int = 0; i < handlers.length; i++) {
				var handler: Object = handlers[i];
				if(handler.callBack.length > 0){
					handler.callBack.apply(handler.ctx, args);
				}else{
					handler.callBack.apply(handler.ctx);
				}
			}
		}
		
		public function on(event: String, callBack: Function, ctx: *): void {
			if (!_msgHandler[event]) {
				_msgHandler[event] = [];
			}
			_msgHandler[event].push({callBack: callBack, ctx: ctx});
		}
		
		public function off(event: String, callBack: Function, ctx: *): void {
			var handlers: Array = _msgHandler[event];
			if (!handlers) return;
			var index: int = -1;
			for (var i: int = 0; i < handlers.length; i++) {
				var handler: Object = handlers[i];
				if (handler.callBack == callBack && handler.ctx == ctx) {
					index = i;
					break;
				}
			}
			if (index < 0) return;
			handlers.splice(index, 1);
		}
	}
}