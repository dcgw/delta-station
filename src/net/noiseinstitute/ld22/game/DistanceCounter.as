package net.noiseinstitute.ld22.game
{
    import flash.filters.GlowFilter;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.graphics.Text;
    import net.noiseinstitute.ld22.Main;
    import net.noiseinstitute.ld22.Range;
    import net.noiseinstitute.ld22.Static;
    import net.noiseinstitute.ld22.Trig;
    import net.noiseinstitute.ld22.VectorMath;

    public class DistanceCounter extends Entity
    {
        [Embed(source="Arrow.png")]
        private static const ARROW_IMAGE:Class;

        private static const ARROW_ALPHA:Number = 0.75;

        private static const FADE_START_DISTANCE:Number = Main.HEIGHT * 0.5;
        private static const FADE_END_DISTANCE:Number = Main.HEIGHT * 0.25;

        private static const ARROW_DISTANCE_FROM_PLAYER:Number = 128;
        private static const TEXT_DISTANCE_FROM_ARROW:Number = 80;

        private var arrow:Image;
        private var deltaStationText:Text;
        private var counterText:Text;
        private var spaceLeaguesText:Text;

        private var player:Player;
        private var deltaStation:DeltaStation;

        private var frame:int = 0;

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

            deltaStationText = new Text("");
            counterText = new Text("");
            spaceLeaguesText = new Text ("");

            deltaStationText.font = Main.FONT;
            counterText.font = Main.FONT;
            spaceLeaguesText.font = Main.FONT;

            deltaStationText.size = 26;
            counterText.size = 16;
            spaceLeaguesText.size = 14;

            deltaStationText.smooth = true;
            counterText.smooth = true;
            spaceLeaguesText.smooth = true;

            deltaStationText.field.filters = [new GlowFilter(0xff0000, 1, 6, 6, 1)];
            counterText.field.filters = [new GlowFilter(0x00ff00, 1, 6, 6, 1)];
            spaceLeaguesText.field.filters = [new GlowFilter(0x00ff00, 1, 6, 6, 1)];

            // For some reason we have to set text after filters or the filters don't take effect.
            deltaStationText.text = "Delta Station";
            counterText.text = "10000";
            spaceLeaguesText.text = "Space Leagues";

            deltaStationText.centerOrigin();
            counterText.originX = deltaStationText.originX;
            counterText.originY = counterText.textHeight * 0.5;
            spaceLeaguesText.originX = spaceLeaguesText.textWidth - deltaStationText.originX;
            spaceLeaguesText.originY = spaceLeaguesText.textHeight * 0.5;

            graphic = new Graphiclist(arrow, deltaStationText, counterText, spaceLeaguesText);
        }

        public override function update():void {
            Static.point.x = deltaStation.x - player.x;
            Static.point.y = deltaStation.y - player.y;

            arrow.angle = VectorMath.angle(Static.point);

            var distance:Number = VectorMath.magnitude(Static.point);
            counterText.text = distance.toFixed(0);
            counterText.width = counterText.textWidth;

            var alpha:Number = (distance - FADE_END_DISTANCE)
                    / (FADE_START_DISTANCE - FADE_END_DISTANCE);
            alpha = Range.clip(alpha, 0, 1);

            arrow.alpha = ARROW_ALPHA * alpha;
            deltaStationText.alpha = alpha;
            counterText.alpha = alpha;
            spaceLeaguesText.alpha = alpha;

            var arrowSin:Number = Trig.sin(frame*2);
            var deltaStationTextSin:Number = Trig.sin(frame*2.1 + 15);
            var counterTextSin:Number = Trig.sin(frame*1.87 + 170);

            arrow.scale = 1 + arrowSin * 0.1;
            deltaStationText.scale = 1 + deltaStationTextSin * 0.05;
            counterText.scale = 1 + counterTextSin * 0.05;
            spaceLeaguesText.scale = 1 + counterTextSin * 0.05;

            if (distance == 0) {
                return;
            }

            VectorMath.copyTo(Static.point2, Static.point);
            VectorMath.scaleInPlace(Static.point2, TEXT_DISTANCE_FROM_ARROW/distance);

            deltaStationText.x = Static.point2.x;
            deltaStationText.y = Static.point2.y - (deltaStationText.textHeight*0.5) + 2;

            counterText.x = deltaStationText.x;
            counterText.y = Static.point2.y + (counterText.textHeight*0.5) - 2;

            spaceLeaguesText.x = deltaStationText.x;
            spaceLeaguesText.y = counterText.y;

            VectorMath.scaleInPlace(Static.point, ARROW_DISTANCE_FROM_PLAYER/distance);

            x = player.x + Static.point.x;
            y = player.y + Static.point.y;

            ++frame;
        }
    }
}