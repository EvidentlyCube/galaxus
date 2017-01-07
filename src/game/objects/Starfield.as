package game.objects {
	import net.retrocade.retrocamel.components.RetrocamelUpdatableObject;
	import net.retrocade.retrocamel.display.layers.RetrocamelLayerFlashBlit;

	public class Starfield extends RetrocamelUpdatableObject {
		private var _stars:Array = [];

		private var _layer:RetrocamelLayerFlashBlit;

		public function Starfield(layer:RetrocamelLayerFlashBlit) {
			_layer = layer;
		}

		override public function update():void {
			while (_stars.length < 150)
				newStar();

			for each(var i:Object in _stars) {
				_layer.plot(i.x, i.y = (i.y + i.speed) % 150, i.color);
			}
		}

		private var _colors:Array;

		private function getColor():uint {
			if (!_colors) {
				_colors = [];

				_colors[0] = 0x33397E;
				_colors[1] = 0x2A2D6D;
				_colors[2] = 0x2A2965;
				_colors[3] = 0x2A255D;
				_colors[4] = 0x222555;
				_colors[5] = 0x222155;
				_colors[6] = 0x22214C;
				_colors[7] = 0x221D4C;
				_colors[8] = 0x1A1D4C;
				_colors[9] = 0x1A1D44;
				_colors[10] = 0x1A1944;
				_colors[11] = 0x1A193C;
				_colors[12] = 0x12153C;
				_colors[13] = 0x121134;
			}

			return _colors[Math.random() * 14 | 0] | 0xFF000000;
		}

		private function newStar():void {
			var star:Object = {
				x: Math.random() * S().levelWidth,
				y: Math.random() * S().levelHeight,
				color: getColor(),
				speed: 0.05 + Math.random() * 0.2
			};

			_stars.push(star);
		}


	}
}