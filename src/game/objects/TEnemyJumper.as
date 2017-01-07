package game.objects {
	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;
	import game.global.Sfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.effects.RetrocamelEffectQuake;
	import net.retrocade.utils.UtilsNumber;

	public class TEnemyJumper extends TEnemy {

		private static var __gfx:Array;
		private static var __gfxDamage:Array;

		{
			__gfx = [];
			__gfxDamage = [];

			__gfx[0] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 12, 18, 8, 6);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 21, 18, 8, 6);
			__gfxDamage[0] = RetrocamelBitmapManager.getBDSpecial(Game._gfx_, 12, 18, 8, 6, false, 0xFFFFFF);
			__gfxDamage[1] = RetrocamelBitmapManager.getBDSpecial(Game._gfx_, 21, 18, 8, 6, false, 0xFFFFFF);
		}

		private var toX:Number;
		private var toY:Number;

		private var state:uint = 0;
		private var stateWait:uint = 0;
		private var fireCount:uint;
		private var fireWait:uint;
		private var fireAngle:Number;
		private var fireAngleDelta:Number;

		private var alpha:Number = 0;

		private var frame:Number = 0;

		public function TEnemyJumper(powerLevel:uint = 1, speedLevel:uint = 1, hpLevel:uint = 1) {
			super(powerLevel, speedLevel, hpLevel * 2);

			_width = 8;
			_height = 6;

			y = Math.random() * 55 + 5;
			x = Math.random() * (S().levelWidth - _width - 10) + 5;

			addDefault();
			addHash();

			_gfx == __gfx[0];
		}


		private function calculateFire():void {
			fireCount = 1 + _powerLevel * 2;

			if (Math.random() < 0.5) {
				fireAngle = Math.PI / 4;
				fireAngleDelta = Math.PI / 2 / (fireCount - 1);

			} else {
				fireAngle = Math.PI * 3 / 4;
				fireAngleDelta = -Math.PI / 2 / (fireCount - 1);
			}

			fireWait = 60 - _powerLevel * 15;
		}

		override public function update():void {

			switch (state) {
				case(0): // Appears
					alpha = UtilsNumber.approach(alpha, 1, 0.05 * _speedLevel, 0.05);
					if (alpha == 1) {
						state = 1;
						stateWait = 180 - _speedLevel * 60;
					}
					break;

				case(1): // Wait before Fire
					if (stateWait == 0) {
						state = 2;
						calculateFire();
					} else
						stateWait--;
					break;

				case(2): // Firing
					if (fireCount) {
						if (stateWait)
							stateWait--;
						else {
							new TBulletJumper(center, middle, fireAngle);
							fireAngle += fireAngleDelta;
							fireCount--;
							stateWait = fireWait;
							Sfx.sfxEnFire.play();
						}

					} else {
						state = 3;
						stateWait = 180 - _speedLevel * 60;
					}
					break;

				case(3): // Wait after fire
					if (stateWait == 0)
						state = 4;
					else
						stateWait--;
					break;

				case(4): // Disappears
					alpha = UtilsNumber.approach(alpha, 0, 0.05 * _speedLevel, 0.05);
					if (alpha == 0) {
						_x = -1000;
						_y = -1000;
						state = 5;
						stateWait = 180 - _speedLevel * 60;
					}
					break;

				case(5): // Wait hidden
					if (stateWait)
						stateWait--;
					else {
						removeHash();
						y = Math.random() * 55 + 5;
						x = Math.random() * (S().levelWidth - _width - 10) + 5;
						addHash();
						state = 0;
					}
					break;

			}

			frame = (frame + 0.125) % 2;

			if (_damageAnim) {
				_damageAnim--;
				Game.lGame.drawAdvanced(__gfxDamage[frame | 0], x, y, 0, 1, 1, null, false, 1);

			} else
				Game.lGame.drawAdvanced(__gfx[frame | 0], x, y, 0, 1, 1, null, false, alpha);

		}

		override public function kill():void {
			super.kill();

			RetrocamelEffectQuake.make().power(5, 5).duration(250).run();

			new TCoin(center, middle, Generator.hp * Generator.hp * 8 + _powerLevel * _powerLevel * 12 + _speedLevel * _speedLevel * 12);
			Score.score.add(Generator.hp * Generator.hp * 8 + _powerLevel * _powerLevel * 12 + _speedLevel * _speedLevel * 12);

			new TExplosion(center, middle);
			new TExplosion(x + Math.random() * _width, y + Math.random() * _height, 4);
			new TExplosion(x + Math.random() * _width, y + Math.random() * _height, 8);


			for (var i:uint = 0; i < _width; i++) {
				for (var j:uint = 0; j < _height; j++) {
					Game.partPixel.add(_x + i, _y + j, __gfx[frame | 0].getPixel32(i, j),
						UtilsNumber.randomWaved(15, 14),
						UtilsNumber.randomWaved(0, 80), UtilsNumber.randomWaved(0, 80));
				}
			}
		}
	}
}