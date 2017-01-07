package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;
	import game.global.Sfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.effects.RetrocamelEffectQuake;
	import net.retrocade.utils.UtilsNumber;

	public class TEnemyPiffer extends TEnemy {

		private static var __gfx:BitmapData;
		private static var __gfxDamage:BitmapData;

		{
			__gfx = RetrocamelBitmapManager.getBDExt(Game._gfx_, 2, 19, 5, 4);
			__gfxDamage = RetrocamelBitmapManager.getBDSpecial(Game._gfx_, 2, 19, 5, 4, false, 0xFFFFFF);
		}

		private var toX:Number;
		private var toY:Number;

		private var fireWait:uint;

		public function TEnemyPiffer(powerLevel:uint = 1, speedLevel:uint = 1, hpLevel:uint = 1) {
			super(powerLevel, speedLevel, hpLevel);

			_width = 5;
			_height = 4;

			y = -5;
			x = Math.random() * (S().levelWidth - width - 10) + 5;

			toX = x;
			toY = Math.random() * 50 + 5;

			addDefault();
			addHash();

			resetFireWait();

			_gfx = __gfx;
		}

		private function resetFireWait():void {
			fireWait = 60 + Math.random() * (270 - _powerLevel * 60)
		}

		override public function update():void {
			removeHash();

			if (y != toY) {
				y = UtilsNumber.approach(y, toY, 0.1, 0.1, 0.2 * _speedLevel);
				if (y == toY)
					resetFireWait();

			} else {
				if (_powerLevel == 1) {
					if (x == toX) {
						toX = Math.random() * (S().levelWidth - _width - 10) + 5;
					} else
						x = UtilsNumber.approach(x, toX, 0.1, 0.1, 0.2 * _speedLevel);

				} else if (_powerLevel == 2) {
					if (x == toX) {
						toX = player.center - _width / 2;
					} else
						x = UtilsNumber.approach(x, toX, 0.1, 0.1, 0.2 * _speedLevel);
				} else if (_powerLevel == 3) {
					x = UtilsNumber.approach(x, player.center - _width / 2, 0.1, 0.1, 0.2 * _speedLevel);
				}
			}

			if (fireWait-- == 0) {
				resetFireWait();
				new TBulletPiffer(center, y);
				Sfx.sfxEnFire.play();
			}

			addHash();

			checkPlayerHit();

			if (_damageAnim) {
				_damageAnim--;
				Game.lGame.draw(__gfxDamage, x, y);

			} else
				Game.lGame.draw(__gfx, x, y);

		}

		override public function kill():void {
			super.kill();

			RetrocamelEffectQuake.make().power(5, 5).duration(150).run();

			new TCoin(center, middle, Generator.hp * Generator.hp * 12 + _powerLevel * _powerLevel * 7 + _speedLevel * _speedLevel * 7);
			Score.score.add(Generator.hp * Generator.hp * 12 + _powerLevel * _powerLevel * 7 + _speedLevel * _speedLevel * 7);

			new TExplosion(center, middle);

			for (var i:uint = 0; i < _width; i++) {
				for (var j:uint = 0; j < _height; j++) {
					Game.partPixel.add(_x + i, _y + j, __gfx.getPixel32(i, j),
						UtilsNumber.randomWaved(15, 14),
						UtilsNumber.randomWaved(0, 80), UtilsNumber.randomWaved(0, 80));
				}
			}
		}
	}
}