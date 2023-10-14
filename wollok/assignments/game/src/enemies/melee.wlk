import enemies.enemy.*
import main.gameManager

class Melee inherits Enemy(image = "melee.png") { 
    const speed = 2
    var shouldAttack = true 
    const minDistanceFromPlayer = player.position().x() + 20

    override method attack() {
        if(position.y() == player.position().y()) {
            if(position.distance(player) <= 20) {
                player.getDamaged(damage)
                shouldAttack = false
                game.schedule(3000, {shouldAttack = true})
            }
        }
    }

    override method move() {
        if(position.x() >= minDistanceFromPlayer) 
            position = position.left(speed).up(player.position().x())
        else 
           position = position.up(player.position().x())

        if(shouldAttack)
            self.attack()
    }
}