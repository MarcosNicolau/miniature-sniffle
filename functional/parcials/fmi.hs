-- ============ Types declaration ============
type RecursoNatural = String

type Receta = Pais -> Pais

data Pais = Pais
  { ingresoPerCapita :: Int,
    sectorPublico :: Int,
    sectorPrivado :: Int,
    recursosNaturales :: [RecursoNatural],
    deuda :: Int
  }
  deriving (Show)

-- ============ Util fns ============
porcentaje :: Int -> Int -> Int
porcentaje num x = (num * x) `div` 100

ternario :: Bool -> a -> a -> a
ternario f x y
  | f = x
  | otherwise = y

poblacionActiva :: Pais -> Int
poblacionActiva pais = sectorPrivado pais + sectorPublico pais

pbi :: Pais -> Int
pbi pais = ingresoPerCapita pais * poblacionActiva pais

actualizarPais :: Pais -> Int -> Int -> Int -> Int -> Pais
actualizarPais pais deltaDeuda deltaIngresoPerCapita deltaSectorPublico deltaSectorPrivado = pais {deuda = deuda pais + deltaDeuda, ingresoPerCapita = ingresoPerCapita pais + deltaIngresoPerCapita, sectorPublico = sectorPublico pais + deltaSectorPublico, sectorPrivado = sectorPrivado pais + deltaSectorPrivado}

pertenece :: (Foldable t, Eq a) => a -> t a -> Bool
pertenece x lista = x `elem` lista

-- ============ Recetas ============
darPrestamo :: Int -> Receta
darPrestamo millones pais = actualizarPais pais (porcentaje (millones * 1000000) 150) 0 0 0

reducirSectorPublico :: Int -> Receta
reducirSectorPublico x pais = actualizarPais pais 0 (-porcentaje (ingresoPerCapita pais) (ternario (x > 100) 20 15)) (-x) 0

otorgarRecursoNatural :: RecursoNatural -> Receta
otorgarRecursoNatural recurso pais = actualizarPais (pais {recursosNaturales = filter (recurso ==) (recursosNaturales pais)}) (-2000000) 0 0 0

blindaje :: Pais -> Pais
blindaje pais = actualizarPais pais (pbi pais `div` 2) (-500) 0 0

-- ============ Funciones ej 3  ============
namibia :: Pais
namibia = Pais 4140 400000 650000 ["mineria", "ecoturismo"] 50000000

recetaLoca :: [Receta]
recetaLoca = [otorgarRecursoNatural "mineria", darPrestamo 200]

aplicarRecetaLoca pais = foldl $ pais recetaLoca

-- ============ Funciones ej 4  ============
cualesZafan :: [Pais] -> [Pais]
cualesZafan = filter (pertenece "petroleo" . recursosNaturales)

deudaAFavor :: [Pais] -> Int
deudaAFavor paises = sum (map deuda paises)

-- ============ Funciones ej 5  ============
estaOrdenado :: [Receta] -> Pais -> Bool
estaOrdenado [x] _ = True
estaOrdenado (receta : receta' : recetas) pais
  | pbi (receta pais) < pbi (receta' pais) = estaOrdenado (receta' : recetas) pais
  | otherwise = False

recursosNaturalesInfinitos :: [String]
recursosNaturalesInfinitos = "Energia" : recursosNaturalesInfinitos

{-

1. Si aplicamos la funcion 4.a (cualesZafan) nunca se terminaria de evaluar, ya que no estariamos difiriendo la llamada

2. Si se podria, ya que no en la funcion no interesa saber los recursos naturales, por tanto no se evaluaran

-}