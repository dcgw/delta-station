package net.noiseinstitute.game
{
	import flash.geom.Point;
	
	import net.flashpunk.Entity;
	import net.flashpunk.Graphic;
	import net.flashpunk.Mask;
	import net.flashpunk.graphics.Image;
	
	public class Kitten extends Entity {
		
		[Embed(source="Kitten.png")]
		private static var KittenImage:Class;
		
		private static const MAX_ANGLE:Number = 360;
		private static const MAX_SPEED:Number = 1;
		private static const MAX_SPIN_SPEED:Number = 5;
		
		private var image:Image = new Image(KittenImage);
		private var positionDelta:Point = new Point();
		private var spinSpeed:Number = 0;
		
		/**
		 * x and y values are the initial position
		 * 
		 * The speed and direction are determined at random.
		 */
		public function Kitten(x:Number, y:Number) {
			this.x = x;
			this.y = y;
			
			// The direction the kitten moves
			var direction:Number = Math.random() * MAX_ANGLE;
			
			// The speed at which the kitten moves
			var speed:Number = MAX_SPEED * Math.random();
			
			// The amount that the kitten's current position should change by when it is updated.
			VectorMath.becomePolar(positionDelta, direction, speed);
			
			// The speed at which the kitten spins around
			spinSpeed = MAX_SPIN_SPEED * Math.random();
			
			image.centerOrigin();
			type = "Kitten";
			
			graphic = image;
			
			setHitbox(image.width, image.height, image.originX, image.originY);
		}
		
		public override function update():void {
			x += positionDelta.x;
			y += positionDelta.y;
			
			image.angle += spinSpeed;
		}
	}
}