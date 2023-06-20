-- ======== Types declaration ========
type Herramienta = Bioma -> Material

type Material = String

data Bioma = Bioma
  { tipo :: String,
    bMateriales :: [Material],
    elementoParaMinar :: String
  }

data Personaje = Personaje
  { nombre :: String,
    puntaje :: Int,
    inventario :: [Material]
  }
  deriving (Show)

data Receta = Receta
  { objeto :: Material,
    rMateriales :: [Material],
    duracionEnS :: Int
  }

-- ======== Data declaration (for examples) ========
-- personajes
steve :: Personaje
steve = Personaje "Steve" 1000 ["pollo", "pollo", "fosforo", "fosforo", "madera", "madera"]

-- Recetas
fogata, polloAsado, sueter :: Receta
fogata = Receta "fogata" ["madera", "fosforo"] 10
polloAsado = Receta "fogata" ["fogata", "pollo"] 300
sueter = Receta "fogata" ["agujas", "lana", "tintura"] 600

-- Biomas
artico :: Bioma
artico = Bioma "artico" ["hielo", "iglu", "lobo"] "sueter"

-- ======== Utils fns ========
pertenece :: (Eq a) => [a] -> a -> Bool
pertenece = flip elem

-- Solo filtra uno de los elementos que matchean la condicion
filterFirst :: (a -> Bool) -> [a] -> [a]
filterFirst _ [] = []
filterFirst f (x : xs)
  | f x = xs
  | otherwise = x : filterFirst f xs

elementoDelMedio :: [a] -> a
elementoDelMedio [] = error "Lista must not be empty"
elementoDelMedio lista = lista !! (length lista `div` 2)

puntosCrafteo :: Receta -> Int
puntosCrafteo receta = duracionEnS receta * 10

-- ======= Parte 1: Craft ========
afectarPuntaje :: Int -> Personaje -> Personaje
afectarPuntaje valor personaje = personaje {puntaje = puntaje personaje + valor}

tieneLosMaterialesNecesarios ::  Receta -> Personaje -> Bool
tieneLosMaterialesNecesarios receta personaje = all (pertenece (inventario personaje)) (rMateriales receta)

personajePuntosDespuesDelCrafteo :: Receta -> Personaje -> Personaje
personajePuntosDespuesDelCrafteo receta = afectarPuntaje (puntosCrafteo receta)

filtrarElementosUsados::Receta->Personaje->[Material]
filtrarElementosUsados receta personaje = foldl (\inv material -> filterFirst (== material) inv) (inventario personaje) (rMateriales receta)

inventarioDespuesDelCrafteo :: Receta -> Personaje -> Personaje
inventarioDespuesDelCrafteo receta personaje = personaje {inventario = objeto receta : filtrarElementosUsados receta personaje}

craftearObjeto :: Personaje -> Receta -> Personaje
craftearObjeto personaje receta
  | not (tieneLosMaterialesNecesarios receta personaje) = afectarPuntaje (-100) personaje
  | otherwise = personajePuntosDespuesDelCrafteo receta (inventarioDespuesDelCrafteo receta personaje)

-- ======== Funciones ejercicio 2 ========
crafteoDuplicaElPuntaje :: Personaje -> Receta -> Bool
crafteoDuplicaElPuntaje personaje receta = puntosCrafteo receta >= puntaje personaje

cualesPuedeHacerYDuplicanSuPuntaje :: Personaje -> [Receta] -> [Receta]
cualesPuedeHacerYDuplicanSuPuntaje personaje = filter (\receta -> tieneLosMaterialesNecesarios receta personaje && crafteoDuplicaElPuntaje personaje receta)

craftearSucesivamente :: Personaje -> [Receta] -> Personaje
craftearSucesivamente = foldl craftearObjeto

esMejorCraftearAlReves :: Personaje -> [Receta] -> Bool
esMejorCraftearAlReves personaje recetas = puntaje (craftearSucesivamente personaje recetas) < puntaje (craftearSucesivamente personaje (reverse recetas))

-- ======== Parte 2: Mine ========

-- Herramientas
hacha :: Herramienta
hacha = last . bMateriales

espada :: Herramienta
espada = head . bMateriales

pico :: Int -> Herramienta
pico precision = (!! precision) . bMateriales

caña :: Herramienta
caña = elementoDelMedio . bMateriales

pala :: Herramienta
pala bioma = head (filter (\material -> head material == 'h') (bMateriales bioma))

puedeMinarEnBioma :: Bioma -> Personaje -> Bool
puedeMinarEnBioma bioma personaje = pertenece (inventario personaje) (elementoParaMinar bioma)

minar :: Herramienta -> Personaje -> Bioma -> Personaje
minar herramienta personaje bioma
  | not (puedeMinarEnBioma bioma personaje) = personaje
  | otherwise = afectarPuntaje 50 (personaje {inventario = herramienta bioma : inventario personaje})
