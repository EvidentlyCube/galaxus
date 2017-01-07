package game.objects {
	import game.global.Cursor;
	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.locale._;

	public class TFinish extends RetrocamelUpdatableObject {
		private var score:RetrocamelBitmapText;

		public function TFinish() {
			Cursor.isVisible = false;

			score = new RetrocamelBitmapText();
			score.align = RetrocamelBitmapText.ALIGN_MIDDLE;
			score.setScale(2);
			score.lineSpace = -1;

			var txt:String = "Your score is:" + " " + Score.score.get() + "\n\n";


			if (Score.score.get() > Generator.bestScore) {
				txt += _("finish2_no");

			} else {
				txt += _("finish3_no");
			}

			score.text = txt;

			RetrocamelEffectFadeFlash.make(score).alpha(0, 1).duration(500).callback(onFadedIn).run();

			score.x = (S().gameWidth - score.width) / 2;
			score.y = (S().gameHeight - score.height) / 2;

			Game.lMain.add(score);
		}

		private function onFadedIn():void {
			addDefault();
		}

		override public function update():void {
			if (Game.mouseMove && RetrocamelInputManager.isMouseHit()) {
				kill();
			} else if (!Game.mouseMove && RetrocamelInputManager.isKeyHit(Game.keyFire)) {
				kill();
			}
		}

		private function kill():void {
			Cursor.isVisible = true;

			nullifyDefault();

			RetrocamelEffectFadeFlash.make(score).alpha(1, 0).duration(1000).callback(onKill).run();
		}

		private function onKill():void {
			Generator.timer = 0;
			Game.lMain.remove(score);
		}
	}
}