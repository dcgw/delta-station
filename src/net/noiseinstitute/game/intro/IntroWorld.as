package net.noiseinstitute.game.intro {
    import flash.media.Sound;
    import flash.media.SoundChannel;

    import net.flashpunk.World;

    public class IntroWorld extends World {
        [Embed(source="IntroMusic.mp3")]
        private static const MUSIC:Class;

        private var music:Sound = Sound(new MUSIC());
        private var musicChannel:SoundChannel;

        private var presidentOfSpace:PresidentOfSpace = new PresidentOfSpace();

        public function IntroWorld () {
            add(presidentOfSpace);
            presidentOfSpace.speaking = true;
        }

        override public function begin():void {
            end();

            musicChannel = music.play(0, int.MAX_VALUE);
        }

        override public function end():void {
            if (musicChannel != null) {
                musicChannel.stop();
                musicChannel = null;
            }
        }
    }
}
