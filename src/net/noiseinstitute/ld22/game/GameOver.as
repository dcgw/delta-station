package net.noiseinstitute.ld22.game
{
    import flash.filters.GlowFilter;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.noiseinstitute.ld22.Main;
    import net.noiseinstitute.ld22.Range;

    public class GameOver extends Entity
    {
        private static const TEXT1_FADE_START:Number=0;
        private static const TEXT1_FADE_END:Number=0.4 * Main.LOGIC_FPS;

        private static const TEXT2_FADE_START:Number = 0.2 * Main.LOGIC_FPS;
        private static const TEXT2_FADE_END:Number = 0.6 * Main.LOGIC_FPS;

        private static const SCREEN_FADE_START:Number = 0;
        private static const SCREEN_FADE_END:Number = 10 * Main.LOGIC_FPS;

        private var frame:int = 0;

        private var fade:Image = Image.createRect(Main.WIDTH, Main.HEIGHT, 0x000000);

        private var gameOverText1:Text = new Text("You failed to reach Delta Station");
        private var gameOverText2:Text = new Text("The President is most disappointed");

        public function GameOver(x:Number, y:Number)
        {
            this.x = x;
            this.y = y;

            fade.centerOrigin();
            fade.alpha = 0;

            gameOverText1.field.filters = [new GlowFilter(0xff00ff, 1, 10, 10, 1, 2)];
            gameOverText1.font = "Electrolize";
            gameOverText1.size = 32;
            gameOverText1.originX = gameOverText1.textWidth * 0.5;
            gameOverText1.originY = gameOverText1.textHeight;
            gameOverText1.alpha = 0;

            gameOverText2.field.filters = [new GlowFilter(0xffff00, 1, 10, 10, 1, 2)];
            gameOverText2.font = "Electrolize";
            gameOverText2.size = 32;
            gameOverText2.originX = gameOverText2.textWidth * 0.5;
            gameOverText2.originY = 0;
            gameOverText2.alpha = 0;

            graphic = new Graphiclist(fade, gameOverText1, gameOverText2);
            graphic.scrollX = 0;
            graphic.scrollY = 0;

            active = false;
            visible = false;
        }

        public function start():void {
            active = true;
            visible = true;
            frame = 0;
        }

        override public function update():void {
            gameOverText1.alpha = Range.clip((frame - TEXT1_FADE_START)/(TEXT1_FADE_END-TEXT1_FADE_START), 0, 1);
            gameOverText2.alpha = Range.clip((frame - TEXT2_FADE_START)/(TEXT2_FADE_END-TEXT2_FADE_START), 0, 1);
            fade.alpha = Range.clip((frame - SCREEN_FADE_START)/(SCREEN_FADE_END-SCREEN_FADE_START), 0, 1);

            ++frame;
        }
    }
}