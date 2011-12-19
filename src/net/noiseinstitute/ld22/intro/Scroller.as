package net.noiseinstitute.ld22.intro {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.noiseinstitute.ld22.Main;

    public class Scroller extends Entity {
        private static const SCROLL_TIME:Number = 4 * Main.LOGIC_FPS;

        private var image:Image;
        private var frame:int = 0;

        public function Scroller (y:Number, image:Image) {
            super(0, y, image);
            this.image = image;
            stop();
        }

        public function start():void {
            frame = 0;
            visible = true;
            active = true;
            x = Main.WIDTH;
        }

        public function stop():void {
            visible = false;
            active = false;
        }

        override public function update():void {
            var startX:Number = Main.WIDTH;
            var endX:Number = -image.width;

            var t:Number = ease(frame/SCROLL_TIME);
            x = (1-t)*startX + t*endX;

            ++frame;
        }

        public function ease(t:Number):Number {
            var r:Number = t <= .5
                    ? .5-((.5-t)*(.5-t)*2)
                    : (t-.5)*(t-.5)*2 + .5;

            return r * 0.5 + t * 0.5;
        }
    }
}
