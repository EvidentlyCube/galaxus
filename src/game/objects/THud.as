package game.objects {
	import flash.display.Bitmap;

	import game.global.Game;
	import game.global.Score;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;

	/**
	 * ...
	 * @author
	 */
	public class THud extends RetrocamelUpdatableObject {
		private static var _instance:THud = new THud;
		public static function get instance():THud {
			return _instance;
		}

		private var _layer:RetrocamelLayerFlashBlit;

		private var _cash:RetrocamelBitmapText;
		private var _coin:Bitmap;

		public function THud() {
			_coin = RetrocamelBitmapManager.getBExt(Game._gfx_, 64, 44, 5, 5);
			_coin.scaleX = _coin.scaleY = 2;

			_cash = new RetrocamelBitmapText("0");
			_cash.setScale(2);
			_cash.color = 0xFFFF00;

			_cash.x = 15;
			_cash.y = S().gameHeight - _cash.height - 2;
		}

		override public function update():void {
			_coin.x = _cash.x - 12;
			_coin.y = _cash.y + (_cash.height - _coin.height) / 2 - 1;

			_cash.text = "" + Score.cash.get();
		}

		public function hookTo(layer:RetrocamelLayerFlashBlit):void {
			RetrocamelCore.groupAfter.add(this);
			_layer = layer;

			Game.lMain.add(_cash);
			Game.lMain.add(_coin);
		}

		public function unhook():void {
			RetrocamelCore.groupAfter.nullify(this);
		}
	}
}