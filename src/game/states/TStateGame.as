package game.states {
	import game.global.Game;
	import game.global.Generator;
	import game.objects.Starfield;
	import game.objects.THud;
	import game.objects.TIntro;
	import game.objects.TPlayer;
	import game.objects.TShop;
	import game.windows.TWinPause;

	import net.retrocade.constants.KeyConst;

	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;

	public class TStateGame extends RetrocamelStateBase {
		private static var _instance:TStateGame = new TStateGame();
		public static function get instance():TStateGame {
			return _instance;
		}

		private var _starfield:Starfield;


		override public function create():void {
			_defaultGroup = Game.gAll;

			TShop.instance.hook(Game.lMain);
			THud.instance.hookTo(Game.lGame);

			_starfield = new Starfield(Game.lGame);

			new TPlayer();

			new TIntro();

			RetrocamelSoundManager.playMusic(Game.music, 1000);

		}

		override public function destroy():void {
			_defaultGroup.clear();
			THud.instance.unhook();
			Game.lGame.clear();
			Game.lBG.clear();
			Game.lMain.clear();
		}

		override public function update():void {
			if (RetrocamelInputManager.isKeyHit(KeyConst.ESCAPE)) {
				TWinPause.instance.show();
				return;
			}

			Generator.update();

			Game.lBG.clear();
			Game.lGame.clear();

			_starfield.update();

			Game.gAll.update();
		}
	}
}