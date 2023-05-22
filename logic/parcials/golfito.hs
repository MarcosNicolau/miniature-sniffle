-- ========= Date declaration =========
type Puntos = Int

type Obstaculo = (Tiro -> (Tiro, Bool))

type Palos = [Tiro]

type Padre = String

data Jugador = Jugador
  { nombre :: String,
    padre :: Padre,
    habilidad :: Habilidad
  }
  deriving (Eq, Show)

data Habilidad = Habilidad
  { fuerzaJugador :: Int,
    precisionJugador :: Int
  }
  deriving (Eq, Show)

data Tiro = Tiro
  { velocidad :: Int,
    precision :: Int,
    altura :: Int
  }
  deriving (Eq, Show)

-- ========= Data declaration =========
bart, todd, rafa :: Jugador
bart = Jugador "Bart" "Homero" (Habilidad 25 60)
todd = Jugador "Todd" "Ned" (Habilidad 15 80)
rafa = Jugador "Rafa" "Gorgory" (Habilidad 10 1)

tiroNulo = Tiro 0 0 0

putter, madera :: Habilidad -> Tiro
putter habilidad = Tiro 10 (precisionJugador habilidad * 2) 0
madera habilidad = Tiro 100 (fromInteger (fromIntegral (precisionJugador habilidad) `div` 2)) 5

hierro :: Int -> Habilidad -> Tiro
hierro n habilidad
  | n - 3 <= 0 = Tiro (fuerzaJugador habilidad * n) (fromIntegral (precisionJugador habilidad) `div` 2) 0
  | otherwise = Tiro (fuerzaJugador habilidad * n) (fromIntegral (precisionJugador habilidad) `div` 2) (n - 3)

hierros :: [Habilidad -> Tiro]
hierros = map hierro [1 .. 5]

palos :: [Habilidad -> Tiro]
palos = [putter, madera] ++ hierros

-- ========= Util fns =========
between :: (Eq a, Enum a) => a -> a -> a -> Bool
between n m x = elem x [n .. m]

maximo :: (Ord a) => [a] -> a
maximo [] = error "Empty list"
maximo [x] = x
maximo (x : x' : xs)
  | x > x' = maximo (x' : xs)
  | otherwise = maximo (x : xs)

maximoSegun :: (Foldable t, Ord a1) => (a2 -> a1) -> t a2 -> a2
maximoSegun f = foldl1 (mayorSegun f)

mayorSegun :: Ord a => (t -> a) -> t -> t -> t
mayorSegun f a b
  | f a > f b = a
  | otherwise = b

-- ========= Golpe =========
golpe :: Jugador -> (Habilidad -> Tiro) -> Tiro
golpe jugador palo = putter (habilidad jugador)

-- ========= Obstáculos =========
obstaculoTunel :: Obstaculo
obstaculoTunel tiro
  | precision tiro > 90 && altura tiro == 0 = (Tiro (velocidad tiro * 2) 100 0, True)
  | otherwise = (tiroNulo, False)

obstaculoLaguna :: Int -> Obstaculo
obstaculoLaguna largoLaguna tiro
  | velocidad tiro > 80 && between (altura tiro) 1 3 = (tiro {altura = altura tiro `div` largoLaguna}, True)
  | otherwise = (tiroNulo, False)

obstaculoHoyo :: Obstaculo
obstaculoHoyo tiro
  | between (velocidad tiro) 5 20 && altura tiro == 0 && precision tiro == 95 = (tiroNulo, True)
  | otherwise = (tiroNulo, False)

-- ========= Palos =========

palosUtiles :: Jugador -> (Tiro -> (Tiro, Bool)) -> [Habilidad -> Tiro]
palosUtiles jugador obstaculo = filter (\palo -> snd (obstaculo (palo (habilidad jugador)))) palos

obstaculosConsecutivos :: Tiro -> [Obstaculo] -> Int
obstaculosConsecutivos tiro obstaculos = length (takeWhile (\obstaculo -> snd (obstaculo tiro)) obstaculos)

paloMasUtil :: Jugador -> [Obstaculo] -> Int
paloMasUtil jugador obstaculos = maximo (map (\palo -> obstaculosConsecutivos (palo (habilidad jugador)) obstaculos) palos)

-- ========= Ganador =========
padrePerdedor :: [(Jugador, Puntos)] -> Padre
padrePerdedor [] = error "Empty list"
padrePerdedor [x] = padre (fst x)
padrePerdedor (x : x' : xs)
  | snd x < snd x' = padrePerdedor (x : xs)
  | otherwise = padrePerdedor (x' : xs)
