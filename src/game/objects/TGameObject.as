package game.objects{
    import game.global.Game;

    import net.retrocade.collision.RetrocamelSimpleCollider;
    import net.retrocade.retrocamel.components.RetrocamelDisplayObject;
    import net.retrocade.retrocamel.components.RetrocamelUpdatableGroup;
    import net.retrocade.retrocamel.interfaces.IRetrocamelSpatialHashElement;

    public class TGameObject extends RetrocamelDisplayObject implements IRetrocamelSpatialHashElement{
        override public function get defaultGroup():RetrocamelUpdatableGroup {
            return Game.gAll;
        }
        
        public function get player():TPlayer {
            return Game.player;
        }
        
        public var isAlive:Boolean = true;
        
        
        public function addHash():void{
            Game.hashEnemy.add(this);
        }
        
        public function removeHash():void{
            Game.hashEnemy.removeFromAll(this);
        }
        
        public function damage(object:TGameObject):void{
            kill();
        }
        
        public function kill():void{
            nullifyDefault();
            removeHash();
        }
        
        protected function checkPlayerHit():void{
            if (RetrocamelSimpleCollider.rectRect(_x | 0, _y | 0, _width | 0, _height | 0, player.x, player.y, player.width, player.height) &&
                RetrocamelSimpleCollider.bitmap(player.gfx, player.x | 0, player.y | 0, 1, 1, 0, 
                                      _gfx,       _x | 0,       _y | 0, 1, 1, 0))
                
                player.damage(this);
        }
    }
}