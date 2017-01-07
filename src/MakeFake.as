package {
	public function MakeFake():MakeClass {
		return MakeClass.instance;
	}
}

import net.retrocade.retrocamel.display.flash.RetrocamelBitmapText;
import net.retrocade.retrocamel.interfaces.IRetrocamelMake;

class MakeClass implements IRetrocamelMake {
	public static var instance:MakeClass = new MakeClass();

	public function button(onClick:Function, text:String, width:Number = NaN):* {
		return null;
	}

	public function text(text:String, color:uint = 0xFFFFFF, scale:uint = 1, x:uint = 0, y:uint = 0):RetrocamelBitmapText {
		return null;
	}
}