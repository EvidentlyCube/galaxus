package game.objects {
	import game.global.Generator;
	import game.global.Sfx;

	public class TEnemy extends TGameObject {

		public static var total:uint = 0;

		protected var _powerLevel:uint;
		protected var _speedLevel:uint;
		protected var _hp:int;

		protected var _damageAnim:uint = 0;

		public function TEnemy(powerLevel:uint = 1, speedLevel:uint = 1, hp:uint = 1):void {
			_powerLevel = powerLevel;
			_speedLevel = speedLevel;
			_hp = hp;

			total++;
		}

		override public function kill():void {
			if (isAlive)
				total--;

			isAlive = false;

			super.kill();

			Generator.enemiesDestroyed.add(1);
		}

		override public function damage(object:TGameObject):void {
			if (!isAlive)
				return;
			_hp--;
			_damageAnim = 5;
			if (_hp <= 0) {
				kill();
				Sfx.sfxExplode.play();
			} else
				Sfx.sfxDamage.play();
		}
	}
}