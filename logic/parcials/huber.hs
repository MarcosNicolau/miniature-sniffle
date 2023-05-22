-- =========== Types declaration ===========
type CondicionViaje = Viaje -> Bool

data Cliente = Cliente
  { cNombre :: String,
    zona :: String
  }

data Viaje = Viaje
  { precio :: Float,
    fecha :: String,
    cliente :: Cliente
  }

data Tachero = Tachero
  { tNombre :: String,
    kilometraje :: Float,
    viajes :: [Viaje],
    tomaViaje :: CondicionViaje
  }

-- ========== Util fns ==========
minElem :: (Num a, Ord a) => (b -> a) -> [b] -> b
minElem _ [x] = x
minElem f (x : y : xs)
  | f x >= f y = minElem f (y : xs)
  | f x <= f y = minElem f (x : xs)

listaInifinita :: t -> [t]
listaInifinita x = x : listaInifinita x

-- =========== Condiciones para tomar viaje ===========
siempre :: b -> Bool
siempre = const True

porZona :: String -> Viaje -> Bool
porZona z viaje = zona (cliente viaje) /= z

porPrecio :: Viaje -> Bool
porPrecio = (> 200) . precio

porNombre :: Int -> Viaje -> Bool
porNombre n viaje = length (cNombre (cliente viaje)) > n

-- =========== Clientes ===========
lucas :: Cliente
lucas = Cliente "Lucas" "Victoria"

daniel, alejandra :: Tachero
daniel = Tachero "Daniel" 23500 [Viaje 150 "20/04/2017" lucas] (porZona "olivos")
alejandra = Tachero "Alejandra" 180000 [] siempre

-- =========== Ejercicio 4 ===========
puedeTomarViaje :: Tachero -> CondicionViaje
puedeTomarViaje = tomaViaje

-- =========== Ejercicio 5 ===========
liquidarViajes :: Tachero -> Float
liquidarViajes tachero = sum (map precio (viajes tachero))

-- =========== Ejercicio 6 ===========
agregarViaje :: Viaje -> Tachero -> Tachero
agregarViaje viaje tachero = tachero {viajes = viaje : viajes tachero}

realizarViaje :: Viaje -> [Tachero] -> Tachero
realizarViaje viaje tacheros = agregarViaje viaje (minElem (length . viajes) (filter (`tomaViaje` viaje) tacheros))

-- =========== Ejercicio 7 ===========

nitoInfy :: Tachero
nitoInfy = Tachero "Nito Infy" 70000 (listaInifinita (Viaje 50 "11/03/2017" lucas)) (porNombre 3)
