-- =========== Types definition ===========

type Actor = String

type Genero = String

type Premio = String

data Pelicula = Pelicula
  { nombre :: String,
    actores :: [Actor],
    duracion :: Int,
    ano :: Int
  }

todosLosActores = [("comedia", ["Carrey", "Grint", "Stiller"]), ("accion", ["Stallone", "Willis", "Schwarzenegger"]), ("drama", ["De Niro", "Foster"])]

-- =========== Data declaration ===========
taxiDriver, machete, harryPotter :: Pelicula
taxiDriver = Pelicula "Taxi driver" ["De Niro", "Foster"] 1976 113
machete = Pelicula "Machete" ["De Niro", "Rodriguez"] 2010 105
harryPotter = Pelicula "Harry Potter 9" ["Watson", "Radcliffe", "Grint"] 2022 1000

-- =========== Util fns ===========
cuantosElementosComparten :: (Eq a) => [a] -> [a] -> Int
cuantosElementosComparten array1 array2 = sum (map (const 1) (filter (`elem` array1) array2))

minutosAHoras :: Num a => a -> a
minutosAHoras min = min * 60

maximo :: (Ord a, Ord t) => [a] -> (a -> t) -> a
maximo [x] _ = x
maximo (x : x' : xs) f
  | f x > f x' = maximo (x : xs) f
  | otherwise = maximo (x' : xs) f

-- =========== Ejercicio 1 ===========
trabajoEnPelicula :: Actor -> Pelicula -> Bool
trabajoEnPelicula actor pelicula = actor `elem` actores pelicula

-- =========== Ejercicio 2 ===========
obtenerGenerosMayoritarios :: Pelicula -> [(Genero, Int)] -> Int -> [Genero]
obtenerGenerosMayoritarios pelicula generos maximo = map fst (filter (\(_, y) -> y == maximo) generos)

generosMayoritarios :: Pelicula -> [(Genero, Int)] -> [Genero]
generosMayoritarios pelicula generos = obtenerGenerosMayoritarios pelicula generos (snd (maximo generos snd))

peliculaEsDelGenero :: Genero -> Pelicula -> Bool
peliculaEsDelGenero genero pelicula = genero `elem` generosMayoritarios pelicula (map (\(x, y) -> (x, cuantosElementosComparten (actores pelicula) y)) todosLosActores)

-- =========== Ejercicio 3 ===========
premioClasicoSetentista, premioPlomo :: Pelicula -> Bool
premioClasicoSetentista pelicula = ano pelicula `elem` [1970 .. 1979]
premioPlomo pelicula = minutosAHoras (duracion pelicula) > 3

premioTresSonMultitud :: Pelicula -> Bool
premioTresSonMultitud pelicula = length (actores pelicula) == 3

premioSonMultitud :: Int -> Pelicula -> Bool
premioSonMultitud n pelicula = length (actores pelicula) == n

premioPeliculaChota :: Pelicula -> Bool
premioPeliculaChota pelicula = length (actores pelicula) == 1 && minutosAHoras (duracion pelicula) > 2

-- =========== Ejercicio 3 ===========
festivalsCannes :: Pelicula -> Int
festivalsCannes pelicula = sum (map (const 1) [premioClasicoSetentista pelicula, premioTresSonMultitud pelicula])

festivalBerlin :: Pelicula -> Int
festivalBerlin pelicula = sum (map (const 1) [premioPlomo pelicula, premioSonMultitud 4 pelicula, premioClasicoSetentista pelicula])