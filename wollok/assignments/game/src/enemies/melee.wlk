import enemies.enemy.*
import main.gameManager

class Melee inherits Enemy(image = "melee.png") { 
    const speed
    var shouldAttack = true 

    override method attack() {
        if(position.y() == player.position().y()) {
            if(position.x() - player.position().x() <= 10) {
                player.getDamaged(damage)
                shouldAttack = false
                game.schedule(3000, {shouldAttack = true})
            }
        }
    }

    override method move() {
        position = position.left(speed).up(player.position().x())
        if(shouldAttack)
            self.attack()
    }
}