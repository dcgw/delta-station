package net.noiseinstitute.ld22.game
{
    import flash.filters.GlowFilter;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.noiseinstitute.ld22.Main;
    import net.noiseinstitute.ld22.Range;

    public class Win extends Entity
    {
        private static const TEXT1_FADE_START:Number=0;
        private static const TEXT1_FADE_END:Number=0.4 * Main.LOGIC_FPS;

        private static const TEXT2_FADE_START:Number = 0.2 * Main.LOGIC_FPS;
        private static const TEXT2_FADE_END:Number = 0.6 * Main.LOGIC_FPS;

        private static const SCREEN_FADE_START:Number = 0;
        private static const SCREEN_FADE_END:Number = 10 * Main.LOGIC_FPS;

        private var frame:int = 0;

        private var fade:Image = Image.createRect(Main.WIDTH, Main.HEIGHT, 0x000000);

        private var winText1:Text = new Text("You successfully reached Delta Station");
        private var winText2:Text = new Text("Your tea is delicious");

        public function Win(x:Number, y:Number)
        {
            this.x = x;
            this.y = y;

            fade.centerOrigin();
            fade.alpha = 0;

            winText1.field.filters = [new GlowFilter(0x0000ff, 1, 10, 10, 1, 2)];
            winText1.font = "Electrolize";
            winText1.size = 32;
            winText1.originX = winText1.textWidth * 0.5;
            winText1.originY = winText1.textHeight;
            winText1.alpha = 0;

            winText2.field.filters = [new GlowFilter(0xff0000, 1, 10, 10, 1, 2)];
            winText2.font = "Electrolize";
            winText2.size = 32;
            winText2.originX = winText2.textWidth * 0.5;
            winText2.originY = 0;
            winText2.alpha = 0;

            graphic = new Graphiclist(fade, winText1, winText2);
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
            winText1.alpha = Range.clip((frame - TEXT1_FADE_START)/(TEXT1_FADE_END-TEXT1_FADE_START), 0, 1);
            winText2.alpha = Range.clip((frame - TEXT2_FADE_START)/(TEXT2_FADE_END-TEXT2_FADE_START), 0, 1);
            fade.alpha = Range.clip((frame - SCREEN_FADE_START)/(SCREEN_FADE_END-SCREEN_FADE_START), 0, 1);

            ++frame;
        }
    }
}