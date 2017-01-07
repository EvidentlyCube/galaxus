package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Generator;

	public class TBulletRider extends TGameObject {
		private static var __gfx:Array;

		{
			__gfx = [];

			__gfx[0] = new BitmapData(4, 4, true, 0);
			__gfx[0].setPixel32(0, 0, 0xFFFFFFFF);
			__gfx[0].setPixel32(1, 1, 0xFFFFFFFF);
			__gfx[0].setPixel32(2, 2, 0xFFFFFFFF);
			__gfx[0].setPixel32(3, 3, 0xFFFFFFFF);

			__gfx[1] = new BitmapData(4, 4, true, 0);
			__gfx[1].setPixel32(0, 3, 0xFFFFFFFF);
			__gfx[1].setPixel32(1, 2, 0xFFFFFFFF);
			__gfx[1].setPixel32(2, 1, 0xFFFFFFFF);
			__gfx[1].setPixel32(3, 0, 0xFFFFFFFF);
		}

		private var left:Boolean;

		public function TBulletRider(x:Number, y:Number, left:Boolean) {
			_x = x;
			_y = y;

			this.left = left;

			if (left)
				_gfx = __gfx[0];
			else
				_gfx = __gfx[1];

			_width = 1;
			_height = 1;

			addDefault();
		}

		override public function update():void {
			var spd:Number = 1 + Generator.speed / 3;

			_x += left ? -spd : spd;
			_y -= spd;

			if (y < -5 || x < -5 || x > S().levelWidth + 5) {
				kill();
				return;
			}

			checkPlayerHit();

			Game.lGame.draw(_gfx, x, y);
		}
	}
}