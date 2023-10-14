import enemies.enemy.*
import _utils.*
import enemies.index.*
import gameLoop.*
import _scheduler.*
import player.*

class SniperBullet inherits EnemyBullet {
    var ySpeed = 5

    override method init() {
        super()
        const yDir  = player.position().y()
        const yDisFromPlayer = player.position().y() - position.y()
        // From the cinematic equations of the player and bullet we can solve the y velocity in order to hit the player
        // I guess cinematcis were important after all...
        ySpeed =  -(player.position().y() - position.y()) / ((player.position().x() - position.x()) / speed)
    }

    override method move() {
        position = position.left(speed).up(ySpeed)        
    }   
}

class TurretBullet inherits EnemyBullet {
    override method move() {
        if(position.x() <= -20) {
            game.removeVisual(self)
            gameLoop.remove("enemy_bullet" + id)
        }
        position = position.left(speed)
    }
}

class Shooter inherits Enemy {
    const speed
    const moveUntil
    
    override method move() {
        position = position.left(speed)
        if(position.x() <= game.width() - moveUntil) {
            self.stopMoving()
            self.attack()
        }
    }
}

class Sniper inherits Shooter(image = "sniper.png", speed = 4,  moveUntil = 150) {
    override method attack() {
        new SniperBullet(position = position, damage = damage, speed = 3, image = "sniper_bullet.png", id = utils.generateRandomId()).init()
        scheduler.schedule(3000, {self.attack()})
    }
}

// They only shoot ahead, witouth pointing to the player
class Turret inherits Shooter(image = "turret.png", speed = 4, moveUntil = 200) {
    override method attack() {
        new TurretBullet(position = position, damage = damage, speed = 2, image = "turret_bullet.png", id = utils.generateRandomId()).init()
        scheduler.schedule(2000, {self.attack()})
    }
}

