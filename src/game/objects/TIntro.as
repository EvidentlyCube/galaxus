package game.objects {
	import flash.display.Bitmap;
	import flash.display.Sprite;

	import game.global.Game;
	import game.global.Generator;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;

	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.locale._;

	public class TIntro extends RetrocamelUpdatableObject {

		private var s:Sprite;

		private var logo:Bitmap;

		private var help:RetrocamelBitmapText;

		public function TIntro() {
			s = new Sprite();

			logo = RetrocamelBitmapManager.getBExt(Game._gfx_, 0, 120, 54, 38);
			logo.scaleX = logo.scaleY = 3;

			help = new RetrocamelBitmapText("");
			help.setScale(2);
			help.align = RetrocamelBitmapText.ALIGN_MIDDLE;
			help.text = _("intro");

			s.addChild(logo);
			s.addChild(help);

			logo.x = (S().gameWidth - logo.width) / 2 | 0;
			help.x = (S().gameWidth - help.width) / 2 | 0;

			logo.y = 10;

			help.y = logo.y + logo.height + 10;

			Game.lMain.add(s);

			RetrocamelEffectFadeFlash.make(s).alpha(0, 1).duration(500).callback(addDefault).run();
		}

		override public function update():void {
			if (Game.mouseMove && RetrocamelInputManager.isMouseHit()) {
				kill();
			} else if (!Game.mouseMove && RetrocamelInputManager.isKeyHit(Game.keyFire)) {
				kill();
			}
		}

		private function kill():void {
			nullifyDefault();

			RetrocamelEffectFadeFlash.make(s).alpha(1, 0).duration(1000).callback(onKill).run();
		}

		private function onKill():void {
			Generator.timer = 0;
			Game.lMain.remove(s);
		}
	}
}