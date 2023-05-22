-- ============== Types declaration ==============
type Transformacion = Personaje -> Personaje

type ElementoAccion = Personaje -> Personaje

data Elemento = Elemento
  { tipo :: String,
    ataque :: ElementoAccion,
    defensa :: ElementoAccion
  }
  deriving (Show)

data Personaje = Personaje
  { nombre :: String,
    salud :: Float,
    elementos :: [Elemento],
    anioPresente :: Int
  }
  deriving (Show)

instance Show (a -> b) where
  show _ = "<function>"

-- ============== Util fns ==============
restarDistintoDeCero :: (Ord a, Num a) => a -> a -> a
restarDistintoDeCero x y
  | x - y <= 0 = 0
  | otherwise = x - y

ternario :: Bool -> p -> p -> p
ternario f a b
  | f = a
  | otherwise = b

composicionRecursiva :: (a -> a) -> Int -> a -> a
composicionRecursiva f 0 = f
composicionRecursiva f n = composicionRecursiva (f . f) (n - 1)

-- ============== Transformaciones ==============
mandarAlAnio :: Int -> Transformacion
mandarAlAnio anio personaje = personaje {anioPresente = anio}

meditar :: Transformacion
meditar personaje = personaje {salud = salud personaje + (salud personaje / 2)}

causarDanio :: Float -> Transformacion
causarDanio danio personaje = personaje {salud = restarDistintoDeCero (salud personaje) danio}

-- ============== Información extra personajes ==============
esMalvado :: Personaje -> Bool
esMalvado personaje = any ((== "Maldad") . tipo) (elementos personaje)

danioQueProduce :: Personaje -> Elemento -> Float
danioQueProduce personaje elemento = salud (causarDanio (salud (ataque elemento personaje)) personaje)

enemigosMortales :: Personaje -> [Personaje] -> [Personaje]
enemigosMortales personaje = filter (any (\elemento -> danioQueProduce personaje elemento == 0) . elementos)

-- ============== Definición de datos ==============

-- Elementos
concentracion :: Int -> Elemento
concentracion nivel = Elemento "Magia" id (composicionRecursiva meditar 3)

esbirrosMalvados :: Int -> [Elemento]
esbirrosMalvados cantidad = replicate cantidad (Elemento "Maldad" (causarDanio 1) id)

katanaMagica :: Elemento
katanaMagica = Elemento "Magia" (causarDanio 1000) id

portalAlFuturo :: Int -> Elemento
portalAlFuturo ano = Elemento "Magia" (\personaje -> personaje {anioPresente = anoFuturo}) (aku anoFuturo . salud)
  where
    anoFuturo = ano + 2800

-- Personajes
jack :: Personaje
jack = Personaje "Jack" 300 [concentracion 3, katanaMagica] 200

aku :: Int -> Float -> Personaje
aku ano salud = Personaje "Aku" salud ([concentracion 4, portalAlFuturo ano] ++ esbirrosMalvados (100 * ano)) ano

-- ============== Lucha ==============

utilizarElementos :: Bool -> [Elemento] -> Personaje -> Personaje
utilizarElementos atacar elementos personaje = foldl (flip (ternario atacar ataque defensa)) personaje elementos

luchar :: Personaje -> Personaje -> (Personaje, Personaje)
luchar atacante defensor
  | salud atacante == 0 = (defensor, atacante)
  | salud defensor == 0 = (atacante, defensor)
  | otherwise = luchar (defensor {salud = salud (utilizarElementos True (elementos atacante) defensor)}) (atacante {salud = salud (utilizarElementos False (elementos defensor) atacante)})
