package net.noiseinstitute.ld22.game
{
    import flash.geom.Point;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.noiseinstitute.ld22.VectorMath;

    public class Asteroid extends Entity {

        [Embed(source="asteroid.png")]
        private static var AsteroidImage:Class;

        private static const MAX_ANGLE:Number = 360;
        private static const MAX_SPEED:Number = 1;
        private static const MAX_SPIN_SPEED:Number = 5;

        private var image:Image = new Image(AsteroidImage);
        private var positionDelta:Point = new Point();
        private var spinSpeed:Number = 0;

        /**
         * x and y values are the initial position
         *
         * The speed and direction are determined at random.
         */
        public function Asteroid(x:Number, y:Number) {
            this.x = x;
            this.y = y;

            // The direction the asteroid moves
            var direction:Number = Math.random() * MAX_ANGLE;

            // The speed at which the asteroid moves
            var speed:Number = MAX_SPEED * Math.random();

            // The amount that the asteroid's current position should change by when it is updated.
            VectorMath.becomePolar(positionDelta, direction, speed);

            // The speed at which the asteroid spins around
            spinSpeed = MAX_SPIN_SPEED * Math.random();

            graphic = image;
            type = "Asteroid";

            image.centerOrigin();

            setHitbox(image.width, image.height, image.originX, image.originY);
        }

        public override function update():void {
            x += positionDelta.x;
            y += positionDelta.y;

            image.angle += spinSpeed;

            // TODO if asteroid position is outside GameWorld.HEIGHT or GameWorld.WIDTH, move asteroid
        }
    }
}