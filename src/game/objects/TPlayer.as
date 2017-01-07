package game.objects {
	import flash.utils.setTimeout;

	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;
	import game.global.Sfx;

	import net.retrocade.constants.KeyConst;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.utils.UtilsNumber;

	public class TPlayer extends TGameObject {

		private var mx:Number = 0;
		private var my:Number = 0;

		public function get maxSpeed():Number {
			return 1 + speedLevel;
		}

		public function get maxSpeedKeys():Number {
			return 1.5 + speedLevel / 6;
		}

		public static var speedLevel:uint = 0;
		public static var bulletsLevel:uint = 0;
		public static var frontShotLevel:uint = 0;
		public static var backShotLevel:uint = 0;

		private var fireWait:uint = 0;
		private var fireWaitRear:uint = 0;

		private var alpha:Number = 0;

		private function get mouseX():Number {
			return RetrocamelInputManager.mouseX / 3;
		}

		private function get mouseY():Number {
			return RetrocamelInputManager.mouseY / 3;
		}

		private var effectOffset:uint = 0;

		public function TPlayer() {
			_gfx = RetrocamelBitmapManager.getBDExt(Game._gfx_, 49, 50, 9, 5);

			_width = 9;
			_height = 5;

			addDefault();

			Game.player = this;

			x = (S().levelWidth - _width) / 2;
			y = S().levelHeight - 10;
		}

		override public function update():void {
			if (Generator.timer != 0) {
				alpha = 0;
				fireWait = fireWaitRear = 0;
				x = (S().levelWidth - width) / 2;
				y = S().levelHeight - height - 10;
				return;

			} else if (alpha < 1)
				alpha = UtilsNumber.limit(alpha + 0.05, 1);

			if (fireWait)
				fireWait--;

			if (fireWaitRear)
				fireWaitRear--;

			var dir:Number;
			var spd:Number;
			if (Game.mouseMove) {
				if (RetrocamelInputManager.isMouseDown())
					fire();

				dir = Math.atan2(mouseY - middle, mouseX - center);
				spd = Math.min(Math.sqrt(UtilsNumber.distanceSquared(center, middle, mouseX, mouseY)) / 10, maxSpeed);
				mx = Math.cos(dir) * spd;
				my = Math.sin(dir) * spd;

			} else {
				if (RetrocamelInputManager.isKeyDown(Game.keyFire))
					fire();

				mx = 0;
				my = 0;

				if (RetrocamelInputManager.isKeyDown(Game.keyUp)) {
					my -= maxSpeed;

				} else if (RetrocamelInputManager.isKeyDown(Game.keyDown)) {
					my += maxSpeed;
				}

				if (RetrocamelInputManager.isKeyDown(Game.keyLeft)) {
					mx -= maxSpeed;
				} else if (RetrocamelInputManager.isKeyDown(Game.keyRight)) {
					mx += maxSpeed;
				}

				if (mx || my) {
					dir = Math.atan2(my, mx);
					spd = Math.min(Math.sqrt(UtilsNumber.distanceSquared(0, 0, mx, my)), maxSpeedKeys);
					mx = Math.cos(dir) * spd;
					my = Math.sin(dir) * spd;
				}

				mx *= 0.95;
				my *= 0.95;
			}

			x += mx;
			y += my;

			if (x < 0) x = 0;
			if (y < 0) y = 0;
			if (x + width >= S().levelWidth)  x = S().levelWidth - width;
			if (y + height >= S().levelHeight) y = S().levelHeight - height;

			Game.lGame.drawAdvanced(_gfx, x, y, 0, 1, 1, null, false, alpha);

			if (effectOffset++ > 2) {
				new TPlayerEffect(x, y);
				effectOffset = 0;
			}
		}

		private function fire():void {
			if (fireWait == 0) {
				if (frontShotLevel == 0)
					new TPlayerBullet(center, y);
				else if (frontShotLevel == 1) {
					new TPlayerBullet(center - 2, y);
					new TPlayerBullet(center + 2, y);
				} else {
					new TPlayerBullet(center - 3, y + 1);
					new TPlayerBullet(center, y);
					new TPlayerBullet(center + 3, y + 1);
				}

				fireWait = 35 - bulletsLevel * 5;

				Sfx.sfxFire.play();
			}

			if (fireWaitRear == 0) {
				if (backShotLevel == 1)
					new TPlayerBulletRear(center, y);
				else if (backShotLevel == 2) {
					new TPlayerBulletRear(center - 2, y);
					new TPlayerBulletRear(center + 2, y);
				}

				fireWaitRear = (35 - bulletsLevel * 5) * 1.5;

				if (backShotLevel)
					Sfx.sfxFire.play();
			}
		}

		override public function damage(object:TGameObject):void {
			var score:Number = Score.score.get();
			Game.gAll.callOnAll(function ():void {
				if (this is TEnemy || this is TBulletJumper || this is TBulletPiffer || this is TBulletRider)
					this.kill();
			});

			Score.score.set(score);

			Generator.reset();

			backShotLevel = 0;
			frontShotLevel = 0;
			speedLevel = 0;
			bulletsLevel = 0;

			Score.cash.set(0);

			Sfx.sfxExplode.play();

			setTimeout(Sfx.sfxExplode.play, 200);
			setTimeout(Sfx.sfxExplode.play, 400);
			setTimeout(Sfx.sfxExplode.play, 600);

			new TExplosion(center, middle, 0);
			new TExplosion(x + Math.random() * width, y + Math.random() * height, 5);
			new TExplosion(x + Math.random() * width, y + Math.random() * height, 10);
			new TExplosion(x + Math.random() * width, y + Math.random() * height, 15);
			new TExplosion(x + Math.random() * width, y + Math.random() * height, 20);
			new TExplosion(x + Math.random() * width, y + Math.random() * height, 25);
			new TExplosion(x + Math.random() * width, y + Math.random() * height, 30);
			new TExplosion(x + Math.random() * width, y + Math.random() * height, 35);
			new TExplosion(x + Math.random() * width, y + Math.random() * height, 40);

		}
	}
}