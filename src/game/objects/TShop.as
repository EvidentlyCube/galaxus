package game.objects {
	import flash.display.Bitmap;
	import flash.display.Sprite;

	import game.global.Game;
	import game.global.Generator;
	import game.global.Score;
	import game.global.Sfx;

	import net.retrocade.constants.KeyConst;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;
	import net.retrocade.retrocamel.core.RetrocamelBitmapManager;
	import net.retrocade.retrocamel.core.RetrocamelCore;
	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
	import net.retrocade.retrocamel.display.flash.RetrocamelButton;
	import net.retrocade.retrocamel.display.global.RetrocamelTooltip;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;
	import net.retrocade.retrocamel.locale._;
	import net.retrocade.utils.UtilsNumber;

	public class TShop extends RetrocamelUpdatableObject {
		public static var show:Boolean = false;

		private static var _instance:TShop = new TShop();

		public static function get instance():TShop {
			return _instance;
		}

		private var space:RetrocamelBitmapText;
		private var space2:Bitmap;

		private var item1:RetrocamelButton;
		private var item2:RetrocamelButton;
		private var item3:RetrocamelButton;
		private var item4:RetrocamelButton;
		private var item5:RetrocamelButton;
		private var item6:RetrocamelButton;
		private var item7:RetrocamelButton;
		private var item8:RetrocamelButton;
		private var itemA:RetrocamelButton;
		private var itemB:RetrocamelButton;
		private var itemC:RetrocamelButton;
		private var itemD:RetrocamelButton;

		private var stats:RetrocamelBitmapText;

		private var container:Sprite = new Sprite();
		private var container2:Sprite = new Sprite();
		private var hidden:Boolean = true;

		public function TShop() {
			space = new RetrocamelBitmapText(_("Space to shop"));
			space2 = RetrocamelBitmapManager.getBExt(Game._gfx_, 89, 93, 24, 9);

			item1 = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			item2 = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			item3 = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			item4 = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			item5 = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			item6 = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			item7 = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			item8 = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			itemA = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			itemB = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			itemC = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);
			itemD = new RetrocamelButton(onClick, Sfx.sfxRollOver.play);

			item1.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 0, 190, 22, 22));
			item2.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 22, 190, 22, 22));
			item3.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 44, 190, 22, 22));
			item4.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 66, 190, 22, 22));
			item5.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 0, 212, 22, 22));
			item6.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 22, 212, 22, 22));
			item7.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 44, 212, 22, 22));
			item8.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 66, 212, 22, 22));
			itemA.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 0, 234, 22, 22));
			itemB.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 22, 234, 22, 22));
			itemC.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 44, 234, 22, 22));
			itemD.addChild(RetrocamelBitmapManager.getBExt(Game._gfx_, 66, 234, 22, 22));

			container.addChild(item1);
			container.addChild(item2);
			container.addChild(item3);
			container.addChild(item4);
			container.addChild(item5);
			container.addChild(item6);
			container.addChild(item7);
			container.addChild(item8);
			container.addChild(itemA);
			container.addChild(itemB);
			container.addChild(itemC);
			container.addChild(itemD);

			item1.x = item5.x = itemA.x = 8;
			item2.x = item6.x = itemB.x = 45;
			item3.x = item7.x = itemC.x = 83;
			item4.x = item8.x = itemD.x = 120;

			item5.y = item6.y = item7.y = item8.y = 30;
			itemA.y = itemB.y = itemC.y = itemD.y = 60;

			stats = new RetrocamelBitmapText();
			stats.align = RetrocamelBitmapText.ALIGN_MIDDLE;
			stats.lineSpace = -2;

			//container.addChild(space);
			container.addChild(space2);
			container2.addChild(stats);

			container.scaleX = container.scaleY = 3;
			container2.scaleX = container2.scaleY = 2;

			container2.alpha = 0;
			container2.mouseChildren = container2.mouseEnabled = false;

			space.x = (S().levelWidth - space.width) / 2;
			space.y = -space.height - 2;

			space2.x = S().levelWidth - space2.width - 2;
			space2.y = -space2.height - 2;
		}

		override public function update():void {
			container.visible = Generator.timer == 0;

			if (space2.alpha < 1 && space2.alpha > 0)
				space2.alpha = UtilsNumber.limit(space2.alpha - 0.05, 1, 0);

			if (!container.visible)
				return;

			if (hidden) {
				if (container2.alpha > 0)
					container2.alpha -= 0.0625;
				container.y = UtilsNumber.approach(container.y, S().gameHeight, 0.1, 1);
				if (container.y == S().gameHeight)
					RetrocamelCore.paused = false;

				if (RetrocamelInputManager.isKeyHit(KeyConst.SPACE) || show) {
					show = false;
					hidden = false;
					space2.alpha -= 0.05;

					RetrocamelInputManager.flushKeys();
					updateTooltips();
				}
			} else {
				if (container2.alpha < 1)
					container2.alpha += 0.0625;
				stats.text = _("Wave #") + Generator.wave + "\n" +
					_("Enemy Power:") + " " + Generator.power + " / 3\n" +
					_("Enemy Speed:") + " " + Generator.speed + " / 3\n" +
					_("Enemy Life:") + " " + Generator.hp + " / 3\n" +
					_("Best score:") + " " + Generator.bestScore + "\n" +
					_("Your score:") + " " + Score.score.get();
				stats.x = (S().gameWidth / 2 - stats.width) / 2 | 0;
				RetrocamelCore.paused = true;

				container.y = UtilsNumber.approach(container.y, S().gameHeight - container.height);

				if (RetrocamelInputManager.isKeyHit(KeyConst.SPACE) || show) {
					hidden = true;
					RetrocamelTooltip.hide();
					RetrocamelInputManager.flushKeys();
				}

			}
		}

		private function onClick(item:RetrocamelButton):void {
			Sfx.sfxClick.play();

			if (TPlayer.backShotLevel == 0 && TPlayer.bulletsLevel == 0 && TPlayer.frontShotLevel == 0 && TPlayer.speedLevel == 0) {
				if (Score.score.get() > Score.highestScoreNoUpgrade.get()) {
					Score.highestScoreNoUpgrade.set(Score.score.get());
				}
			}

			switch (item) {
				case(item1):
					TPlayer.bulletsLevel = 1;
					updateTooltips();
					Score.cash.add(-1000);
					break;

				case(item2):
					TPlayer.bulletsLevel = 2;
					updateTooltips();
					Score.cash.add(-2000);
					break;

				case(item3):
					TPlayer.bulletsLevel = 3;
					updateTooltips();
					Score.cash.add(-4000);
					break;

				case(item4):
					TPlayer.bulletsLevel = 4;
					updateTooltips();
					Score.cash.add(-7000);
					break;

				case(item5):
					TPlayer.frontShotLevel = 1;
					updateTooltips();
					Score.cash.add(-4000);
					break;

				case(item6):
					TPlayer.frontShotLevel = 2;
					updateTooltips();
					Score.cash.add(-8000);
					break;

				case(item7):
					TPlayer.backShotLevel = 1;
					updateTooltips();
					Score.cash.add(-500);
					break;

				case(item8):
					TPlayer.backShotLevel = 2;
					updateTooltips();
					Score.cash.add(-2000);
					break;

				case(itemA):
					TPlayer.speedLevel = 1;
					updateTooltips();
					Score.cash.add(-1000);
					break;

				case(itemB):
					TPlayer.speedLevel = 2;
					updateTooltips();
					Score.cash.add(-2000);
					break;

				case(itemC):
					TPlayer.speedLevel = 3;
					updateTooltips();
					Score.cash.add(-4000);

				case(itemD):
					hidden = true;
					RetrocamelTooltip.hide();
					break;
			}

			updateTooltips();
		}

		private function updateTooltips():void {
			RetrocamelTooltip.unhook(item1);
			RetrocamelTooltip.unhook(item2);
			RetrocamelTooltip.unhook(item3);
			RetrocamelTooltip.unhook(item4);
			RetrocamelTooltip.unhook(item5);
			RetrocamelTooltip.unhook(item6);
			RetrocamelTooltip.unhook(item7);
			RetrocamelTooltip.unhook(item8);
			RetrocamelTooltip.unhook(itemA);
			RetrocamelTooltip.unhook(itemB);
			RetrocamelTooltip.unhook(itemC);
			RetrocamelTooltip.unhook(itemD);

			RetrocamelTooltip.hook(item1, _("shop1"));
			RetrocamelTooltip.hook(item2, _("shop2"));
			RetrocamelTooltip.hook(item3, _("shop3"));
			RetrocamelTooltip.hook(item4, _("shop4"));

			RetrocamelTooltip.hook(item5, _("shop5"));
			RetrocamelTooltip.hook(item6, _("shop6"));
			RetrocamelTooltip.hook(item7, _("shop7"));
			RetrocamelTooltip.hook(item8, _("shop8"));

			RetrocamelTooltip.hook(itemA, _("shopA"));
			RetrocamelTooltip.hook(itemB, _("shopB"));
			RetrocamelTooltip.hook(itemC, _("shopC"));
			RetrocamelTooltip.hook(itemD, _("shopD"));

			item1.alpha = item2.alpha = item3.alpha = item4.alpha = item5.alpha = item6.alpha = 0.5;
			item7.alpha = item8.alpha = itemA.alpha = itemB.alpha = itemC.alpha = 0.5;

			if (TPlayer.bulletsLevel == 0)
				item1.alpha = 1;
			else if (TPlayer.bulletsLevel == 1)
				item2.alpha = 1;
			else if (TPlayer.bulletsLevel == 2)
				item3.alpha = 1;
			else if (TPlayer.bulletsLevel == 3)
				item4.alpha = 1;

			if (TPlayer.frontShotLevel == 0)
				item5.alpha = 1;
			else if (TPlayer.frontShotLevel == 1)
				item6.alpha = 1;

			if (TPlayer.backShotLevel == 0)
				item7.alpha = 1;
			else if (TPlayer.backShotLevel == 1)
				item8.alpha = 1;

			if (TPlayer.speedLevel == 0)
				itemA.alpha = 1;
			else if (TPlayer.speedLevel == 1)
				itemB.alpha = 1;
			else if (TPlayer.speedLevel == 2)
				itemC.alpha = 1;

			item1.clickDisabled = true;
			item2.clickDisabled = true;
			item3.clickDisabled = true;
			item4.clickDisabled = true;

			if (TPlayer.bulletsLevel == 0 && Score.cash.get() >= 1000)
				item1.clickDisabled = false;
			else if (TPlayer.bulletsLevel == 1 && Score.cash.get() >= 2000)
				item2.clickDisabled = false;
			else if (TPlayer.bulletsLevel == 2 && Score.cash.get() >= 4000)
				item3.clickDisabled = false;
			else if (TPlayer.bulletsLevel == 3 && Score.cash.get() >= 7000)
				item4.clickDisabled = false;

			item5.clickDisabled = true;
			item6.clickDisabled = true;

			if (TPlayer.frontShotLevel == 0 && Score.cash.get() >= 4000)
				item5.clickDisabled = false;
			else if (TPlayer.frontShotLevel == 1 && Score.cash.get() >= 8000)
				item6.clickDisabled = false;

			item7.clickDisabled = true;
			item8.clickDisabled = true;

			if (TPlayer.backShotLevel == 0 && Score.cash.get() >= 500)
				item7.clickDisabled = false;
			else if (TPlayer.backShotLevel == 1 && Score.cash.get() >= 2000)
				item8.clickDisabled = false;

			itemA.clickDisabled = true;
			itemB.clickDisabled = true;
			itemC.clickDisabled = true;

			if (TPlayer.speedLevel == 0 && Score.cash.get() >= 1000)
				itemA.clickDisabled = false;
			else if (TPlayer.speedLevel == 1 && Score.cash.get() >= 2000)
				itemB.clickDisabled = false;
			else if (TPlayer.speedLevel == 2 && Score.cash.get() >= 4000)
				itemC.clickDisabled = false;
		}

		public function hook(layer:RetrocamelLayerFlashSprite):void {
			layer.add(container);
			layer.add(container2);

			container.y = S().gameHeight;

			RetrocamelCore.groupAfter.add(this);
		}
	}
}