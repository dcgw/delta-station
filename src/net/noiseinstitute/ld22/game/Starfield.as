package net.noiseinstitute.ld22.game {
    import net.noiseinstitute.ld22.*;
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.geom.ColorTransform;
    import flash.geom.Point;

    import net.flashpunk.FP;
    import net.flashpunk.Graphic;

    public class Starfield extends Graphic {
        [Embed(source="Stars.png")]
        private static const STARS_SPRITEMAP:Class;

        private static const STAR_WIDTH:int = 11;
        private static const STAR_HEIGHT:int = 11;

        private static const ANIMATION:Vector.<int> = Vector.<int>([0, 1, 2, 3, 2, 1]);
        private static const MIN_ANIMATION_RATE:Number = 3 / Main.LOGIC_FPS;
        private static const MAX_ANIMATION_RATE:Number = 15 / Main.LOGIC_FPS;

        private static const NUM_STARS:int = 64;

        private static const PARALLAX_FACTOR:Number = 1;

        private static const RANDOMNESS_SCALE:int = 0xffffff;

        private static const X_RANDOM_INDEX:int = 0;
        private static const Y_RANDOM_INDEX:int = 1;
        private static const DISTANCE_RANDOM_INDEX:int = 2;
        private static const ANIMATION_OFFSET_RANDOM_INDEX:int = 3;
        private static const ANIMATION_RATE_RANDOM_INDEX:int = 4;
        private static const COLOUR_RANDOM_INDEX:int = 5;
        private static const RANDOM_NUMBERS_PER_STAR:int = 6;

        private static const RANDOM_COLOUR_ZERO_MASK:uint = 0x1f1f1f;
        private static const RANDOM_COLOUR_ONE_MASK:uint = 0xe0e0e0;

        private static var colorTransform:ColorTransform = new ColorTransform();

        private var bitmap:Bitmap;

        private var timer:int = 0;

        // It would be better if this were Vector.<Number>, except that
        // retrieving Numbers from a Vector thrashes the heap.
        private var _randomness:Vector.<int> = new Vector.<int>();

        public function Starfield() {
            for (var i:int=0; i<NUM_STARS*RANDOM_NUMBERS_PER_STAR; ++i) {
                _randomness[i] = Math.random() * RANDOMNESS_SCALE;
            }

            bitmap = new Bitmap(FP.getBitmap(STARS_SPRITEMAP));

            active = true;
        }

        override public function update():void {
            timer++;
        }

        override public function render(target:BitmapData, point:Point, camera:Point):void {
            target.lock();
            target.fillRect(target.rect, 0x000000);
            for (var i:int=0; i<NUM_STARS; ++i) {
                var randomIndexBase:int = i*RANDOM_NUMBERS_PER_STAR;

                var distance:Number = _randomness[randomIndexBase + DISTANCE_RANDOM_INDEX] / RANDOMNESS_SCALE;

                var x:int = (1-distance)*PARALLAX_FACTOR*(point.x-camera.x);
                x += _randomness[randomIndexBase + X_RANDOM_INDEX] * Main.WIDTH / RANDOMNESS_SCALE;
                x = Range.wrap(x, 0, Main.WIDTH);

                var y:int = (1-distance)*PARALLAX_FACTOR*(point.y-camera.y);
                y += _randomness[randomIndexBase + Y_RANDOM_INDEX] * Main.HEIGHT / RANDOMNESS_SCALE;
                y = Range.wrap(y, 0, Main.HEIGHT);

                var animationRate:Number = MIN_ANIMATION_RATE
                        + (_randomness[randomIndexBase + ANIMATION_RATE_RANDOM_INDEX]
                                * (MAX_ANIMATION_RATE - MIN_ANIMATION_RATE)
                                / RANDOMNESS_SCALE);

                var animationOffset:Number = _randomness[randomIndexBase + ANIMATION_OFFSET_RANDOM_INDEX]
                        * ANIMATION.length / RANDOMNESS_SCALE;

                var frame:int = ANIMATION[
                        Math.floor(animationOffset + timer * animationRate)
                        % ANIMATION.length];

                colorTransform.color = _randomness[randomIndexBase + COLOUR_RANDOM_INDEX]
                        & RANDOM_COLOUR_ZERO_MASK | RANDOM_COLOUR_ONE_MASK;
                colorTransform.alphaMultiplier = 1-distance;

                FP.matrix.a = FP.matrix.d = 1;
                FP.matrix.b = FP.matrix.c = 0;
                FP.matrix.tx = x - frame * STAR_WIDTH;
                FP.matrix.ty = y;

                FP.rect.x = x;
                FP.rect.y = y;
                FP.rect.width = STAR_WIDTH;
                FP.rect.height = STAR_HEIGHT;

                target.draw(bitmap, FP.matrix, colorTransform, null, FP.rect);

                if (x+STAR_WIDTH > Main.WIDTH) {
                    FP.matrix.tx -= Main.WIDTH;
                    FP.rect.x -= Main.WIDTH;
                    target.draw(bitmap, FP.matrix, colorTransform, null, FP.rect);

                    FP.matrix.tx += Main.WIDTH;
                    FP.rect.x += Main.WIDTH;
                }

                if (y+STAR_HEIGHT > Main.HEIGHT) {
                    FP.matrix.ty -= Main.HEIGHT;
                    FP.rect.y -= Main.HEIGHT;
                    target.draw(bitmap, FP.matrix, colorTransform, null, FP.rect);

                    if (x+STAR_WIDTH > Main.WIDTH) {
                        FP.matrix.tx -= Main.WIDTH;
                        FP.rect.x -= Main.WIDTH;
                        target.draw(bitmap, FP.matrix, colorTransform, null, FP.rect);
                    }
                }
            }
            target.unlock();
        }
    }
}
