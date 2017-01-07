package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TPlayerEffect extends RetrocamelUpdatableObject {
		public static var _gfx:BitmapData;

		{
			_gfx = RetrocamelBitmapManager.getBDExt(Game._gfx_, 49, 50, 9, 5);
		}

		private var x:uint;
		private var y:uint;
		private var alpha:uint = 255;

		public function TPlayerEffect(x:uint, y:uint) {
			this.x = x;
			this.y = y;

			addDefault();
		}

		override public function update():void {
			alpha -= 15;

			if (alpha == 0) {
				nullifyDefault();
				return;
			}

			var c:uint = 0x0000FF | (alpha << 24);

			Game.lBG.drawColor(_gfx, x, y, c);
		}
	}
}