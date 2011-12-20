package net.noiseinstitute.ld22.game
{
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.noiseinstitute.ld22.Main;

    public class DeltaStation extends Entity {
        [Embed(source="DeltaStation.png")]
        private static var DeltaStationImage:Class;

        private static const ANGULAR_VELOCITY:Number = -10/Main.LOGIC_FPS;

        private var image:Image = new Image(DeltaStationImage);

        public function DeltaStation(x:Number=0, y:Number=0) {
            this.x = x;
            this.y = y;

            image.centerOrigin();
            image.smooth = true;
            graphic = image;
        }

        override public function update():void {
            image.angle += ANGULAR_VELOCITY;
        }
    }
}