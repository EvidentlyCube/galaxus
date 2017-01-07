package game.objects {
	import game.global.Game;

	import net.retrocade.collision.RetrocamelSimpleCollider;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;

	public class TPlayerBulletRear extends TGameObject {
		private static var __gfx:Array = [];

		{
			__gfx[0] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 61, 68, 2, 4);
			__gfx[1] = RetrocamelBitmapManager.getBDExt(Game._gfx_, 64, 68, 2, 4);
		}

		private var frame:uint = 0;

		public function TPlayerBulletRear(x:uint, y:uint) {
			_x = x;
			_y = y;

			_width = 2;
			_height = 4;

			frame = Math.random() * 6;

			addDefault();
		}

		override public function update():void {
			y += 0.5 + TPlayer.speedLevel * 0.3;

			frame = (frame + 1) % 6;

			Game.lGame.draw(__gfx[frame / 3 | 0], x, y);

			if (y > S().levelHeight) {
				kill();

			} else {
				var objects:Array = Game.hashEnemy.getOverlapping(this);
				for each(var t:TGameObject in objects) {
					if (RetrocamelSimpleCollider.rectRect(_x, _y, _width, _height, t.x, t.y, t.width, t.height)) {
						t.damage(this);
						kill();
					}

				}
			}
		}
	}
}