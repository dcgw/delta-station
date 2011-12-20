package net.noiseinstitute.ld22 {
    import net.flashpunk.Engine;
    import net.flashpunk.FP;
    import net.flashpunk.utils.Input;
    import net.flashpunk.utils.Key;
    import net.noiseinstitute.ld22.game.GameWorld;
    import net.noiseinstitute.ld22.intro.IntroWorld;
    import net.noiseinstitute.ld22.title.TitleWorld;

    [SWF(width="640", height="480", backgroundColor="#000000", frameRate="60")]
    public class Main extends Engine {
        [Embed(source="Electrolize-Regular.ttf", embedAsCFF="false", fontFamily="Electrolize")]
        private static const FONT_CLASS:Class;

        public static const FONT:String = "Electrolize";

        public static const WIDTH:int = 640;
        public static const HEIGHT:int = 480;
        public static const LOGIC_FPS:int = 60;

        public static const KEY_LEFT:String = "left";
        public static const KEY_RIGHT:String = "right";
        public static const KEY_THRUST:String = "thrust";
        public static const KEY_CONTINUE:String = "continue";

        private static var _main:Main;

        public static function goToGame():void {
            FP.world = new GameWorld();
        }

        public static function goToTitle():void {
            FP.world = _main._titleWorld;
        }

        public static function goToIntro():void {
            FP.world = _main._introWorld;
        }

        private var _titleWorld:TitleWorld;
        private var _introWorld:IntroWorld;

        public function Main() {
            super(WIDTH, HEIGHT, LOGIC_FPS, true);

            _main = this;

            _titleWorld = new TitleWorld();
            _introWorld = new IntroWorld();

            Input.define(KEY_LEFT, Key.LEFT);
            Input.define(KEY_RIGHT, Key.RIGHT);
            Input.define(KEY_THRUST, Key.UP);
            Input.define(KEY_CONTINUE, Key.ENTER, Key.SPACE, Key.X);

            FP.screen.color = 0x000000;

            FP.console.enable();

            FP.world = _titleWorld;
        }
    }
}
