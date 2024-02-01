class Plato {
    const property azucar

    method calorias() = 3*azucar + 100

    method esBonito()
}


class Entrada inherits Plato(azucar = 0) {
    override method esBonito() = true
}
class Principal inherits Plato(azucar = 0) {
    const esBonito
    override method esBonito() = esBonito
}
class Postre inherits Plato(azucar = 120) {
    const colores
    override method esBonito() = colores > 3
}

class Catador {
    method catar(plato)
}

class Especialidad inherits Catador {

    method cocinar()
}

class Pastelero inherits Especialidad {
    const nivelDeDulzor
    
    override method catar(plato) = 5 * plato.azucar() / nivelDeDulzor

    override method cocinar() = new Postre(colores = nivelDeDulzor / 50)
}

class Chef inherits Especialidad {
    const limiteCalorias

    override method catar(plato) {
        if(plato.calorias() <= limiteCalorias && plato.esBonito()) return 10
        else return 0
    } 


    override method cocinar() = new Principal(azucar = limiteCalorias, esBonito = true)
}

class SousChef inherits Chef {
    override method catar(plato) {
        super(plato)
        const op = plato.calorias() / 100
        if(op > 6) return 6
        else return op
    } 

    override method cocinar() = new Entrada()
}


class Cocinero {
    var especialidad

    method cambiarEspecialidad(nuevaEspecialidad) {
        especialidad = nuevaEspecialidad
    }     

    method cocinar()  = especialidad.cocinar()
    method catar(plato) = especialidad.cocinar(plato)
}

class Torneo {
    const cocinerosParticipantes = []
    const catadores = []
    var cocineroGanador 
    var sumaGanadora
    
    method ganador() {
        if(cocinerosParticipantes.size() == 0) throw new Exception(message = "Al menos un cocinero debe presentarse")
        cocinerosParticipantes.forEach({cocinero => self.evaluar(cocinero)})
    }

    method evaluar(cocinero) {
        const suma = catadores.sum({catador => catador.catar(cocinero.cocinar())})
         if(suma >= sumaGanadora) {
            sumaGanadora = suma
            cocineroGanador = cocinero
        } 
    }
}