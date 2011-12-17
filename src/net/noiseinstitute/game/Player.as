package net.noiseinstitute.game {
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;

    public class Player extends Entity {
        [Embed(source="Player.png")]
        private static var PlayerImage:Class;

        public function Player () {
            graphic = new Image(PlayerImage);

        }

        public override function update():void {
            x += 1;
            y += 1;
        }
    }
}
