package net.noiseinstitute.ld22.game {
    import flash.geom.Point;
    import flash.media.Sound;
    import flash.media.SoundChannel;

    import net.flashpunk.Entity;
    import net.flashpunk.World;
    import net.flashpunk.utils.Input;
    import net.noiseinstitute.ld22.*;
    import net.noiseinstitute.ld22.tutorial.Tutorial1;
    import net.noiseinstitute.ld22.tutorial.Tutorial2;
    import net.noiseinstitute.ld22.tutorial.Tutorial3;

    public class GameWorld extends World {
        [Embed(source="GameMusic.mp3")]
        private static const MUSIC:Class;

        private var music:Sound = Sound(new MUSIC());
        private var musicChannel:SoundChannel;

        private static const NUMBER_OF_ASTEROIDS:int = 120;
        public static const ASTEROID_WRAP_WIDTH:int = 1400;
        public static const ASTEROID_WRAP_HEIGHT:int = 1400;

        private static const KITTEN_DISTANCE_FROM_DELTA_STATION:Number = 800;

        private static const WIN_DISTANCE:Number = 200;

        private var player:Player;
        private var kitten:Kitten;
        private var asteroids:Array = new Array();
        private var deltaStation:DeltaStation;
        private var gameOver:GameOver;
        private var win:Win;
        private var distanceCounter:DistanceCounter;
        private var fuelCounter:FuelCounter;
        private var teaCounter:TeaCounter;

        private var tutorial1:Tutorial1 = new Tutorial1();
        private var tutorial2:Tutorial2 = new Tutorial2();
        private var tutorial3:Tutorial3 = new Tutorial3();

        private var tutorialLevel:int = 0;

        private var frame:int = 0;

        public function GameWorld() {
            add(new Entity(0, 0, new Starfield(), null));

            var deltaStationAngle:Number = Math.random() * 360;
            var deltaStationPosition:Point = VectorMath.polar(deltaStationAngle, 10000);
            deltaStation = new DeltaStation(deltaStationPosition.x, deltaStationPosition.y);
            add(deltaStation);

            fuelCounter = new FuelCounter(0, 50, 1000);

            var playerFlameParticles:PlayerFlameParticles = new PlayerFlameParticles();
            player = new Player(0, 0, fuelCounter, playerFlameParticles);
            add(player);

            add(new Entity(0, 0, playerFlameParticles));

            for (var i:int = 0; i < NUMBER_OF_ASTEROIDS; i++) {
                var x:Number = Math.random() * ASTEROID_WRAP_WIDTH;
                var y:Number = Math.random() * ASTEROID_WRAP_HEIGHT;

                asteroids[i] = new Asteroid(x, y, player, i/NUMBER_OF_ASTEROIDS);
                add(asteroids[i]);
            }

            // The important bit
            var kittenAngleFromDeltaStation:Number = Math.random() * 360;
            var kittenStartPosition:Point = VectorMath.polar(kittenAngleFromDeltaStation, KITTEN_DISTANCE_FROM_DELTA_STATION);
            kitten = new Kitten(deltaStation.x + kittenStartPosition.x, deltaStation.y + kittenStartPosition.y);
            add(kitten);

            distanceCounter = new DistanceCounter(player, deltaStation);
            add(distanceCounter);

            add(fuelCounter);

            teaCounter = new TeaCounter(0, 70);
            add(teaCounter);

            add(tutorial1);
            add(tutorial2);
            add(tutorial3);

            gameOver = new GameOver(Main.WIDTH/2, Main.HEIGHT/2);
            add(gameOver);

            win = new Win(Main.WIDTH/2, Main.HEIGHT/2);
            add(win);
        }

        public override function update():void {
            camera.x = player.x - Main.WIDTH/2;
            camera.y = player.y - Main.HEIGHT/2;

            // Detect collisions
            if (player.collide("Kitten", player.x, player.y)
                    || player.collide("Asteroid", player.x, player.y)) {
                player.asplode();
            }

            Static.point.x = deltaStation.x - player.x;
            Static.point.y = deltaStation.y - player.y;
            if (VectorMath.magnitude(Static.point) < WIN_DISTANCE) {
                player.stop();
                if (!win.active) {
                    win.start();
                }
            }

            if (player.asploded) {
                if (!gameOver.active) {
                    gameOver.start();
                }
            }

            if (player.asploded || win.active) {
                if (Input.pressed(Main.KEY_CONTINUE)) {
                    Main.goToTitle();
                }
            }

            if (frame > 3.2 * Main.LOGIC_FPS && tutorialLevel < 1) {
                tutorial1.x = player.x - 32;
                tutorial1.y = player.y + 96;
                tutorial1.start();
                tutorialLevel = 1;
            }
            if (frame > 6 * Main.LOGIC_FPS && tutorialLevel < 2) {
                tutorial2.x = player.x;
                tutorial2.y = player.y + 112;
                tutorial2.start();
                tutorialLevel = 2;
            }
            if (frame > 8.8 * Main.LOGIC_FPS && tutorialLevel < 3) {
                tutorial3.x = player.x + 32;
                tutorial3.y = player.y + 128;
                tutorial3.start();
                tutorialLevel = 3;
            }

            ++frame;
            teaCounter.kelvin = teaCounter.kelvin - 0.01;

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
