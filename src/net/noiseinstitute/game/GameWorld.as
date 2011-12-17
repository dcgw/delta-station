package net.noiseinstitute.game {
    import net.flashpunk.Entity;
    import net.flashpunk.World;

    public class GameWorld extends World {
		
		private static const NUMBER_OF_ASTEROIDS:int = 10;
		private static const MIN_STARTING_DISTANCE_FROM_DELTA_STATION:int = 500; 
		private static const MAX_STARTING_DISTANCE_FROM_DELTA_STATION:int = 1000; 
		
		private var player:Player;
		
        public function GameWorld() {
			add(new Entity(0, 0, new Starfield(), null));
			
			var deltaStation:DeltaStation = new DeltaStation(0, 0);
			add(deltaStation);
			
			const RANGE_FROM_DELTA_STATION:int = MAX_STARTING_DISTANCE_FROM_DELTA_STATION - MIN_STARTING_DISTANCE_FROM_DELTA_STATION;
			var xDistanceFromDelta:int = Math.random() * RANGE_FROM_DELTA_STATION;
			var yDistanceFromDelta:int = Math.random() * RANGE_FROM_DELTA_STATION;
            player = new Player(xDistanceFromDelta, yDistanceFromDelta);
            add(player);
			
			for (var i:int = 0; i < NUMBER_OF_ASTEROIDS; i++) {
				var x:Number = Math.random() * Main.WIDTH;
				var y:Number = Math.random() * Main.HEIGHT;
				
				add(new Asteroid(x, y));
			}

			// The important bit
			add(new Kitten(Math.random() * Main.WIDTH, Math.random() * Main.HEIGHT));	
        }
		
		public override function update():void {
			camera.x = player.x - Main.WIDTH/2;
			camera.y = player.y - Main.HEIGHT/2;
			super.update();
		}
    }
}
