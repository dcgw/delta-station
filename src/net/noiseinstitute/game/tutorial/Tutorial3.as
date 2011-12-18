package net.noiseinstitute.game.tutorial {
    import net.flashpunk.graphics.Image;

    public class Tutorial3 extends Tutorial {
        [Embed(source="Tutorial3.png")]
        private static const IMAGE:Class;

        public function Tutorial3 () {
            super(new Image(IMAGE));
        }
    }
}
