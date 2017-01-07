package game.windows {
	import flash.net.URLRequest;
	import flash.net.navigateToURL;

	import game.global.Game;
	import game.global.Make;
	import game.global.Options;

	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.flash.RetrocamelWindowFlash;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeFlash;
	import net.retrocade.retrocamel.global.RetrocamelSimpleSave;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsGraphic;

	public class TWinPause extends RetrocamelWindowFlash {
		private static var _instance:TWinPause = new TWinPause();

		public static function get instance():TWinPause {
			return _instance;
		}


		protected var options:Options;

		protected var controlMouse:RetrocamelButton;
		protected var controlKeys:RetrocamelButton;

		protected var closer:RetrocamelButton;
		protected var credits:RetrocamelButton;

		public function TWinPause() {
			this._blockUnder = true;
			this._pauseGame = true;

			var txt:RetrocamelBitmapText = Make.text(_("Game is Paused"), 0xFFFFFF, 2);

			options = new Options();
			closer = Make.buttonColor(onClose, _('Return to Game'));
			credits = Make.buttonColor(onCredits, _('credits'));

			controlMouse = Make.buttonColor(onControlMouse, _("Mouse Controls"));
			controlKeys = Make.buttonColor(onControlKeys, _("Key Controls"));

			controlMouse.x = 35;
			controlKeys.x = 215;

			addChild(controlMouse);
			addChild(controlKeys);
			addChild(txt);
			addChild(options);
			addChild(closer);
			addChild(credits);

			options.y = 25;
			controlKeys.y = controlMouse.y = options.y + options.height + 5;

			closer.y = controlKeys.y + controlKeys.height + 5;
			credits.y = closer.y + closer.height + 5;

			graphics.beginFill(0);
			graphics.drawRect(0, 0, 300, options.height + closer.height + 75);

			txt.x = (width - txt.width) / 2 + 5 | 0;
			closer.x = (width - closer.width) / 2 + 5 | 0;
			options.x = (width - options.width) / 2 + 5 | 0;
			credits.x = (width - credits.width) / 2 + 5 | 0;

			centerWindow();

			UtilsGraphic.clear(this).beginFill(0, 0.5).drawRect(-x, -y, S().gameWidth, S().gameHeight)
				.beginFill(0).drawRect(0, 0, options.width + 10, credits.y + credits.height + 10);

			credits.rollOverCallback = RetrocamelTooltip.show;
			credits.rollOutCallback = RetrocamelTooltip.hide;

			RetrocamelTooltip.hookToObject(credits, _('helpTooltip'));

			if (RetrocamelSimpleSave.read("useMouse", true) == true)
				controlMouse.disable();
			else
				controlKeys.disable();
		}

		override public function show():void {
			super.show();
			RetrocamelEffectFadeFlash.make(this).alpha(0, 1).duration(250).run();
			mouseEnabled = true;
			mouseChildren = true;
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: RetrocamelButton Callbacks
		// ::::::::::::::::::::::::::::::::::::::::::::::

		private function onClose():void {
			mouseEnabled = false;
			mouseChildren = false;
			RetrocamelEffectFadeFlash.make(this).alpha(1, 0).duration(250).callback(hide).run();
		}

		private function onCredits():void {
			TWinCredits.show();
		}

		private function onControlMouse():void {
			controlMouse.disable();
			controlKeys.enable();
			Game.mouseMove = true;

			RetrocamelSimpleSave.write('useMouse', true);
		}

		private function onControlKeys():void {
			controlMouse.enable();
			controlKeys.disable();
			Game.mouseMove = false;
			RetrocamelSimpleSave.write('useMouse', false);
		}
	}
}