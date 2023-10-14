import gameLoop.*

// Bullets
class Bullet {
    var property position = game.center()
    const speed = 6
    const id
    method image() = "bullet.png"

    method init() {
        game.addVisual(self)
        gameLoop.add("player_bullet_move" + id, {self.move()})
    }   
    
    method move() {
        if(position.x() >= game.width() + 50) {
            game.removeVisual(self)
            gameLoop.remove("player_bullet_move" + id)
        }
        position = position.right(speed)
    }
}

// Objects
object player {
    const speed = 5
    var property bulletsLeft = 10
    var isMovingUp = false
    var property health = 100
    var bulletNumber = 0
    
    var property position = game.at(0, 400)
    method image() = "player.png"

    
    method init() {
        game.addVisual(self)
        game.addVisual(playerBulletsUI)
        self.setupControls()
        gameLoop.add("player_move", {self.move()})
    } 

    method move() {
        if(isMovingUp) {
            if(position.y() >= game.height())
                isMovingUp = false
            position = position.up(speed)
        }
        else {
            if(position.y() <= 0)  
                isMovingUp = true
            position = position.down(speed)    
        }
        
    }

    method getDamaged(damage) {
        health -= damage
        if(health <= 0) self.die()
    }

    method setupControls() {
        keyboard.w().onPressDo({isMovingUp = true})
        keyboard.s().onPressDo({isMovingUp = false})
        keyboard.space().onPressDo({self.shoot()})
    }

    method shoot() {
        if(bulletsLeft > 0) {
            const bullet = new Bullet(position = position, id = bulletNumber)
            bulletNumber += 1
            bullet.init()
            playerBulletsUI.bullets(bulletsLeft)
            bulletsLeft -= 1
        }
    }

    method die() {
        game.stop()
        // game.addVisual(gameOver) //TODO make gameOver in main
    }
}


// ============== UI ================
object playerBulletsUI {
    var property bullets = player.bulletsLeft()
    method position() = game.at(game.width() - 100, 20)
    method message() = "Bullets: " + player.bulletsLeft()
    method text() = "Bullets: " + player.bulletsLeft()
}

