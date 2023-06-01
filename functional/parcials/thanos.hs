-- ============ Types declaration ============
type Habilidad = String

type Habilidades = [Habilidad]

type Gema = Personaje -> Personaje

type Gemas = [Gema]

data Guantelete = Guantelete
  { material :: String,
    gemas :: Gemas
  }

data Personaje = Personaje
  { nombre :: String,
    planeta :: String,
    edad :: Int,
    energia :: Int,
    habilidades :: Habilidades
  }

type Universo = [Personaje]

-- ============ Data declaration ============
ironMan :: Personaje
ironMan = Personaje "Tony" "Tierra" 43 100 ["Cojerse a Pepper Pots", "Cojerse a Pepper Pots en cuatro"]

-- ============ Util fns ============
numeroDeGemas :: Guantelete -> Int
numeroDeGemas = length . gemas

aplicarEfectoEnergia personaje efecto
  | efecto <= 0 = personaje {energia = 0}
  | otherwise = personaje {energia = efecto}

efectoEnergiaPersonaje :: Personaje -> Int -> Personaje
efectoEnergiaPersonaje personaje efecto = aplicarEfectoEnergia personaje (energia personaje - efecto)

ternario :: Bool -> a -> a -> a
ternario f a b
  | f = a
  | otherwise = b

-- ============ Funciones ej 1 ============
chasquido :: Guantelete -> Universo -> Universo
chasquido guantelete universo
  | material guantelete == "uru" && numeroDeGemas guantelete == 6 = take (length universo `div` 2) universo
  | otherwise = universo

-- ============ Funciones ej 2 ============
universoAptoParaPendex :: Universo -> Bool
universoAptoParaPendex = any ((>= 45) . edad)

energiaTotalUniverso :: Universo -> Int
energiaTotalUniverso universo = sum (map energia (filter ((> 2) . length . habilidades) universo))

-- ============ Funciones ej 3 ============
laMente :: Int -> Gema
laMente n oponente = oponente {energia = energia oponente - n}

elAlma :: Habilidad -> Gema
elAlma habilidad oponente = oponente {habilidades = filter (/= habilidad) (habilidades oponente)}

elEspacio :: String -> Gema
elEspacio planeta oponente = oponente {planeta = planeta, energia = energia (efectoEnergiaPersonaje oponente (-20))}

elPoder :: Gema
elPoder oponente = oponente {energia = 0, habilidades = ternario (length (habilidades oponente) <= 2) [] (habilidades oponente)}

calcularEdadOponente :: Int -> Gema
calcularEdadOponente edad oponente
  | edad <= 18 = oponente {edad = 18}
  | otherwise = oponente {edad = edad}

elTiempo :: Gema
elTiempo oponente = oponente {edad = edad (calcularEdadOponente (edad oponente `div` 2) oponente), energia = energia (efectoEnergiaPersonaje oponente (-50))}

laGemaLoca :: a -> (a -> Personaje -> Personaje) -> Personaje -> Personaje
laGemaLoca cambio poder oponente = poder cambio (poder cambio oponente)

-- ============ Funciones ej 4 ============
ejemploGema :: Personaje -> Personaje
ejemploGema = laGemaLoca "programación en Haskell" elAlma . elAlma "usar Mjolnir" . elTiempo

-- ============ Funciones ej 5 ============
utilizar :: Gemas -> Personaje -> Personaje
utilizar gemas enemigo = foldl (\x y -> y x) enemigo gemas

-- ============ Funciones ej 6 ============
calcularGemaMasPoderosa :: Gemas -> Personaje -> Gema
calcularGemaMasPoderosa [x] _ = x
calcularGemaMasPoderosa (gema : gema' : gemas) personaje
  | energia (gema personaje) < energia (gema personaje) = calcularGemaMasPoderosa (gema : gemas) personaje
  | otherwise = calcularGemaMasPoderosa (gema' : gemas) personaje

gemaMasPoderosa :: Guantelete -> Personaje -> Gema
gemaMasPoderosa guantelete = calcularGemaMasPoderosa (gemas guantelete)

infinitasGemas :: Gema -> [Gema]
infinitasGemas gema = gema : (infinitasGemas gema)

guanteleteDeLocos :: Guantelete
guanteleteDeLocos = Guantelete "vesconite" (infinitasGemas elTiempo)

usoLasTresPrimerasGemas :: Guantelete -> Personaje -> Personaje
usoLasTresPrimerasGemas guantelete = (utilizar . take 3 . gemas) guantelete

-- Esta funcion no se terminara nunca de evaluar, ya que la obtencion de la gema mas poderosa
foo = gemaMasPoderosa guanteleteDeLocos ironMan

-- Esta funcion si se puede correr, ya que antes de utilizar tenemos take 3, la cual hace que `gemas` se termine de evaluar la tercer vez
bar = usoLasTresPrimerasGemas guanteleteDeLocos ironMan