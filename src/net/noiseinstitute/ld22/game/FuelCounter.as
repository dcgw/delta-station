package net.noiseinstitute.ld22.game
{
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Text;

    public class FuelCounter extends Entity
    {
        private var counterText:Text;
        public var fuel:Number = 0.0;

        public function FuelCounter(x:Number, y:Number, fuel:Number)
        {
            this.x = x;
            this.y = y;
            this.fuel = fuel;

            counterText = new Text("Remaining Fuel: 0 Galactic Gallons");
            counterText.scrollX = 0;
            counterText.scrollY = 0;
            graphic = counterText;
        }

        public override function update():void {
            counterText.text = "Remaining Fuel: " + fuel.toFixed(2) + " Galactic Gallons";
        }

        public function isDepleted():Boolean {
            return fuel <= 0;
        }
    }
}