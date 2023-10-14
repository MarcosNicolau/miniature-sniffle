import player.*
import gameLoop.*
import enemies.index.waveManager

object gameManager {
  

    method start() {
        game.width(600)
        game.height(800)
        game.cellSize(1)
        game.boardGround("background.png")
        game.start()
        player.init()
        gameLoop.start()
        waveManager.init()
    }
}