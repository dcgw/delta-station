package net.noiseinstitute.game {
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;

    [SWF(width="640", height="480", backgroundColor="#000000", frameRate="60")]
    public class Main extends Engine {
        public static const WIDTH:int = 640;
        public static const HEIGHT:int = 480;
        public static const LOGIC_FPS:int = 60;

        public static const KEY_LEFT:String = "left";
        public static const KEY_RIGHT:String = "right";
        public static const KEY_THRUST:String = "thrust";

        public function Main() {
            super(WIDTH, HEIGHT, LOGIC_FPS, true);

            Input.define(KEY_LEFT, Key.LEFT);
            Input.define(KEY_RIGHT, Key.RIGHT);
            Input.define(KEY_THRUST, Key.UP);

            FP.screen.color = 0x000000;

            FP.console.enable();

            FP.world = new GameWorld();
        }
    }
}
