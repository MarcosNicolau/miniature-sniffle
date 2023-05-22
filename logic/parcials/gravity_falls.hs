-- =========== Types Declaration ===========
type Item = String

type DesasimientoCriatura = Persona -> Bool

data Criatura = Criatura
  { peligrosidad :: Int,
    desasimiento :: DesasimientoCriatura
  }

data Persona = Persona
  { edad :: Int,
    experiencia :: Int,
    items :: [Item],
    criaturas :: [Criatura]
  }

-- =========== Util fns ===========
isInBetween :: (Eq a, Enum a) => a -> a -> a -> Bool
isInBetween x y z = x `elem` [y .. z]

contieneItem :: Persona -> Item -> Bool
contieneItem persona item = item `elem` (items persona)

esUnaLetra :: Char -> Bool
esUnaLetra x = x `elem` ['a' .. 'z']

-- =========== Data Declaration ===========
siempredetras :: Criatura
siempredetras = Criatura 0 (const False)

gnomos :: Int -> Criatura
gnomos n = Criatura (2 ^ n) (elem "soplador de hojas" . items)

fantasma :: Int -> DesasimientoCriatura -> Criatura
fantasma categoria
  | isInBetween categoria 1 10 = error "La categoria del fantasma debe ser entre 1 y 10"
  | otherwise = Criatura (20 * categoria)

-- =========== Funciones ejercicio 2 ===========
enfrentarseCriatura :: Persona -> Criatura -> Persona
enfrentarseCriatura persona criatura
  | desasimiento criatura persona = persona {experiencia = experiencia persona + peligrosidad criatura}
  | otherwise = persona {experiencia = experiencia persona + 1}

-- =========== Funciones ejercicio 3 ===========
experienciaGanada :: Persona -> Int
experienciaGanada persona = experiencia (foldl enfrentarseCriatura persona (criaturas persona))

ejemploExpGanada :: Int
ejemploExpGanada = experienciaGanada (Persona 12 20 [] [siempredetras, gnomos 10, fantasma 3 (\persona -> edad persona < 13 && contieneItem persona "disfraz de oveja"), fantasma 1 ((> 10) . experiencia)])

-- =========== Funciones ejercicio 4 ===========
delegateZipWith :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> Int -> [b]
delegateZipWith f g [x] (y : ys) i
  | not (g y) = ys ++ [y]
  | otherwise = ys ++ [f x y]
delegateZipWith f g (x : xs) (y : ys) i
  | length (y : ys) == i = y : ys
  | not (g y) = delegateZipWith f g (x : xs) (ys ++ [y]) (i + 1)
  | otherwise = delegateZipWith f g xs (ys ++ [f x y]) (i + 1)

zipWithIf :: (a -> b -> b) -> (b -> Bool) -> [a] -> [b] -> [b]
zipWithIf f g x y = delegateZipWith f g x y 0

-- =========== Funciones ejercicio 5 ===========
abecedarioDesde :: Char -> [Char]
abecedarioDesde letra = [letra .. 'z'] ++ takeWhile (< letra) ['a' .. 'z']

desencriptarLetra :: Char -> Char -> Char
desencriptarLetra letraClave letraADesencriptar = ['a' .. 'z'] !! length (takeWhile (letraADesencriptar /=) (abecedarioDesde letraClave))

cesar :: Char -> String -> String
cesar letraClave textoEncriptado = zipWithIf (\x y -> desencriptarLetra letraClave y) esUnaLetra textoEncriptado textoEncriptado

-- =========== Funciones ejercicio 6 ===========
vigenere :: String -> String -> String
vigenere palabraClave textoADesencriptar = zipWithIf (\x y -> desencriptarLetra x y) esUnaLetra palabraClave textoADesencriptar
