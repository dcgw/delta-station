package net.noiseinstitute.game
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Text;
	
	public class TeaCounter extends Entity
	{
		private var counterText:Text;
		public var kelvin:Number = 373.15;
		
		public function TeaCounter(x:Number, y:Number)
		{
			this.x = x;
			this.y = y;
			
			counterText = new Text("Temperature of Tea: 373.15 Space kelvin");
			counterText.scrollX = 0;
			counterText.scrollY = 0;
			graphic = counterText;
		}
		
		public override function update():void {
			var text:String = "Temperature of Tea: " + kelvin.toFixed(2) + " Space kelvin";
			if (kelvin < 273.15) {
				text = text + " (frozen!)";
			}
			counterText.text = text;
			
			if (kelvin < 0.0) {
				kelvin = 0.0;
			}
		}
	}
}