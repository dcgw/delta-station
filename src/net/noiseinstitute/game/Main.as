package net.noiseinstitute.game {
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    import net.noiseinstitute.game.intro.IntroWorld;

    [SWF(width="640", height="480", backgroundColor="#000000", frameRate="60")]
    public class Main extends Engine {
        public static const WIDTH:int = 640;
        public static const HEIGHT:int = 480;
        public static const LOGIC_FPS:int = 60;

        public static const KEY_LEFT:String = "left";
        public static const KEY_RIGHT:String = "right";
        public static const KEY_THRUST:String = "thrust";

        private static var _main:Main;

        public static function goToGame():void {
            FP.world = _main._gameWorld;
        }

        public static function goToIntro():void {
            FP.world = _main._introWorld;
        }

        private var _introWorld:IntroWorld;
        private var _gameWorld:GameWorld;

        public function Main() {
            super(WIDTH, HEIGHT, LOGIC_FPS, true);

            _main = this;

            _introWorld = new IntroWorld();
            _gameWorld = new GameWorld();

            Input.define(KEY_LEFT, Key.LEFT);
            Input.define(KEY_RIGHT, Key.RIGHT);
            Input.define(KEY_THRUST, Key.UP);

            FP.screen.color = 0x000000;

            FP.console.enable();

            FP.world = _introWorld;
        }
    }
}
