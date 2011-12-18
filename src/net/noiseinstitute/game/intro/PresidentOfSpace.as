package net.noiseinstitute.game.intro {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;

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
            graphic = image1;
        }

        override public function update():void {
            frame++;
            if (speaking) {
                if (frame % 12 <= 7) {
                    graphic = image1;
                } else {
                    graphic = image2;
                }
            } else {
                graphic = image1;
            }
        }
    }
}
