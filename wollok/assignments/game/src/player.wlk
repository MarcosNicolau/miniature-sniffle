import main.*

// Bullets
class Bullet {
    var property position = game.center()
    const speed = 6
    method image() = "bullet.png"

    method init() {
        game.addVisual(self)
        gameManager.addRunFn({self.move()})
    }   
    
    method move() {
        if(position.x() >= game.width() + 50) {
            game.removeVisual(self)
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
    
    var property position = game.at(0, 400)
    method image() = "player.png"

    
    method init() {
        self.setupControls()
        gameManager.addRunFn({self.move()})
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

    method setupControls() {
        keyboard.w().onPressDo({isMovingUp = true})
        keyboard.s().onPressDo({isMovingUp = false})
        keyboard.space().onPressDo({self.shoot()})
    }

    method shoot() {
        if(bulletsLeft > 0) {
            const bullet = new Bullet(position = position)
            bullet.init()
            playerBulletsUI.bullets(bulletsLeft)
            bulletsLeft -= 1
        }
    }

    method die() {
        if (health <= 0){
            game.stop()
            game.addVisual(gameOver) //TODO make gameOver in main
        }
    }
}


// ============== UI ================
object playerBulletsUI {
    var property bullets = player.bulletsLeft()
    method position() = game.at(game.width() - 100, 20)
    method message() = "Balas: " + player.bulletsLeft()
    method text() = "Balas: " + player.bulletsLeft()
}

