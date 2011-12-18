package net.noiseinstitute.game {
    import flash.geom.Point;

    import flash.media.SoundTransform;

    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Image;
    import net.flashpunk.utils.Input;
    import flash.media.Sound;
    import flash.media.SoundChannel;

    public class Player extends Entity {
        [Embed(source="Player.png")]
        private static var PlayerImage:Class;
		
		[Embed(source="asplosion2.png")]
		private static var AsplosionImage:Class;
		
		[Embed(source="thrust.mp3")]
		private static const THRUST_SOUND:Class;

		[Embed(source="Asplode.mp3")]
		private static const ASPLODE_SOUND:Class;
		
		private var thrustSound:Sound = Sound(new THRUST_SOUND());
		private var thrustSoundChannel:SoundChannel;
        private var thrustSoundTransform:SoundTransform = new SoundTransform(0.6);

		private var asplodeSound:Sound = Sound(new ASPLODE_SOUND());
		private var asplodeSoundChannel:SoundChannel;

        private static const ANGULAR_THRUST:Number = 1/Main.LOGIC_FPS;
        private static const THRUST:Number = 1/Main.LOGIC_FPS;

        private var angle:Number = 0;
        private var angularVelocity:Number = 0;

        private var velocity:Point = new Point;

        private var playerImage:Image;
		private var asplosionImage:Image;
		
		private var _asploded:Boolean = false;
		private var asploding:Boolean = false;
		
        public function Player (x:Number, y:Number) {
            this.x = x;
            this.y = y;

            angularVelocity = Math.random() - 0.5;

            VectorMath.becomePolar(velocity, Math.random() * 360, Math.random());

            angle = Math.random() * 360;

            playerImage = new Image(PlayerImage);
            playerImage.smooth = true;
			playerImage.centerOrigin();
			asplosionImage = new Image(AsplosionImage);
			asplosionImage.smooth = true;
			asplosionImage.centerOrigin();
			
            graphic = playerImage;
			
			setHitbox(playerImage.width, playerImage.height, playerImage.originX, playerImage.originY);
        }

        public override function update():void {
			
			if (_asploded) {
				// Zed's dead baby, Zed's dead
				return;
				
			} else if (asploding) {
				// asplosion animation - gradually grow asplosion and fade it out
				asplosionImage.scale += 0.05;
				asplosionImage.alpha -= 0.01;
				if (asplosionImage.alpha <= 0.0) {
					_asploded = true;
				}
				
			} else {
	            if (Input.check(Main.KEY_LEFT)) {
	                angularVelocity += ANGULAR_THRUST;
					FuelCounter.fuel -= 0.3;
	            }
	            if (Input.check(Main.KEY_RIGHT)) {
	                angularVelocity -= ANGULAR_THRUST;
					FuelCounter.fuel -= 0.3;
	            }
	            if (Input.check(Main.KEY_THRUST)) {
	                VectorMath.becomePolar(Static.point, angle, THRUST);
	                VectorMath.addTo(velocity, Static.point);
					FuelCounter.fuel -= 0.5;
					if (thrustSoundChannel == null) {
						thrustSoundChannel = thrustSound.play(0, int.MAX_VALUE, thrustSoundTransform);
					}
	            } else if (thrustSoundChannel != null) {
					thrustSoundChannel.stop();
					thrustSoundChannel = null;
				}
	
	            angle += angularVelocity;
	            x += velocity.x;
	            y += velocity.y;
	
	            playerImage.angle = angle;
			}
        }
		
		public function asplode():void {
			if (thrustSoundChannel != null) {
				thrustSoundChannel.stop();
				thrustSoundChannel = null;
			}
			
			if (!asploding) {
				// start small, do animation in update function
				asplosionImage.scale = 0.05;
				asploding = true;
				graphic = asplosionImage;
				asplodeSoundChannel = asplodeSound.play();
			}
		}
		
		public function get asploded():Boolean {
			return _asploded;
		}
    }
}
