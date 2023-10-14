import ui.* 
import _utils.* 
import main.*
import enemies.index.waveManager

class Enemy {
    const property image
    var property position = utils.getRandomPosOutOfScreenRight()
    var health = 100
    const damage


    method init() {
        console.println("obj")
        game.addVisual(self)
        game.addVisual(new HealthBar(parent = self, upFromPos =  20))
        gameManager.addRunFn({self.move()})
    }

    method move()

    method attack()

    method getDamaged(value) {
        health -= value
        if(health <= 0) {
            self.die()
        }
    }

    method die() {
        waveManager.destroyEnemy(self)
    }  
}