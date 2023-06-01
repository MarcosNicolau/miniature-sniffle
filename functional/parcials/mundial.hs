-- ========== Types declaration ==========
type Grupo = Char

data Jugador = CJugador
  { jNombre :: String,
    edad :: Int,
    promedioDeGol :: Float,
    habilidad :: Int,
    cansancio :: Float
  }
  deriving (Eq)

data Equipo = Equipo
  { eNombre :: String,
    eGrupo :: Grupo,
    jugadores :: [Jugador]
  }

-- ========== Data declaration ==========
martin, juan, maxi, jonathan, lean, brian, garcia, messi, aguero :: Jugador
martin = CJugador "Martin" 26 0.0 50 35.0
juan = CJugador "Juancho" 30 0.2 50 40.0
maxi = CJugador "Maxi Lopez" 27 0.4 68 30.0
jonathan = CJugador "Chueco" 20 1.5 80 99.0
lean = CJugador "Hacha" 23 0.01 50 35.0
brian = CJugador "Panadero" 21 5 80 15.0
garcia = CJugador "Sargento" 30 1 80 13.0
messi = CJugador "Pulga" 26 10 99 43.0
aguero = CJugador "Aguero" 24 5 90 5.0

equipo1, losDeSiempre, restoDelMundo :: Equipo
equipo1 = Equipo "Lo Que Vale Es El Intento" 'F' [martin, juan, maxi]
losDeSiempre = Equipo "Los De Siempre" 'F' [jonathan, lean, brian]
restoDelMundo = Equipo "Resto del Mundo" 'A' [garcia, messi, aguero]

jugadoresFaranduleros = ["Maxi Lopez", "Icardi", "Aguero", "Caniggia", "Demichelis"]

-- ========== Util fns ==========
quickSort :: (a -> a -> Bool) -> [a] -> [a]
quickSort _ [] = []
quickSort criterio (x : xs) = (quickSort criterio . filter (not . criterio x)) xs ++ [x] ++ (quickSort criterio . filter (criterio x)) xs

nombreDeJugadoresEquipo :: Equipo -> [String]
nombreDeJugadoresEquipo equipo = map jNombre (jugadores equipo)

esJoven :: Jugador -> Bool
esJoven = (< 27) . edad

ordenarJugadoresPorCansancio :: [Jugador] -> [Jugador]
ordenarJugadoresPorCansancio = quickSort (\j1 j2 -> cansancio j1 < cansancio j2)

-- ========== Ejercicio 1 ==========
figuras :: Equipo -> [Jugador]
figuras equipo = filter (\jugador -> habilidad jugador > 75 && promedioDeGol jugador > 0) (jugadores equipo)

esFigura :: Jugador -> Equipo -> Bool
esFigura jugador equipo = jugador `elem` figuras equipo

-- ========== Ejercicio 2 ==========
tieneFarandulero :: Equipo -> Bool
tieneFarandulero equipo = any (\jugador -> jugador `elem` nombreDeJugadoresEquipo equipo) jugadoresFaranduleros

esFarandulero :: Jugador -> Bool
esFarandulero jugador = jNombre jugador `notElem` jugadoresFaranduleros

-- ========== Ejercicio 3 ==========
figusDificilesEquipo :: Equipo -> [Jugador]
figusDificilesEquipo equipo = filter (\jugador -> esJoven jugador && not (esFarandulero jugador) && esFigura jugador equipo) (jugadores equipo)

figusDificles :: [Equipo] -> Grupo -> [[Jugador]]
figusDificles equipos grupo = map figusDificilesEquipo (filter ((grupo ==) . eGrupo) equipos)

-- ========== Ejercicio 4 ==========
afectarJugadorPorPartido :: Equipo -> Jugador -> Jugador
afectarJugadorPorPartido equipo jugador
  | esJoven jugador && not (esFarandulero jugador) && esFigura jugador equipo = jugador {cansancio = 50}
  | esJoven jugador = jugador {cansancio = cansancio jugador / 2}
  | esFigura jugador equipo = jugador {cansancio = cansancio jugador + 20}
  | otherwise = jugador {cansancio = cansancio jugador * 2}

jugarPartido :: Equipo -> Equipo
jugarPartido equipo = equipo {jugadores = map (afectarJugadorPorPartido equipo) (jugadores equipo)}

-- ========== Ejercicio 5 ==========
promedioDeGolEquipoPorCansancio :: Equipo -> Float
promedioDeGolEquipoPorCansancio equipo = sum (map promedioDeGol (take 11 (ordenarJugadoresPorCansancio (jugadores equipo))))

quienGana :: Equipo -> Equipo -> Equipo
quienGana equipo1 equipo2
  | promedioDeGolEquipoPorCansancio equipo1 > promedioDeGolEquipoPorCansancio equipo2 = jugarPartido equipo1
  | otherwise = jugarPartido equipo2

-- ========== Ejercicio 6 ==========
jugarTorneo, jugarTorneo' :: [Equipo] -> Equipo
-- Por high order
jugarTorneo = foldl1 quienGana
-- Por recursividad
jugarTorneo' [x] = x
jugarTorneo' (equipo1 : equipo2 : equipos) = jugarTorneo' (quienGana equipo1 equipo2 : equipos)

-- ========== Ejercicio 7 ==========
obtenerFigura :: Equipo -> Jugador
obtenerFigura equipo = head (filter (`esFigura` equipo) (jugadores equipo))

premioElMasGroso :: [Equipo] -> Jugador
premioElMasGroso equipos = obtenerFigura (jugarTorneo equipos)