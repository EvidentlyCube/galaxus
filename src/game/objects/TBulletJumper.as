package game.objects {
	import game.global.Game;
	import game.global.Generator;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TBulletJumper extends TGameObject {

		private static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 78, 63, 5, 5);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 84, 62, 4, 6);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 89, 63, 5, 5);
		}

		private var mx:Number;
		private var my:Number;

		public function TBulletJumper(x:Number, y:Number, angle:Number) {
			_width = 5;
			_height = 5;

			center = x;
			middle = y;

			mx = Math.cos(angle) * (1 + Generator.speed / 3);
			my = Math.sin(angle) * (1 + Generator.speed / 3);

			angle = angle * 180 / Math.PI;

			if (angle > 112.5)
				_gfx = __gfx[0];
			else if (angle > 67.5)
				_gfx = __gfx[1];
			else
				_gfx = __gfx[2];

			addDefault();
		}

		override public function update():void {
			_x += mx;
			_y += my;

			if (y > S().levelHeight || x < -_width || x > S().levelWidth) {
				kill();
				return;
			}

			checkPlayerHit();

			Game.lGame.draw(_gfx, x, y);
		}
	}
}