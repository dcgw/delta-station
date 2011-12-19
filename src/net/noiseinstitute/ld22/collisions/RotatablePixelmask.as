package net.noiseinstitute.ld22.collisions {
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.Graphics;

    import net.flashpunk.FP;
    import net.flashpunk.Mask;
    import net.flashpunk.masks.Hitbox;
    import net.flashpunk.masks.Pixelmask;
    import net.noiseinstitute.ld22.Static;
    import net.noiseinstitute.ld22.VectorMath;

    public class RotatablePixelmask extends Mask {
        public var x:Number = 0;
        public var y:Number = 0;

        public function get width():Number {
            return _buffer.width;
        }

        public function get height():Number {
            return _buffer.height;
        }

        public function get originX():Number {
            return _originX;
        }

        public function set originX(value:Number):void {
            bufferRequiresUpdate = true;
            _originX = value;
        }

        public function get originY():Number {
            return _originY;
        }

        public function set originY(value:Number):void {
            if (value != _originY) {
                bufferRequiresUpdate = true;
                _originY = value;
            }
        }

        public function get angle():Number {
            return _angle;
        }

        public function set angle(value:Number):void {
            if (value != _angle) {
                bufferRequiresUpdate = true;
                _angle = value;
            }
        }

        public function get bufferOffsetX():Number {
            return -bufferCentre;
        }

        public function get bufferOffsetY():Number {
            return -bufferCentre;
        }

        public function get buffer():Bitmap {
            updateBuffer();
            return _buffer;
        }

        public var threshold:uint = 1;

        public function RotatablePixelmask(source:*) {
            if (source is BitmapData) {
                bitmap.bitmapData = source;
            } else if (source is Class) {
                bitmap.bitmapData = FP.getBitmap(source);
            } else {
                throw new Error("Invalid RotatablePixelmask source image");
            }

            Static.point.x = bitmap.bitmapData.width;
            Static.point.y = bitmap.bitmapData.height;

            bufferCentre = Math.ceil(VectorMath.magnitude(Static.point));
            var size:int = bufferCentre * 2;

            _buffer = new Bitmap(new BitmapData(size, size, true, 0x0));

            _check[Mask] = collideMask;
            _check[Hitbox] = collideHitbox;
            _check[Pixelmask] = collidePixelmask;
            _check[RotatablePixelmask] = collideRotatablePixelmask;
        }

        public function updateBuffer():void {
            if (bufferRequiresUpdate) {
                var bitmapData:BitmapData = _buffer.bitmapData;

                bitmapData.lock();
                bitmapData.fillRect(bitmapData.rect, 0);

                if (_angle == 0) {
                    Static.point.x = bufferCentre - originX;
                    Static.point.y = bufferCentre - originY;
                    bitmapData.copyPixels(bitmap.bitmapData, bitmap.bitmapData.rect, Static.point, null, null, true);
                } else {
                    FP.matrix.identity();
                    FP.matrix.translate(-originX, -originY);
                    FP.matrix.rotate(_angle * FP.RAD);
                    FP.matrix.translate(bufferCentre, bufferCentre);

                    bitmapData.draw(bitmap, FP.matrix);
                }

                bitmapData.unlock();

                bufferRequiresUpdate = false;
            }
        }

        private function collideMask(other:Mask):Boolean {
            updateBuffer();

            Static.point.x = x - bufferCentre + parent.x;
            Static.point.y = y - bufferCentre + parent.y;

            FP.rect.x = other.parent.x + other.parent.originX;
            FP.rect.y = other.parent.y - other.parent.originY;
            FP.rect.width = other.parent.width;
            FP.rect.height = other.parent.height;

            return _buffer.bitmapData.hitTest(Static.point, threshold, FP.rect);
        }

        private function collideHitbox(other:Hitbox):Boolean {
            updateBuffer();

            Static.point.x = x - bufferCentre + parent.x;
            Static.point.y = y - bufferCentre + parent.y;

            FP.rect.x = other.parent.x + other.x;
            FP.rect.y = other.parent.y + other.y;
            FP.rect.width = other.width;
            FP.rect.height = other.height;

            return _buffer.bitmapData.hitTest(Static.point, threshold, FP.rect);
        }

        private function collidePixelmask(other:Pixelmask):Boolean {
            updateBuffer();

            Static.point.x = x - bufferCentre + parent.x;
            Static.point.y = y - bufferCentre + parent.y;

            Static.point2.x = other.parent.x + other.x;
            Static.point2.y = other.parent.y + other.y;

            return _buffer.bitmapData.hitTest(Static.point, threshold, other.data, Static.point2, other.threshold);
        }

        private function collideRotatablePixelmask(other:RotatablePixelmask):Boolean {
            updateBuffer();
            other.updateBuffer();

            Static.point.x = x - bufferCentre + parent.x;
            Static.point.y = y - bufferCentre + parent.y;

            Static.point2.x = other.x - other.bufferCentre + other.parent.x;
            Static.point2.y = other.y - other.bufferCentre + other.parent.y;

            return _buffer.bitmapData.hitTest(Static.point, threshold, other.buffer, Static.point2, other.threshold);
        }

        public function centerOrigin():void {
            originX = bitmap.bitmapData.width * 0.5;
            originY = bitmap.bitmapData.height * 0.5;
        }

        override public function renderDebug(g:Graphics):void {
            updateBuffer();

            if (debugBuffer == null) {
                debugBuffer = new BitmapData(_buffer.bitmapData.width, _buffer.bitmapData.height, true, 0x0);
            }

            debugBuffer.fillRect(debugBuffer.rect, 0x0);
            debugBuffer.threshold(_buffer.bitmapData, debugBuffer.rect, FP.zero, ">=", threshold<<24, 0x40FFFFFF, 0xFF000000);

            var sx:Number = FP.screen.scaleX * FP.screen.scale;
            var sy:Number = FP.screen.scaleY * FP.screen.scale;

            FP.matrix.identity();
            FP.matrix.translate(x - bufferCentre + parent.x - FP.camera.x,
                    y - bufferCentre + parent.y - FP.camera.y);
            FP.matrix.scale(sx, sy);

            g.lineStyle();
            g.beginBitmapFill(debugBuffer, FP.matrix);
            g.drawRect(FP.matrix.tx, FP.matrix.ty, debugBuffer.width*sx, debugBuffer.height*sy);
            g.endFill();
        }

        private var _originX:Number = 0;
        private var _originY:Number = 0;
        private var _angle:Number = 0;
        private var bitmap:Bitmap = new Bitmap();
        private var bufferCentre:int;
        private var _buffer:Bitmap;
        private var bufferRequiresUpdate:Boolean = false;
        private var debugBuffer:BitmapData;
    }
}