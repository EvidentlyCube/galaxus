package game.global {
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.media.Sound;

	import game.objects.TPlayer;
	import game.states.TStateGame;
	import game.windows.TWinFocusPause;

	import net.retrocade.collision.RetrocamelSimpleCollider;

	import net.retrocade.constants.KeyConst;

	import net.retrocade.data.RetrocamelSpatialHash;

	import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
	import net.retrocade.retrocamel.core.RetrocamelDisplayManager;

	import net.retrocade.retrocamel.core.RetrocamelInputManager;
	import net.retrocade.retrocamel.core.RetrocamelSoundManager;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashSprite;
	import net.retrocade.retrocamel.global.RetrocamelSimpleSave;
	import net.retrocade.retrocamel.particles.RetrocamelParticlesPixel;

	public class Game {
		[Embed(source="/../src.assets/assets.png")]
		public static var _gfx_:Class;
		[Embed(source="/../src.music/music.mp3")]
		public static var _music_:Class;

		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Game Variables
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static var lMain:RetrocamelLayerFlashSprite;
		public static var lBG:RetrocamelLayerFlashBlit;
		public static var lGame:RetrocamelLayerFlashBlit;
		public static var lPart:RetrocamelLayerFlashBlit;

		public static var gAll:RetrocamelUpdatableGroup = new RetrocamelUpdatableGroup();
		public static var hashEnemy:RetrocamelSpatialHash;

		public static var player:TPlayer;

		public static var partPixel:RetrocamelParticlesPixel;

		private static var musics:Array;

		public static function get music():Sound {
			if (!musics) {
				musics = [];
				musics[0] = new _music_;
			}

			return musics[musics.length * Math.random() | 0];
		}


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Keys
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static var keyLeft:uint = KeyConst.LEFT;
		public static var keyRight:uint = KeyConst.RIGHT;
		public static var keyUp:uint = KeyConst.UP;
		public static var keyDown:uint = KeyConst.DOWN;
		public static var keyFire:uint = KeyConst.Z;
		public static var keySound:uint = KeyConst.S;
		public static var keyMusic:uint = KeyConst.M;

		public static var mouseMove:Boolean = false;

		public static var allKeys:Array = ['keyLeft', 'keyRight', 'keyUp', 'keyDown', 'keySound', 'keyMusic', 'keyFire'];


		// ::::::::::::::::::::::::::::::::::::::::::::::
		// :: Init
		// ::::::::::::::::::::::::::::::::::::::::::::::

		public static function init():void {
			for each(var i:String in allKeys) {
				Game[i] = RetrocamelSimpleSave.read("opt" + i, Game[i]);
			}

			mouseMove = RetrocamelSimpleSave.read("useMouse", true);

			Game.lBG = new RetrocamelLayerFlashBlit();
			Game.lGame = new RetrocamelLayerFlashBlit();
			Game.lPart = new RetrocamelLayerFlashBlit();
			Game.lMain = new RetrocamelLayerFlashSprite();

			Game.lGame.setScale(3, 3);
			Game.lBG.setScale(3, 3);
			Game.lPart.setScale(3, 3);

			Game.hashEnemy = new RetrocamelSpatialHash(S().SPATIAL_HASH_CELL, S().SPATIAL_HASH_MAX_BUCKETS);

			Game.partPixel = new RetrocamelParticlesPixel(Game.lPart, 1000);
			TStateGame.instance.setToMe();

			TWinFocusPause.hook();

			RetrocamelSimpleCollider.initBitmapCollision(100, 100);

			RetrocamelInputManager.addStageKeyDown(onKeyDown);

			Cursor.init();
			RetrocamelDisplayManager.addEventListener(Event.ENTER_FRAME, Cursor.update);
		}

		private static var oldSoundVolume:Number = 1;
		private static var oldMusicVolume:Number = 1;

		private static function onKeyDown(e:KeyboardEvent):void {
			if (e.keyCode == Game.keySound) {
				if (RetrocamelSoundManager.soundVolume == 0)
					RetrocamelSoundManager.soundVolume = oldSoundVolume;
				else {
					oldSoundVolume = RetrocamelSoundManager.soundVolume;
					RetrocamelSoundManager.soundVolume = 0;
				}

				RetrocamelSimpleSave.write('optVolumeSound', RetrocamelSoundManager.soundVolume);
			} else if (e.keyCode == Game.keyMusic) {
				if (RetrocamelSoundManager.musicVolume == 0)
					RetrocamelSoundManager.musicVolume = oldMusicVolume;
				else {
					oldMusicVolume = RetrocamelSoundManager.musicVolume;
					RetrocamelSoundManager.musicVolume = 0;
				}

				RetrocamelSimpleSave.write('optVolumeMusic', RetrocamelSoundManager.musicVolume);
			}
		}
	}
}