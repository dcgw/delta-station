package net.noiseinstitute.ld22.game
{
    import flashx.textLayout.formats.TextAlign;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.noiseinstitute.ld22.Main;
    import net.noiseinstitute.ld22.Range;
    import net.noiseinstitute.ld22.Static;
    import net.noiseinstitute.ld22.VectorMath;

    public class DistanceCounter extends Entity
    {
        [Embed(source="Arrow.png")]
        private static const ARROW_IMAGE:Class;

        private static const ARROW_ALPHA:Number = 0.5;

        private static const FADE_START_DISTANCE:Number = Main.HEIGHT * 0.5;
        private static const FADE_END_DISTANCE:Number = Main.HEIGHT * 0.25;

        private static const ARROW_DISTANCE_FROM_PLAYER:Number = 128;
        private static const TEXT_DISTANCE_FROM_ARROW:Number = 80;

        private var arrow:Image;
        private var text:Text;

        private var player:Player;
        private var deltaStation:DeltaStation;

        public function DistanceCounter(player:Player, deltaStation:DeltaStation)
        {
            this.player = player;
            this.deltaStation = deltaStation;

            x = player.x;
            y = player.y;

            arrow = new Image(ARROW_IMAGE);
            arrow.centerOrigin();
            arrow.smooth = true;
            arrow.alpha = ARROW_ALPHA;

            text = new Text("");
            text.align = TextAlign.CENTER;

            graphic = new Graphiclist(arrow, text);
        }

        public override function update():void {
            Static.point.x = deltaStation.x - player.x;
            Static.point.y = deltaStation.y - player.y;

            arrow.angle = VectorMath.angle(Static.point);

            var distance:Number = VectorMath.magnitude(Static.point);
            text.text = "Delta Station\n" + distance.toFixed(2) + " Space Leagues";
            text.centerOrigin();

            var alpha:Number = (distance - FADE_END_DISTANCE)
                    / (FADE_START_DISTANCE - FADE_END_DISTANCE);
            alpha = Range.clip(alpha, 0, 1);

            arrow.alpha = ARROW_ALPHA * alpha;
            text.alpha = alpha;

            if (distance == 0) {
                return;
            }

            VectorMath.copyTo(Static.point2, Static.point);
            VectorMath.scaleInPlace(Static.point2, TEXT_DISTANCE_FROM_ARROW/distance);
            text.x = Static.point2.x;
            text.y = Static.point2.y;

            VectorMath.scaleInPlace(Static.point, ARROW_DISTANCE_FROM_PLAYER/distance);

            x = player.x + Static.point.x;
            y = player.y + Static.point.y;
        }
    }
}