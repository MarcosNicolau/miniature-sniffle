-- ====== Types declaration ======
data Auto = Auto {
    aMarca::String,
    aModelo:: Float,
    aKilometraje:: Float
} deriving (Show, Eq)

data Persona = Persona {
    nombre::String,
    pagaImpuestos::Bool,
    autos::[Auto]
} deriving (Show)

data Concesionaria = Concesionaria {
    cNombre::String,
    cMarca::String,
    cKilometraje::Float,
    cModelo::Int,
    cPreferecia::Persona -> Bool
}


-- ====== Definición de datos ======

--Autos
ferrari,fitito, reno :: Auto
ferrari = Auto "Ferrari" 1990 100
fitito = Auto "Fiat" 1960 100000
reno = Auto "Renault" 2023 0

-- Personas
javi, jorgito, dani, fer::Persona
javi = Persona "Javier" False [ferrari, ferrari, reno]
jorgito = Persona "Jorge" True [ferrari, ferrari, ferrari, reno, fitito]
dani = Persona "Daniel" False [fitito]
fer = Persona "Fernanda" True [reno]

-- Concesionarias
pdepautos, funcional, promocion, loco :: Concesionaria
pdepautos = Concesionaria "Pdep Autos" "ferrari" 0 2023 esMillonario
funcional = Concesionaria "Funcional" "Haskell" 0 2023 ((>2).numeroDeAutos)
promocion = Concesionaria "Promoción" "Haskell" 0 2023 ((>8).numeroDeAutos)
loco = Concesionaria "El loco" "renault" 0 2023 (any esAutoImportado . autos)

-- ====== Util fns ======
marcasAutosImportadas :: [String]
marcasAutosImportadas = ["Ferrari", "Mercedes Benz", "Audi"]

esAutoImportado :: Auto -> Bool
esAutoImportado auto | aMarca auto `elem` marcasAutosImportadas = True
                     | otherwise = False

numeroDeAutos ::Persona->Int
numeroDeAutos persona = length (autos persona)

calcularValorAutoBase :: Auto -> Float
calcularValorAutoBase auto = aModelo auto * 100 - aKilometraje auto

valorAuto::Auto->Float
valorAuto auto | esAutoImportado auto = calcularValorAutoBase auto + 200000
                       | otherwise = calcularValorAutoBase auto

valorTotalDeAutos::[Auto]-> Float
valorTotalDeAutos autos = sum (map valorAuto autos)

esMillonario::Persona -> Bool
esMillonario persona = valorTotalDeAutos (autos persona) > 1000000

esHonesto::Persona->Bool
esHonesto = pagaImpuestos

esMillonarioYHonesto:: Persona-> Bool
esMillonarioYHonesto persona = esHonesto persona && esMillonario persona

cantidadDeMillonariosHonestos::[Persona] -> Int
cantidadDeMillonariosHonestos personas = length (filter esMillonarioYHonesto personas)

comprarAuto::Persona -> Concesionaria -> [Auto]
comprarAuto persona concesionaria | cPreferecia concesionaria persona = [Auto (cMarca concesionaria) 2023 0]
                                  | otherwise = []

irDeCompras::Persona -> [Concesionaria]->[Auto]
irDeCompras persona concesionarias | not (null concesionarias) = comprarAuto persona (head concesionarias) ++ irDeCompras persona (tail concesionarias)
                                  | otherwise = autos persona

pudoComprar::Persona -> [Concesionaria] ->Bool
pudoComprar persona concesionarias = autos persona /= irDeCompras persona concesionarias

obtenerMejorAutoAsc :: Ord a => (Auto -> a) -> [Auto] -> Auto
obtenerMejorAutoAsc criterio autos 
                       | null (tail autos) = head autos
                       | criterio (head autos) > criterio ((head.tail) autos) = obtenerMejorAutoAsc criterio (head autos : (tail.tail) autos)
                       | otherwise = obtenerMejorAutoAsc criterio ((head.tail) autos : (tail.tail) autos)

obtenerMejorAutoDsc :: Ord a => (Auto -> a) -> [Auto] -> Auto
obtenerMejorAutoDsc criterio autos 
                       | null (tail autos) = head autos
                       | criterio (head autos) < criterio ((head.tail) autos) = obtenerMejorAutoDsc criterio (head autos : (tail.tail) autos)
                       | otherwise = obtenerMejorAutoDsc criterio ((head.tail) autos : (tail.tail) autos)

printPersonasName :: [Persona] -> String
printPersonasName personas = show (map nombre personas)


-- ====== Program to be run with stack ====== 
main :: IO ()
main = do
        putStr "Las cantidad de personas millonarias y honestas entre: "
        putStr (printPersonasName [javi, jorgito, dani, fer] ++ " es: ")
        print (cantidadDeMillonariosHonestos [javi, jorgito, dani, fer])