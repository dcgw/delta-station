package net.noiseinstitute.ld22.game
{
    import flash.geom.Point;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.noiseinstitute.ld22.Main;
    import net.noiseinstitute.ld22.Range;
    import net.noiseinstitute.ld22.VectorMath;

    public class Asteroid extends Entity {

        [Embed(source="asteroid.png")]
        private static var AsteroidImage:Class;

        private static const MAX_ANGLE:Number = 360;
        private static const MAX_SPEED:Number = 20 / Main.LOGIC_FPS;
        private static const MAX_SPIN_SPEED:Number = 100 / Main.LOGIC_FPS;

        private var image:Image = new Image(AsteroidImage);

        private var player:Player;

        private var velocity:Point = new Point();
        private var spinSpeed:Number = 0;

        /**
         * x and y values are the initial position
         *
         * The speed and direction are determined at random.
         */
        public function Asteroid(x:Number, y:Number, player:Player) {
            this.x = x;
            this.y = y;

            this.player = player;

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

            setHitbox(image.width, image.height, image.originX, image.originY);
        }

        public override function update():void {
            x += velocity.x;
            y += velocity.y;

            image.angle += spinSpeed;

            x = Range.wrap(x, player.x - GameWorld.ASTEROID_WRAP_WIDTH*0.5, player.x + GameWorld.ASTEROID_WRAP_WIDTH*0.5);
            y = Range.wrap(y, player.y - GameWorld.ASTEROID_WRAP_WIDTH*0.5, player.y + GameWorld.ASTEROID_WRAP_WIDTH*0.5);
        }
    }
}