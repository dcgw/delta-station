package net.noiseinstitute.ld22.game
{
    import flash.geom.Point;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.noiseinstitute.ld22.Main;
    import net.noiseinstitute.ld22.VectorMath;

    public class Kitten extends Entity {

        [Embed(source="kitten.png")]
        private static var KittenImage:Class;

        private static const MAX_ANGLE:Number = 360;
        private static const MAX_SPEED:Number = 3 / Main.LOGIC_FPS;
        private static const MAX_SPIN_SPEED:Number = 300 / Main.LOGIC_FPS;

        private var image:Image = new Image(KittenImage);
        private var velocity:Point = new Point();
        private var spinSpeed:Number = 0;

        /**
         * x and y values are the initial position
         *
         * The speed and direction are determined at random.
         */
        public function Kitten(x:Number, y:Number) {
            this.x = x;
            this.y = y;

            // The direction the kitten moves
            var direction:Number = Math.random() * MAX_ANGLE;

            // The speed at which the kitten moves
            var speed:Number = MAX_SPEED * Math.random();

            // The amount that the kitten's current position should change by when it is updated.
            VectorMath.becomePolar(velocity, direction, speed);

            // The speed at which the kitten spins around
            spinSpeed = MAX_SPIN_SPEED * Math.random() * 2 - MAX_SPIN_SPEED;

            image.smooth = true;
            image.centerOrigin();

            type = "Kitten";

            graphic = image;

            setHitbox(image.width, image.height, image.originX, image.originY);
        }

        public override function update():void {
            x += velocity.x;
            y += velocity.y;

            image.angle += spinSpeed;
        }
    }
}