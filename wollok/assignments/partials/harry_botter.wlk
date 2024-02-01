class Bot {
    var property cargaElectrica
    var property aceitePuro

}

class Casa {
    const property estudiantes = []
    method esPeligrosa()
}

class Estudiante inherits Bot {
    const property casa
    const property hechizos = []

    method asistirAMateria(materia) {
        hechizos.add(materia.hechizo())
    }

    method activo() = cargaElectrica >= 0

    method esExperimentado() = hechizos.size() > 3 && cargaElectrica > 50

    method lanzarHechizo(hechizo, hechizado) = hechizo.lanzarHechizo(self, hechizado)

    method recibirHechizo(aceite, cargaElectricaAfectada) {}
}

class Profesor inherits Estudiante {
    const materiasQueDa = []
    override method recibirHechizo(aceite, cargaElectricaAfectada) {}

    override method esExperimentado() = super() && materiasQueDa.size() > 3
}

class Hechizo {
    method lanzarHechizo(hechizante, hechizado) {
        if(self.puedeLanzarHechizo(hechizante))
            hechizado.recibirHechizo(false, 49)
    }
    method puedeLanzarHechizo(hechizante)
}

class Materia {
    const property profesor
    const property hechizo
}

object sombreroSeleccionador inherits Bot(cargaElectrica = 50, aceitePuro = false) {
    override method aceitePuro(x) {}

    method asignarCasa(estudiante) {
        // Agarra todas las casas y asigna en base a la cantidad
        // Instanciando un nuevo estudiante y que se yo.
    }
}

object acciones {
    method llegaGrupoDeEstudiantes(estudiantes) {}
    method darMateria(estudiantes) {}
    method lanzarHechizo(es1, es2) {} 
    method todosContraVoldemort(casa) {}
}