package net.noiseinstitute.ld22.game
{
    import flash.geom.Point;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.noiseinstitute.ld22.Main;
    import net.noiseinstitute.ld22.Range;
    import net.noiseinstitute.ld22.Static;
    import net.noiseinstitute.ld22.VectorMath;
    import net.noiseinstitute.ld22.collisions.RotatablePixelmask;

    public class Asteroid extends Entity {

        [Embed(source="asteroid.png")]
        private static var AsteroidImage:Class;

        private static const NEAR_PLAYER_DISTANCE:Number = 700;

        private static const ASTEROIDS_START_DISTANCE:Number = 500;
        private static const ASTEROIDS_END_DISTANCE:Number = 9000;

        private static const MAX_ANGLE:Number = 360;
        private static const MAX_SPEED:Number = 20 / Main.LOGIC_FPS;
        private static const MAX_SPIN_SPEED:Number = 100 / Main.LOGIC_FPS;

        private var image:Image = new Image(AsteroidImage);

        private var rotatablePixelMask:RotatablePixelmask;

        private var player:Player;

        private var velocity:Point = new Point();
        private var spinSpeed:Number = 0;
        private var difficulty:Number;

        /**
         * x and y values are the initial position
         *
         * The speed and direction are determined at random.
         */
        public function Asteroid(x:Number, y:Number, player:Player, difficulty:Number) {
            this.x = x;
            this.y = y;

            this.player = player;

            this.difficulty = difficulty;

            // The direction the asteroid moves
            var direction:Number = Math.random() * MAX_ANGLE;

            // The speed at which the asteroid moves
            var speed:Number = MAX_SPEED * Math.random();

            // The amount that the asteroid's current position should change by when it is updated.
            VectorMath.becomePolar(velocity, direction, speed);

            // The speed at which the asteroid spins around
            spinSpeed = MAX_SPIN_SPEED * Math.random() * 2 - MAX_SPIN_SPEED;

            graphic = image;
            type = "Asteroid";

            image.smooth = true;
            image.centerOrigin();

            rotatablePixelMask = new RotatablePixelmask(AsteroidImage);
            rotatablePixelMask.centerOrigin();

            mask = rotatablePixelMask;

            setHitbox(rotatablePixelMask.width, rotatablePixelMask.height,
                    -rotatablePixelMask.bufferOffsetX, -rotatablePixelMask.bufferOffsetY);

            updateDifficulty(-GameWorld.ASTEROID_WRAP_WIDTH*0.5, GameWorld.ASTEROID_WRAP_WIDTH*0.5,
                    -GameWorld.ASTEROID_WRAP_HEIGHT*0.5, GameWorld.ASTEROID_WRAP_HEIGHT*0.5);
        }

        public override function update():void {
            x += velocity.x;
            y += velocity.y;

            image.angle += spinSpeed;
            rotatablePixelMask.angle = image.angle;

            var playfieldLeft:Number = player.x - GameWorld.ASTEROID_WRAP_WIDTH*0.5;
            var playfieldRight:Number = player.x + GameWorld.ASTEROID_WRAP_WIDTH*0.5;
            var playfieldTop:Number = player.y - GameWorld.ASTEROID_WRAP_HEIGHT*0.5;
            var playfieldBottom:Number = player.y + GameWorld.ASTEROID_WRAP_HEIGHT*0.5;

            x = Range.wrap(x, playfieldLeft, playfieldRight);
            y = Range.wrap(y, playfieldTop, playfieldBottom);

            Static.point.x = x - player.x;
            Static.point.y = y - player.y;
            var distanceFromPlayer:Number = VectorMath.magnitude(Static.point);

            if (distanceFromPlayer > NEAR_PLAYER_DISTANCE) {
                updateDifficulty(playfieldLeft, playfieldRight, playfieldTop, playfieldBottom);
            }
        }

        private function updateDifficulty (playfieldLeft:Number, playfieldRight:Number, playfieldTop:Number, playfieldBottom:Number):void {
            var difficultyDistance:Number = ASTEROIDS_START_DISTANCE
                    + difficulty * (ASTEROIDS_END_DISTANCE - ASTEROIDS_START_DISTANCE);

            Static.point.x = Range.wrap(x, playfieldLeft, playfieldRight);
            Static.point.y = Range.wrap(y, playfieldTop, playfieldBottom);

            var startDistance:Number = VectorMath.magnitude(Static.point);
            collidable = visible = startDistance > difficultyDistance
                    && startDistance < ASTEROIDS_END_DISTANCE;
        }
    }
}