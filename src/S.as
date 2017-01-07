package {
	public function S():SettingsClass {
		return SettingsClass.instance;
	}
}

import net.retrocade.retrocamel.interfaces.IRetrocamelSettings;

class SettingsClass implements IRetrocamelSettings {
	public static var instance:SettingsClass = new SettingsClass();


	public const SPATIAL_HASH_CELL:Number = 16;
	public const SPATIAL_HASH_MAX_BUCKETS:Number = 100;


	public function get eventsCount():uint {
		return 1;
	}

	public function get languages():Array {
		return ['en', 'pl'];
	}

	public function get languagesNames():Array {
		return ["English", 'Polish'];
	}

	public function get gameWidth():uint {
		return 450;
	}

	public function get gameHeight():uint {
		return 450;
	}

	public function get levelWidth():uint {
		return 150;
	}

	public function get levelHeight():uint {
		return 150;
	}
}