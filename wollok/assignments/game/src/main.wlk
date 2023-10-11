import player.*
import enemies.index.enemyManager

object gameManager {
    const runner = []

    method start() {
        game.width(600)
        game.height(800)
        game.cellSize(1)
        game.boardGround("background.png")
        game.start()
        player.init()
        enemyManager.init()
        game.onTick(60, "runner", {runner.forEach({fn => fn.apply()})})
    }


    method addRunFn(fn) {
        runner.add(fn)
    }

    method removeRunFn(fn) {
        runner.remove(fn)
    }
}