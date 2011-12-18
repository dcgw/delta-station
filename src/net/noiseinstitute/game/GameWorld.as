package net.noiseinstitute.game {
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.utils.Input;

    public class GameWorld extends World {
        [Embed(source="GameMusic.mp3")]
        private static const MUSIC:Class;

        private var music:Sound = Sound(new MUSIC());
        private var musicChannel:SoundChannel;

		private static const NUMBER_OF_ASTEROIDS:int = 15;
		private static const MIN_STARTING_DISTANCE_FROM_DELTA:int = 800; 
		private static const MAX_STARTING_DISTANCE_FROM_DELTA:int = 1200;
		
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

				player.asplode();	
			}
			
			if (player.asploded || fuelCounter.isDepleted()) {
				gameOver.setTextVisible();
				
				if (Input.pressed(Main.KEY_RETRY)) {
					Main.goToIntro();
				}
			}
			
			super.update();
		}

        override public function begin():void {
            end();

            musicChannel = music.play(0, int.MAX_VALUE);
        }

        override public function end():void {
            if (musicChannel != null) {
                musicChannel.stop();
                musicChannel = null;
            }
        }
    }
}
