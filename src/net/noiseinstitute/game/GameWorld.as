package net.noiseinstitute.game {
    import net.flashpunk.World;

    public class GameWorld extends World {
        public function GameWorld() {
            var player:Player = new Player();
            add(player);
        }
    }
}
