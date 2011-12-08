package net.noiseinstitute.game {
    import net.flashpunk.Engine;
    import net.flashpunk.FP;

    [SWF(width="640", height="480", backgroundColor="#000000", frameRate="60")]
    public class Main extends Engine {
        public static const WIDTH:int = 640;
        public static const HEIGHT:int = 480;
        public static const LOGIC_FPS:int = 60;

        public function Main() {
            super(WIDTH, HEIGHT, LOGIC_FPS, true);
            FP.world = new GameWorld();
        }
    }
}