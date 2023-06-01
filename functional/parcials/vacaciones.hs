-- =========== Types declaration ===========
type Idioma = String

type Marea = String

type Excursion = Turista -> Turista

type Tour = [Excursion]

type Tours = [Tour]

data Turista = Turista
  { estaSolo :: Bool,
    idiomas :: [Idioma],
    cansancio :: Int,
    stress :: Int
  }

type Turistas = [Turista]

-- =========== Util fns ===========
ternario :: Bool -> p -> p -> p
ternario f a b
  | f = a
  | otherwise = b

intensidadCaminata :: Int -> Int
intensidadCaminata minutos = minutos `div` 4

agregarSiNoSeEncuentra :: Eq a => a -> [a] -> [a]
agregarSiNoSeEncuentra item list
  | item `elem` list = list
  | otherwise = item : list

obtenerPorcentaje :: Int -> Int -> Int
obtenerPorcentaje num porcentaje = (num * porcentaje) `div` 100

deltaSegun :: (a -> Int) -> a -> a -> Int
deltaSegun f algo1 algo2 = f algo1 - f algo2

-- =========== Excursiones ===========
efectoExcursion :: Turista -> Int -> Int -> Turista
efectoExcursion turista modificadorStress modificadorCansancio = turista {stress = stress turista + modificadorStress, cansancio = cansancio turista + modificadorCansancio}

irALaPlaya :: Turista -> Turista
irALaPlaya turista = efectoExcursion turista (ternario (estaSolo turista) (-5) (-1)) 0

apreciarPaisaje :: String -> Turista -> Turista
apreciarPaisaje paisaje turista = efectoExcursion turista (-length paisaje) 0

hablarIdioma :: Idioma -> Turista -> Turista
hablarIdioma idioma turista = turista {estaSolo = False, idiomas = agregarSiNoSeEncuentra idioma (idiomas turista)}

efectoCaminata :: Int -> Turista -> Turista
efectoCaminata intensidad turista = efectoExcursion turista (-intensidad) (-intensidad)

caminar :: Int -> Turista -> Turista
caminar minutos = efectoCaminata (intensidadCaminata minutos)

paseoDeBarco :: Marea -> Turista -> Turista
paseoDeBarco marea turista
  | marea == "fuerte" = efectoExcursion turista (-6) (-10)
  | marea == "moderada" = turista
  | marea == "tranquila" = turista {estaSolo = False, idiomas = idiomas (hablarIdioma "aleman" turista), stress = stress (apreciarPaisaje "mar" (caminar 10 turista)), cansancio = cansancio (caminar 10 turista)}
  | otherwise = error "El valor de la marea es invalido, posibles valores son: <fuerte, moderada, tranquila>"

-- =========== Modelos ===========
ana, beto, cathi :: Turista
ana = Turista False ["espanol"] 0 21
beto = Turista False ["aleman"] 15 15
cathi = Turista False ["aleman", "catalan"] 15 15

calcularEfectoExcursionPlus :: Turista -> Turista
calcularEfectoExcursionPlus turista = turista {stress = stress turista - obtenerPorcentaje (stress turista) 10}

efectoExcursionPlus :: Turista -> (Turista -> Turista) -> Turista
efectoExcursionPlus turista excursion = calcularEfectoExcursionPlus (excursion turista)

deltaExcursionSegun :: (Turista -> Int) -> Turista -> Excursion -> Int
deltaExcursionSegun indice turista excursion = deltaSegun indice (excursion turista) turista

excursionEsEducativa :: Turista -> Excursion -> Bool
excursionEsEducativa turista excursion = deltaExcursionSegun (length . idiomas) turista excursion >= 1

excursionEsDesestresante :: Turista -> Excursion -> Bool
excursionEsDesestresante turista excursion = deltaExcursionSegun stress turista excursion >= 3

excursionDejaAcompanado :: Turista -> Excursion -> Bool
excursionDejaAcompanado turista excursion = deltaExcursionSegun (\turista -> ternario (estaSolo turista) 0 1) turista excursion >= 1

-- =========== Tours ===========
realizarExcursiones :: Turista -> Tour -> Turista
realizarExcursiones = foldl (\turista excursion -> excursion turista)

realizarTour :: Turista -> Tour -> Turista
realizarTour turista tour = realizarExcursiones (turista {stress = stress turista + length tour}) tour

algunTourEsConveniente :: Turista -> Tours -> Bool
algunTourEsConveniente turista = any (any (\excursion -> excursionEsDesestresante turista excursion && excursionDejaAcompanado turista excursion))

puntosDespuesDeTour :: (Turista -> Int) -> Turista -> Tour -> Int
puntosDespuesDeTour f turista tour = f (realizarTour turista tour) - f turista

espiritualidadRecibida :: Tour -> Turista -> Int
espiritualidadRecibida tour turista = puntosDespuesDeTour stress turista tour + puntosDespuesDeTour cansancio turista tour

efectividadDeTour :: Turistas -> Tour -> Int
efectividadDeTour turistas tour = sum (map (espiritualidadRecibida tour) (filter (\turista -> algunTourEsConveniente turista [tour]) turistas))

data Hola = Lista
  { elem1 :: Int
  }

obtenerNumero :: Hola -> Int
obtenerNumero hola = elem1 hola

hola :: [Hola] -> Int
hola holas = sum (map (\hola -> elem1 hola) holas)

chau :: (Int -> Int) -> Int -> Int -> Int
chau f a b
  | f a > f b = a
  | otherwise = b

chauDevuelta :: Int
chauDevuelta = chau (\x -> x + 5) 1 2