package net.noiseinstitute.game {
    import net.flashpunk.Entity;
    import net.flashpunk.World;

    public class GameWorld extends World {
		
		public static const NUMBER_OF_ASTEROIDS:int = 10;
		
		private var player:Player;
		
        public function GameWorld() {
			add(new Entity(0, 0, new Starfield(), null));
			
            player = new Player();
            add(player);
			
			for (var i:int = 0; i < NUMBER_OF_ASTEROIDS; i++) {
				var x:Number = Math.random() * Main.WIDTH;
				var y:Number = Math.random() * Main.HEIGHT;
				
				add(new Asteroid(x, y));
			}

			add(new Kitten(Math.random() * Main.WIDTH, Math.random() * Main.HEIGHT));
        }
		
		public override function update():void {
			camera.x = player.x - Main.WIDTH/2;
			camera.y = player.y - Main.HEIGHT/2;
			super.update();
		}
    }
}
