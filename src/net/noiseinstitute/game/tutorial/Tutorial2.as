package net.noiseinstitute.game.tutorial {
    import net.flashpunk.graphics.Image;

    public class Tutorial2 extends Tutorial {
        [Embed(source="Tutorial2.png")]
        private static const IMAGE:Class;

        public function Tutorial2 () {
            super(new Image(IMAGE));
        }
    }
}
