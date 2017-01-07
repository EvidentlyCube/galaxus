package game.global {
	import flash.display.Bitmap;
	import flash.ui.Mouse;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	import net.retrocade.retrocamel.core.RetrocamelInputManager;

	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;

	public class Cursor {
		private static var _layer:RetrocamelLayerFlashSprite;
		private static var _cursor:Bitmap;

		private static var _isVisible:Boolean;


		public static function set isVisible(value:Boolean):void {
			_isVisible = value;
			update();
		}

		public static function init():void{
			_layer = new RetrocamelLayerFlashSprite();
			_cursor = RetrocamelBitmapManager.getBExt(Game._gfx_, 40, 40, 5, 5);
			_cursor.scaleX = _cursor.scaleY = 3;

			_isVisible = true;
		}

		public static function update(e:* = null):void{
			var scale:int = 3;
			if (_cursor && _isVisible){
				var toCursorX:uint = RetrocamelInputManager.mouseX - 0;
				var toCursorY:uint = RetrocamelInputManager.mouseY - 0;

				toCursorX = (toCursorX / scale | 0) * scale;
				toCursorY = (toCursorY / scale | 0) * scale;

				_cursor.x = toCursorX;
				_cursor.y = toCursorY;

				Mouse.hide();
			} else {
				Mouse.show();
			}
		}
	}
}
