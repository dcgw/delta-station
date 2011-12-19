package net.noiseinstitute.ld22.game
{
    import net.flashpunk.Entity;
    import net.flashpunk.graphics.Graphiclist;
    import net.flashpunk.graphics.Text;

    public class GameOver extends Entity
    {
        public function GameOver(x:Number, y:Number)
        {
            this.x = x;
            this.y = y;

            var gameOverText1:Text = new Text("You failed to reach Delta Station");
            gameOverText1.font = "Electrolize";
            gameOverText1.size = 32;
            gameOverText1.originX = gameOverText1.textWidth * 0.5;
            gameOverText1.originY = gameOverText1.textHeight;

            var gameOverText2:Text = new Text("The President is most disappointed");
            gameOverText2.font = "Electrolize";
            gameOverText2.size = 32;
            gameOverText2.originX = gameOverText2.textWidth * 0.5;
            gameOverText2.originY = 0;

            graphic = new Graphiclist(gameOverText1, gameOverText2);
            graphic.scrollX = 0;
            graphic.scrollY = 0;

            visible = false;
        }
    }
}