package net.noiseinstitute.ld22.game {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.BlendMode;
    import flash.geom.ColorTransform;
    import flash.geom.Point;

    import net.flashpunk.FP;
    import net.flashpunk.Graphic;
    import net.noiseinstitute.ld22.Main;
    import net.noiseinstitute.ld22.Static;
    import net.noiseinstitute.ld22.VectorMath;

    public class PlayerFlameParticles extends Graphic {
        [Embed(source="FlameParticle.png")]
        private static const SPRITE_SHEET:Class;

        private static const NUM_PARTICLES:int = 100;

        private static const THRUST_PARTICLE_LIFETIME:int = 0.2 * Main.LOGIC_FPS;

        private static const THRUST_PARTICLE_SPEED:Number = 100/Main.LOGIC_FPS;

        private static const PARTICLE_WIDTH:Number = 24;
        private static const PARTICLE_HEIGHT:Number = 24;

        private static const HALF_PARTICLE_WIDTH:Number = PARTICLE_WIDTH*0.5;
        private static const HALF_PARTICLE_HEIGHT:Number = PARTICLE_HEIGHT*0.5;

        private static const NUM_PARTICLE_SPRITES:int = 4;

        private static const THRUST_PARTICLE_MIN_SCALE:Number = 0.5;
        private static const THRUST_PARTICLE_MAX_SCALE:Number = 1.5;

        private static const LEFT_EMISSION_POINT:Point = new Point(-8, 19);
        private static const RIGHT_EMISSION_POINT:Point = new Point(8, 19);

        private static const THRUST_ANGLE_OFFSET:Number = 5;

        private static var colourTransform:ColorTransform = new ColorTransform();

        public var player:Player;

        private var bitmap:Bitmap;

        private var timer:int = 0;

        private var particleStartPositions:Vector.<Point>;
        private var particleVelocities:Vector.<Point>;
        private var particleCreationTimes:Vector.<int>;
        private var particleLifetimes:Array; // Should be Vector.<Number> but that thrashes the heap
        private var particleMinScale:Array; // Should be Vector.<Number> but that thrashes the heap
        private var particleMaxScale:Array; // Should be Vector.<Number> but that thrashes the heap
        private var particleEnabled:Vector.<Boolean>;

        private var i:int=0;

        public function PlayerFlameParticles() {
            bitmap = new Bitmap(FP.getBitmap(SPRITE_SHEET));

            particleStartPositions = new Vector.<Point>();
            particleVelocities = new Vector.<Point>();
            particleCreationTimes = new Vector.<int>();
            particleLifetimes = [];
            particleMinScale = [];
            particleMaxScale = [];
            particleEnabled = new Vector.<Boolean>();

            for (var i:int=0; i<NUM_PARTICLES; ++i) {
                particleStartPositions[i] = new Point();
                particleVelocities[i] = new Point();
                particleLifetimes[i] = 0;
                particleMinScale[i] = 0;
                particleMaxScale[i] = 0;
                particleEnabled[i] = false;
            }

            active = true;
        }

        override public function update():void {
            timer++;
        }

        public function emitThrust():void {
            emitLeft();
            emitRight();
        }

        public function emitRight ():void {
            VectorMath.copyTo(particleStartPositions[i], RIGHT_EMISSION_POINT);
            VectorMath.rotateInPlace(particleStartPositions[i], player.angle);
            particleStartPositions[i].x += player.x;
            particleStartPositions[i].y += player.y;

            VectorMath.becomePolar(particleVelocities[i],
                    player.angle + 180 + THRUST_ANGLE_OFFSET,
                    THRUST_PARTICLE_SPEED);
            VectorMath.addTo(particleVelocities[i], player.velocity);

            particleCreationTimes[i] = timer;

            particleLifetimes[i] = THRUST_PARTICLE_LIFETIME;

            particleMinScale[i] = THRUST_PARTICLE_MIN_SCALE;
            particleMaxScale[i] = THRUST_PARTICLE_MAX_SCALE;

            particleEnabled[i] = true;

            i = (i + 1) % NUM_PARTICLES;
        }

        public function emitLeft ():void {
            VectorMath.copyTo(particleStartPositions[i], LEFT_EMISSION_POINT);
            VectorMath.rotateInPlace(particleStartPositions[i], player.angle);
            particleStartPositions[i].x += player.x;
            particleStartPositions[i].y += player.y;

            VectorMath.becomePolar(particleVelocities[i],
                    player.angle + 180 - THRUST_ANGLE_OFFSET,
                    THRUST_PARTICLE_SPEED);
            VectorMath.addTo(particleVelocities[i], player.velocity);

            particleCreationTimes[i] = timer;

            particleLifetimes[i] = THRUST_PARTICLE_LIFETIME;

            particleMinScale[i] = THRUST_PARTICLE_MIN_SCALE;
            particleMaxScale[i] = THRUST_PARTICLE_MAX_SCALE;

            particleEnabled[i] = true;

            i = (i + 1) % NUM_PARTICLES;
        }

        override public function render(target:BitmapData, point:Point, camera:Point):void {
            target.lock();
            for (var i:int=0; i<NUM_PARTICLES; ++i) {
                if (!particleEnabled[i]) {
                    continue;
                }

                var lifetime:Number = particleLifetimes[i];

                var age:int = timer - particleCreationTimes[i];
                if (age > lifetime) {
                    particleEnabled[i] = false;
                    continue;
                }

                var startPosition:Point = particleStartPositions[i];
                var velocity:Point = particleVelocities[i];

                VectorMath.copyTo(Static.point, startPosition);
                VectorMath.copyTo(Static.point2, velocity);
                VectorMath.scaleInPlace(Static.point2, age);
                VectorMath.addTo(Static.point, Static.point2);
                VectorMath.subtractFrom(Static.point, camera);

                var frame:int = i%NUM_PARTICLE_SPRITES;
                var minScale:Number = particleMinScale[i];
                var maxScale:Number = particleMaxScale[i];
                var scale:Number = minScale + age * (maxScale-minScale) / lifetime;

                FP.matrix.a = FP.matrix.d = 1;
                FP.matrix.b = FP.matrix.c = 0;
                FP.matrix.tx = -frame * PARTICLE_WIDTH - HALF_PARTICLE_WIDTH;
                FP.matrix.ty = -HALF_PARTICLE_HEIGHT;

                FP.matrix.scale(scale, scale);
                FP.matrix.translate(Static.point.x, Static.point.y);

                FP.rect.x = Static.point.x - HALF_PARTICLE_WIDTH*scale;
                FP.rect.y = Static.point.y - HALF_PARTICLE_HEIGHT*scale;
                FP.rect.width = PARTICLE_WIDTH*scale;
                FP.rect.height = PARTICLE_HEIGHT*scale;

                colourTransform.alphaMultiplier = 1 - age/lifetime;

                target.draw(bitmap, FP.matrix, colourTransform, BlendMode.ADD, FP.rect, true);
            }
            target.unlock();
        }
    }
}
