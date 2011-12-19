package net.noiseinstitute.ld22.game {
    import net.flashpunk.FP;

    public class Trig {
        public static function sin(angle:Number):Number {
            return Math.sin(angle*FP.RAD);
        }

        public static function cos(angle:Number):Number {
            return Math.cos(angle*FP.RAD);
        }
    }
}
