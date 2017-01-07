package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.effects.RetrocamelEffectQuake;
	import net.retrocade.utils.UtilsNumber;

	public class TEnemyGlobe extends TEnemy {

		private static var __gfx:Array = [];
		private static var __gfxDamage:BitmapData;

		{
			__gfx = [];
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 33, 19, 5, 5);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 33, 25, 5, 5);
			__gfx[2] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 33, 31, 5, 5);
			__gfx[3] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 33, 37, 5, 5);


			__gfxDamage = RetrocamelBitmapManager.getBDSpecial(Game._gfx_, 33, 19, 5, 5, false, 0xFFFFFF);
		}

		private var toX:Number;
		private var toY:Number;
		private var speed:Number;

		public function TEnemyGlobe(powerLevel:uint = 1, speedLevel:uint = 1, hpLevel:uint = 1) {
			super(powerLevel, speedLevel, hpLevel);

			speed = (speedLevel - 1) / 3 + Math.random() * 0.2 + 0.1;

			_width = _height = 5;

			x = Math.random() * (S().levelWidth - width - 10) + 5;
			y = -5 - Math.random() * 15;

			toX = Math.random() * (S().levelWidth - width - 10) + 5;
			toY = Math.random() * 50 + 5;

			addDefault();
			addHash();

			_gfx = __gfx[0];

			switch (Math.random() * 20 | 0) {
				case(0):
					if (_powerLevel < 3) {
						_powerLevel++;
						_gfx = __gfx[1];
					}
					break;

				case(1):
					_speedLevel += 1 / 3;
					_gfx = __gfx[2];
					break;

				case(2):
					_hp *= 2;
					_gfx = __gfx[3];
					break;
			}
		}

		override public function update():void {
			removeHash();

			if (_powerLevel == 2) {
				if (Math.abs(player.center - center) < 30 && Math.abs(player.middle - middle) < 30)
					x += player.center > center ? 0.2 : -0.2;

			} else if (_powerLevel == 3) {
				x += player.center > center ? 0.2 : -0.2;
			}

			y += speed;

			if (y > S().levelHeight)
				y = -15;

			addHash();

			checkPlayerHit();

			if (_damageAnim) {
				_damageAnim--;
				Game.lGame.draw(__gfxDamage, x, y);

			} else
				Game.lGame.draw(_gfx, x, y);
		}

		override public function kill():void {
			super.kill();

			RetrocamelEffectQuake.make().power(5, 5).duration(150).run();

			new TCoin(center, middle, Generator.hp * Generator.hp * 15 + _powerLevel * _powerLevel * 6 + _speedLevel * _speedLevel * 6);
			Score.score.add(Generator.hp * Generator.hp * 15 + _powerLevel * _powerLevel * 6 + _speedLevel * _speedLevel * 6);

			new TExplosion(center, middle);

			for (var i:uint = 0; i < _width; i++) {
				for (var j:uint = 0; j < _height; j++) {
					Game.partPixel.add(_x + i, _y + j, _gfx.getPixel32(i, j),
						UtilsNumber.randomWaved(15, 14),
						UtilsNumber.randomWaved(0, 80), UtilsNumber.randomWaved(0, 80));
				}
			}
		}
	}
}