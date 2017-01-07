package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;
	import game.global.Sfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.effects.RetrocamelEffectQuake;
	import net.retrocade.utils.UtilsNumber;

	public class TEnemyRider extends TEnemy {

		private static var __gfx:BitmapData;
		private static var __gfxDamage:BitmapData;

		{
			__gfx = RetrocamelBitmapManager.getBDExt(Game._gfx_, 44, 17, 7, 9);
			__gfxDamage = RetrocamelBitmapManager.getBDSpecial(Game._gfx_, 44, 17, 7, 9, false, 0xFFFFFF);
		}

		private var state:uint = 0;
		private var stateWait:uint = 180;

		public function TEnemyRider(powerLevel:uint = 1, speedLevel:uint = 1, hpLevel:uint = 1) {
			super(powerLevel, speedLevel, hpLevel * 2);

			_width = 7;
			_height = 9;

			y = -50;
			x = Math.random() * (S().levelWidth - width - 10) + 5;

			addDefault();
			addHash();

			_gfx = __gfx;

			stateWait = 210 + Math.random() * (120 - _speedLevel * 30);
		}

		override public function update():void {
			removeHash();

			if (state == 0) {
				stateWait--;
				if (stateWait % 60 > 30 && stateWait < 180)
					drawArrow();

				if (stateWait == 0)
					state = 1;
			} else {
				y += 1 + _speedLevel / 3;

				stateWait++;
				if (stateWait == (20 - _powerLevel * 2) && y < 130) {
					stateWait = 0;
					new TBulletRider(x, y, true);
					new TBulletRider(right, y, false);
					Sfx.sfxEnFire.play();
				}

				if (y > S().levelHeight) {
					state = 0;
					stateWait = 210 + Math.random() * (120 - _speedLevel * 30);
					x = Math.random() * (S().levelWidth - width - 10) + 5;
					y = -50;
				}
			}

			addHash();

			checkPlayerHit();

			if (_damageAnim) {
				_damageAnim--;
				Game.lGame.draw(__gfxDamage, x, y);

			} else
				Game.lGame.draw(__gfx, x, y);

		}

		private function drawArrow():void {
			Game.lGame.shapeRect(_x, 1, 7, 1, 0xFFFFFFFF);
			Game.lGame.shapeRect(_x + 1, 2, 5, 1, 0xFFFFFFFF);
			Game.lGame.shapeRect(_x + 2, 3, 3, 1, 0xFFFFFFFF);
			Game.lGame.shapeRect(_x + 3, 4, 1, 1, 0xFFFFFFFF);
		}

		override public function kill():void {
			super.kill();

			RetrocamelEffectQuake.make().power(5, 5).duration(250).run();

			new TCoin(center, middle, Generator.hp * Generator.hp * 17 + _powerLevel * _powerLevel * 5 + _speedLevel * _speedLevel * 12);
			Score.score.add(Generator.hp * Generator.hp * 17 + _powerLevel * _powerLevel * 5 + _speedLevel * _speedLevel * 12);

			new TExplosion(center, bottom);
			new TExplosion(center, middle, 4);
			new TExplosion(center, y, 8);


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