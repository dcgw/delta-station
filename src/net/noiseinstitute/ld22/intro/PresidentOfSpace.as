package net.noiseinstitute.ld22.intro {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.noiseinstitute.ld22.game.Trig;

    public class PresidentOfSpace extends Entity {
        [Embed(source="PresidentOfSpace1.png")]
        private static const IMAGE1:Class;

        [Embed(source="PresidentOfSpace2.png")]
        private static const IMAGE2:Class;

        private var image1:Image = new Image(IMAGE1);
        private var image2:Image = new Image(IMAGE2);

        private var frame:int = 0;

        public var speaking:Boolean = false;

        public function PresidentOfSpace () {
            image1.centerOrigin();
            image2.centerOrigin();

            image1.y = image1.originY;
            image2.x = image2.originX;

            image2.y = image2.originY;
            image1.x = image1.originX;

            image1.smooth = true;
            image2.smooth = true;

            graphic = image1;
        }

        override public function update():void {
            image1.scale = 1 + 0.025 * Trig.sin(frame) + 0.0125 * Trig.sin(frame * 0.65);
            image2.scale = image1.scale;

            image1.angle = 0 + 7 * Trig.sin(frame * 0.567) - 3 * Trig.sin(frame * 0.381);
            image2.angle = image1.angle;

            if (speaking) {
                if (frame % 12 <= 7) {
                    graphic = image1;
                } else {
                    graphic = image2;
                }
            } else {
                graphic = image1;
            }

            frame++;
        }
    }
}
