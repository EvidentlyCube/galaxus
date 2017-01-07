package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.effects.RetrocamelEffectQuake;
	import net.retrocade.utils.UtilsNumber;

	public class TEnemyCube extends TEnemy {

		private static var __gfx:BitmapData;
		private static var __gfxDamage:BitmapData;

		{
			__gfx = RetrocamelBitmapManager.getBDExt(Game._gfx_, 87, 18, 8, 8);
			__gfxDamage = RetrocamelBitmapManager.getBDSpecial(Game._gfx_, 87, 18, 8, 8, false, 0xFFFFFF);
		}

		private var toX:Number;
		private var toY:Number;

		private var mx:Number = 0;
		private var my:Number = 0;

		private var dist:Number = 0;

		private var nextX:Boolean = false;

		private var timer:uint = 0;

		public function TEnemyCube(powerLevel:uint = 1, speedLevel:uint = 1, hpLevel:uint = 1) {
			super(powerLevel, speedLevel, hpLevel * 3);

			_width = 8;
			_height = 8;

			y = S().levelHeight + 20 + Math.random() * 20;
			x = Math.random() * (S().levelWidth - width - 10) + 5;

			timer = Math.random() * 30 | 0;

			toX = x;
			toY = y;

			addDefault();
			addHash();

			_gfx = __gfx;
		}

		override public function update():void {
			removeHash();

			if (_powerLevel == 1) {
				if (middle == toY)
					toY = player.middle;
				else
					middle = UtilsNumber.approach(middle, toY, 0.1, 0.1, _speedLevel / 6);

			} else if (_powerLevel == 2) {
				if (toX == center && toY == middle) {
					if (nextX)
						toX = player.center;
					else
						toY = player.middle;

					nextX = !nextX;

				} else {
					center = UtilsNumber.approach(center, toX, 0.1, 0.1, _speedLevel / 6);
					middle = UtilsNumber.approach(middle, toY, 0.1, 0.1, _speedLevel / 6);
				}

			} else if (_powerLevel == 3) {
				if (dist <= 0) {
					var dir:Number = Math.atan2(player.middle - middle, player.center - center);
					mx = Math.cos(dir) * _speedLevel / 6;
					my = Math.sin(dir) * _speedLevel / 6;

					dist = Math.sqrt(UtilsNumber.distanceSquared(center, middle, player.center, player.middle)) / (_speedLevel / 6);
				} else {
					x += mx;
					y += my;
					dist--;
				}
			}

			addHash();

			checkPlayerHit();

			if (y > S().levelHeight) {
				timer++;
				if (timer % 30 < 15)
					drawArrow();
			}

			if (_damageAnim) {
				_damageAnim--;
				Game.lGame.draw(__gfxDamage, x, y);

			} else
				Game.lGame.draw(__gfx, x, y);
		}

		private function drawArrow():void {
			Game.lGame.shapeRect(_x, S().levelHeight - 2, 7, 1, 0xFFFFFFFF);
			Game.lGame.shapeRect(_x + 1, S().levelHeight - 3, 5, 1, 0xFFFFFFFF);
			Game.lGame.shapeRect(_x + 2, S().levelHeight - 4, 3, 1, 0xFFFFFFFF);
			Game.lGame.shapeRect(_x + 3, S().levelHeight - 5, 1, 1, 0xFFFFFFFF);
		}

		override public function kill():void {
			super.kill();

			RetrocamelEffectQuake.make().power(8, 8).duration(300).run();

			new TCoin(center, middle, Generator.hp * Generator.hp * 11 + _powerLevel * _powerLevel * 11 + _speedLevel * _speedLevel * 11);
			Score.score.add(Generator.hp * Generator.hp * 11 + _powerLevel * _powerLevel * 11 + _speedLevel * _speedLevel * 11);

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