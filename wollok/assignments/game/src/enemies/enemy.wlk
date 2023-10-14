import ui.* 
import _utils.* 
import gameLoop.*
import enemies.index.waveManager

class Enemy {
    const property image
    var property position = utils.getRandomPosOutOfScreenRight()
    var health = 100
    const id
    const damage


    method init() {
        game.addVisual(self)
        // game.addVisual(new HealthBar(parent = self, upFromPos =  20))
        gameLoop.add("enemy_move" + id, {self.move()})
    }

    method stopMoving() {
        gameLoop.remove("enemy_move" + id)
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
        gameLoop.remove("enemy_move" + id)
    }  
}

class EnemyBullet {
    var property position
    const id
    const speed
    const damage
    const property image

    method init() {
        game.addVisual(self)
        gameLoop.add("enemy_bullet" + id, {self.move()})
    }   
    
    method move() 

    method collision() {
        game.whenCollideDo(self, {visual => {
            visual.getDamaged(damage)
        }})
    }
}

