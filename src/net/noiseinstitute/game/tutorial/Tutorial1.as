package net.noiseinstitute.game.tutorial {
    import net.flashpunk.graphics.Image;

    public class Tutorial1 extends Tutorial {
        [Embed(source="Tutorial1.png")]
        private static const IMAGE:Class;

        public function Tutorial1 () {
            super(new Image(IMAGE));
        }
    }
}
