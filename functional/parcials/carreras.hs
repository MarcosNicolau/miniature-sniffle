-- ========= Data declaration =========
type Tiempo = Float

type Distancia = Float

type Velocidad = Float

type Color = String

type PowerUp = Auto -> [Auto] -> [Auto]

data Auto = Auto
  { color :: Color,
    velocidadEnMs :: Velocidad,
    distancia :: Distancia
  }
  deriving (Show, Eq)

newtype Carrera = Carrera {participantes :: [Auto]} deriving (Show)

-- ========= Utils fns =========
afectarALosQueCumplen :: (a -> Bool) -> (a -> a) -> [a] -> [a]
afectarALosQueCumplen criterio efecto lista =
  (map efecto . filter criterio) lista ++ filter (not . criterio) lista

obtenerAutoPorColor :: [Auto] -> Color -> Auto
obtenerAutoPorColor [] color = error "Ningún auto con el color indicado"
obtenerAutoPorColor (auto : autos) _color
  | color auto == _color = auto
  | otherwise = obtenerAutoPorColor autos _color

-- ========= 1 =========
autosEstanCerca :: Auto -> Auto -> Bool
autosEstanCerca auto1 auto2 = color auto1 /= color auto2 && abs (distancia auto1) - abs (distancia auto2) <= 11

tieneAlgunAutoCerca :: Auto -> [Auto] -> Bool
tieneAlgunAutoCerca auto = any (autosEstanCerca auto)

aCuantosLeGana :: Auto -> [Auto] -> Int
aCuantosLeGana auto autos = length (filter ((< distancia auto) . distancia) autos)

posicion :: Auto -> [Auto] -> Int
posicion auto autos = aCuantosLeGana auto autos + 1

estaTranquilo :: Auto -> [Auto] -> Bool
estaTranquilo auto autos = posicion auto autos == 1 && not (tieneAlgunAutoCerca auto autos)

-- ========= 2 =========
autoCorrer :: Auto -> Tiempo -> Distancia
autoCorrer auto tiempoEnSegundos = distancia auto + velocidadEnMs auto * tiempoEnSegundos

autoModificarVelocidad :: Velocidad -> Auto -> Auto
autoModificarVelocidad modificadorVelocidadEnMs auto
  | velocidadEnMs auto + modificadorVelocidadEnMs <= 0 = Auto (color auto) (0) (distancia auto)
  | otherwise = Auto (color auto) (velocidadEnMs auto + modificadorVelocidadEnMs) (distancia auto)

-- ========= Power ups ========
terremoto :: PowerUp
terremoto auto1 = afectarALosQueCumplen (autosEstanCerca auto1) (autoModificarVelocidad (-50))

miguelitos :: Velocidad -> PowerUp
miguelitos velocidad auto autos = afectarALosQueCumplen (\auto2 -> posicion auto autos > posicion auto2 autos) (autoModificarVelocidad velocidad) autos

jetpack :: Tiempo -> PowerUp
jetpack tiempo auto = afectarALosQueCumplen (== auto) (\auto2 -> Auto (color auto2) (velocidadEnMs auto2) (autoCorrer (autoModificarVelocidad (velocidadEnMs auto * 2) auto2) tiempo))

misil :: Color -> PowerUp
misil _color auto autos = afectarALosQueCumplen (== obtenerAutoPorColor autos _color) (\auto2 -> Auto (color auto2) 0 (distancia auto)) autos

-- ========= Simular carrera =========
aplicarEventos :: Carrera -> [Carrera -> Carrera] -> Carrera
aplicarEventos = foldl (\carrera evento -> evento carrera)

tablaDePosiciones :: Carrera -> [(Int, Color)]
tablaDePosiciones carrera = map (\auto -> (posicion auto (participantes carrera), color auto)) (participantes carrera)

simularCarrera :: Carrera -> [Carrera -> Carrera] -> [(Int, Color)]
simularCarrera carrera eventos = tablaDePosiciones (aplicarEventos carrera eventos)

-- ========= Eventos =========
correnTodos :: Tiempo -> Carrera -> Carrera
correnTodos tiempoEnSegundos carrera = Carrera (map (\auto -> auto {distancia = autoCorrer auto tiempoEnSegundos}) (participantes carrera))

usarPowerUp :: Color -> PowerUp -> Carrera -> Carrera
usarPowerUp color powerUp carrera = Carrera (powerUp (obtenerAutoPorColor (participantes carrera) color) (participantes carrera))

carrera :: [(Int, Color)]
carrera = simularCarrera (Carrera [Auto "azul" 120 0, Auto "rojo" 120 0, Auto "blanco" 120 0, Auto "negro" 120 0]) [usarPowerUp "azul" (misil "blanco"), correnTodos 30, usarPowerUp "azul" (jetpack 3), usarPowerUp "blanco" terremoto, correnTodos 40, usarPowerUp "blanco" (miguelitos 20), usarPowerUp "negro" (jetpack 6), correnTodos 10]