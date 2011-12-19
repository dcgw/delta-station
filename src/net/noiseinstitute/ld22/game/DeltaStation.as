package net.noiseinstitute.ld22.game
{
    import net.noiseinstitute.ld22.*;
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Image;

    public class DeltaStation extends Entity {
        [Embed(source="Player.png")]
        private static var DeltaStationImage:Class;

        public function DeltaStation(x:Number=0, y:Number=0) {
            this.x = x;
            this.y = y;

            graphic = new Image(DeltaStationImage);
        }
    }
}