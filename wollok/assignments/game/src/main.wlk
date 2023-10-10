import player.*
import enemy.*
object gameManager {
    const runner = []


    method start() {
        game.width(600)
        game.height(800)
        game.cellSize(1)
        game.boardGround("background.png")
        game.addVisual(player)
        game.start()
        player.init()
        game.addVisual(playerBulletsUI)
        game.onTick(60, "runner", {runner.forEach({fn => fn.apply()})})
        enemyManager.init()
    }


    method addRunFn(fn) {
        runner.add(fn)
    }
}