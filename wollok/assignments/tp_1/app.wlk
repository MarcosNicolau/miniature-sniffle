class Propiedad {
    const property valor
}

class Acompanante {
    const property animal
    var property peligroso

}

object sutil {
    const casas = [casaLannister, casaStark, guardiaDeLaNoche]
    method accion(personajeObjetivo) {
        const casaConMenorCapital = casas.min({casa => casa.capital()})
        return casaConMenorCapital.intergrantes().anyOne({integrante => integrante.puedeCasarse(personajeObjetivo)})
    }
}

object asesino {
    method accion(personajeObjetivo) {
        personajeObjetivo.vive(false)
    }
}

object confundido {
    method accion(personajeObjectivo) {
        personajeObjectivo.conquistarPropiedad(new Propiedad(valor = 100))
    }
}

object miedoso {
    method accion(personajeObjectivo) {
    }
}

class Personaje {
    var dinero
    const ciudad
    const personalidad //recibe objeto personalidad
    var property cantidadCasamientos
    var property casa // recibe objeto casa
    var property vive = true
    const acompanantes = []

    method esRico() = dinero + (casa.capital() * 0.1) > 1000

    method conquistarPropiedad(propiedad) {
        dinero += propiedad.valor() * 0.1
        casa.agregarPropiedad(propiedad)
    }

    method noTieneAcompanantes() = acompanantes.isEmpty()

    method traicionar(nuevaCasa) {
        casa = nuevaCasa
    }

    method esPeligroso() = vive && acompanantes.anyOne({acompanante => acompanante.peligroso()})

    method casarse(personaje) {
        if(casa.puedenCasarse(self, personaje))
            cantidadCasamientos += 1
    }

    method accionConspiratoria(personajeObjectivo) {
        personalidad.accion(personajeObjectivo)
    }

}

object casaLannister {
    const propiedades = []
    const property integrantes = []

    method puedenCasarse(personaje1, personaje2) = personaje1.cantidadCasamientos() == 1 && personaje2.cantidadCasamientos() == 1

    method capital () = propiedades.sum({x => x.valor()})
    
    method agregarPropiedad(propiedad) {
        propiedades.add(propiedad)
    }

}

object casaStark {
    var property capital = 1000
    const property integrantes = []
    method puedenCasarse(personaje1, personaje2) = personaje1 != personaje2 

    method agregarPropiedad(propiedad) {
        capital += propiedad.valor()
    }
}

object guardiaDeLaNoche {
    const property capital = 0
    const property integrantes = []

    method puedeCasarse(personaje1, personaje2) = false

    method agregarPropiedad(propiedad) {
    }
}

class Conspiracion {
    const personajeObjetivo
    var ejecutada = false
    const complotados = []

    method ejecutar()  {
        if(!personajeObjetivo.esPeligroso())
            throw new Exception(message = "El personaje tiene que ser peligroso")
        complotados.forEach({complotado => complotado.accion(personajeObjetivo)})
        ejecutada = true
    }

    method objetivoCumplido() = ejecutada && personajeObjetivo.esPeligroso()
}