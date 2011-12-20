package net.noiseinstitute.ld22.title {
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.filters.GlowFilter;

    import net.flashpunk.Entity;
    import net.flashpunk.FP;
    import net.flashpunk.World;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.flashpunk.utils.Input;
    import net.noiseinstitute.ld22.Main;

    public class TitleWorld extends World {
        [Embed(source="KittenDare.png")]
        private static const KITTEN_IMAGE:Class;

        private var clickHere:Entity;
        private var pressSpace:Entity;

        private var listening:Boolean;

        public function TitleWorld() {
            var kittenImage:Image = new Image(KITTEN_IMAGE);
            add(new Entity(Main.WIDTH - kittenImage.width - 64,
                    Main.HEIGHT - kittenImage.height - 64,
                    kittenImage));

            var titleText1:Text = new Text("10,000 Space Leagues");
            titleText1.field.filters = [new GlowFilter(0xffff00, 1, 12, 12, 1, 2)];
            titleText1.font = Main.FONT;
            titleText1.size = 48;
            titleText1.centerOrigin();
            add(new Entity(Main.WIDTH * 0.5, 64, titleText1));

            var titleText2:Text = new Text("from Delta Station");
            titleText2.field.filters = [new GlowFilter(0xff0000, 1, 12, 12, 1, 2)];
            titleText2.font = Main.FONT;
            titleText2.size = 48;
            titleText2.centerOrigin();
            add(new Entity(Main.WIDTH * 0.5, 128, titleText2));

            var clickHereText:Text = new Text("click here to play");
            clickHereText.field.filters = [new GlowFilter(0x0000ff, 1, 8, 8, 1, 2)];
            clickHereText.font = Main.FONT;
            clickHereText.size = 28;
            clickHereText.centerOrigin();

            clickHere = new Entity(Main.WIDTH * 0.5, 256, clickHereText);
            add(clickHere);

            var pressSpaceText:Text = new Text("press space to play");
            pressSpaceText.field.filters = [new GlowFilter(0x00ff00, 1, 8, 8, 1, 2)];
            pressSpaceText.font = Main.FONT;
            pressSpaceText.size = 28;
            pressSpaceText.centerOrigin();

            pressSpace = new Entity(Main.WIDTH * 0.5, 256, pressSpaceText);
            pressSpace.visible = false;
            add(pressSpace);
        }

        override public function update():void {
            if (!listening) {
                FP.stage.addEventListener(MouseEvent.MOUSE_DOWN, onFocus);
                FP.stage.addEventListener(Event.ACTIVATE, onFocus);
                FP.stage.addEventListener(Event.DEACTIVATE, onBlur);
                listening = true;
            } else if (Input.pressed(Main.KEY_CONTINUE)) {
                Main.goToIntro();
            }
        }

        private function onFocus(event:Event):void {
            pressSpace.visible = true;
            clickHere.visible = false;
        }

        private function onBlur(event:Event):void {
            clickHere.visible = true;
            pressSpace.visible = false;
        }
    }
}
