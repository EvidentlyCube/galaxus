package game.global{
    import game.objects.TEnemy;
    import game.objects.TEnemyCube;
    import game.objects.TEnemyGlobe;
    import game.objects.TEnemyJumper;
    import game.objects.TEnemyPiffer;
    import game.objects.TEnemyRider;
    import game.objects.TEnemyShield;
    import game.objects.TFinish;
    import game.objects.TPlayer;
    
    import net.retrocade.vault.Safe;
    
    public class Generator{
        public static var timer:int = -1;
        private static var _wave:Safe = new Safe(0);
        public static function get wave():uint{
            return _wave.get();
        }
        public static function set wave(u:uint):void{
            _wave.set(u);
        }
        
        private static var _power:Safe = new Safe(1);
        public static function get power():uint{
            return _power.get();
        }
        public static function set power(u:uint):void{
            _power.set(u);
        }
        
        private static var _speed:Safe = new Safe(1);
        public static function get speed():uint{
            return _speed.get();
        }
        public static function set speed(u:uint):void{
            _speed.set(u);
        }
        
        private static var _hp:Safe = new Safe(1);
        public static function get hp():uint{
            return _hp.get();
        }
        public static function set hp(u:uint):void{
            _hp.set(u);
        }
        
        public static var bestScore:uint = 0;
        
        private static var _score:Safe = new Safe(0);
        public static function get score():uint{
            return _score.get();
        }
        public static function set score(u:uint):void{
            _score.set(u);
        }
        
        public static var coinsCollected:Safe = new Safe(0);
        public static var enemiesDestroyed:Safe = new Safe(0);
        
        public static function update():void{
            if (timer > 0){
                timer--
            } else if (TEnemy.total == 0 && timer == 0){
                Game.hashEnemy.clear();
                
                wave +=2;
                
                if (wave % 10 == 0)
                    increasePower();
                
                makeWave();
                
                submitWaveData();
            }
        }
        
        private static function submitWaveData():void{
            coinsCollected.set(0);
            enemiesDestroyed.set(0);
            
            
            if (TPlayer.backShotLevel == 0 && TPlayer.bulletsLevel == 0 && TPlayer.frontShotLevel == 0 && TPlayer.speedLevel == 0){
                if (Score.score.get() > Score.highestScoreNoUpgrade.get()){
                    Score.highestScoreNoUpgrade.set(Score.score.get());
                }
            }
        }
        
        public static function reset():void{
            submitWaveData();
            
            wave = 0;
            power = 1;
            speed = 1;
            hp = 1;
            
            timer = -1;
            
            new TFinish();
        }
        
        private static function increasePower():void{
            while(true){
                var random:uint = Math.random() * 9 | 0;
                
                if (random < 3 && power < 3 && power <= speed){
                    power++;
                    return;
                } else if (random < 6 && speed < 3 && speed <= power){
                    speed++;
                    return;
                } else if (hp < 3 && speed > hp && power > hp){
                    hp++;
                    return;
                } else if (hp == speed && speed == hp && hp == 3){
                    return;
                }
            }
        }
        
        private static function makeWave():void{
            if (Math.random() < Math.max(0.2, 0.5 - wave / 100)){
                makeSimpleWave();
            } else {
                makeComplexWave();
            }
        }
        
        private static function makeSimpleWave():void{
            var random:Number = Math.random() * wave % 20;
            
            if (random < 2)
                makeGlobes(5 + Math.ceil(wave / 2));
                
            else if (random < 5)
                makePiffers(3 + Math.ceil(wave / 3));
                
            else if (random < 8)
                makeJumpers(2 + Math.ceil(wave / 6));
                
            else if (random < 12)
                makeRiders(2 + Math.ceil(wave / 5));
            
            else if (random < 20)
                makeCubes(2 + Math.ceil(wave / 5));
            
        }
        
        private static function makeComplexWave():void{
            var totalAvailable:uint = 5 + wave;
            
            while(totalAvailable){
                var random:Number = Math.random() * wave % 20;

                if (random < 2 && totalAvailable >= 1){
                    makeGlobes(1);
                    totalAvailable--;
                    
                } else if (random < 5 && totalAvailable >= 2){
                    makePiffers(1);
                    totalAvailable -= 2;
                    
                } else if (random < 8 && totalAvailable >= 6){
                    makeJumpers(1);
                    totalAvailable -= 6;
                    
                } else if (random < 12 && totalAvailable >= 6){
                    makeRiders(1);
                    totalAvailable -= 6;
                    
                } else if (random < 15 && totalAvailable >= 8 && TPlayer.backShotLevel > 0){
                    makeShields(1);
                    totalAvailable -= 8;
                } else if (random < 20 && totalAvailable >= 6){
                    makeCubes(1);
                    totalAvailable -= 6;
                }
            }
        }
        
        private static function makeGlobes(count:uint):void{
            while(count--)
                new TEnemyGlobe(power, speed, hp);
        }
        
        private static function makePiffers(count:uint):void{
            while(count--)
                new TEnemyPiffer(power, speed, hp);
        }
        
        private static function makeRiders(count:uint):void{
            while(count--)
                new TEnemyRider(power, speed, hp);
        }
        
        private static function makeJumpers(count:uint):void{
            while(count--)
                new TEnemyJumper(power, speed, hp);
        }
        
        private static function makeShields(count:uint):void{
            while(count--)
                new TEnemyShield(power, speed, hp);
        }
        
        private static function makeCubes(count:uint):void{
            while(count--)
                new TEnemyCube(power, speed, hp);
        }
    }
}