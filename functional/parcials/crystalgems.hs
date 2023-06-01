-- ========= Types declaration =========
type Situacion = [Aspecto]

type Personalidad = Situacion -> Situacion

data Aspecto = Aspecto
  { tipoDeAspecto :: String,
    grado :: Float
  }
  deriving (Show, Eq)

data Gema = Gema
  { nombre :: String,
    fuerza :: Int,
    personalidad :: Personalidad
  }

-- ========= Util fns =========
ternario f x y
  | f = x
  | otherwise = y

mejorAspecto :: Aspecto -> Aspecto -> Bool
mejorAspecto mejor peor = grado mejor < grado peor

mismoAspecto :: Aspecto -> Aspecto -> Bool
mismoAspecto aspecto1 aspecto2 = tipoDeAspecto aspecto1 == tipoDeAspecto aspecto2

buscarAspecto :: Aspecto -> [Aspecto] -> Aspecto
buscarAspecto aspectoBuscado = head . filter (mismoAspecto aspectoBuscado)

buscarAspectoDeTipo :: String -> [Aspecto] -> Aspecto
buscarAspectoDeTipo tipo = buscarAspecto (Aspecto tipo 0)

reemplazarAspecto :: Aspecto -> [Aspecto] -> [Aspecto]
reemplazarAspecto aspectoBuscado situacion = aspectoBuscado : filter (not . mismoAspecto aspectoBuscado) situacion

esMasFuerte :: Gema -> Gema -> Bool
esMasFuerte gema1 gema2 = fuerza gema1 > fuerza gema2

gemasSonCompatibles :: Gema -> Gema -> Situacion -> Bool
gemasSonCompatibles gema1 gema2 situacion = mejorSituacion (personalidadFusionada gema1 gema2 situacion) (personalidad gema1 situacion) && mejorSituacion (personalidadFusionada gema1 gema2 situacion) (personalidad gema2 situacion)

-- ========= Modelado de aspectos =========
tension, incertidumbre, peligro :: Float -> Aspecto
tension = Aspecto "tension"
incertidumbre = Aspecto "incertidumbre"
peligro = Aspecto "peligro"

-- ========= Funciones ejercicio 1 =========
modificarAspecto :: (Float -> Float) -> Aspecto -> Aspecto
modificarAspecto f aspecto = aspecto {grado = f (grado aspecto)}

mejorSituacion :: Situacion -> Situacion -> Bool
mejorSituacion situacion1 situacion2 = all (\x -> mejorAspecto x (buscarAspecto x situacion2)) (filter (`elem` situacion2) situacion1)

modificarSituacion :: [(String, Aspecto -> Float)] -> Situacion -> Situacion
modificarSituacion fs situacion = foldl (\x (tipo, grado) -> reemplazarAspecto (Aspecto tipo (grado (buscarAspectoDeTipo tipo x))) x) situacion fs

-- ========= Funciones ejercicio 2 =========
vidente :: Personalidad
vidente = modificarSituacion [("incertidumbre", (/ 2) . grado), ("tension", \aspecto -> grado aspecto - 10)]

relajada :: Float -> Personalidad
relajada nivel = modificarSituacion [("tension", \aspecto -> grado aspecto - 30), ("peligro", \aspecto -> grado aspecto + nivel)]

bajarTodasLasSituaciones :: Float -> Personalidad
bajarTodasLasSituaciones nivel situacion = modificarSituacion (map (\x -> (tipoDeAspecto x, \aspecto -> grado aspecto + nivel)) situacion) situacion

gemaVidente :: Gema
gemaVidente = Gema "Vidente" 10 vidente

gemaRelajada :: Gema
gemaRelajada = Gema "Vidente" 15 (relajada 10)

-- ========= Funciones ejercicio 3 =========
gemaGanadora :: Gema -> Gema -> Situacion -> Bool
gemaGanadora gema1 gema2 situacion = esMasFuerte gema1 gema2 && mejorSituacion (personalidad gema1 situacion) (personalidad gema2 situacion)

-- ========= Funciones ejercicio 4 =========
nombreDeFusion :: Gema -> Gema -> String
nombreDeFusion gema1 gema2
  | nombre gema1 == nombre gema2 = nombre gema1
  | otherwise = nombre gema1 ++ nombre gema2

personalidadFusionada :: Gema -> Gema -> Personalidad
personalidadFusionada gema1 gema2 = personalidad gema1 . personalidad gema2 . bajarTodasLasSituaciones (-10)

fuerzaFusionada :: Gema -> Gema -> Situacion -> Int
fuerzaFusionada gema1 gema2 situacion
  | gemasSonCompatibles gema1 gema2 situacion = (fuerza gema1 + fuerza gema2) * 10
  | otherwise = ternario (gemaGanadora gema1 gema2 situacion) (7 * fuerza gema1) (7 * fuerza gema2)

fusionDeGemas :: Gema -> Gema -> Situacion -> Gema
fusionDeGemas gema1 gema2 situacion = Gema (nombreDeFusion gema1 gema2) (fuerzaFusionada gema1 gema2 situacion) (personalidadFusionada gema1 gema2)

-- ========= Funciones ejercicio 5 =========
fusionGrupal :: [Gema] -> Situacion -> Gema
fusionGrupal [x] _ = x
fusionGrupal (gema : gema' : gemas) situacion = fusionGrupal (fusionDeGemas gema gema' situacion : gemas) situacion