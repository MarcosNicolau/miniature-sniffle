-- Reconoce si una letra es una vocal mediante pattern matching --
esVocal :: Char -> Bool
esVocal 'a' = True
esVocal 'e' = True
esVocal 'i' = True
esVocal 'o' = True
esVocal 'u' = True
esVocal _ = False

-- Recibe un numero y un rango (min, max) y devuelve un bool si el numero cae dentro de ese rango(incluyente).
estaEntre :: Float -> Float -> Float -> Bool
estaEntre number min max = (number >= min) && (number <= max)

-- Calcula la potencia de un numero. Nota: como no se puede utilizar la built-in function ^, se calcula llamando la función n veces, siendo n el exponente.
-- Para ello se deben agregar los casos especiales de x^0 y x^1
-- potencia base 0 = 1
-- potencia base 1 = base 
-- potencia base exponent = base * potencia base (exponent -1 )

potencia base exponent | exponent == 0 = 1 
                       | exponent > 1 = base * potencia base (exponent -1)
                       | exponent < 1 = (1/base) * potencia (1/base) (-exponent -1)
                       | otherwise = potencia base (truncate exponent)
                       
                         

