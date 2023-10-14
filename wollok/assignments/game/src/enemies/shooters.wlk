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
        game.whenCollideDo(self, {visual => {
            visual.getDamaged(damage)
        }})
    }
}

class Shooter inherits Enemy {
    const speed
    const bulletSpeed
    const bulletImage
    const moveUntil
    const bulletStartingYPos = position.y(player.y()) 

    override method attack() {
        new Bullet(position = bulletStartingYPos, damage = damage, speed = bulletSpeed, image = bulletImage).init()
        game.schedule(6000, {self.attack()})
    }
    
    override method move() {
        position = position.left(speed)
        if(position.y() <= game.width() - moveUntil) {
            gameManager.removeRunFn({self.move()})
        }
    }
}

class Sniper inherits Shooter(image = "sniper.png", speed = 4, bulletSpeed = 5, bulletImage = "sniper_bullet.png", moveUntil = 40) {}
// They only shoot ahead, witouth pointing to the player
class Turret inherits Shooter(image = "turret.png", speed = 4, bulletSpeed = 5, bulletImage = "turrent_bullet.png", moveUntil = 80, bulletStartingYPos = position.y()) {}

