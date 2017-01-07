package game.objects {
	import flash.display.BitmapData;

	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;
	import game.global.Sfx;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.effects.RetrocamelEffectQuake;
	import net.retrocade.utils.UtilsNumber;

	public class TEnemyShield extends TEnemy {

		private static var __gfx:BitmapData;
		private static var __gfxDamage:BitmapData;

		{
			__gfx = RetrocamelBitmapManager.getBDExt(Game._gfx_, 58, 19, 13, 7);
			__gfxDamage = RetrocamelBitmapManager.getBDSpecial(Game._gfx_, 58, 19, 13, 7, false, 0xFFFFFF);
		}

		private var toX:Number;

		public function TEnemyShield(powerLevel:uint = 1, speedLevel:uint = 1, hpLevel:uint = 1) {
			super(powerLevel, speedLevel, hpLevel * 4);

			_width = 13;
			_height = 7;

			x = Math.random() < 0.5 ? -_width : S().levelWidth;
			y = 130 - 20 * _powerLevel;

			addDefault();
			addHash();

			_gfx = __gfx;
		}

		override public function update():void {
			removeHash();

			toX = player.center;

			center = UtilsNumber.approach(center, toX, 0.01, 0.001, 0.2);

			addHash();

			checkPlayerHit();

			if (_damageAnim) {
				_damageAnim--;
				Game.lGame.draw(__gfxDamage, x, y);

			} else
				Game.lGame.draw(__gfx, x, y);
		}

		override public function damage(object:TGameObject):void {
			if (object is TPlayerBulletRear) {
				_hp--;
				_damageAnim = 5;
				Sfx.sfxDamage.play();
			}

			if (_hp <= 0) {
				kill();
				Sfx.sfxExplode.play();
			}
		}

		override public function kill():void {
			super.kill();

			RetrocamelEffectQuake.make().power(8, 8).duration(500).run();

			new TCoin(center, middle, Generator.hp * Generator.hp * 15 + _powerLevel * _powerLevel * 7 + _speedLevel * _speedLevel * 7);
			Score.score.add(Generator.hp * Generator.hp * 15 + _powerLevel * _powerLevel * 7 + _speedLevel * _speedLevel * 7);

			new TExplosion(center, y);
			new TExplosion(x, middle, 4);
			new TExplosion(right, y, 8);
			new TExplosion(center, y, 12);
			new TExplosion(center, bottom, 16);


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