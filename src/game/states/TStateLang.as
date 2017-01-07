package game.states {
	import flash.display.Sprite;

	import game.display.PixelBugEffect;

	import game.global.Make;
	import game.objects.Starfield;

	import net.retrocade.retrocamel.components.RetrocamelStateBase;
	import net.retrocade.retrocamel.core.retrocamel_int;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.effects.RetrocamelEffectFadeScreen;
	import net.retrocade.retrocamel.locale.RetrocamelLocale;

	import preloader.Preloader;

	use namespace retrocamel_int;

	/**
	 * ...
	 * @author Maurycy Zarzycki
	 */
	public class TStateLang extends RetrocamelStateBase {
		/****************************************************************************************************************/
		/**                                                                                                  VARIABLES  */
		/****************************************************************************************************************/

		private var _parent:Sprite;

		private var _flags:Array = [];
		private var _flagsGroup:Sprite;

		private var _langText:RetrocamelBitmapText;

		private var _startupFunction:Function;

		private var _star:Starfield;


		/****************************************************************************************************************/
		/**                                                                                                  FUNCTIONS  */
		/****************************************************************************************************************/

		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Creation
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		public function TStateLang(startupFunction:Function) {
			_startupFunction = startupFunction;

			_star = new Starfield(Preloader.loaderLayerBG);

			_parent = Sprite(Preloader.loaderLayer.layer);
			_flagsGroup = new Sprite();

			var flag:RetrocamelButton;
			var lastFlag:RetrocamelButton;
			var tempFlag:RetrocamelButton;
			var slide:Number;

			for each(var s:String in S().languages) {
				//flag = new RetrocamelButton(onButtonClick, onButtonOver, onButtonOut, true);
				flag = Make.buttonColor(onButtonClick, S().languagesNames[S().languages.indexOf(s)]);
				flag.rollOutCallback = onButtonOut;
				flag.rollOverCallback = onButtonOver;
				flag.data.lang = s;

				RetrocamelTooltip.hook(flag, S().languagesNames[S().languages.indexOf(s)]);

				//flag.data.txt.text = S().languageNames[S().languages.indexOf(s)];
				//flag.data.grid9.width = flag.width;

				_flags.push(flag);

				if (lastFlag) {
					flag.x = lastFlag.x + lastFlag.width + 8;
					flag.y = lastFlag.y;

					if (flag.x + flag.width > S().gameWidth - 100) {
						slide = (S().gameWidth - 100 - lastFlag.x - lastFlag.width) / 2 | 0;
						for each (tempFlag in _flags) {
							if (tempFlag.y == flag.y)
								tempFlag.x += slide;
						}

						flag.x = 0;
						flag.y += 44;
					}
				}

				lastFlag = flag;

				_flagsGroup.addChild(flag);
			}


			slide = (S().gameWidth - 100 - lastFlag.x - lastFlag.width) / 2 | 0;
			for each (tempFlag in _flags) {
				if (tempFlag.y == flag.y)
					tempFlag.x += slide;
			}

			_flagsGroup.x = 50;
			_flagsGroup.y = S().gameHeight - 50 - _flagsGroup.height;

			_langText = Make.text('asd', 0xFFFFFF, 2, 0, 30);
			_langText.text = RetrocamelLocale.get(null, 'choseLanguage');

			_parent.addChild(_flagsGroup);
			_parent.addChild(_langText);

			centerizeMessage();
		}

		override public function create():void {
			var count:uint = 15;
			while (count--)
				new PixelBugEffect(Preloader.loaderLayerBG, S().levelWidth, S().levelHeight, 0.2 + Math.random() * 2, 0xFFFFFFFF, 0xFF0000FF);

		}

		override public function update():void {
			Preloader.loaderLayerBG.clear();
			_star.update();
			_defaultGroup.update();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Helpers
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		private function centerizeMessage():void {
			_langText.positionToCenterScreen();
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::::
		// :: Events
		// ::::::::::::::::::::::::::::::::::::::::::::::::

		private function onFaded():void {
			_parent.removeChild(_flagsGroup);
			_parent.removeChild(_langText);

			_startupFunction();
		}

		private function onButtonClick(data:RetrocamelButton):void {
			RetrocamelEffectFadeScreen.makeOut().duration(1000).callback(onFaded).run();

			_flagsGroup.mouseChildren = false;

			RetrocamelLocale.selected = data.data.lang;
		}

		private function onButtonOver(data:RetrocamelButton):void {
			_langText.text = RetrocamelLocale.get(data.data.lang as String, 'choseLanguage');
			centerizeMessage();
		}

		private function onButtonOut(data:RetrocamelButton):void {
			_langText.text = RetrocamelLocale.get(null, 'choseLanguage');
			centerizeMessage();
		}

	}

}