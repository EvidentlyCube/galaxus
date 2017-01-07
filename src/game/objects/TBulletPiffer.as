package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Generator;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TBulletPiffer extends TGameObject {
		private static var __gfx:BitmapData;

		{
			__gfx = RetrocamelBitmapManager.getBDExt(Game._gfx_, 74, 64, 1, 5);
		}

		public function TBulletPiffer(x:Number, y:Number) {
			_x = x;
			_y = y;

			_width = 1;
			_height = 5;

			addDefault();

			_gfx = __gfx;
		}

		override public function update():void {
			y += 1 + Generator.speed / 3;

			if (y > S().levelHeight) {
				kill();
				return;
			}

			checkPlayerHit();

			Game.lGame.draw(_gfx, x, y);
		}
	}
}