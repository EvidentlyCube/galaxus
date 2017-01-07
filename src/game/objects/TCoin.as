package game.objects {
	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;
	import game.global.Sfx;

	import net.retrocade.collision.RetrocamelSimpleCollider;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.utils.UtilsNumber;

	public class TCoin extends TGameObject {
		public static var __gfx:Array;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 64, 44, 5, 5);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 69, 44, 5, 5);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 74, 44, 5, 5);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 79, 44, 5, 5);
		}

		private var _value:uint;
		private var _frame:uint = 0;
		private var _alpha:Number = 0;

		public function TCoin(x:uint, y:uint, value:uint) {
			_width = 5;
			_height = 5;

			center = x;
			middle = y;

			_value = value;

			addDefault();
		}

		override public function update():void {
			y += 0.3;

			if (RetrocamelSimpleCollider.rectRect(_x | 0, _y | 0, _width | 0, _height | 0, player.x, player.y, player.width, player.height) &&
				RetrocamelSimpleCollider.bitmap(player.gfx, player.x | 0, player.y | 0, 1, 1, 0,
					_gfx, _x | 0, _y | 0, 1, 1, 0)) {

				kill();
				Score.cash.add(_value * 2 * 2);
				Generator.coinsCollected.add(1);

				if (Score.cash.get() >= 15000 && TPlayer.speedLevel == 0 &&
					TPlayer.backShotLevel == 0 && TPlayer.bulletsLevel == 0 && TPlayer.frontShotLevel == 0)


					if (Score.highestCash.get() < Score.cash.get()) {
						Score.highestCash.set(Score.cash.get());
					}

				Sfx.sfxCoin.play();
				return;
			}

			if (y > S().levelHeight)
				kill();

			if (_alpha < 1)
				_alpha = UtilsNumber.limit(_alpha + 0.025, 1);

			_frame = (_frame + 1) % 16;
			_gfx = __gfx[_frame / 4 | 0];

			Game.lGame.drawAdvanced(_gfx, x, y, 0, 1, 1, null, false, _alpha);
		}
	}
}