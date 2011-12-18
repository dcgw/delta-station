package net.noiseinstitute.game.tutorial {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.utils.Ease;
    import net.noiseinstitute.game.Main;

    public class Tutorial extends Entity {
        private static const FADE_IN_TIME:Number = 0.3 * Main.LOGIC_FPS;
        private static const VISIBLE_TIME:Number = 6 * Main.LOGIC_FPS;
        private static const MAX_SCALE:Number = 1.4;

        private var image:Image;
        private var frame:int;

        function Tutorial (image:Image) {
            this.image = image;
            graphic = image;

            image.smooth = true;

            image.centerOrigin();

            active = false;
            visible = false;
        }

        public function start():void {
            frame = 0;
            active = true;
            visible = true;
        }

        public function stop():void {
            active = false;
            visible = false;
        }

        override public function update():void {
            image.scale = 1 + (MAX_SCALE - 1) * frame / VISIBLE_TIME;

            if (frame < FADE_IN_TIME) {
                image.alpha = Ease.sineIn(frame / FADE_IN_TIME);
            } else {
                image.alpha = 1 - Ease.sineOut((frame-FADE_IN_TIME) / (VISIBLE_TIME-FADE_IN_TIME));
            }

            if (frame > VISIBLE_TIME) {
                stop();
            }

            ++frame;
        }
    }
}
