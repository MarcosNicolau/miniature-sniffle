object enemyManager {
    var currentWave = 1
    const enemies = []
    
    method init() {
        self.startWave()                
    }

    method startWave() {
        //TODO improve spawning and wave logic
        game.schedule(3000, {self.spawnEnemies()})
    }

    method nextWave() {
        currentWave += 1
        //TODO should display all of the diferent things that can happen. Ex: if the player did not take any damage then give him life and display a message
        //TODO a counter before starting the wave and the wave number should be displayed
        //TODO should start a different wave based on some params
        self.startWave()
    }
    
    method destroyEnemy(enemy) {
        enemies.remove(enemy)
        if(enemies.isEmpty()) {
            self.nextWave()
        }
    }

    method spawnEnemies() {
        const enemiesToAdd = currentWave * 5 - enemies.size() 
        if(enemies.size() < currentWave * 5) {
            game.schedule(3000, {self.spawnEnemies()})
        }
    }
}