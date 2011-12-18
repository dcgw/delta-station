package net.noiseinstitute.game {
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    
    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.utils.Input;

    import net.noiseinstitute.game.tutorial.Tutorial1;
    import net.noiseinstitute.game.tutorial.Tutorial2;
    import net.noiseinstitute.game.tutorial.Tutorial3;

    public class GameWorld extends World {
        [Embed(source="GameMusic.mp3")]
        private static const MUSIC:Class;

        private var music:Sound = Sound(new MUSIC());
        private var musicChannel:SoundChannel;

		private static const NUMBER_OF_ASTEROIDS:int = 40;
		private static const MIN_STARTING_DISTANCE_FROM_DELTA:int = 800; 
		private static const MAX_STARTING_DISTANCE_FROM_DELTA:int = 1200;
		private static const PLAY_AREA_WIDTH:int = 1500;
		private static const PLAY_AREA_HEIGHT:int = 1500;
		
		private var player:Player;
		private var kitten:Kitten;
		private var asteroids:Array = new Array();
		private var deltaStation:DeltaStation;
		private var gameOver:GameOver;
		private var distanceCounter:DistanceCounter;
		private var fuelCounter:FuelCounter;

        private var tutorial1:Tutorial1 = new Tutorial1();
        private var tutorial2:Tutorial2 = new Tutorial2();
        private var tutorial3:Tutorial3 = new Tutorial3();

        private var tutorialLevel:int = 0;

        private var frame:int = 0;
		
        public function GameWorld() {
			add(new Entity(0, 0, new Starfield(), null));
			
			deltaStation = new DeltaStation(0, 0);
			add(deltaStation);
			
			for (var i:int = 0; i < NUMBER_OF_ASTEROIDS; i++) {
				var x:Number = Math.random() * PLAY_AREA_WIDTH;
				var y:Number = Math.random() * PLAY_AREA_HEIGHT;
				
				asteroids[i] = new Asteroid(x, y);
				add(asteroids[i]);
			}

			// The important bit
			kitten = new Kitten(Math.random() * Main.WIDTH, Math.random() * Main.HEIGHT);
			add(kitten);

            var playerAngleFromDeltaStation:Number = Math.random() * 360;
            var playerPosition:Point = VectorMath.polar(playerAngleFromDeltaStation, 10000);
            player = new Player(playerPosition.x, playerPosition.y);
			add(player);
			
			gameOver = new GameOver(Main.WIDTH/2, Main.HEIGHT/2);
			add(gameOver);
			
			distanceCounter = new DistanceCounter(0, 30);
			add(distanceCounter);
			
			fuelCounter = new FuelCounter(0, 50, 1000.0);
			add(fuelCounter);

            add(tutorial1);
            add(tutorial2);
            add(tutorial3);
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

            if (frame > 0.2 * Main.LOGIC_FPS && tutorialLevel < 1) {
                tutorial1.x = player.x - 32;
                tutorial1.y = player.y + 96;
                tutorial1.start();
                tutorialLevel = 1;
            }
            if (frame > 3 * Main.LOGIC_FPS && tutorialLevel < 2) {
                tutorial2.x = player.x;
                tutorial2.y = player.y + 112;
                tutorial2.start();
                tutorialLevel = 2;
            }
            if (frame > 5.8 * Main.LOGIC_FPS && tutorialLevel < 3) {
                tutorial3.x = player.x + 32;
                tutorial3.y = player.y + 128;
                tutorial3.start();
                tutorialLevel = 3;
            }

            ++frame;

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
