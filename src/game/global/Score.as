package game.global{
    import net.retrocade.vault.Safe;

    public class Score{
        public static var score:Safe = new Safe(0);
        
        public static var cash:Safe = new Safe(0);
        
        public static var highestCash:Safe = new Safe(0);
        public static var highestScoreNoUpgrade:Safe = new Safe(0); 
    }
}