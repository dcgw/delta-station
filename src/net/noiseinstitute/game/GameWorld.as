package net.noiseinstitute.game {
    import flash.geom.Point;
    import flash.system.System;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.debug.Console;
    import net.flashpunk.graphics.Text;

    public class GameWorld extends World {
		
		private static const NUMBER_OF_ASTEROIDS:int = 10;
		private static const MIN_STARTING_DISTANCE_FROM_DELTA:int = 500; 
		private static const MAX_STARTING_DISTANCE_FROM_DELTA:int = 1000;
		
		private var player:Player;
		private var kitten:Kitten;
		private var asteroids:Array = new Array();
		private var deltaStation:DeltaStation;
		private var gameOver:GameOver;
		private var distanceCounter:DistanceCounter;
		private var fuelCounter:FuelCounter;
		
        public function GameWorld() {
			add(new Entity(0, 0, new Starfield(), null));
			
			deltaStation = new DeltaStation(0, 0);
			add(deltaStation);
			
			for (var i:int = 0; i < NUMBER_OF_ASTEROIDS; i++) {
				var x:Number = Math.random() * Main.WIDTH;
				var y:Number = Math.random() * Main.HEIGHT;
				
				asteroids[i] = new Asteroid(x, y);
				add(asteroids[i]);
			}

			// The important bit
			kitten = new Kitten(Math.random() * Main.WIDTH, Math.random() * Main.HEIGHT);
			add(kitten);
			
			const RANGE:int = MAX_STARTING_DISTANCE_FROM_DELTA - MIN_STARTING_DISTANCE_FROM_DELTA;
			var xDistanceFromDelta:int = Math.random() * RANGE;
			var yDistanceFromDelta:int = Math.random() * RANGE;
			player = new Player(xDistanceFromDelta, yDistanceFromDelta);
			add(player);
			
			gameOver = new GameOver(Main.WIDTH/2, Main.HEIGHT/2);
			add(gameOver);
			
			distanceCounter = new DistanceCounter(0, 30);
			add(distanceCounter);
			
			fuelCounter = new FuelCounter(0, 50, 1000.0);
			add(fuelCounter);
        }
		
		public override function update():void {
			camera.x = player.x - Main.WIDTH/2;
			camera.y = player.y - Main.HEIGHT/2;
			var playerPosition:Point = new Point(player.x, player.y);
			var deltaPosition:Point = new Point(deltaStation.x, deltaStation.y);
			var distanceFromDelta:Point = VectorMath.subtract(playerPosition, deltaPosition);
			distanceCounter.distance = VectorMath.magnitude(distanceFromDelta);
			
			// Detect collisions
			if (player.collide("Kitten", player.x, player.y) || 
				player.collide("Asteroid", player.x, player.y)) {
				
				FP.console.log("Collision!");
				player.asplode();
			} else {
				FP.console.log("OK");
			}
			
			if (player.asploded || fuelCounter.isDepleted()) {
				gameOver.setTextVisible();
			}
			
			super.update();
		}
    }
}
