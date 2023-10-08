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
    
object player {
    const speed = 5
    var bulletsLeft = 10
    var isMovingUp = false
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
            bulletsLeft -= 1
        }
        
    }
}

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

        game.onTick(60, "runner", {runner.forEach({fn => fn.apply()})})
    }


    method addRunFn(fn) {
        runner.add(fn)
    }
}