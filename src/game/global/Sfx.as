package game.global {
	import net.retrocade.sfxr.SfxrParams;
	import net.retrocade.sfxr.SfxrSynth;

	public class Sfx {
		public static var sfxRollOver:SfxrSynth;
		public static var sfxClick:SfxrSynth;

		public static var sfxFire:SfxrSynth;
		public static var sfxExplode:SfxrSynth;

		public static var sfxEnFire:SfxrSynth;
		public static var sfxDamage:SfxrSynth;

		public static var sfxCoin:SfxrSynth;

		public static function initialize():void {
			var p:SfxrParams = new SfxrParams();

			p.setSettingsString("2,0.0051,0.0252,,0.21,0.29,0.0752,,,,,,0.89,0.4339,,,,,1,,,,,0.52");
			sfxRollOver = new SfxrSynth();
			sfxRollOver.params = p.clone();

			p.setSettingsString("2,,0.186,,0.0638,0.5582,,,,,,,,,,,,,1,,,0.1,,0.52");
			sfxClick = new SfxrSynth();
			sfxClick.params = p.clone();

			p.setSettingsString("1,,0.13,,0.24,0.48,0.2,-0.3,,0.31,0.52,0.54,,0.681,-0.24,,-0.4,0.3,1,,,,,0.5");
			sfxFire = new SfxrSynth();
			sfxFire.params = p.clone();

			p.setSettingsString("3,,0.34,0.25,0.27,0.1746,,0.0986,,,,,,,,0.7233,,,1,,,,,0.5");
			sfxExplode = new SfxrSynth();
			sfxExplode.params = p.clone();

			p.setSettingsString("0,,0.2028,0.2366,0.2398,0.7515,0.0673,-0.4,,,,,,1,-0.6599,,0.0557,-0.1727,1,,,,,0.5");
			sfxEnFire = new SfxrSynth();
			sfxEnFire.params = p.clone();

			p.setSettingsString("3,,0.0877,,0.1188,0.3671,,-0.453,,,,,,,,,,,1,,,,,0.5");
			sfxDamage = new SfxrSynth();
			sfxDamage.params = p.clone();

			p.setSettingsString("0,,0.01,0.16,0.32,0.55,,,,,,0.6399,0.74,,,,,,1,,,,,0.5");
			sfxCoin = new SfxrSynth();
			sfxCoin.params = p.clone();

			sfxRollOver.cacheSound();
			sfxClick.cacheSound();
		}

		public static function startGenerating(callback:Function):void {
			var count:int = 5;
			
			sfxFire.cacheMutations(5, c, 10, 0.05);
			sfxExplode.cacheMutations(3, c, 10, 0.05);
			sfxEnFire.cacheMutations(2, c, 10, 0.05);
			sfxDamage.cacheMutations(2, c, 10, 0.05);
			sfxCoin.cacheMutations(3, c, 10, 0.05);
			
			function c():void{
				count--;
				
				if (count == 0){
					callback();
				}
			}
		}
	}
}