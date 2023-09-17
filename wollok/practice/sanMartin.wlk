object sanMartin {
    var army = []
    var horses = 5

    method enroll(soldier) {
        army.add(soldier)
    }

    method unenroll(soldier) {
        army.remove(soldier)
    }

    method army() = army

    method belongs(soldier) = army.contains(soldier)
    
    method enoughHorses() = army.size() <= horses

    method fireEveryone() = army.clear()

    method troops() = army.size()

    method power() = army.sum({x => x.power()})
    
    method isArmyBiggerThan(enemy) = self.troops() > enemy.troops()
    
    method isAfraidOfEnemy(enemy) = enemy.troops() >= 100 || self.troops() == 0

    method attack( enemy) {
        enemy.troops(enemy.troops() - self.power())
        enemy.powerCoeficient(enemy.powerCoeficient() - 0.01 * self.power())
    }

    method visitCity(city) {
        city.activity(self)
       
    }
    method askForEconomicHelp(city){
        horses += city.economicHelp() 
    }

    method massiveDesertion() {
        army = army.filter({x => x.deserts()})
    } 

    method winsWar(enemy) = self.troops() >= enemy.troops() && !self.isAfraidOfEnemy(enemy) && self.power() > enemy.power()
   
}

object realisticCaptain {
    var property troops = 500
    var property powerCoeficient = 500
    const property power = troops * powerCoeficient
}

object cabral {
    var property power = 10

    method deserts() = false
    method train() {
        if(power <= 50) {
            power += 1 
        } 
    }
    method altersTranquility() = false
}

object pepita {
    const property power = 30

    method deserts() = true
    method power(x) {}
    method train() {}
    method altersTranquility() = false
}

object gladys {
    const property power = 0

    method deserts() = true
    method power(x) {}
    method train() {}
    method altersTranquility() = true
}

object sanLorenzo {
    const people = [cabral, pepita, gladys]

    method peopleThatFight() = people.filter({x => x.power() > 0})
    
    method trainingDay(army) {
        army.forEach({x => x.train() })
    }

    method economicHelp() = people.filter({x => !x.fights()}).size()

    method activty(visitor) {
        self.peopleThatFight().forEeach({x => visitor.enroll()})
        self.trainingDay(visitor.army())
    }
}