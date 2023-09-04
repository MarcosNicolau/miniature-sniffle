// ================ Donpepe ================
object cuentaCorrienteDonPepe {
    var saldo = 5000

    method getSaldo() = saldo

    method depositar(monto) {
        saldo = saldo + monto
    }

    method retirar(monto) {
        saldo = saldo - monto
    }
}
object campoDonPepe {
    const tamano_hectareas = 15
    var cultivo_sembrado = trigo
    var hectareas_sembradas = 10

    
    method fumigar() {
        cuentaCorrienteDonPepe.retirar(10 * tamano_hectareas)
    }

    method fertilizar(precio_fertilizante_por_hectarea) {
        cuentaCorrienteDonPepe.retirar(precio_fertilizante_por_hectarea * hectareas_sembradas)
        cultivo_sembrado.fertilizar()
    }

    method resembrar(nuevo_cultivo) {
        cuentaCorrienteDonPepe.retirar(nuevo_cultivo.costo(hectareas_sembradas))
        cultivo_sembrado.restablecer()
        cultivo_sembrado = nuevo_cultivo
    }

    method ampliarSuperficie() {
        const nuevas_hectareas = tamano_hectareas - hectareas_sembradas
        cuentaCorrienteDonPepe.retirar(cultivo_sembrado.costo(nuevas_hectareas))
        hectareas_sembradas = hectareas_sembradas + nuevas_hectareas
    }

    method sembrar(nuevo_cultivo, hectareas_a_sembrar) {
        if(hectareas_a_sembrar <= tamano_hectareas) {
            cuentaCorrienteDonPepe.retirar(nuevo_cultivo.costo(hectareas_a_sembrar))
            cultivo_sembrado = nuevo_cultivo
            hectareas_sembradas = hectareas_a_sembrar
        }
        else {
           console.println("Error, Hectareas insuficientes")
        }
    }

    method cosechar() {
        const ganancia = cultivo_sembrado.precioDeVenta(cultivo_sembrado.rendimiento(hectareas_sembradas))
        cuentaCorrienteDonPepe.depositar(ganancia)  
        //Se restablece el estado del cultivo
        cultivo_sembrado.restablecer()
        cultivo_sembrado = cultivoVacio
    }

}

// ================ Other subjects ================
object mercadoChicago {
    method precio_soja() = 1368
}

object bcra {
    method dolar_soja() = 350
}


// ================ Cultivos declaration ================
//Se crea para a la hora de cosechar no se produzca un error
object cultivoVacio {
    method costo(hectareas){}
    method rendimiento(hectareas) {}
    method precioDeVenta(quintales) {}
    method fertilizar() {
    }
    method restablecer() {
    }
}

object trigo {
    const rendimiento_por_hectarea_base = 10
    var rendimiento_por_hectarea = rendimiento_por_hectarea_base
    const precio_venta_por_quintal = 1000
    const precio_por_hectarea = 500

    method rendimiento(hectareas) = hectareas * rendimiento_por_hectarea

    method costo(hectareas) = precio_por_hectarea * hectareas

    method precioDeVenta(quintales) = quintales * precio_venta_por_quintal

    method fertilizar() {
        rendimiento_por_hectarea = rendimiento_por_hectarea + 2
    }

    method restablecer() {
        rendimiento_por_hectarea = rendimiento_por_hectarea_base
    }
}

object soja {
    const rendimiento_por_hectarea_base = 20
    const rendimiento_por_hectarea_fertilizado = 40
    var rendimiento_por_hectarea = rendimiento_por_hectarea_base
    var esta_fertilizado = false

    method costo(hectareas) = mercadoChicago.precio_soja()/2 * hectareas

    method rendimiento(hectareas) = hectareas * rendimiento_por_hectarea

    method precioDeVenta(quintales) = quintales * (mercadoChicago.precio_soja() * bcra.dolar_soja())*(1-0.35)

    method fertilizar() {
        if(esta_fertilizado) {
            rendimiento_por_hectarea = rendimiento_por_hectarea_base
            esta_fertilizado = false   
        }
        else {
            esta_fertilizado = true
            rendimiento_por_hectarea = rendimiento_por_hectarea_fertilizado
        }
    }

    method restablecer() {
        rendimiento_por_hectarea = rendimiento_por_hectarea_base
        esta_fertilizado =  false
    }
}

object maiz {
    const precio_por_hectarea = 500
    const rendimiento_por_hectarea = 15

    method costo(hectareas) {
        const costo = hectareas * precio_por_hectarea
        if(costo > 5000) return 5000 
        return costo
    }

    method rendimiento(hectareas) = hectareas * rendimiento_por_hectarea

    method fertilizar() {}

    method precioDeVenta(quintales) = quintales * soja.precioDeVenta(quintales) / 2

    method restablecer() {}
}

// Cultivo agregado 
object batata {
    const precio_por_hectarea = 20
    const rendimiento_por_hectarea_base = 15
    var rendimiento_por_hectarea = rendimiento_por_hectarea_base
    const precio_venta_por_quintal = 30

    method costo(hectareas) = precio_por_hectarea * hectareas

    method rendimiento(hectareas) = hectareas * rendimiento_por_hectarea

    method precioDeVenta(quintales) = quintales * precio_venta_por_quintal

    method fertilizar() {
        rendimiento_por_hectarea = rendimiento_por_hectarea + rendimiento_por_hectarea/2
    }

    method restablecer() {
        rendimiento_por_hectarea = rendimiento_por_hectarea_base
    }
}