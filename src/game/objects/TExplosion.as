package game.objects {
	import game.global.Game;

	import net.retrocade.retrocamel.components.RetrocamelDisplayObject;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TExplosion extends RetrocamelDisplayObject {
		[Embed(source="/../src.assets/explosion2.png")]
		public static var _gfx_:Class;

		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(_gfx_, 0, 0, 10, 9);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(_gfx_, 10, 0, 10, 9);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(_gfx_, 20, 0, 10, 9);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(_gfx_, 30, 0, 10, 9);
			__gfx[4] = RetrocamelBitmapManager.getBDExt(_gfx_, 40, 0, 10, 9);
			__gfx[5] = RetrocamelBitmapManager.getBDExt(_gfx_, 50, 0, 10, 9);
			__gfx[6] = RetrocamelBitmapManager.getBDExt(_gfx_, 60, 0, 10, 9);
			__gfx[7] = RetrocamelBitmapManager.getBDExt(_gfx_, 70, 0, 10, 9);
			__gfx[8] = RetrocamelBitmapManager.getBDExt(_gfx_, 80, 0, 10, 9);
		}

		private var frame:uint = 0;
		private var frameTimer:uint = 0;
		private var wait:uint;

		public function TExplosion(x:int, y:int, wait:uint = 0) {
			_width = 10;
			_height = 9;

			center = x;
			middle = y;

			_gfx = __gfx[0];

			addDefault();

			this.wait = wait;
		}

		override public function update():void {
			if (wait) {
				wait--;
				return;
			}

			frameTimer++;
			if (frameTimer == 2) {
				frameTimer = 0;
				frame++;

				if (frame == 9) {
					nullifyDefault();
					return;
				}

				_gfx = __gfx[frame];
			}

			Game.lGame.draw(_gfx, x, y);
		}
	}
}