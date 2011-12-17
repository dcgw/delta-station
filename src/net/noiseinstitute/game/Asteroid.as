package net.noiseinstitute.game
{
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Asteroid extends Entity {
		
		[Embed(source="Asteroid.png")]
		private static var AsteroidImage:Class;
		
		public function Asteroid(x:Number, y:Number) {
			graphic = new Image(AsteroidImage);
			this.x = x;
			this.y = y;
		}
	}
}