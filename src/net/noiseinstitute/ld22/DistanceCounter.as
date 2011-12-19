package net.noiseinstitute.ld22
{
    import net.flashpunk.Entity;
    import net.flashpunk.Graphic;
    import net.flashpunk.Mask;
    import net.flashpunk.graphics.Text;

    public class DistanceCounter extends Entity
    {
        private var counterText:Text;
        public var distance:int = 0;

        public function DistanceCounter(x:Number, y:Number)
        {
            this.x = x;
            this.y = y;

            counterText = new Text("Distance from Delta Station: 0 Space Leagues");
            counterText.scrollX = 0;
            counterText.scrollY = 0;
            graphic = counterText;
        }

        public override function update():void {
            counterText.text = "Distance from Delta Station: " + distance + " Space Leagues";
        }
    }
}