import enemies.enemy.*
import main.gameManager
import player.*
import _scheduler.*

class Melee inherits Enemy(image = "melee.png") { 
    const speed = 2
    var shouldAttack = true 
    var shouldMoveOnY = true
    var moveOnY = speed

    override method attack() {
        if(position.distance(player.position()) <= 50) {
            position = position.left(50)
            scheduler.schedule(1000, {position = position.right(50)})
            shouldAttack = false
            scheduler.schedule(5000, {shouldAttack = true})
        }
    }

    method moveY() {
        const isPlayerOnTop = player.position().y() >= position.y()
        var yToMove = speed
        if(!isPlayerOnTop) yToMove = -1 * yToMove
        position = position.up(yToMove)
        moveOnY = yToMove
        shouldMoveOnY = false
        scheduler.schedule(500, {shouldMoveOnY = true})
    }

    override method move() {
        if(position.x() >= 50) 
            position = position.left(speed)
        if(shouldMoveOnY)
            self.moveY()
        else 
            position = position.up(moveOnY)

        if(shouldAttack)
            self.attack()
    }
}