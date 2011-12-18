package net.noiseinstitute.game.intro {
    import net.flashpunk.World;

    public class IntroWorld extends World {
        private var presidentOfSpace:PresidentOfSpace = new PresidentOfSpace();

        public function IntroWorld () {
            add(presidentOfSpace);
            presidentOfSpace.speaking = true;
        }
    }
}
