package net.noiseinstitute.game {
    import net.flashpunk.World;

    public class GameWorld extends World {
		
		public static const NUMBER_OF_ASTEROIDS:int = 10;
		
        public function GameWorld() {
            var player:Player = new Player();
            add(player);
			
			for (var i:int = 0; i < NUMBER_OF_ASTEROIDS; i++) {
				var x:Number = Math.random() * Main.WIDTH;
				var y:Number = Math.random() * Main.HEIGHT;
				
				var asteroid:Asteroid = new Asteroid(x, y);
				add(asteroid);
			}
			
        }
    }
}
