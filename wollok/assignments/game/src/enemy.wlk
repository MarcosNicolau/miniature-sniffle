class Enemy {
    const property image
    var property position
    var health = 100
    var damage    

    method init() {
        
    }

    method move() {}

    method attack()

    method getDamaged() {
        if(health <= 0) {
            self.die()
        }
    }

    method die() {
        enemyManager.destroyEnemy(self)
    }
    
}

class EnemyHealthBarUI {
    var property position
    const enemy
    var property text = "Life: " + enemy.health()
    
}

class Melee inherits Enemy(image = "melee.png") { 
    method attack(player) {}
}
class Sniper inherits Enemy(image = "sniper.png") {
    
    method attack(player) {}
}

class Shooter inherits Enemy(image = "shooter.png") {
    method attack(player) {}
}

object enemyManager {
    var currentWave = 1
    const enemies = []
    
    method init() {
        self.startWave()                
    }

    method startWave() {
        //TODO wave logic
        game.schedule(3000, {self.spawnEnemies()})
    }

    method nextWave() {
        if(enemies.isEmpty()) {
            currentWave += 1
        }
    }
    method destroyEnemy(enemy) {
        enemies.remove(enemy)
        self.nextWave()
    }

    method spawnEnemies() {
        const enemiesToAdd = currentWave * 5 - enemies.size() 
        if(enemies.size() <= enemiesToAdd) {
            if(enemiesToAdd < 3) {
                enemiesToAdd.times(new Melee(position = game.center(), damage = currentWave *  2))
            }
            else {
                enemy.add(new Sniper(position = game.center(), damage = currentWave * 5))
                enemy.add(new Melee(position = game.center(), damage = currentWave * 2))
                enemy.add(new Shooter(position = game.center(), damage = currentWave * 1))
            }
        }
        if(enemies.size() < currentWave * 5) {
            game.schedule(3000, {self.spawnEnemies()})
        }
    }
}