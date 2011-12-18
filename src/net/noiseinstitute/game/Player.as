package net.noiseinstitute.game {
    import flash.geom.Point;
    
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.utils.Input;

    public class Player extends Entity {
        [Embed(source="Player.png")]
        private static var PlayerImage:Class;

        private static const ANGULAR_THRUST:Number = 1/Main.LOGIC_FPS;
        private static const THRUST:Number = 1/Main.LOGIC_FPS;

        private var angle:Number = 0;
        private var angularVelocity:Number = 0;

        private var velocity:Point = new Point;

        private var image:Image;

        public function Player (x:Number, y:Number) {
            this.x = x;
            this.y = y;

            angularVelocity = Math.random() - 0.5;

            VectorMath.becomePolar(velocity, Math.random() * 360, Math.random());

            angle = Math.random() * 360;

            image = new Image(PlayerImage);
            image.smooth = true;

            graphic = image;

            image.centerOrigin();
        }

        public override function update():void {
            if (Input.check(Main.KEY_LEFT)) {
                angularVelocity += ANGULAR_THRUST;
				FuelCounter.fuel -= 0.3;
            }
            if (Input.check(Main.KEY_RIGHT)) {
                angularVelocity -= ANGULAR_THRUST;
				FuelCounter.fuel -= 0.3;
            }
            if (Input.check(Main.KEY_THRUST)) {
                VectorMath.becomePolar(Static.point, angle, THRUST);
                VectorMath.addTo(velocity, Static.point);
				FuelCounter.fuel -= 0.5;
            }

            angle += angularVelocity;
            x += velocity.x;
            y += velocity.y;

            image.angle = angle;
        }
    }
}
