package game.windows {
	import flash.display.Shape;
	import flash.display.Sprite;

	import game.global.Make;

	import net.retrocade.constants.KeyConst;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelPreciseGrid9;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsDisplay;
	import net.retrocade.utils.UtilsGraphic;

	/**
	 * ...
	 * @author ...
	 */
	public class TWinCredits extends RetrocamelWindowFlash {
		public static function show():void {
			var instance:TWinCredits = new TWinCredits();
			instance.show();
		}


		public function TWinCredits() {
			_blockUnder = true;
			_pauseGame = false;

			var container:Sprite = new Sprite();
			var by:RetrocamelBitmapText = Make.text(_("Game by"), 0xFFFF00, 2);
			var by2:RetrocamelBitmapText = Make.text(_("RETROCADE.net"), 0x44FF44, 2);

			var prg:RetrocamelBitmapText = Make.text(_("Programming"), 0xFFFF00);
			var prg2:RetrocamelBitmapText = Make.text(_("Maurycy Zarzycki"), 0xFFFFFF);

			var gfx:RetrocamelBitmapText = Make.text(_("Graphics"), 0xFFFF00);
			var gfx2:RetrocamelBitmapText = Make.text(_("Maurycy Zarzycki"), 0xFFFFFF);

			var mus:RetrocamelBitmapText = Make.text(_("Music"), 0xFFFF00);
			var mus2:RetrocamelBitmapText = Make.text(_("MusicCredit"), 0xFFFFFF);

			var sfx:RetrocamelBitmapText = Make.text(_("Sound Effects"), 0xFFFF00);
			var sfx2:RetrocamelBitmapText = Make.text(_("Various Resources"), 0xFFFFFF);

			var closer:RetrocamelButton = Make.buttonColor(onClose, _("Close"));

			var all:Array = [by, by2, prg, prg2, gfx, gfx2, mus, mus2, sfx, sfx2, closer];

			by2.y = 22;
			prg.y = 65;
			prg2.y = 80;
			gfx.y = 100;
			gfx2.y = 115;
			mus.y = 135;
			mus2.y = 150;
			sfx.y = 185;
			sfx2.y = 200;

			mus2.align = RetrocamelBitmapText.ALIGN_MIDDLE;

			var wid:Number = Math.max(by.width, by2.width, prg.width, prg2.width, gfx.width, gfx2.width, mus.width, mus2.width, sfx.width,
				sfx2.width);

			by.x = (wid - by.width) / 2;
			by2.x = (wid - by2.width) / 2;
			closer.x = (wid - closer.width) / 2;

			prg.x = (wid - prg.width) / 2;
			prg2.x = (wid - prg2.width) / 2;
			gfx.x = (wid - gfx.width) / 2;
			gfx2.x = (wid - gfx2.width) / 2;
			mus.x = (wid - mus.width) / 2;
			mus2.x = (wid - mus2.width) / 2;
			sfx.x = (wid - sfx.width) / 2;
			sfx2.x = (wid - sfx2.width) / 2;

			closer.y = Math.max(sfx2.y + sfx2.height) + 15;

			UtilsDisplay.addArray(container, all);

			var bg:Shape = new Shape();
			UtilsGraphic.clear(bg).rectFill(0, 0, wid + 40, container.height + 10, 0, 1);

			addChild(bg);
			addChild(container);
			container.x = 20;

			centerWindow();

			mouseEnabled = false;
			mouseChildren = false;
		}


		override public function update():void {
			if (RetrocamelInputManager.isKeyHit(KeyConst.ESCAPE)) {
				onClose();
			}

			super.update();
		}

		override public function show():void {
			super.show();

			mouseEnabled = false;
			mouseChildren = false;

			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(250).callback(callbackEnableMouse).run();
		}

		private function onClose():void {
			if (mouseEnabled) {
				mouseEnabled = false;
				mouseChildren = false;

				RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(250).callback(onHideFinish).run();
			}
		}

		private function onHideFinish():void {
			hide();
		}
	}
}