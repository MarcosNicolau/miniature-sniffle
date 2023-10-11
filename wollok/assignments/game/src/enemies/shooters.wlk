import enemies.enemy.*
import main.gameManager

class Bullet {
    var property position
    const speed
    const damage
    const property image

    method init() {
        game.addVisual(self)
        gameManager.addRunFn({self.move()})
    }   
    
    method move() {
        if(position.y() <= game.width() + 50) {
            game.removeVisual(self)
        }
        position = position.left(speed)
    }

    method collision() {
        game.onCollideDo(self, {visual => {
            visual.getDamaged(damage)
        }})
    }
}

class Shooter inherits Enemy {
    const speed
    const bulletSpeed
    const bulletImage
    const moveUntil

    override method attack() {
        new Bullet(position = position.x(player.x()), damage = damage, speed = bulletSpeed, image = bulletImage).init()
        game.schedule(6000, {self.attack()})
    }
    
    override method move() {
        position = position.left(speed)
        if(position.y() <= game.width() - moveUntil) {
            gameManager.removeRunFn({self.move()})
        }
    }
}

class Sniper inherits Shooter(image = "sniper.png", speed = 10, bulletSpeed = 5, bulletImage = "sniper_bullet.png", moveUntil = 40) {}
class Turret inherits Shooter(image = "turret.png", speed = 10, bulletSpeed = 5, bulletImage = "turrent_bullet.png", moveUntil = 80) {}

